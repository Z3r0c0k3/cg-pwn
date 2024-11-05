#include <stdio.h>

int main(){
	
	int age = 0;
	char name[100] = {0,};

	printf("Your age : ");
	scanf("%d",&age);
	
	printf("Your name : ");
	scanf("%s",name);

	printf("Age : %d\n",age);
	printf("Name : %s\n",name);

	return 0;
}


