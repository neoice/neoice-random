/*      prime finder, version 1.03
        completed november 12 2007

version history
1.00: initial code
1.01: ignore numbers divisible by 2
1.02: switched int to unsigned long

unsigned long was messy.  switched to a
typedef.  added an extra long too

new algorithm is as follows:

2 and 3 are prime.  even numbers cannot be
prime, so the number being tested can be
incremented by 2 per loop. the number being
tested is divided by every prime smaller than
half of itself.

this implementation feels messy. v1.04 may
seek to streamline the process either to remove
algorithm bugs that generate invalid data
or to enhance performance.  none of the versions
preceding this have run to completion either due
to time constraints (>1hr!) or memory / errors?

*/

#include <stdio.h>

#define SOLVE_TO 1000000

// typedef defines bignum as a variable
// type equal to an unsigned long long
// makes code cleaner
typedef unsigned int bignum;

bignum known_primes[SOLVE_TO];
bignum solved_to;
bignum divisor_counter;
bignum number;
int result;


int main(void) {
        divisor_counter = 1;
        
        known_primes[0] = 2;
        known_primes[1] = 3;

        printf("2\n"); // 2 and 3 are explicitly
        printf("3\n"); // defined as prime

        result = 0;
printf("entering main() forloop\n");
        for (number = 3; number < SOLVE_TO; number += 2) {
printf("number: %u\n",number);
                result = prime(number);
                if (result == 1) {
                        printf("%u\n", number);
                        known_primes[solved_to++] = number;
                }
        }
return(0);
}

// OPTIMUS PRIME!
// TRANSFORM AND ROLL OUT
int prime(bignum prime) {
        int i = 1;
        int holder = 0;
        int divisor = 1;
printf("inside prime()\n");
        for (i; i < ((prime / 2) + 1) ; i++) {
printf("divisor_counter: %u\n", divisor_counter);
printf("prime/first_divisor : %u\n", prime / known_primes[divisor_counter]);
                if (1 < (prime / known_primes[divisor_counter]) ) // this means that the first_divisor prime
                        divisor_counter++;       // can potentially be a factor, the next cannot
                divisor = known_primes[divisor_counter - i];
                holder = prime % divisor;
printf("divisor: %u\n", divisor); 
printf("holder: %u\n", holder);
                if (holder == 0)
                        return(0);
        }
return(1);
}






