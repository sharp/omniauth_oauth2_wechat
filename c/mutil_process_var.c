#include <sys/types.h>
#include <sys/mman.h>
#include <fcntl.h> /* For O_* constants */ 
int main(){
	void *mem;
	int shm_fd;
	shm_fd = shm_open("file", O_CREAT | O_RDWR, 0644);
	ftruncate(shm_fd, sizeof(int));
	mem = mmap(0, sizeof(int), PROT_WRITE | PROT_READ, MAP_SHARED, shm_fd, 0);
	/* fork it, use it */
	fork();
	munmap(mem, sizeof(int));
	close(shm_fd);
	shm_unlink("file");
}
