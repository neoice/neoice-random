#!/usr/bin/python

primes = [2, 3]
am_i_prime = 5

for am_i_prime in range(5, 1000000, 2) :

   counter = 0
   divisor = primes[counter]

   if am_i_prime % divisor == 0 :
      print "prime found"

#print primes
