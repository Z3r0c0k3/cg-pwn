#include <stdio.h>

int main(){
	
	char buf[256];
	
	printf("buf : %p\n",buf);
	printf("input : ");
	gets(buf);
	printf("Your input : %s\n",buf);

	return 0;
}


