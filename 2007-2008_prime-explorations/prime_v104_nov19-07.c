/*      prime finder, version 1.04
        completed november 19 2007

version history
1.00: initial code
1.01: ignore numbers divisible by 2
1.02: switched int to unsigned long
1.03: floating point exceptions.

stopped using bignum, reverted to int.

changed algorithm structure.

runtime: 2m, 30s

*/

#include <stdio.h>

#define SOLVE_TO 1000000

// typedef defines bignum as a variable
// type equal to an unsigned long long
// makes code cleaner
//typedef unsigned int bignum;

int known_primes[SOLVE_TO];
int am_i_prime;
int num_primes;
int counter;

int main(void) {
        known_primes[0] = 2;
        known_primes[1] = 3;
	num_primes = 1; // array numbering, see above

        printf("2\n"); // 2 and 3 are explicitly
        printf("3\n"); // defined as prime

        for (am_i_prime = 5; am_i_prime < SOLVE_TO; am_i_prime += 2) {
		counter = 0;

		while (counter <= num_primes) {

			if (am_i_prime % known_primes[counter] == 0)
				break; // prime not found

			counter++;
			
			if (counter > num_primes) {
				// prime found!
				printf("%d\n", am_i_prime);
				num_primes++;
				known_primes[num_primes] = am_i_prime;
				counter++; // required to break the counter <= num_primes
			}
		}
	}
return(0);
}
