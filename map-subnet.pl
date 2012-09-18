#!/usr/bin/perl

use strict;
use warnings;
use Net::Netmask;
use Net::Ping;
use Net::DNS;

my $subnet = $ARGV[0];

my $netmask = new Net::Netmask ($subnet);
my $ping = Net::Ping->new();
my $resolver = Net::DNS::Resolver->new;

my @ips = $netmask->enumerate();
shift(@ips); # discard base IP
my $gateway = shift(@ips); # gateway is first usable IP
pop(@ips); # discard broadcast IP

for my $ip (@ips){
    print "$ip : ";
    my $arpa_zone = join('.', reverse split(/\./, $ip)).".in-addr.arpa.";
    my $response = $resolver->query("$arpa_zone", 'PTR');
    my @ptr_records = ();
    my $hostname = 'unknown';
    if ($response){
      for my $record ($response->answer){
        next unless ($record->type eq 'PTR');
        my $record_name = $record->ptrdname;
        push (@ptr_records,$record_name);
      }
      $hostname = join(',',@ptr_records);
    }
    if ($ping->ping($ip,3)){
        print "online";
    } else {
        print "offline";
    }
    print " ($hostname)\n";
}

$ping->close();
