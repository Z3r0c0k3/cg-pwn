#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <unistd.h>


int main(){

	void * handle = dlopen("/lib/i386-linux-gnu/libc.so.6",1);
	int (*system_addr)(const char* str) = dlsym(handle, "system");

	char buf[0x100];

	puts("/bin/sh");
	printf("system addr : %p\n",system_addr);

	gets(buf);

	return 0;
}
