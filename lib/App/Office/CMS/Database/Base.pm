package App::Office::CMS::Database::Base;

use strict;
use warnings;

use Moo;

has db =>
(
	is  => 'rw',
	isa => 'Any',
);

our $VERSION = '0.93';

# --------------------------------------------------

sub log
{
	my($self, $level, $s) = @_;

	$self -> db -> log($level, $s);

} # End of log.

# --------------------------------------------------

1;
