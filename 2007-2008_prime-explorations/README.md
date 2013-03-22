# prime explorations

after taking a long haitus from programming in 2006 and 2007, I decided to get
back in the saddle. for some reason, prime number generation seemed like a good
playground to experiment with basic C coding and algorithms.

these are presented exactly as I found them. as you can see, I was not using a
version control system yet, preferring to name files by date and revision number.
I have also included the list of the first 1 million prime numbers. I used this
and the `diff` command to determine if my program was producing the correct output.

    version history
    1.00: initial code
    1.01: ignore numbers divisible by 2
    1.02: switched int to unsigned long
    1.03: floating point exceptions.
    1.04: changed changed algorithm structure.
    1.05: switched algorithm to hacked version of Sieves. runtime: >7s
    1.06: removed printf, write to file instead

# client/server version

I forget if this even worked, but I attempted to build a simple client/server
prime finder. the idea was that the server would hand out 1 number to each
client and the client would report back if it was prime or not. by running 1
client per CPU core in my fleet, I could potentially solve a huge number of
primes in a short time period WITHOUT resorting to the Sieve of Eratosthenes
and consuming 1 million ints of memory.

again, this has been presented completely without modification.
