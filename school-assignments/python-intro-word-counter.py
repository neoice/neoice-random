#!/usr/bin/python2.6

# this program was written for a school assignment. it was a 300 level course
# examining the differences between programming languages, both syntactically
# and under-the-hood. Python was the first language and this assignment was
# intended as a "warmup" exercise to get students familiar with Python and the
# included data structures. the paraphrased goal of the program was to sort
# a text file and output a list of words, sorted by frequency of occurence.

# given that I was already conversant in Python, I decided to write a completely
# overkill program and learn `optparse` and `multiprocessing` along the way.

# I was given a 100% and told to skip the second assignment. also, that optparse
# was cheating :P

import optparse
import re

### helper functions ###
def flatten(L):
    """ exploit list comprehension and sum() to turn nested lists into a single list.
        inspired by posts on StackOverflow. this was the only list-flatting algorithm
        that made sense to me. surprised there's not a standard library list.flatten()
    """
    return sum( L, [] )

def chunks(L, n):
    """ generator for n-sized workunits from list L. the "yield" keyword builds "generators",
        a kind of iterative data structure. also, exceedingly cool.
        during 2to3, xrange() is turned into Python3 range(), so usage is recommended.
        inspired by posts on StackOverflow.
    """
    for each in xrange(0, len(L), n):
        yield L[ each : each+n ]

def _mp_parser(w):
    global words
    _parsed = []
    for each in w:
        _parsed.append( (words.count(each), each) )
    return _parsed

### processors ###
def multi_process():
    import multiprocessing
    p = multiprocessing.Pool(options.count) # make a pool of workers
    result = p.map_async( _mp_parser, chunks(uniq,1000) ) # map: the power of distributed processing
    p.close() # cleanup
    p.join()  # cleanup

    parsed = flatten( result.get() )
    parsed = list(parsed)

    return parsed

def single_process():
    parsed = []
    for each in uniq:
        parsed.append( (words.count(each), each) )

    return parsed

### MAIN ###
if __name__ == "__main__":
    # build option parser
    op = optparse.OptionParser("usage: %prog --threadmode", description="this program reads in a file and produces a frequency count of the words \
                                                                         contained. the output is formatted as (count, word) with one instance    \
                                                                         per line of output. case and most punctuation is removed, however, some  \
                                                                         valid words are not captured. all exceptions are unchecked and passed to \
                                                                         the user.")

    # file options
    g1 = optparse.OptionGroup(op, "File Options", "you may choose your input/output files. they default to 'input' and 'output' respectively")
    g1.add_option("-i", "--input", dest="infile", default="input", type="string", help="input file to process.")
    g1.add_option("-o", "--output", dest="outfile", default="output", type="string", help="file to write output.")

    # thread options
    g2 = optparse.OptionGroup(op, "Threading Modes", "you must pick only one threading mode and optionally supply a --threadcount")
    g2.add_option("-s", "--single", dest="single", action="store_true", help="run without multiprocessing.")
    g2.add_option("-m", "--multi", dest="multi", action="store_true", help="run with multiprocessing. (may not be supported on all platforms)")
    g2.add_option("-t", "--threads", dest="count", default=5, type="int", help="number of threads to run. defaults to 5, recommended that you tune to your CPU using cores+1.")

    # add the groups
    op.add_option_group(g1)
    op.add_option_group(g2)

    # parse ze options
    (options, args) = op.parse_args()

    # ensure we choose a mode
    if not options.multi and not options.single:
        op.error("you *must* pick a threading mode: --single OR --multi")
    if options.multi and options.single:
        op.error("you may only pick one! (--single OR --multi)")

    # set up main
    funcmap = {"single": single_process, "multi": multi_process}
    if options.single:
        _m = funcmap["single"]
    else:
        _m = funcmap["multi"]

    # read in file
    file = open(options.infile, 'r')
    raw = file.read()
    file.close()

    # clean data
    clean = raw.lower()
    clean = clean.translate(None, '!@#$%^&*()+=[]{}:;\",./\\`')

    # create the word lists
    #words = re.split("\W", clean) # this regex is insufficient, but I've smashed my head against it for too long. I cant capture "it's" :(
    words = clean.split()
    uniq = list( set(words) ) # le secret sauce

    # run our parser of choice
    parsed = _m()
    parsed.sort()

    # write it out
    o = open(options.outfile, 'w')
    for each in parsed:
        o.write( str(each) + "\n" )
