#!/usr/bin/perl

use strict;
use warnings;
use Net::DNS::Nameserver;

my $ns = new Net::DNS::Nameserver(
    LocalPort => 53,
    ReplyHandler => \&reply,
#    Verbose => 1,
) || die $!;

$ns->main_loop;

sub reply {
    my ($qname, $qclass, $qtype, $peerhost, $query, $conn) = @_;
    my ($rcode, @answer, @auth, @add);

#    $query->print;

    my ($ttl, $rdata) = (0, '127.0.0.1');
    my $rr = new Net::DNS::RR("$qname $ttl $qclass $qtype $rdata");
    push (@answer, $rr);
    $rcode = 'NOERROR';

    return ($rcode, \@answer, \@auth, \@add, { aa => 1 });
}
