package App::Office::CMS::View::Site;

use strict;
use warnings;

use File::Spec;

use Moo;

use Text::Xslate 'mark_raw';

extends 'App::Office::CMS::View::Base';

our $VERSION = '0.93';

# -----------------------------------------------

sub build_head_js
{
	my($self) = @_;

	$self -> log(debug => 'build_head_js()');

	return $self -> templater -> render('site.js', {form_action => $self -> form_action} );

} # End of build_head_js.

# -----------------------------------------------

sub build_new_site_html
{
	my($self) = @_;

	$self -> log(debug => 'build_new_site_html()');

	my($context) = 'new';
	my($param)   =
	{
	 context          => $context,
	 design_name      => '', # Menu orientation 4 is vertical.
#	 menu_orientation => mark_raw($self -> build_select('menu_orientations', 4) ),
	 name             => '',
#	 os_type          => mark_raw($self -> build_select('os_types', $self -> db -> get_default_os_type_id) ),
	 output_doc_root  => '/',
	 output_directory => File::Spec -> tmpdir,
	 sid              => $self -> session -> id,
	 submit_text      => 'Save',
	 ucfirst_context  => ucfirst $context,
	};

	# Make YUI happy by turning the HTML into 1 long line.

	my($html) = $self -> templater -> render('site.tx', $param);
	$html     =~ s/\n//g;

	return $html;

} # End of build_new_site_html.

# -----------------------------------------------

sub build_update_site_html
{
	my($self, $site, $design) = @_;

	$self -> log(debug => "build_update_site_html($$site{name}, $$design{name})");

	my($context) = 'update';
	my($param)   =
	{
	 context          => $context,
	 design_name      => $$design{name},
#	 menu_orientation => mark_raw($self -> build_select('menu_orientations', $$design{menu_orientation_id}) ),
	 name             => $$site{name},
#	 os_type          => mark_raw($self -> build_select('os_types', $$design{os_type_id}) ),
	 output_directory => $$design{output_directory},
	 output_doc_root  => $$design{output_doc_root},
	 sid              => $self -> session -> id,
	 submit_text      => 'Save',
	 ucfirst_context  => ucfirst $context,
	};

	# Make YUI happy by turning the HTML into 1 long line.

	my($html) = $self -> templater -> render('site.tx', $param);
	$html     =~ s/\n//g;

	return $html;

} # End of build_update_site_html.

# -----------------------------------------------

sub display
{
	my($self, $site, $design) = @_;

	$self -> log(debug => 'display()');

	return $self -> build_update_site_html($site, $design);

} # End of display.

# -----------------------------------------------

1;

=pod

=head1 NAME

App::Office::CMS::View::Site - Manage the Canny, Microlight and Simple CMS

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
