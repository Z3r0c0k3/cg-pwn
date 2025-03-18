#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(void) {

	char secret[23] = "FLAG{g00d_MeM02y_1eAK}";
  	char name[20] = {0,};

	write(1,"Your name? : ",13);
	read(0,name,40);

  	printf("Your name : %s ", name);
	return 0;
}
