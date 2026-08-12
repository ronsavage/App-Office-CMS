package App::Office::CMS::Controller::Design;

use parent 'App::Office::CMS::Controller';
use strict;
use warnings;

use JSON::XS;

use Try::Tiny;

# We don't use Moo because we isa CGI::Application.

our $VERSION = '0.93';

# -----------------------------------------------

sub cgiapp_init
{
	my($self) = @_;

	$self -> run_modes([qw/delete duplicate/]);

} # End of cgiapp_init.

# -----------------------------------------------

sub delete
{
	my($self) = @_;

	$self -> log(debug => 'delete()');

	my($message);

	try
	{
		my($design);
		my($site);

		($message, $site, $design) = $self -> process_site_and_design_form('delete');

		if (! $message)
		{
			$message = $self -> param('db') -> design -> delete($site, $design);
		}
	}
	catch
	{
		$message = $_;
	};

	# search_result_div is always on screen (under the Edit Site tab).
	# It appears there by virtue of being within search.tx.

	return JSON::XS -> new -> utf8 -> encode
	({
		results =>
		{
			message    => $message,
			target_div => 'search_result_div',
		}
	});

} # End of delete.

# -----------------------------------------------

sub duplicate
{
	my($self) = @_;

	$self -> log(debug => 'duplicate()');

	my($message);

	try
	{
		my($design);
		my($site);

		($message, $site, $design) = $self -> process_site_and_design_form('duplicate_design');

		if (! $message)
		{
			# Note: The new design name is stored in the $site object.
			# See App::Office::CMS::Controller.check_site_and_design_names().

			if (! $$site{new_name})
			{
				$message = $self -> param('view') -> format_errors({'Missing name' => ['You must specify a name for the new design']});
			}
			else
			{
				$message = $self -> param('db') -> design -> duplicate($site, $design);
			}
		}
	}
	catch
	{
		$message = $_;
	};

	# search_result_div is always on screen (under the Edit Site tab).
	# It appears there by virtue of being within search.tx.

	return JSON::XS -> new -> utf8 -> encode
	({
		results =>
		{
			message    => $message,
			target_div => 'update_site_message_div',
		}
	});

} # End of duplicate.

# -----------------------------------------------

1;

=pod

=head1 NAME

App::Office::CMS::Controller::Design - Manage the Canny, Microlight and Simple CMS

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
