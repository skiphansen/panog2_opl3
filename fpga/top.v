//-----------------------------------------------------------------
// TOP
//-----------------------------------------------------------------
module top
(
     input           SYSCLK
    ,inout           pano_button
    ,output          GMII_RST_N
    ,output          led_red
    ,inout           led_green
    ,inout           led_blue

    // UART
    ,input           uart_txd_i
    ,output          uart_rxd_o

    // SPI-Flash
    ,output          flash_sck_o
    ,output          flash_cs_o
    ,output          flash_si_o
    ,input           flash_so_i

     // WM8750 Codec
`ifdef NOT_YET
     ,output codec_mclk
     ,output codec_bclk
     ,output codec_dacdata
     ,output codec_daclrck
     ,input  codec_adcdata
     ,output codec_adclrck
`endif
     ,inout  codec_scl
     ,inout  codec_sda
);

// Generate 32 Mhz system clock and 25 Mhz audio clock from 125 Mhz input clock
wire clk32;
wire clk25;

`ifdef NOT_YET
assign codec_mclk = clk25;
`endif

IBUFG clkin1_buf
(   .O (clkin1),
    .I (SYSCLK)
);

PLL_BASE
    #(.BANDWIDTH              ("OPTIMIZED"),
      .CLKFBOUT_MULT          (18),
      .CLKFBOUT_PHASE         (0.000),
      .CLK_FEEDBACK           ("CLKFBOUT"),
      .CLKIN_PERIOD           (8.000),
      .COMPENSATION           ("SYSTEM_SYNCHRONOUS"),
      .DIVCLK_DIVIDE          (5),
      .REF_JITTER             (0.010),
      .CLKOUT0_DIVIDE         (6),
      .CLKOUT0_DUTY_CYCLE     (0.500),
      .CLKOUT0_PHASE          (0.000),
      .CLKOUT1_DIVIDE         (18),
      .CLKOUT1_DUTY_CYCLE     (0.500),
      .CLKOUT1_PHASE          (0.000)
    )
    pll_base_inst
      // Output clocks
     (.CLKFBOUT              (clkfbout),
      .CLKOUT0               (clkout32),
      .CLKOUT1               (clkout25),
      .CLKOUT2               (clkout2_unused),
      .CLKOUT3               (clkout3_unused),
      .CLKOUT4               (clkout4_unused),
      .CLKOUT5               (clkout5_unused),
      // Status and control signals
      .LOCKED                (LOCKED),
      .RST                   (RESET),
       // Input clock control
      .CLKFBIN               (clkfbout_buf),
      .CLKIN                 (clkin1)
);

// Output buffering
//-----------------------------------
BUFG clkf_buf
 (.O (clkfbout_buf),
  .I (clkfbout));

BUFG clk32_buf
  (.O (clk32),
   .I (clkout32));

BUFG clk25_buf
(.O (clk25),
 .I (clkout25));

//-----------------------------------------------------------------
// Reset
//-----------------------------------------------------------------
wire rst;

reset_gen
u_rst
(
    .clk_i(clk32),
    .rst_o(rst)
);

//-----------------------------------------------------------------
// Core
//-----------------------------------------------------------------
wire        dbg_txd_w;
wire        uart_txd_w;

wire        spi_clk_w;
wire        spi_so_w;
wire        spi_si_w;
wire [7:0]  spi_cs_w;

wire [31:0] gpio_in_w;
wire [31:0] gpio_out_w;
wire [31:0] gpio_out_en_w;

fpga_top
#(
    .CLK_FREQ(75000000)
   ,.BAUDRATE(1000000)   // SoC UART baud rate
   ,.UART_SPEED(1000000) // Debug bridge UART baud (should match BAUDRATE)
   ,.C_SCK_RATIO(2)      // SPI clock divider (M25P128 maxclock = 54 Mhz)
   ,.CPU("riscv")        // riscv or armv6m
)
u_top
(
     .clk_i(clk32)
    ,.rst_i(rst)

    ,.dbg_rxd_o(dbg_txd_w)
    ,.dbg_txd_i(uart_txd_i)

    ,.uart_tx_o(uart_txd_w)
    ,.uart_rx_i(uart_txd_i)

    ,.spi_clk_o(spi_clk_w)
    ,.spi_mosi_o(spi_si_w)
    ,.spi_miso_i(spi_so_w)
    ,.spi_cs_o(spi_cs_w)

    ,.gpio_input_i(gpio_in_w)
    ,.gpio_output_o(gpio_out_w)
    ,.gpio_output_enable_o(gpio_out_en_w)
);

//-----------------------------------------------------------------
// SPI Flash
//-----------------------------------------------------------------
assign flash_sck_o = spi_clk_w;
assign flash_si_o  = spi_si_w;
assign flash_cs_o  = spi_cs_w[0];
assign spi_so_w    = flash_so_i;

//-----------------------------------------------------------------
// GPIO bits
// 0: reserved for CPU reset (?)
// 1: Pano button
// 2: Output only - red LED
// 3: In/out - green LED
// 4: In/out - blue LED
// 5: Wolfson codec SDA
// 6: Wolfson codec SCL
// 9...31: Not implmented
//-----------------------------------------------------------------

assign pano_button = gpio_out_en_w[1]  ? gpio_out_w[1]  : 1'bz;
assign gpio_in_w[1]  = pano_button;

assign led_red = gpio_out_w[2];
assign gpio_in_w[2]  = led_red;

assign led_green = gpio_out_en_w[3]  ? gpio_out_w[3]  : 1'bz;
assign gpio_in_w[3]  = led_green;

assign led_blue = gpio_out_en_w[4]  ? gpio_out_w[4]  : 1'bz;
assign gpio_in_w[4]  = led_blue;

assign codec_sda = gpio_out_en_w[5]  ? gpio_out_w[5]  : 1'bz;
assign gpio_in_w[5]  = codec_sda;


assign codec_scl = gpio_out_en_w[6]  ? gpio_out_w[6]  : 1'bz;
assign gpio_in_w[6]  = codec_scl;


genvar i;
generate
for (i=7; i < 31; i=i+1)
begin
    assign gpio_in_w[i]  = 1'b0;
end
endgenerate

//-----------------------------------------------------------------
// UART Tx combine
//-----------------------------------------------------------------
// Xilinx placement pragmas:
//synthesis attribute IOB of uart_rxd_o is "TRUE"
reg txd_q;

always @ (posedge clk32 or posedge rst)
if (rst)
    txd_q <= 1'b1;
else
    txd_q <= dbg_txd_w & uart_txd_w;

// 'OR' two UARTs together
assign uart_rxd_o  = txd_q;

`ifdef NOT_YET

// Audio
wire signed [15:0] opl2_channel_a;
wire signed [15:0] opl2_channel_b;
wire signed [15:0] opl2_channel_c;
wire signed [15:0] opl2_channel_d;
wire opl3_sample_clk;
wire codec_bclk;

opl3 opl3_inst (
  .clk(clk33),  // system clock
  .clk_opl3(clk25),  // 25 MHz OPL2 clock
  .opl3_we(),   // register write
  .opl3_data(), // register data
  .opl3_adr(),  // register address
  .channel_a(opl2_channel_a), // output channel a
  .channel_b(opl2_channel_b), // output channel b
  .channel_c(opl2_channel_c),
  .channel_d(opl2_channel_d),
  .sample_clk(audio_sample_clk),
  .sample_clk_128(codec_bclk)   // 128 X sample rate clock
);

wire signed [18:0] left_pre, right_pre;

assign left_pre = opl2_channel_a + opl2_channel_c;
assign right_pre = opl2_channel_b + opl2_channel_d;

wire signed [15:0] left, right;

assign left = left_pre > 32767 ? 16'hffff : left_pre < -32768 ? 16'h0000 : left_pre[15:0];
assign right = right_pre > 32767 ? 16'hffff : right_pre < -32768 ? 16'h0000: right_pre[15:0];

audio audio_out (
    .clk25(clk25),
    .reset25(),
    .codec_bclk(codec_bclk),
    .audio_dacdat(codec_dacdata),
    .audio_daclrc(codec_daclrck),
    .audio_adcdat(codec_adcdata),
    .audio_adclrc(codec_adclrck),
    .audio_right_sample(right),
    .audio_left_sample(left),
    .audio_sample_clk(audio_sample_clk)
);
`endif

//-----------------------------------------------------------------
// Tie-offs
//-----------------------------------------------------------------

// Must remove reset from the Ethernet Phy for 125 Mhz input clock.
// See https://github.com/tomverbeure/panologic-g2
assign GMII_RST_N = 1'b1;

endmodule
