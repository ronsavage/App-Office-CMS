package App::Office::CMS::Database::Event;

use strict;
use warnings;

use Date::Format;

use Moo;

extends 'App::Office::CMS::Database::Base';

our $VERSION = '0.93';

# --------------------------------------------------

sub add
{
	my($self, $action, $object) = @_;

	$self -> log(debug => "add($action, $$object{name})");

	$self -> save_event_record($action, $object);

	return "Saved event $action for object '$$object{name}'";

} # End of add.

# --------------------------------------------------

sub save_event_record
{
	my($self, $context, $object) = @_;

	$self -> log(debug => "save_event_record($context, $$object{name})");

	my($table_name) = 'events';
	my(@time)       = localtime;
	my($time)       = strftime('%Y-%m-%d %X', @time);
	my(@field)      = (qw/
event_type_id
id_list
/);
	my($data) = {};

	for (@field)
	{
		$$data{$_} = $$object{$_};
	}

	if ($context eq 'add')
	{
		$$data{timestamp} = $time;
		$$object{id}      = $self -> db -> insert_hash_get_id($table_name, $data);
	}
	else
	{
		die "save_event_record called with context not being 'add'";
	}

	$self -> log(debug => "Saved ($context) object '$$object{name}' with id $$data{id}");

} # End of save_event_record.

# --------------------------------------------------

1;

=pod

=head1 NAME

App::Office::CMS::Database::Event - Manage the Canny, Microlight and Simple CMS

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
