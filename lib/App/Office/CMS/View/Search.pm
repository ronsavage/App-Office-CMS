package App::Office::CMS::View::Search;

use strict;
use warnings;

use JSON::XS;

use Moo;

extends 'App::Office::CMS::View::Base';

our $VERSION = '0.93';

# -----------------------------------------------

sub build_search_html
{
	my($self) = @_;

	$self -> log(debug => 'build_search_html()');

	# Make YUI happy by turning the HTML into 1 long line.

	my($html) = $self -> templater -> render
	(
	 'search.tx',
	 {
		 sid => $self -> session -> id,
	 }
	);
	$html =~ s/\n//g;

	return $html;

} # End of build_search_html.

# -----------------------------------------------

sub build_head_js
{
	my($self) = @_;

	$self -> log(debug => 'build_head_js()');

	return $self -> templater -> render
	(
	 'search.js',
	 {
		 form_action => $self -> form_action
	 }
	);

} # End of build_head_js.

# -----------------------------------------------

sub display
{
	my($self, $name, $result) = @_;

	$self -> log(debug => "display($name, " . scalar(@$result) . ')');

	$result = $self -> format_search_result($result);

	my($output);

	if ($#$result >= 0)
	{
		$output = {results => [@$result]};
	}
	else
	{
		$output = {results => [{site_name => "No names match '$name'"}]};
	}

	return JSON::XS -> new -> utf8 -> encode($output);

} # End of display.

# -----------------------------------------------

sub format_search_result
{
	my($self, $record) = @_;
	my($result) = [];

	for my $item (@$record)
	{
		push @$result,
		{
			design_name => $$item{design_name},
			match       => $$item{match},
			page_name   => $$item{page_name},
			site_name   => qq|<a href="#" onClick="display_site('$$item{id_pair}')">| . "$$item{site_name}</a>",
		},
	}

	return $result;

} # End of format_search_result.

# -----------------------------------------------

1;

=pod

=head1 NAME

C<App::Office::CMS::View::Search> - Manage the Canny, Microlight and Simple CMS

=head1 Machine-Readable Change Log

The file Changes was converted into Changelog.ini by L<Module::Metadata::Changes>.

=head1 Version Numbers

Version numbers < 1.00 represent development versions. From 1.00 up, they are production versions.

=head1 Support

Email the author.

=head1 Author

L<CPAN::MetaCurator> was written by Ron Savage I<E<lt>ron@savage.net.auE<gt>> in 2025.

My homepage: L<https://savage.net.au/>.

=head1 Copyright

Australian copyright (c) 2010, Ron Savage.

	All Programs of mine are 'OSI Certified Open Source Software';
	you can redistribute them and/or modify them under the terms of
	The Perl License, a copy of which is available at:
	http://dev.perl.org/licenses/

=cut
