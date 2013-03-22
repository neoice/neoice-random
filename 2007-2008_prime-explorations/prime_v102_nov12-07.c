/*	prime finder, version 1.02
	completed november 12 2007

version history
1.00: initial code
1.01: ignore numbers divisible by 2

1.01 appeared to crash, probably due
to some sort of overflow.

changed ints to long

*/

#include <stdio.h>

long number;
int result;

int main(void) {
        //printf("hello\n");
	printf("2\n"); // 2 is a prime, so it MUST be printed
        result = 0;

        for (number = 3; number < 10^6; number += 2) {
                result = prime(number);
                if (result == 1)
                        printf("%d\n", number);
        }
return(0);
}

                               


int prime(long prime) {
        int i = 1;
        int holder = 0;
        int divisor = 1;

        for (i; i < prime - 1; i++) {
                divisor = (prime - i);
                holder = prime % divisor;
                if (holder == 0)
                        return(0);
        }
return(1);
}
