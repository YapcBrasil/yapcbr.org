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

my $template = Template->new( $template_config );

find( \&wanted, $dir );

for my $file ( @files ) {
	my $md = read_file( $file );	
	my $content = markdown( $md );
	
	my $title = "YAPC::Brasil 2016 - dias 2 e 3 de Dezembro em SãoPaulo";
	if ( $md =~ /\t(.*)\t\n/ ) {
		$title = $1;
	}

	$file =~ s/(.*\.)md/$1html/;

	my $html = $template->process( \*DATA, 
			{ 
				content => $content,
				title	=> $title,
			} 
		) or die;

	open my $fh, '>', $file  or die " Failed opening the file\n";
		print $fh $html;
	close $fh;

}

sub wanted {  -e  && /\.md$/ && push @files, $File::Find::name }

__DATA__
<!DOCTYPE html>
<html>
 <head>
  <title></title>
  <meta charset="utf-8">
  <meta name="viewport"     content="width=device-width, initial-scale=1, maximum-scale=1">
  <link rel="shortcut icon" href="/favicon.png"/>
  <link rel="stylesheet"    href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
  <link rel="stylesheet"    href="style.min.css">
  <link rel="manifest"      href="manifest.json">
  <link href='https://fonts.googleapis.com/css?family=Lato' rel='stylesheet' type='text/css'>
 </head>
 <body>

[% content %]

<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-81330067-1', 'auto');
  ga('require', 'linkid');
  ga('send', 'pageview');

</script>

 </body>
</html>

