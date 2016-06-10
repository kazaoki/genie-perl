#!/usr/bin/perl

use strict;
my $data;

if($ENV{GENIE_SENDLOG_ENABLED}){

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

# -- メール配送が無効ならここで終了
if(
	($ENV{GENIE_PROC} eq 'spec' && $ENV{GENIE_SPEC_NO_SENDMAIL}) ||
	($ENV{GENIE_PROC} eq 'zap'  && $ENV{GENIE_ZAP_NO_SENDMAIL})
){
	exit 0;
}

# -- MTAにパスする
open(MAIL, '| /etc/alternatives/mta '.join(' ', @ARGV));
print MAIL $data;
close MAIL;

exit 0;
