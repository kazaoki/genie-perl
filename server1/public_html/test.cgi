#!/usr/bin/perl

use strict;
use utf8;
use Mojolicious;

print "content-type: text/html\n\n";
print "test1<br>";
print "<hr>";
print "<pre>";
print `perl -v`;
print "</pre>";
print "<hr>";
print "\$^V = ".$^V;
print "<hr>";
foreach(sort keys %ENV) {
	print "$_ : $ENV{$_}<br>";
}

exit;
