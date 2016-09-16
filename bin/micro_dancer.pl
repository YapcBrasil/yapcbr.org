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
    INCLUDE_PATH    => $dir . "/template",
};

find( \&wanted, $dir );

for my $file ( @files ) {
    my @md = read_file( $file, binmode => ':utf8' );
    $file =~ s/(.*\.)md/$1html/;

    my $vars;
    $vars->{ title } = "YAPC::Brasil 2016 - dias 2 e 3 de Dezembro em Sao Paulo";

    if ( $md[0] eq "blocks:\n" ){
        print "With header $file $md[0]\n";
        my $line;
        do {
            $line = shift @md;
            my ( $key, $value ) = split ( '\t=', $line );
            $vars->{ $key } = $value;
        } while ( $line ne ";\n" or ! @md );
    } else {
        print "No header $file\n";
    }

    if ( ! @md ) {
        die "Error processing $file\n";
    }

    my $content = markdown( join "" , @md );
    $vars->{ content } = $content;
    my $html;


    my $template = Template->new( $template_config );
    $template->process(
            'default.tt',
            $vars,
            $file,
    ) or die;

}

sub wanted {  -e  && /\.md$/ && push @files, $File::Find::name }

