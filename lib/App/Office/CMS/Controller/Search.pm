package App::Office::CMS::Controller::Search;

use parent 'App::Office::CMS::Controller';
use strict;
use warnings;

# We don't use Moo because we isa CGI::Application.

our $VERSION = '0.93';

# -----------------------------------------------

sub display
{
	my($self) = @_;

	$self -> log(debug => 'display()');

	my($name)   = $self -> query -> param('name') || '';
	my($result) = $self -> param('db') -> site -> search($name);
	$result     = $self -> param('db') -> design -> search($name, $result);
	$result     = $self -> param('db') -> page -> search($name, $result);

	return $self -> param('view') -> search -> display($name, $result);

} # End of display.

# -----------------------------------------------

1;

=pod

=head1 NAME

App::Office::CMS::Controller::Search - Manage the Canny, Microlight and Simple CMS

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
