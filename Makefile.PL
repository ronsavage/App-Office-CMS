use strict;
use warnings;

use ExtUtils::MakeMaker;

# ----------------

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

my(%params) =
(
	($] ge '5.005') ?
	(
		AUTHOR   => 'Ron Savage (ron@savage.net.au)',
		ABSTRACT => 'The Canny, Microlight and Simple CMS',
	) : (),
	clean =>
	{
		FILES => 'blib/* Makefile MANIFEST App-Office-CMS-*'
	},
	dist =>
	{
		COMPRESS => 'gzip',
		SUFFIX   => 'gz'
	},
	DISTNAME  => 'App-Office-CMS',
	NAME      => 'App::Office::CMS',
	PL_FILES  => {},
	PREREQ_PM =>
	{
		'Any::Moose'					=> 0.13,
		'Brannigan'						=> 0.5,
		'Capture::Tiny'					=> 0.08,
		'CGI'							=> 3.49,
		'CGI::Application'				=> 4.31,
		'CGI::Application::Dispatch'	=> 2.17,
		'CGI::Untaint'					=> 1.26,
		'Config::Tiny'					=> 2.12,
		'Data::Session'					=> 1.01,
		'Date::Format'					=> 2.24,
		'DBD::SQLite'					=> 1.29,
		'DBI'							=> 1.611,
		'DBIx::Admin::CreateTable'		=> 2.04,
		'File::Path'					=> 2.08,
		'File::Spec'					=> 3.31,
		'File::Slurp'					=> 9999.13,
		'FindBin'						=> 1.49,
		'JSON::XS'						=> 2.29,
		'Log::Handler'					=> 0.68,
		'parent'						=> 0.218,
		'Path::Class'					=> 0.18,
		'String::Dirify'				=> 1.01,
		'Tree::DAG_Node'				=> 1.06,
		'Tree::DAG_Node::Persist'		=> 1.03,
		'Try::Tiny'						=> 0.06,
		'Text::Xslate'					=> 0.1051,
	},
	TEST_REQUIRES =>
	{
		'Test::More'	=> 1.001002,
		'Test::Pod'		=> 1.48,
	}
	VERSION_FROM => 'lib/App/Office/CMS.pm',
);

if ( ($ExtUtils::MakeMaker::VERSION =~ /^\d\.\d\d$/) && ($ExtUtils::MakeMaker::VERSION > 6.30) )
{
	$params{LICENSE} = 'perl';
}

if ($ExtUtils::MakeMaker::VERSION ge '6.46')
{
	$params{META_MERGE} =
	{
		'meta-spec' =>
		{
			version => 2,
		},
		resources =>
		{
			bugtracker	=> 'https://rt.cpan.org/Public/Dist/Display.html?Name=App-Office-CMS',
			license		=> 'http://dev.perl.org/licenses/',
			repository	=>
			{
				type	=> 'git',
				url		=> 'https://github.com/ronsavage/App-Office-CMS.git',
				web		=> 'https://github.com/ronsavage/App-Office-CMS',
			},
		},
	};
}

WriteMakefile(%params);
