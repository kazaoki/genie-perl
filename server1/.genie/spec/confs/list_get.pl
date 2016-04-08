#!/usr/bin/perl

use strict;

# -- prepare regexes
my @regexes;
foreach my $str (split(/\s+/, $ENV{SPEC_ARGS_FEATURE})) {
	my $regex = "^/opt/spec/$ENV{SPEC_TARGET_DIR}/$str";
	push @regexes, $regex;
}

# -- list up & filtering
my $result = `find "/opt/spec/$ENV{SPEC_TARGET_DIR}/" -type f | sed -e "s|^$ENV{SPEC_PATH}/features/|  - |g"`;
my @list;
foreach my $line (split(/\s+/, $result)) {
	if(grep{ $line =~ /$_/ }@regexes) {
		push @list, $line;
	}
}

# -- output
print join(' ', @list);
