#include <stdio.h>

int main(){

	char shellcode[] = "\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\x89\xc2\xb0\x0b\xcd\x80";

	void (*shell)();
	shell=(void (*)()) shellcode;

	shell();

	return 0;
}

//gcc -m32 -z execstack -o not_nx shellcode.c


