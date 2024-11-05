#include <stdio.h>

int main(){

	char arr[20] = {0,};
	int num = 10;
	int i = 0;

	printf("Your name : ");
	scanf("%s",arr);

	printf("hello~~ %s\n",arr);

	for(i = 1 ; i < num; i++){
		printf("2 * %d = %d\n",i,2*i);
	}

	return 0;


}
