package App::Office::CMS::View::Content;

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

	my($config) = $self -> config;
	my($param)  =
	{
		form_action => $self -> form_action,
	};

	return $self -> templater -> render('content.js', $param);

} # End of build_head_js.

# -----------------------------------------------

sub build_update_content_html
{
	my($self, $site, $design, $page, $asset) = @_;

	$self -> log(debug => 'build_update_content_html()');

	my($backup_command) = ${$self -> config}{backup_command};
	my($content)        = $self -> db -> content -> get_content_by_page_id($$page{id});
	my($context)        = 'update';
	my($param)          =
	{
	 backup      => $backup_command ? 1 : 0, # We only need a Boolean in the template.
	 body_text   => mark_raw($$content{body_text}),
	 colspan     => $backup_command ? 1 : 2, # Make generate button's position look pretty.
	 context     => $context,
	 design_name => $$design{name},
	 head_text   => mark_raw($$content{head_text}),
	 page_name   => $$page{name},
	 sid         => $self -> session -> id,
	 site_name   => $$site{name},
	 submit_text => 'Save',
	};

	return $self -> templater -> render('content.tx', $param);

} # End of build_update_content_html.

# -----------------------------------------------

sub edit
{
	my($self, $site, $design, $page, $asset) = @_;

	$self -> log(debug => 'edit()');

	return $self -> build_update_content_html($site, $design, $page, $asset);

} # End of edit.

# -----------------------------------------------

sub generate
{
	my($self, $site, $design, $page, $menu, $content) = @_;

	$self -> log(debug => 'generate()');

	my($config) = $self -> config;
	my($param)  =
	{
		body_text   => mark_raw($$content{body_text}),
		design_name => $$design{name},
		head_text   => mark_raw($$content{head_text}),
		menu        => mark_raw(join("\n", @$menu) ),
		page_name   => $$page{name},
		site_name   => $$site{name},
		yui_url     => $$config{yui_url},
	};

	my($template_name) = $$page{homepage} eq 'Yes' ? 'home.page.tx' : 'generic.page.tx';

	return $self -> templater -> render("page.templates/$template_name", $param);

} # End of generate.

# -----------------------------------------------

1;

=pod

=head1 NAME

App::Office::CMS::View::Content - Manage the Canny, Microlight and Simple CMS

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
