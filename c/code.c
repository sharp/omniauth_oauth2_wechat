#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const char cb64[]="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

static const char cd64[]="|$$$}rstuvwxyz{$$$$$$$>?@ABCDEFGHIJKLMNOPQRSTUVW$$$$$$XYZ[\\]^_`abcdefghijklmnopq";

void encodeblock(unsigned char in[3], unsigned char out[4], int len)
{
  out[0] = cb64[in[0] >> 2];
  out[1] = cb64[((in[0] & 0x03) << 4) | ((in[1] & 0xf0) >> 4)];
  out[2] = (unsigned char)(len > 1 ? cb64[((in[1] & 0x0f) << 2) | ((in[2] & 0xc0) >> 6)] : '=');
  out[3] = (unsigned char)(len > 2 ? cb64[in[2] & 0x3f] : '=');
}

void encode(char *infile, char  *outfile, int linesize)
{
  unsigned char in[3], out[4];
  int i, k, j, len, blocksout = 0;

  len = strlen(infile);
  if(len <= 3)
  {
    i = 0;
    memcpy(in, infile, len);
    if(len == 1)
    {
      in[1] = in[2] = 0;
    }
    else if(len == 2)
    {
      in[2] = in[1] = 0;
    }
    encodeblock(in, out, len);
    memcpy(outfile, out, 4);
  }
  else{
    j = len/3;
    k = len%3;
    for(i = 0; i < j; i++)
    {
      memcpy(in, infile + (i*3), 3);
      encodeblock(in, out, 3);
      memcpy(outfile+(i*4), out, 4);
    }
    if(k != 0){
      switch(k)
      {
        case 1:
          in[0] = infile[j*3];
          in[1] = 0;
          break;
        case 2:
          in[0] = infile[j*3];
          in[1] = infile[j*3+1];
          in[2] = 0;
          break;
      }
      encodeblock(in, out, k);
      printf("%s\n", out);
      memcpy(outfile+j*4, out, 4);
  }
  for(i = 0; i < strlen(outfile); i++)
    printf("%c", outfile[i]);
  printf("\n");
}

int main(int argc, char **argv)
{
  int ret = 0;
  char outcode[256] = {0};
  if(argc < 0)
    return 1;
  else
    encode(argv[1], outcode, sizeof(outcode));
  return 0;
}
