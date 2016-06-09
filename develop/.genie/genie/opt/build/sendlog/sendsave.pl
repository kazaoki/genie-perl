#!/usr/bin/perl

use strict;
my $data;

if($ENV{GENIE_POSTFIX_ENABLED} && $ENV{GENIE_POSTFIX_SENDLOG_ENABLED}){

	# -- 保存先の用意
	my $dir = '/sendlog'; # -- 権限の問題で、ディレクトリ自体の作成はDockerfileの方で行う。
	my @list = glob("$dir/*.eml");
	my $logfile = sprintf("$dir/%06d.eml", scalar(@list)+1);

	# -- 受信したデータをファイルに保存する
	$data = join('', <STDIN>);
	open  LOG, ">$logfile";
	print LOG 'X-Genie-Send-Command: sendmail ' . join(' ', @ARGV)."\n";
	print LOG $data;
	close LOG;
}

# -- MTAにパスする
open(MAIL, '| /etc/alternatives/mta '.join(' ', @ARGV));
print MAIL $data;
close MAIL;

exit;
