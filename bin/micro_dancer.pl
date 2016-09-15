#!/usr/bin/perl

use strict;
use warnings;

use Cwd qw/abs_path/;
use File::Basename;
use File::Find;
use File::Slurp;
use Text::Markdown qw/markdown/;

my $dir = ( dirname abs_path $0 ) . "/../";
my @files;

find( \&wanted, $dir );

for my $file ( @files ) {
	my $md = read_file( $file );	
	my $html = markdown( $md );

	$file =~ s/(.*\.)md/$1html/;

	open my $fh, '>', $file  or die " Failed opening the file\n";
		print $fh $html;
	close $fh;

}

sub wanted {  -e  && /\.md$/ && push @files, $File::Find::name }
