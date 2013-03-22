I forget the exact situation, but sometime during 2009, the datacenter I worked
at was performing a migration from a legacy shared hosting system to some other
shared hosting system. I was tasked with determining the following:

    1) how many of the domains we think we host are using our name servers?

    2) how many of the domains we think we host are running on our hardware?

    3) which server is each domain running on?

task 1 was solved by "dns.py". task 2 was solved by "real.py". task 3 was
solved by "server.py".

I was actually expected to just do this manually. as the night shift NOC Tech,
no one thought twice about giving me giant, tedious tasks. every time I was
given one of these tasks, I typically resorted to Python instead of performing
the work by hand. while these scripts are terrible, I intentionally made the
trade-off of developer time vs runtime. in under 2 hours, I produced all three
scripts and had results 1 hour later.

I have no recollection of why these scripts were named this way. my memory of the
goals are fairly fuzzy as well. I do know that I produced a CSV report in one
night that management expected me to spend 2 weeks creating.
