\use ExtUtils::MakeMaker;

# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.

WriteMakefile
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
		Any::Moose                 => 0.13,
		Brannigan                  => 0.5,
		CGI                        => 3.49,
		CGI::Application           => 4.31,
		CGI::Application::Dispatch => 2.17,
		CGI::Session               => 4.42,
		CGI::Untaint               => 1.26,
		common::sense              => 3.0,
		Config::Tiny               => 2.12,
		Date::Format               => 2.24,
		DBD::SQLite                => 1.29,
		DBI                        => 1.611,
		DBIx::Admin::CreateTable   => 2.04,
		File::Path                 => 2.08,
		File::Spec                 => 3.31,
		File::Slurp                => 9999.13,
		FindBin::Real              => 1.05,
		JSON::XS                   => 2.29,
		Log::Dispatch              => 2.26,
		Log::Dispatch::Config      => 1.03,
		Log::Dispatch::DBI         => 0.02,
		parent                     => 0.218,
		Path::Class                => 0.18,
		String::Dirify             => 1.01,
		Test::Simple               => 0.94,
		Test::Pod                  => 1.41,
		Tree::DAG_Node             => 1.06,
		Tree::DAG_Node::Persist    => 1.03,
		Try::Tiny                  => 0.06,
		Text::Xslate               => 0.1051,
	},
	VERSION_FROM => 'lib/App/Office/CMS.pm',
);
