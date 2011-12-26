#include <netinet/in.h>
#include <errno.h>
#include <fcntl.h>

static struct sockaddr cssc_addr;

int main(int argc, char **argv){
  int result;
  result = start_test();
  return result;
}

int start_test(void)
{
  char buf[256] = {0};
  int sock = session_connect();
  if (!sock)
    return sock;

  if (send(sock, "hello", sizeof ("hello"), 0) <= 0)
  {
    perror("send error");
    return -1;
  }
  if (recv(sock, buf, sizeof (buf), 0) <= 0)
  {
    printf("recv error \n");
    return -1;
  }else{
    printf("recv is :%s\n", buf);
  }
  close(sock);
  return sock;
}

int session_connect()
{
  int sock;
  struct timeval tv;
  struct sockaddr_in server_addr;
  tv.tv_sec = 5;
  tv.tv_usec = 0;

  bzero(&server_addr, sizeof(server_addr));
  server_addr.sin_family = AF_INET;
  server_addr.sin_port = htons(8080);
  inet_pton(AF_INET, "127.0.0.1", &server_addr.sin_addr);
  sock = socket(AF_INET, SOCK_STREAM, 0);
  if (sock < 0)
  {
    perror("connect error!");
  }
  if (setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, (char *) &tv, sizeof (tv)) != 0)
  {
    perror("connect error!");
  }

  if (connect(sock, &server_addr, sizeof(server_addr)) != 0)
  {
    perror("connect error!");
  }

  return sock;
}


