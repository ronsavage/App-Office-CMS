package App::Office::CMS::View;

use strict;
use warnings;

use Moo;

use Types::Standard qw/Any/;

extends 'App::Office::CMS::View::Base';

use App::Office::CMS::View::Content;
use App::Office::CMS::View::Page;
use App::Office::CMS::View::Search;
use App::Office::CMS::View::Site;

has content =>
(
	is  => 'rw',
	isa => Any, # 'App::Office::CMS::View::Content',
);

has page =>
(
	is  => 'rw',
	isa => Any, # 'App::Office::CMS::View::Page',
);

has search =>
(
	is  => 'rw',
	isa => Any, # 'App::Office::CMS::View::Search',
);

has site =>
(
	is  => 'rw',
	isa => Any, # 'App::Office::CMS::View::Site',
);

our $VERSION = '0.93';

# -----------------------------------------------

sub BUILD
{
	my($self) = @_;

	$self -> content(App::Office::CMS::View::Content -> new
	(
	 config      => $self -> config,
	 form_action => $self -> form_action,
	 db          => $self -> db,
	 session     => $self -> session,
	 templater   => $self -> templater,
	) );

	$self -> page(App::Office::CMS::View::Page -> new
	(
	 config      => $self -> config,
	 form_action => $self -> form_action,
	 db          => $self -> db,
	 session     => $self -> session,
	 templater   => $self -> templater,
	) );

	$self -> search(App::Office::CMS::View::Search -> new
	(
	 config      => $self -> config,
	 form_action => $self -> form_action,
	 db          => $self -> db,
	 session     => $self -> session,
	 templater   => $self -> templater,
	) );

	$self -> site(App::Office::CMS::View::Site -> new
	(
	 config      => $self -> config,
	 form_action => $self -> form_action,
	 db          => $self -> db,
	 session     => $self -> session,
	 templater   => $self -> templater,
	) );

}	# End of BUILD.

# --------------------------------------------------

1;

=pod

=head1 NAME

C<App::Office::CMS::View> - Manage the Canny, Microlight and Simple CMS

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
