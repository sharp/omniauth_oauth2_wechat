#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const char cb64[]="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"; 
static const char cd64[]="|$$$}rstuvwxyz{$$$$$$$>?@ABCDEFGHIJKLMNOPQRSTUVW$$$$$$XYZ[\\]^_`abcdefghijklmnopq";


void decodeblock(unsigned char in[4], unsigned char out[3])
{
  out[0] = (unsigned char)(in[0] << 2 | in[1] >> 4);
  out[1] = (unsigned char)(in[1] << 4 | in[2] >> 2);
  out[2] = (unsigned char)(((in[2] << 6) & 0xc0) | in[3]);
}

void decode(char *infile, char *outfile)
{
  unsigned char in[4], out[3], v;
  int i, j, k, len;

  len = strlen(infile);
  if(len >= 4)
  { 
    j = len/4;
    for(i = 0; i < j; i++){
      memcpy(in, infile+i*4, 4);
      for(k = 0; k < 4; k++)
      {
        v = in[k];
        v = (unsigned char)((v < 43 || v > 122) ? 0 : cd64[v - 43]);
        if(v){
          v = (unsigned char)((v == '$') ? 0: v - 61);
          if(v)
            in[k] = (unsigned char)(v - 1);
          else
            in[k] = 0;
        }    
      }
      decodeblock(in, out);
      memcpy(outfile+i*3, out, 3);
    }    
  }
  else
  {
    printf("error\n");
    return;
  }  
  for(i = 0; i < strlen(outfile); i++)
    printf("%c", outfile[i]);
  printf("\n");
}

int main(int argc, char **argv)
{
  unsigned char buffer[256] = {0};
  printf("%s\n", argv[1]);
  decode(argv[1], buffer);
  return 0;
}
