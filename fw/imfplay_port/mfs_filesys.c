/* 
   Dummy mfs that just returns data from a single file which is compiled
   into the application.
 
   open/close/read/seek are the only routines
*/ 
#include <stdint.h>
#include <string.h>
#include <stdio.h>

#include "spiffs.h"

#include "xilmfs.h"
#define DEBUG_LOGGING
// #define VERBOSE_DEBUG_LOGGING
// #define LOG_TO_BOTH
#include "log.h"

extern spiffs *gSpiffs;

/**
 * open a file
 * @param filename is the name of the file to open
 * @param mode is MFS_MODE_READ or MFS_MODE_WRITE or MFS_MODE_CREATE
 * this function should be used for FILEs and not DIRs
 * no error checking (is this FILE and not DIR?) is done for MFS_MODE_READ
 * MFS_MODE_CREATE automatically creates a FILE and not a DIR
 * MFS_MODE_WRITE fails if the specified file is a DIR
 * @return index of file in array mfs_open_files or -1
 */
int mfs_file_open(const char *filename, int mode) 
{
   int Ret;
   LOG("Opening '%s'\n",filename);
   Ret = (int) SPIFFS_open(gSpiffs,filename,SPIFFS_O_RDONLY, 0);
   LOG("SPIFFS_open returned %d\n",Ret);

   return Ret;
}

/**
 * read characters to a file
 * @param fd is a descriptor for the file from which the characters are read
 * @param buf is a pre allocated buffer that will contain the read characters
 * @param buflen is the number of characters from buf to be read
 * fd should be a valid index in mfs_open_files array
 * Works only if fd points to a file and not a dir
 * buf should be a pointer to a pre-allocated buffer of size buflen or more
 * buflen chars are read and placed in buf
 * if fewer than buflen chars are available then only that many chars are read
 * @return num bytes read or 0 for error=no bytes read
*/
int mfs_file_read(int fd, char *buf, int buflen) 
{
   int Ret; 
   VLOG("Reading %d bytes into buffer @ %p\n",buflen,buf);
   Ret = (int) SPIFFS_read(gSpiffs,(s16_t) fd,buf,buflen);
   VLOG("Returning %d\n",Ret);
   if(Ret > 0) {
      VLOG_HEX(buf,Ret);
   }

   return Ret;
}

/**
 * close an open file and
 * recover the file table entry in mfs_open_files corresponding to the fd
 * if the fd is not valid, return 0
 * fd is not valid if the index in mfs_open_files is out of range, or
 * if the corresponding entry is not an open file
 * @param fd is the file descriptor for the file to be closed
 * @return 1 on success, 0 otherwise
 */
int mfs_file_close(int fd) 
{
   int Ret;
   LOG("Called, fd %d\n",fd);
   Ret = (int) SPIFFS_close(gSpiffs,(s16_t) fd);

   return Ret;
}

/**
 * seek to a given offset within the file
 * @param fd should be a valid file descriptor for an open file
 * @param whence is one of MFS_SEEK_SET, MFS_SEEK_CUR or MFS_SEEK_END
 * @param offset is the offset from the beginning, end or current position as specified by the whence parameter
 * if MFS_SEEK_END is specified, the offset can be either 0 or negative
 * otherwise offset should be positive or 0
 * it is an error to seek before beginning of file or after the end of file
 * @return -1 on failure, value of offset from beginning of file on success
 */
long mfs_file_lseek(int fd, long offset, int whence) 
{
   long Ret;
   VLOG("Called fd %d, offset %ld, whence %d\n",fd,offset,whence);
   
   Ret = SPIFFS_lseek(gSpiffs,fd,offset,whence);
   VLOG("Returning %ld\n",Ret);

   return Ret;
}

