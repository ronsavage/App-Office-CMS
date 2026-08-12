package App::Office::CMS::Controller::Backup;

use parent 'App::Office::CMS::Controller';
use strict;
use warnings;

use JSON::XS;

use Try::Tiny;

# We don't use Moo because we isa CGI::Application.

our $VERSION = '0.93';

# -----------------------------------------------

sub build_error_result
{
	my($self, $page, $message, $target_div) = @_;

 	$self -> log(debug => "build_error_result(..., $target_div)");

	return
	{
		current_page        => $$page{name},
		homepage            => $$page{homepage},
		menu                => [],
		menu_orientation_id => 1, # TODO.
		message             => $message,
		page_name           => $$page{name},
		target_div          => $target_div,
	};

} # End of build_error_result.

# -----------------------------------------------

sub build_success_result
{
	my($self, $caller, $page, $message, $target_div) = @_;

	$self -> log(debug => "build_success_result(..., $target_div)");

	return
	{
		current_page        => $$page{name},
		homepage            => $$page{homepage},
		menu                => $self -> build_menu($caller, $page),
		menu_orientation_id => 1, # TODO: $$design{menu_orientation_id},
		message             => $message,
		page_name           => $$page{name},
		target_div          => $target_div,
	};

} # End of build_success_result.

# -----------------------------------------------

sub cgiapp_init
{
	my($self) = @_;

	$self -> run_modes([qw/run/]);

} # End of cgiapp_init.

# -----------------------------------------------

sub run
{
	my($self) = @_;

	$self -> log(debug => 'run()');

	my($target_div) = 'update_content_message_div';

	my($result);

	try
	{
		my($message, $page, $content) = $self -> process_content_form('update');

		if (! $message)
		{
			# Success.

			$message = $self -> param('db') -> content -> update($page, $content);
			$result  = $self -> build_success_result($page, $message, $target_div);
		}
	}
	catch
	{
		$result = $self -> build_error_result($_, $target_div);
	};

	# update_content_message_div is on screen (under the Edit Content tab)
	# because we're displaying content.

	return JSON::XS -> new -> utf8 -> encode({results => $result});

} # End of run.

# -----------------------------------------------

1;

=pod

=head1 NAME

App::Office::CMS::Controller::Backup - Manage the Canny, Microlight and Simple CMS

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
