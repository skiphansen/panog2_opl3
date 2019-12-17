#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <unistd.h>
#include <string.h>

#include "spiffs.h"
#include "spi_lite.h"
#include "spiffs_drv.h"
#include "printf.h"
#define DEBUG_LOGGING
#include "log.h"

void ListFiles(spiffs *pFS);

spiffs *gSpiffs;

//-----------------------------------------------------------------
// main
//-----------------------------------------------------------------
int main(int argc, char *argv[])
{
    int i;
    unsigned char Buf[256];
    int Id = 0;

    printf("Spi read test\n");
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

    switch(Id) {
       case 0x202018:
          printf("M25P128 SPI flash confirmed\n");
          break;

       case 0x202014:
          printf("M25P80 SPI flash confirmed\n");
          break;

       default:
          printf("Unknown JEDEC ID\n");
          break;
    }

    printf("\nReading first 256 bytes of flash...");
    spi_cs(0);
    spi_sendrecv(0x03);
    spi_sendrecv(0);
    spi_sendrecv(0);
    spi_sendrecv(0);
    spi_readblock(Buf,1);
    spi_readblock(Buf,sizeof(Buf));
    spi_cs(1);
    printf("\n");

    // LogHex(Buf,sizeof(Buf));

    if((gSpiffs = SpiffsMount()) == NULL) {
       ELOG("SpiffsMount failed\n");
    }
    else {
       LOG("gSpiffs: %p\n",gSpiffs);
       ListFiles(gSpiffs);
       SpiffsUnmount();
    }

    for( ; ; );

    return 0;
}

void ListFiles(spiffs *pFS)
{
    spiffs_DIR dir;
    struct spiffs_dirent ent;
    struct spiffs_dirent *it;
    uint32_t Total = 0;

    SPIFFS_opendir(pFS,0,&dir);
    for( ; ; ) {
        it = SPIFFS_readdir(&dir, &ent);
        if (!it) {
            break;
        }
        Total += it->size;
        printf("%s: %ld\n",it->name,it->size);
    }
    SPIFFS_closedir(&dir);
    printf("\nTotal %ld\n",Total);
}

