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
#include "pano_io.h"

#define DEBUG_LOGGING
#include "log.h"

ContextI2C gI2cCtx = {
   .GpioBase = GPIO_BASE,
   .BitSCL = GPIO_BIT_CODEC_SCL,
   .BitSDA = GPIO_BIT_CODEC_SDA
};


#define REG_WR(reg, wr_data)       *((volatile uint32_t *)(reg)) = (wr_data)
#define REG_RD(reg)                *((volatile uint32_t *)(reg))

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
    }

    for( ; ; );

    return 0;
}

#ifndef LOGGING_DISABLED
void LogHex(char *LogFlags,void *Data,int Len)
{
   int i;
   uint8_t *cp = (uint8_t *) Data;

   for(i = 0; i < Len; i++) {
      if(i != 0 && (i & 0xf) == 0) {
         _LOG(LogFlags,"\n");
      }
      else if(i != 0) {
         _LOG(LogFlags," ");
      }
      _LOG(LogFlags,"%02x",cp[i]);
   }
   if(((i - 1) & 0xf) != 0) {
      _LOG(LogFlags,"\n");
   }
}
#endif

