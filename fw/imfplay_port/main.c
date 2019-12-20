#include <stdint.h>
#include "pano_io.h"
#include "timer.h"
#include "i2c.h"
#include "audio.h"

#define DEBUG_LOGGING
// #define VERBOSE_DEBUG_LOGGING
#define LOG_TO_BOTH
#include "log.h"

ContextI2C gI2cCtx = {
   .GpioBase = GPIO_BASE,
   .BitSCL = GPIO_BIT_CODEC_SCL,
   .BitSDA = GPIO_BIT_CODEC_SDA
};

int imfplay(char *filename);

void main() 
{
   ALOG("imfplay compiled " __DATE__ " " __TIME__ "\n");
   printf("Calling i2c_init\n");
   if(i2c_init(&gI2cCtx)) {
      ELOG("i2c_init failed\n");
   }
   else {
      audio_init(&gI2cCtx);
   }
   ALOG("Calling imfplay\n");
   ALOG("imfplay returned %d\n",imfplay("dummy"));
   for( ; ; );
}

