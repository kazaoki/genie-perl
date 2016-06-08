#!/usr/bin/perl

use strict;

my $data = join('', <STDIN>);

open(LOG, '>>/send.log');
print LOG join(' ', @ARGV)."\n";
print LOG "------------------------------------------------------------\n";
print LOG $data;
print LOG "------------------------------------------------------------\n";
print LOG "ok\n";
close LOG;

open(MAIL, '| /etc/alternatives/mta '.join(' ', @ARGV));
print MAIL $data;
close MAIL;

exit;
