#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main() {

        int one, two, answer;
        srand(time(0));

        for (int i = 0; i < 100; i++) {
                one = rand() % 50000;
                two = rand() % 50000;

                printf("#%d: %d + %d = [?]\n", i, one, two);
                printf("> ");
                scanf("%d", &answer);

                if (one + two == answer) {
                        printf("Correct!\n");
                }
                else {
                        printf("Wrong! bye~ bye~\n");
                        exit(1);
                }

        }

        printf("Good! Good! Good!");
        system("/bin/sh");

        return 0;
}
