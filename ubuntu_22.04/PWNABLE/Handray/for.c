#include <stdio.h>

void func(int a){
	for(int i=1;i<10;i++){
		printf("%d * %d = %d\n",a,i,a*i);
	}
}

int main(){

	int a = 0;
	scanf("%d",&a);

	func(a);
	return 0;
}
