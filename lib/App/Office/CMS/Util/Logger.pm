package App::Office::CMS::Util::Logger;

use Any::Moose;
use common::sense;

use Log::Dispatch;
use Log::Dispatch::DBI;

# We don't use:
# extends 'App::Office::CSM::Database::Base';
# because our sub log is different.

has creator =>
(
	is  => 'rw',
	isa => 'Any',
);

has db =>
(
	is  => 'rw',
	isa => 'Any',
);

has engine =>
(
	is  => 'rw',
	isa => 'Str',
);

has logger =>
(
	is  => 'rw',
	isa => 'Any',
);

has time_option =>
(
	is  => 'rw',
	isa => 'Str',
);

# If Moose...
#use namespace::autoclean;

our $VERSION = '1.00';

# -----------------------------------------------

sub BUILD
{
	my($self)   = @_;
	my($config) = App::Office::CMS::Util::Config -> new -> config;

# Because SQLite won't allow the logger -> add() without
# the log table having been created, we ensure that it is.

	$self -> create_log_table_if_necessary;
	$self -> logger(Log::Dispatch -> new);
	$self -> logger -> add
	(
		Log::Dispatch::DBI -> new
		(
			dbh       => $self -> db -> dbh,
			min_level => $$config{min_log_level},
			name      => __PACKAGE__,
		)
	);

}	# End of BUILD.

# --------------------------------------------------
# Warning: Duplicate from from Database.pm.

sub create_log_table
{
	my($self)        = @_;
	my($table_name)  = 'log';
	my($primary_key) = $self -> creator -> generate_primary_key_sql($table_name);
	my($engine)      = $self -> engine;
	my($time_option) = $self -> time_option;
	my($result)      = $self -> creator -> create_table(<<SQL);
create table $table_name
(
id $primary_key,
level varchar(9) not null,
message varchar(255) not null,
timestamp timestamp $time_option not null default current_timestamp
) $engine
SQL

}	# End of create_log_table.

# -----------------------------------------------

sub create_log_table_if_necessary
{
	my($self)      = @_;
	my($table_sth) = $self -> db -> dbh -> table_info(undef, undef, '%', 'TABLE');

	my($count);
	my($table_data, $table_name, %table_name);

	for $table_data (@{$table_sth -> fetchall_arrayref({})})
	{
		$table_name{$$table_data{TABLE_NAME} } = 1;
	}

	if (! $table_name{log})
	{
		require DBIx::Admin::CreateTable;

		$self -> creator(DBIx::Admin::CreateTable -> new(dbh => $self -> db -> dbh, verbose => 0) );
		$self -> engine($self -> creator -> db_vendor =~ /(?:Mysql)/i ? 'engine=innodb' : '');

		$self -> time_option($self -> creator -> db_vendor =~ /(?:Postgres)/i ? '(0) without time zone' : '');
		$self -> create_log_table;
	}

} # End of create_log_table_if_necessary.

# -----------------------------------------------
# This is adapted from App::Office::CMS::Controller.

sub log
{
	my($self, $level, $s) = @_;
	$level ||= 'info';

	$self -> logger -> $level($s || '');

} # End of log.

# --------------------------------------------------

no Any::Moose;

# If Moose...
#__PACKAGE__ -> meta -> make_immutable;

1;
