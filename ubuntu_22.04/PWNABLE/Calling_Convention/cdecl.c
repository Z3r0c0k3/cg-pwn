#include <stdio.h>

void a(char * name, int age){

	printf("%s %d\n",name,age);

}

int main(){

	char name[10] = "shj";
	int age = 20;

	a(name, age);

	return 0;
}
