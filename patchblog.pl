#!/usr/bin/perl

use strict;
use warnings;

die "only one argument: blog.txt file" if @ARGV != 1;
my $file = shift @ARGV;

open(FH, '<', $file) or die "cannot open file \'$file\': $!";
my @file_content;
my $i = 0;
my $j = 0;
my $line_nojs;

while (my $line = <FH>) {
	push @file_content, $line;
}
close FH;

open(FH, '>', $file) or die "cannot open file: $!";
foreach my $line (@file_content) {
	chomp $line;
	# saut si ligne vide
	next if $line =~ /^\s*$/;

	# écriture et saut si ligne est déjà remplacée
	if ($line =~ /img class="\w+\"/) {
		print FH "$line\n\n";
		$i++; 
		next;
	}
	
	# recupération de w et h pour comparaison
	$line =~ /width=\"(\d+)\"/;
	my $w = $1;
	$line =~/height=\"(\d+)\"/;
	my $h = $1;	

	$line_nojs = $line;

	# verification h*w
	if ($w > $h) {
		$line =~ s/img src=/img class=\"medium\" data-original=/;
#		$line_nojs =~ s/img src=/img class=\"medium\" src=/;
	} else {
		$line =~ s/img src=/img class=\"instaimg\" data-original=/ if ($w <= $h);
#		$line_nojs =~ s/img src=/img class=\"instaimg\" src=/ if ($w <= $h);
	}
	
	$line_nojs = "<noscript>$line_nojs</noscript>";
	
	$j++;
	# écriture
#	print FH "$line\n$line_nojs\n";
	print FH "$line\n\n";
}
print "Skipped: $i, Patched: $j\n";
close FH;