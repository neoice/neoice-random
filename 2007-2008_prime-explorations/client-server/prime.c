#include <stdio.h>
#include <stdlib.h>

int counter = 2;

int main(int argc, char *argv[])
{
	int am_i_prime = atoi(argv[1]);

	for (counter = 2; counter < am_i_prime; counter++) {
		if ((am_i_prime % counter) == 0) {
			return -1;
		}
	}

	printf("%d", am_i_prime);
	return 0;
}
