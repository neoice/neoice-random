/*	prime finder, version 1.01
	completed november 12 2007

first revision.  changed pure brute force
algorithm to ignore numbers divisible by 2.
any number divisible by 2 is automatically
not prime.

removed debug code as 1.00 generated to
554303 successfully. (killed as runtime 
was over an hour at this point)

appeared to crash while running.
upgraded to 1.02

*/

#include <stdio.h>

int number;
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

                               


int prime(int prime) {
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
