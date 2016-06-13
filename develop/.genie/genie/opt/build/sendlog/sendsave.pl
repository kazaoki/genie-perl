#!/usr/bin/perl

use strict;
my $data;

if($ENV{GENIE_GENERAL_RUNMODE} eq 'develop') {
	if($ENV{GENIE_SENDLOG_ENABLED}){

		# -- prepared save path
		my $dir = '/sendlog'; # -- mkdir in Dockerfile (a permission problem)
		my @list = glob("$dir/*.eml");
		my $logfile = sprintf("$dir/%06d.eml", scalar(@list)+1);

		# -- arg data to file
		$data = join('', <STDIN>);
		open  LOG, ">$logfile";
		print LOG 'X-Genie-Send-Command: sendmail ' . join(' ', @ARGV)."\n";
		print LOG $data;
		close LOG;
	}
}

# -- exit if nosend file
exit 0 if -f '/tmp/nosend';

# -- passthru to MTA
open(MAIL, '| /etc/alternatives/mta '.join(' ', @ARGV));
print MAIL $data;
close MAIL;

exit 0;
