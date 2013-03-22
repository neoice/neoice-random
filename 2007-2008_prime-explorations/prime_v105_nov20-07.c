/*      prime finder, version 1.05
        completed november 20 2007

version history
1.00: initial code
1.01: ignore numbers divisible by 2
1.02: switched int to unsigned long
1.03: floating point exceptions.
1.04: changed changed algorithm structure.

switched algorithm to hacked version of
Sieves

runtime: >7s

*/

#include <stdio.h>

#define SOLVE_TO 1000000

// typedef defines bignum as a variable
// type equal to an unsigned long long
// makes code cleaner
//typedef unsigned int bignum;

int array[SOLVE_TO];
int am_i_prime;
int counter;

int main(void) {
        array[2] = 1;
        am_i_prime = 2;

        printf("2\n"); // 2 is explicitly

        while (am_i_prime <= SOLVE_TO) {
                for (counter = am_i_prime; counter < SOLVE_TO; counter += am_i_prime)
                        array[counter] = 1;

                am_i_prime++;

                if (array[am_i_prime] == 0) {
                        printf("%d\n", am_i_prime);
                        array[am_i_prime] = 1;
                }
        }
return(0);
}
