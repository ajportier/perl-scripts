#!/usr/bin/perl
# Author: Adam Portier <adam_portier@cable.comcast.com>
# Purpose: Reads a text file for CIDR network values and reduces it to the smallest set

use strict;
use warnings;
use Net::Netmask;

my $acl_file = $ARGV[0];
my $print_savings = 1;
open (FILE,$acl_file) or die $!;
while (<FILE>){
    my $line = $_;
    chomp($line);
    if ($line =~ m/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\/\d{1,2})/){
        my $block = new Net::Netmask($1);
        $block->storeNetblock();
    }
}
close (FILE);

my @full_acl = Net::Netmask::dumpNetworkTable();

if ($print_savings){
    for my $test_block(@full_acl){
        for my $block(@full_acl){
            next if $block->sameblock($test_block);
            print "$block contains $test_block\n" if $block->contains($test_block);
        }
    }
}

print "##### Smaller ACL #####\n";

my @smaller_acl = Net::Netmask::cidrs2cidrs(@full_acl);
my $acl_size = (scalar @full_acl);
for my $block (@smaller_acl){
    print "$block\n";
}
my $savings = ($acl_size - (scalar @smaller_acl));
print "##### Removed $savings redundant ACL values ($acl_size original) #####\n";
