#!/usr/bin/perl

use strict;
use warnings;
use threads;
use POSIX qw(strftime);

my $max = $ARGV[0];

# Build up a set of threads to call countdown with an increasing value
for (my $i = 0; $i < $max; ++$i){
  my $thread = threads->create(\&countdown, $i+1);
}

# Start all of the threads
for my $thread (threads->list){
  $thread->join();
}

# This won't get called until all the threads have exited
print "Threads are all done! Counted backwards from $max!\n";

# Waits for a number of seconds equal to the difference between the passed value and the
# max value, then prints out the value and the time the thread was started
sub countdown {
  my $value = shift;
  my $start_time = strftime "%H:%M:%S", localtime;
  sleep ($max-$value);
  my $end_time = strftime "%H:%M:%S", localtime;
  print "$value! ($start_time \- $end_time)\n";
}
