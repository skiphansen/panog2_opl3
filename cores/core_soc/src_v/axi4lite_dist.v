//-----------------------------------------------------------------
//                     Basic Peripheral SoC
//                           V1.0
//                     Ultra-Embedded.com
//                     Copyright 2014-2019
//
//                 Email: admin@ultra-embedded.com
//
//                         License: GPL
// If you would like a version with a more permissive license for
// use in closed source commercial applications please contact me
// for details.
//-----------------------------------------------------------------
//
// This file is open source HDL; you can redistribute it and/or 
// modify it under the terms of the GNU General Public License as 
// published by the Free Software Foundation; either version 2 of 
// the License, or (at your option) any later version.
//
// This file is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public 
// License along with this file; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
// USA
//-----------------------------------------------------------------

//-----------------------------------------------------------------
//                          Generated File
//-----------------------------------------------------------------

module axi4lite_dist
(
    // Inputs
     input           clk_i
    ,input           rst_i
    ,input           inport_awvalid_i
    ,input  [ 31:0]  inport_awaddr_i
    ,input           inport_wvalid_i
    ,input  [ 31:0]  inport_wdata_i
    ,input  [  3:0]  inport_wstrb_i
    ,input           inport_bready_i
    ,input           inport_arvalid_i
    ,input  [ 31:0]  inport_araddr_i
    ,input           inport_rready_i
    ,input           outport0_awready_i
    ,input           outport0_wready_i
    ,input           outport0_bvalid_i
    ,input  [  1:0]  outport0_bresp_i
    ,input           outport0_arready_i
    ,input           outport0_rvalid_i
    ,input  [ 31:0]  outport0_rdata_i
    ,input  [  1:0]  outport0_rresp_i
    ,input           outport1_awready_i
    ,input           outport1_wready_i
    ,input           outport1_bvalid_i
    ,input  [  1:0]  outport1_bresp_i
    ,input           outport1_arready_i
    ,input           outport1_rvalid_i
    ,input  [ 31:0]  outport1_rdata_i
    ,input  [  1:0]  outport1_rresp_i
    ,input           outport2_awready_i
    ,input           outport2_wready_i
    ,input           outport2_bvalid_i
    ,input  [  1:0]  outport2_bresp_i
    ,input           outport2_arready_i
    ,input           outport2_rvalid_i
    ,input  [ 31:0]  outport2_rdata_i
    ,input  [  1:0]  outport2_rresp_i
    ,input           outport3_awready_i
    ,input           outport3_wready_i
    ,input           outport3_bvalid_i
    ,input  [  1:0]  outport3_bresp_i
    ,input           outport3_arready_i
    ,input           outport3_rvalid_i
    ,input  [ 31:0]  outport3_rdata_i
    ,input  [  1:0]  outport3_rresp_i
    ,input           outport4_awready_i
    ,input           outport4_wready_i
    ,input           outport4_bvalid_i
    ,input  [  1:0]  outport4_bresp_i
    ,input           outport4_arready_i
    ,input           outport4_rvalid_i
    ,input  [ 31:0]  outport4_rdata_i
    ,input  [  1:0]  outport4_rresp_i

    // Outputs
    ,output          inport_awready_o
    ,output          inport_wready_o
    ,output          inport_bvalid_o
    ,output [  1:0]  inport_bresp_o
    ,output          inport_arready_o
    ,output          inport_rvalid_o
    ,output [ 31:0]  inport_rdata_o
    ,output [  1:0]  inport_rresp_o
    ,output          outport0_awvalid_o
    ,output [ 31:0]  outport0_awaddr_o
    ,output          outport0_wvalid_o
    ,output [ 31:0]  outport0_wdata_o
    ,output [  3:0]  outport0_wstrb_o
    ,output          outport0_bready_o
    ,output          outport0_arvalid_o
    ,output [ 31:0]  outport0_araddr_o
    ,output          outport0_rready_o
    ,output          outport1_awvalid_o
    ,output [ 31:0]  outport1_awaddr_o
    ,output          outport1_wvalid_o
    ,output [ 31:0]  outport1_wdata_o
    ,output [  3:0]  outport1_wstrb_o
    ,output          outport1_bready_o
    ,output          outport1_arvalid_o
    ,output [ 31:0]  outport1_araddr_o
    ,output          outport1_rready_o
    ,output          outport2_awvalid_o
    ,output [ 31:0]  outport2_awaddr_o
    ,output          outport2_wvalid_o
    ,output [ 31:0]  outport2_wdata_o
    ,output [  3:0]  outport2_wstrb_o
    ,output          outport2_bready_o
    ,output          outport2_arvalid_o
    ,output [ 31:0]  outport2_araddr_o
    ,output          outport2_rready_o
    ,output          outport3_awvalid_o
    ,output [ 31:0]  outport3_awaddr_o
    ,output          outport3_wvalid_o
    ,output [ 31:0]  outport3_wdata_o
    ,output [  3:0]  outport3_wstrb_o
    ,output          outport3_bready_o
    ,output          outport3_arvalid_o
    ,output [ 31:0]  outport3_araddr_o
    ,output          outport3_rready_o
    ,output          outport4_awvalid_o
    ,output [ 31:0]  outport4_awaddr_o
    ,output          outport4_wvalid_o
    ,output [ 31:0]  outport4_wdata_o
    ,output [  3:0]  outport4_wstrb_o
    ,output          outport4_bready_o
    ,output          outport4_arvalid_o
    ,output [ 31:0]  outport4_araddr_o
    ,output          outport4_rready_o
);



//-----------------------------------------------------------------
// Read Dist
//-----------------------------------------------------------------
reg [2:0] read_sel_r;
reg [2:0] read_sel_q;
reg read_pending_q;
reg read_pending_r;

always @ *
begin
    read_pending_r = read_pending_q;

    // Read response
    if (inport_rvalid_o && inport_rready_i)
        read_pending_r = 1'b0;
    // New request
    else if (!read_pending_r && inport_arvalid_i)
        read_pending_r = inport_arready_o;

    // Address to port selection
    if (!read_pending_q)
        read_sel_r  = inport_araddr_i[26:24];
    else
        read_sel_r  = read_sel_q;
end

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
begin
    read_sel_q      <= 3'b0;
    read_pending_q  <= 1'b0;
end
else
begin
    read_sel_q      <= read_sel_r;
    read_pending_q  <= read_pending_r;
end

//-----------------------------------------------------------------
// Read Request
//-----------------------------------------------------------------
assign outport0_arvalid_o =  inport_arvalid_i && (read_sel_r == 3'd0) && !read_pending_q;
assign outport0_araddr_o  =  inport_araddr_i;
assign outport1_arvalid_o =  inport_arvalid_i && (read_sel_r == 3'd1) && !read_pending_q;
assign outport1_araddr_o  =  inport_araddr_i;
assign outport2_arvalid_o =  inport_arvalid_i && (read_sel_r == 3'd2) && !read_pending_q;
assign outport2_araddr_o  =  inport_araddr_i;
assign outport3_arvalid_o =  inport_arvalid_i && (read_sel_r == 3'd3) && !read_pending_q;
assign outport3_araddr_o  =  inport_araddr_i;
assign outport4_arvalid_o =  inport_arvalid_i && (read_sel_r == 3'd4) && !read_pending_q;
assign outport4_araddr_o  =  inport_araddr_i;

//-----------------------------------------------------------------
// Read Request Accept
//-----------------------------------------------------------------
reg inport_arready_r;

always @ *
begin
    inport_arready_r  = 1'b0;

    case (read_sel_r)
    3'd0:
        inport_arready_r = outport0_arready_i;
    3'd1:
        inport_arready_r = outport1_arready_i;
    3'd2:
        inport_arready_r = outport2_arready_i;
    3'd3:
        inport_arready_r = outport3_arready_i;
    3'd4:
        inport_arready_r = outport4_arready_i;
    default :
        ;
    endcase
end

assign inport_arready_o = inport_arready_r && !read_pending_q;

//-----------------------------------------------------------------
// Read Response
//-----------------------------------------------------------------
reg        inport_rvalid_r;
reg [31:0] inport_rdata_r;
reg [1:0]  inport_rresp_r;

always @ *
begin
    inport_rvalid_r  = 1'b0;
    inport_rdata_r   = 32'b0;
    inport_rresp_r   = 2'b0;

    case (read_sel_q)
    3'd0:
    begin
        inport_rvalid_r = outport0_rvalid_i;
        inport_rdata_r  = outport0_rdata_i;
        inport_rresp_r  = outport0_rresp_i;
    end
    3'd1:
    begin
        inport_rvalid_r = outport1_rvalid_i;
        inport_rdata_r  = outport1_rdata_i;
        inport_rresp_r  = outport1_rresp_i;
    end
    3'd2:
    begin
        inport_rvalid_r = outport2_rvalid_i;
        inport_rdata_r  = outport2_rdata_i;
        inport_rresp_r  = outport2_rresp_i;
    end
    3'd3:
    begin
        inport_rvalid_r = outport3_rvalid_i;
        inport_rdata_r  = outport3_rdata_i;
        inport_rresp_r  = outport3_rresp_i;
    end
    3'd4:
    begin
        inport_rvalid_r = outport4_rvalid_i;
        inport_rdata_r  = outport4_rdata_i;
        inport_rresp_r  = outport4_rresp_i;
    end
    default :
        ;
    endcase
end

assign inport_rvalid_o = inport_rvalid_r;
assign inport_rdata_o  = inport_rdata_r;
assign inport_rresp_o  = inport_rresp_r;

//-----------------------------------------------------------------
// Read Response accept
//-----------------------------------------------------------------
assign outport0_rready_o = inport_rready_i && (read_sel_q == 3'd0);
assign outport1_rready_o = inport_rready_i && (read_sel_q == 3'd1);
assign outport2_rready_o = inport_rready_i && (read_sel_q == 3'd2);
assign outport3_rready_o = inport_rready_i && (read_sel_q == 3'd3);
assign outport4_rready_o = inport_rready_i && (read_sel_q == 3'd4);

//-----------------------------------------------------------------
// Write Address Latch (for delayed data)
//-----------------------------------------------------------------
reg [31:0] awaddr_q;
reg        awvalid_q;
reg        awvalid_r;

always @ *
begin
    awvalid_r   = awvalid_q;

    // Address ready, data not ready
    if (inport_awvalid_i && inport_awready_o && !inport_wvalid_i)
        awvalid_r = 1'b1;
    else if (inport_bvalid_o && inport_bready_i)
        awvalid_r = 1'b0;
end

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
begin
    awvalid_q   <= 1'b0;
    awaddr_q    <= 32'b0;
end
else
begin
    awvalid_q   <= awvalid_r;

    if (inport_awvalid_i && inport_awready_o)
        awaddr_q    <= inport_awaddr_i;
end

wire        inport_awvalid_w = inport_awvalid_i | awvalid_q;
wire [31:0] inport_awaddr_w  = awvalid_q ? awaddr_q : inport_awaddr_i;

//-----------------------------------------------------------------
// Write Dist
//-----------------------------------------------------------------
reg [2:0] write_sel_r;
reg [2:0] write_sel_q;
reg write_pending_q;
reg write_pending_r;

always @ *
begin
    write_pending_r = write_pending_q;

    // Write response
    if (inport_bvalid_o && inport_bready_i)
        write_pending_r = 1'b0;
    // New request
    // NOTE: Assumes slaves will accept both address & data in same cycle...
    else if (!write_pending_r && inport_wvalid_i)
        write_pending_r = inport_wready_o;

    // Address to port selection
    if (!write_pending_q)
        write_sel_r  = inport_awaddr_w[26:24];
    else
        write_sel_r  = write_sel_q;
end

always @ (posedge clk_i or posedge rst_i)
if (rst_i)
begin
    write_sel_q      <= 3'b0;
    write_pending_q  <= 1'b0;
end
else
begin
    write_sel_q      <= write_sel_r;
    write_pending_q  <= write_pending_r;
end

//-----------------------------------------------------------------
// Write Request
//-----------------------------------------------------------------
// NOTE: Assumes slaves will accept both address & data in same cycle...
assign outport0_awvalid_o =  inport_awvalid_w && inport_wvalid_i && (write_sel_r == 3'd0) && !write_pending_q;
assign outport0_awaddr_o  =  inport_awaddr_w;
assign outport0_wvalid_o  =  outport0_awvalid_o;
assign outport0_wdata_o   =  inport_wdata_i;
assign outport0_wstrb_o   =  inport_wstrb_i;
assign outport1_awvalid_o =  inport_awvalid_w && inport_wvalid_i && (write_sel_r == 3'd1) && !write_pending_q;
assign outport1_awaddr_o  =  inport_awaddr_w;
assign outport1_wvalid_o  =  outport1_awvalid_o;
assign outport1_wdata_o   =  inport_wdata_i;
assign outport1_wstrb_o   =  inport_wstrb_i;
assign outport2_awvalid_o =  inport_awvalid_w && inport_wvalid_i && (write_sel_r == 3'd2) && !write_pending_q;
assign outport2_awaddr_o  =  inport_awaddr_w;
assign outport2_wvalid_o  =  outport2_awvalid_o;
assign outport2_wdata_o   =  inport_wdata_i;
assign outport2_wstrb_o   =  inport_wstrb_i;
assign outport3_awvalid_o =  inport_awvalid_w && inport_wvalid_i && (write_sel_r == 3'd3) && !write_pending_q;
assign outport3_awaddr_o  =  inport_awaddr_w;
assign outport3_wvalid_o  =  outport3_awvalid_o;
assign outport3_wdata_o   =  inport_wdata_i;
assign outport3_wstrb_o   =  inport_wstrb_i;
assign outport4_awvalid_o =  inport_awvalid_w && inport_wvalid_i && (write_sel_r == 3'd4) && !write_pending_q;
assign outport4_awaddr_o  =  inport_awaddr_w;
assign outport4_wvalid_o  =  outport4_awvalid_o;
assign outport4_wdata_o   =  inport_wdata_i;
assign outport4_wstrb_o   =  inport_wstrb_i;

//-----------------------------------------------------------------
// Write Request Accept
//-----------------------------------------------------------------
reg inport_awready_r;
reg inport_wready_r;

always @ *
begin
    inport_awready_r  = 1'b0;
    inport_wready_r   = 1'b0;

    case (write_sel_r)
    3'd0:
    begin
        inport_awready_r = outport0_awready_i;
        inport_wready_r  = outport0_wready_i;
    end
    3'd1:
    begin
        inport_awready_r = outport1_awready_i;
        inport_wready_r  = outport1_wready_i;
    end
    3'd2:
    begin
        inport_awready_r = outport2_awready_i;
        inport_wready_r  = outport2_wready_i;
    end
    3'd3:
    begin
        inport_awready_r = outport3_awready_i;
        inport_wready_r  = outport3_wready_i;
    end
    3'd4:
    begin
        inport_awready_r = outport4_awready_i;
        inport_wready_r  = outport4_wready_i;
    end
    default :
        ;
    endcase
end

assign inport_awready_o = inport_awready_r && !write_pending_q && !awvalid_q;
assign inport_wready_o  = inport_wready_r  && !write_pending_q && inport_awvalid_w;

//-----------------------------------------------------------------
// Write Response
//-----------------------------------------------------------------
reg        inport_bvalid_r;
reg [1:0]  inport_bresp_r;

always @ *
begin
    inport_bvalid_r  = 1'b0;
    inport_bresp_r   = 2'b0;

    case (write_sel_q)
    3'd0:
    begin
        inport_bvalid_r = outport0_bvalid_i;
        inport_bresp_r  = outport0_bresp_i;
    end
    3'd1:
    begin
        inport_bvalid_r = outport1_bvalid_i;
        inport_bresp_r  = outport1_bresp_i;
    end
    3'd2:
    begin
        inport_bvalid_r = outport2_bvalid_i;
        inport_bresp_r  = outport2_bresp_i;
    end
    3'd3:
    begin
        inport_bvalid_r = outport3_bvalid_i;
        inport_bresp_r  = outport3_bresp_i;
    end
    3'd4:
    begin
        inport_bvalid_r = outport4_bvalid_i;
        inport_bresp_r  = outport4_bresp_i;
    end
    default :
        ;
    endcase
end

assign inport_bvalid_o = inport_bvalid_r;
assign inport_bresp_o  = inport_bresp_r;

//-----------------------------------------------------------------
// Write Response accept
//-----------------------------------------------------------------
assign outport0_bready_o = inport_bready_i && (write_sel_q == 3'd0);
assign outport1_bready_o = inport_bready_i && (write_sel_q == 3'd1);
assign outport2_bready_o = inport_bready_i && (write_sel_q == 3'd2);
assign outport3_bready_o = inport_bready_i && (write_sel_q == 3'd3);
assign outport4_bready_o = inport_bready_i && (write_sel_q == 3'd4);



endmodule
