package App::Office::CMS::View::Page;

use strict;
use warnings;

use Moo;

use Text::Xslate 'mark_raw';

use Try::Tiny;

extends 'App::Office::CMS::View::Base';

our $VERSION = '0.93';

# -----------------------------------------------

sub build_head_js
{
	my($self) = @_;

	$self -> log(debug => 'build_head_js()');

	return $self -> templater -> render('page.js', {form_action => $self -> form_action});

} # End of build_head_js.

# -----------------------------------------------

sub build_update_page_html
{
	my($self, $site, $design, $page) = @_;

	$self -> log(debug => 'build_update_page_html()');

	# TODO. We assume the page has 1 asset, so we get it from the db.

	my($asset)      = $self -> db -> asset -> get_asset_by_page_id($$page{id});
	my($asset_type) = $self -> db -> asset -> get_asset_type_by_id($$asset{asset_type_id});
	my($context)    = 'update';
	my($param)      =
	{
	 context           => $context,
	 current_page_name => $$page{name},
	 design_name       => $$design{name},
	 homepage          => $$page{homepage} eq 'Yes' ? 'checked' : '',
	 name              => $$page{name}, # Prefer '', but set it for validation.
	 sid               => $self -> session -> id,
	 site_name         => $$site{name},
	 submit_text       => 'Save',
	 template_name     => mark_raw($self -> build_select('asset_types', $$asset{asset_type_id}) ),
	};

	return $self -> templater -> render('page.tx', $param);

} # End of build_update_page_html.

# -----------------------------------------------

sub edit
{
	my($self, $site, $design, $page) = @_;

	$self -> log(debug => 'edit()');

	return $self -> build_update_page_html($site, $design, $page);

} # End of edit.

# -----------------------------------------------

1;

=pod

=head1 NAME

C<App::Office::CMS::View::Page> - Manage the Canny, Microlight and Simple CMS

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
