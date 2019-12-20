#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <unistd.h>
#include <string.h>

#include "pano_io.h"
#include "timer.h"
#include "i2c.h"
#include "audio.h"
#include "spiffs.h"
#include "spi_lite.h"
#include "spiffs_drv.h"
#include "printf.h"

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
void PlayFiles(spiffs *pFS);


spiffs *gSpiffs;

int main(int argc, char **argv)
{
   unsigned char Buf[256];
   int Id = 0;
   int i;

   ALOG("imfplay compiled " __DATE__ " " __TIME__ "\n");

   if(i2c_init(&gI2cCtx)) {
      ELOG("i2c_init failed\n");
   }
   else {
      audio_init(&gI2cCtx);
   }

   memset(Buf,0x55,sizeof(Buf));
   spi_cs(0);
// read SPI flash device id
   spi_sendrecv(0x9f);
// Read and toss first byte which was received while the command was
// being shifted out
   spi_readblock(Buf,1);
   spi_readblock(Buf,3);
   spi_cs(1);
   printf("SPI flash JEDEC device ID:");
   for(i = 0; i < 3; i++) {
      Id <<= 8;
      Id += Buf[i];
      printf(" 0x%02x",Buf[i]);
   }
   printf("\n");

   if((gSpiffs = SpiffsMount()) == NULL) {
      ELOG("SpiffsMount failed\n");
   }
   else {
      if(argc > 0) {
         for(i = 0; i < argc; i++) {
            imfplay(argv[i]);
         }
      }
      else {
         PlayFiles(gSpiffs);
      }
      SpiffsUnmount();
   }

   for( ; ; );
}

void PlayFiles(spiffs *pFS)
{
    spiffs_DIR dir;
    struct spiffs_dirent ent;
    struct spiffs_dirent *it;
    uint32_t Total = 0;
    char *cp;

    SPIFFS_opendir(pFS,0,&dir);
    for( ; ; ) {
        it = SPIFFS_readdir(&dir, &ent);
        if (!it) {
            break;
        }
        Total += it->size;
        printf("%s: %ld\n",it->name,it->size);
        cp = strrchr(it->name,'.');
        if(cp != NULL && strcmp(cp,".dro") == 0) {
           ALOG("Calling imfplay\n");
           ALOG("imfplay returned %d\n",imfplay(it->name));
        }
    }
    SPIFFS_closedir(&dir);
    printf("\nTotal %ld\n",Total);
}

