/*	prime finder, version 1.00
	completed november 11 2007

pure brute force algorithm to solve prime
numbers.  terribly slow.

improvement for next version: any number
divisible by 2 is automatically not prime.
simply incrementing $number by 2 in the
main loop should solve this.

debug code left in. will remove in 1.01
if 1.00 generates successfully.

average runtime = over an hour.
(killed after generating to 554303
successfully)

*/

#include <stdio.h>

int number;
int result;

int main(void) {
        //printf("hello\n");
        result = 0;

        for (number = 2; number < 10^6; number++) {
                //printf("number = %d\n", number);
                result = prime(number);
                //printf("result: %d\n", result);
                if (result == 1)
                        printf("%d\n", number);
        }
return(0);
}

                               


int prime(int prime) {
        int i = 1;
        int holder = 0;
        int divisor = 1;

//printf("inside prime\n");

        for (i; i < prime - 1; i++) {
                //printf("i = %d\n", i);
                divisor = (prime - i);
                holder = prime % divisor;
                //printf("divisor = %d\n", divisor);
                //printf("holder = %d\n", holder);
                if (holder == 0)
                        return(0);
        }
return(1);
}
