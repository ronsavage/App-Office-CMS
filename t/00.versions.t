#/usr/bin/env perl

use strict;
use warnings;

# I tried 'require'-ing modules but that did not work.

use Local::Wines; # For the version #.

use Test::More;

use boolean;
use Config::Tiny;
use Date::Simple;
use DBI;
use DBIx::Admin::CreateTable;
use DBIx::Simple;
use Encode;
use FindBin;
use Getopt::Long;
use Lingua::EN::Inflect;
use Mojolicious;
use Mojo::Base;
use Mojo::Log;
use Moo;
use Path::Tiny;
use Pod::Usage;
use strict;
use Text::CSV;
use Text::CSV::Encoded;
use Text::Xslate;
use Types::Standard;
use warnings;

# ----------------------

pass('All external modules loaded');

my(@modules) = qw
/
	boolean
	Config::Tiny
	Date::Simple
	DBI
	DBIx::Admin::CreateTable
	DBIx::Simple
	Encode
	FindBin
	Getopt::Long
	Lingua::EN::Inflect
	Mojolicious
	Mojo::Base
	Mojo::Log
	Moo
	Path::Tiny
	Pod::Usage
	strict
	Text::CSV
	Text::CSV::Encoded
	Text::Xslate
	Types::Standard
	warnings
/;

diag "Testing Local::Wines V $Local::Wines::VERSION";

for my $module (@modules)
{
	no strict 'refs';

	my($ver) = ${$module . '::VERSION'} || 'N/A';

	diag "Using $module V $ver";
}

done_testing;
