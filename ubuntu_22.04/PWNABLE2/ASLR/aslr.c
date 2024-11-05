#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <unistd.h>


int main(){

	void * handle = dlopen("/lib/i386-linux-gnu/libc.so.6",1);
	int (*system_addr)(const char* str) = dlsym(handle, "system");

	char arr[100];
	
	int * heap_ptr = (int*)malloc(sizeof(int));
	
	printf("library : %p\n",system_addr);
	printf("stack : %p\n",arr);
	printf("heap : %p\n",heap_ptr);


	return 0;
}
