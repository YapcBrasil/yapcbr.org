#!/usr/bin/perl

use strict;
use warnings;

use Cwd qw/abs_path/;
use File::Basename;
use File::Find;
use File::Slurp;
use Template;
use Text::Markdown qw/markdown/;

my $dir = ( dirname abs_path $0 ) . "/../";
my @files;

my $template_config = {
	INCLUDE_PATH	=> $dir . "/template",
};


find( \&wanted, $dir );

for my $file ( @files ) {
	my $md = read_file( $file );	
	my $content = markdown( $md );
    my $html;
	
	my $title = "YAPC::Brasil 2016 - dias 2 e 3 de Dezembro em Sã Paulo";
	if ( $md =~ /\t(.*)\t\n/ ) {
		$title = $1;
	}

	$file =~ s/(.*\.)md/$1html/;

    print "$file\n";

    my $template = Template->new( $template_config );
	$template->process(
            'default.tt',
			{ 
				content => $content,
				title	=> $title,
			},
            $file,
		) or die;

#	open my $fh, '>', $file  or die " Failed opening the file\n";
#		print $fh $html;
#	close $fh;

}

sub wanted {  -e  && /\.md$/ && push @files, $File::Find::name }

