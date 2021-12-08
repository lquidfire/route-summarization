#!/usr/bin/perl
# copied from http://adrianpopagh.blogspot.com/2008/03/route-summarization-script.html
use strict;
use warnings;
use Net::CIDR::Lite;

my $ipv4String='[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}';

if (defined $ARGV[0] && $ARGV[0] eq '-h') {
    print "usage: $0\n\n";
    print "This script summarizes your IP classes (if possible).\n";
    print "Input IPs with mask one per line. End with CTRL+D.\n\n";
    print "Optionally, redirect a file to stdin like so:\n";
    print "$0 < cidr.txt \n";
    exit;
}


print "Enter IP/Mask one per line (1.2.3.0/24). End with CTRL+D.\n";

my $cidr =Net::CIDR::Lite->new;

while (<>) {
    if (/($ipv4String\/[0-9]{1,2})/) {
        my $item=$1;
        $cidr->add($item);
    } else {
        print "Ignoring previous line.\n";
    }
}

my @cidr_list = $cidr->list;
print "======Aggregated IP list:======\n";
foreach my $item(@cidr_list){
    print "$item\n";
}
