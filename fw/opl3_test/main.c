#include <stdint.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "gpio_defs.h"
#include "spi_lite.h"
#include "pano_io.h"
#include "i2c.h"
#include "audio.h"
#include "timer.h"
#include "opl3_drv.h"

#define DEBUG_LOGGING
#include "log.h"

ContextI2C gI2cCtx = {
   .GpioBase = GPIO_BASE,
   .BitSCL = GPIO_BIT_CODEC_SCL,
   .BitSDA = GPIO_BIT_CODEC_SDA
};

void SinTest(void);


//-----------------------------------------------------------------
// main
//-----------------------------------------------------------------
int main(int argc, char *argv[])
{
    int i;
    unsigned char Buf[256];
    int Id = 0;
    uint32_t Temp;
    uint32_t Led;

    LOG("Hello pano world!\n");

    printf("Calling i2c_init\n");
    if(i2c_init(&gI2cCtx)) {
       ELOG("i2c_init failed\n");
    }
    else {
       audio_init(&gI2cCtx);
       SinTest();
    }

    for( ; ; );

    return 0;
}


#define BANK   0
// initialize OPL3 registers for a 1kHz sine wave
struct {
   uint8_t Bank;
   uint8_t Reg;
   uint8_t Value;
} InitData[] = {
//    {1, 0x05, 0x01 }, // enable OPL3 mode

   {BANK,  0x20, 0x21 }, // OP1 Control Flags/Multiplier
   {BANK,  0x23, 0x21 }, // OP2 Control Flags/Multiplier
   {BANK,  0x28, 0x21 }, // OP3 Control Flags/Multiplier
   {BANK,  0x2b, 0x21 }, // OP4 Control Flags/Multiplier

   {BANK,  0x40, 0x08 }, // OP1 KSL/TL
#if 0                         //
   {BANK,  0x43, 0x3f }, // OP2 KSL/TL (muted)
   {BANK,  0x48, 0x3f }, // OP3 KSL/TL (muted)
   {BANK,  0x4b, 0x3f }, // OP4 KSL/TL (muted)
#endif

   {BANK,  0x60, 0x88 }, // OP1 AR/DR
   {BANK,  0x63, 0x88 }, // OP2 AR/DR
   {BANK,  0x68, 0x88 }, // OP3 AR/DR
   {BANK,  0x6b, 0x88 }, // OP4 AR/DR

   {BANK,  0x80, 0x00 }, // OP1 SL/RR
   {BANK,  0x83, 0x00 }, // OP2 SL/RR
   {BANK,  0x88, 0x00 }, // OP3 SL/RR
   {BANK,  0x8b, 0x00 }, // OP4 SL/RR

   {BANK,  0xe0, 0x00 }, // OP1 Waveform
   {BANK,  0xe3, 0x00 }, // OP2 Waveform
   {BANK,  0xe8, 0x00 }, // OP3 Waveform
   {BANK,  0xeb, 0x00 }, // OP4 Waveform

   {BANK,  0xc0, 0x01 }, // Channels/Connections/Feedback
   {BANK,  0xc3, 0x00 }, // Channels/Connections/Feedback

// FNUM        $freq = ($fnum / (1 << (20-$block))) * 49715.0;

   {BANK,  0xa0, 0xa4 }, // FNUM        $freq = ($fnum / (1 << (20-$block))) * 49715.0;
   {BANK,  0xb0, 0x3c }, // KON/Block/FNUM_H

#if 0
#undef BANK
#define BANK   1

   {BANK,  0x20, 0x21 }, // OP1 Control Flags/Multiplier
   {BANK,  0x23, 0x21 }, // OP2 Control Flags/Multiplier
   {BANK,  0x28, 0x21 }, // OP3 Control Flags/Multiplier
   {BANK,  0x2b, 0x21 }, // OP4 Control Flags/Multiplier

   {BANK,  0x40, 0x00 }, // OP1 KSL/TL
   {BANK,  0x43, 0x3f }, // OP2 KSL/TL (muted)
   {BANK,  0x48, 0x3f }, // OP3 KSL/TL (muted)
   {BANK,  0x4b, 0x3f }, // OP4 KSL/TL (muted)

   {BANK,  0x60, 0x88 }, // OP1 AR/DR
   {BANK,  0x63, 0x88 }, // OP2 AR/DR
   {BANK,  0x68, 0x88 }, // OP3 AR/DR
   {BANK,  0x6b, 0x88 }, // OP4 AR/DR

   {BANK,  0x80, 0x00 }, // OP1 SL/RR
   {BANK,  0x83, 0x00 }, // OP2 SL/RR
   {BANK,  0x88, 0x00 }, // OP3 SL/RR
   {BANK,  0x8b, 0x00 }, // OP4 SL/RR

   {BANK,  0xe0, 0x00 }, // OP1 Waveform
   {BANK,  0xe3, 0x00 }, // OP2 Waveform
   {BANK,  0xe8, 0x00 }, // OP3 Waveform
   {BANK,  0xeb, 0x00 }, // OP4 Waveform

   {BANK,  0xc0, 0x31 }, // Channels/Connections/Feedback
   {BANK,  0xc3, 0x30 }, // Channels/Connections/Feedback

// FNUM        $freq = ($fnum / (1 << (20-$block))) * 49715.0;

   {BANK,  0xa0, 0xa4 }, // FNUM        $freq = ($fnum / (1 << (20-$block))) * 49715.0;
   {BANK,  0xb0, 0x38 }, // KON/Block/FNUM_H
#endif
   {0xff}   // end of table
};


void SinTest()
{
   int i;
   int j;

   for(i = 0; i < NUM_BANKS; i++) {
      for(j = 0; j < NUM_OPS_PER_BANK; j++) {
         Opl3WriteReg(0,REG_ADR(i,0x40+OpOffset[j]),0x3f);   // KSL/TL (muted)
      }
   }

   for(i = 0; InitData[i].Bank != 0xff; i++) {
      Opl3WriteReg(0,InitData[i].Reg + (InitData[i].Bank << 8) ,InitData[i].Value);
   }
}

