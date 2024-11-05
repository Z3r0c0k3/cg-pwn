#include <stdio.h>
#include <stdlib.h>

void hidden(){
	system("/bin/sh");
}

int main(){

	char buf[100];

	printf("Your name : ");
	gets(buf);
	printf("hi %s\n",buf);

	return 0;
}


