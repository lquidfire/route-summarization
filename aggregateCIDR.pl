#!/usr/bin/perl
# based on original from http://adrianpopagh.blogspot.com/2008/03/route-summarization-script.html
use strict;
use warnings;
use Net::CIDR::Lite;
use Getopt::Long;

GetOptions(
    'quiet' => \my $quiet,
    'help' => \my $help
);

if ($help) {
    print "usage: $0\n";
    print "\t-h|--help\tprint usage\n";
    print "\t-q|--quiet\tsuppress outputs\n";
    print "\nThis script summarizes your IP classes (if possible).\n";
    print "Input IPv4s with CIDR mask one per line. End with CTRL+D.\n\n";
    print "Optionally, redirect a file to stdin like so:\n";
    print "$0 < cidr.txt \n";
    exit;
}

if (!$quiet) { print "# Enter IP/Mask one per line (1.2.3.0/24). End with CTRL+D.\n"; }

my $cidr =Net::CIDR::Lite->new;

while (<>) {
    my $line = $_;
    chomp $line;

    if(  $line =~ m/^(\d\d?\d?)\.(\d\d?\d?)\.(\d\d?\d?)\.(\d\d?\d?)\/(\d\d?)$/ &&
                  ( $1 <= 255 && $2 <= 255 && $3 <= 255 && $4 <= 255 && $5 <=32) ) {
        my $item=$line;
        $cidr->add($item);

    } else {
        if (!$quiet) { print "# Ignoring: $line\n"; }
    }
}

my @cidr_list = $cidr->list;
print "# Aggregated IP list:\n";
foreach my $item(@cidr_list){
    print "$item\n";
}
