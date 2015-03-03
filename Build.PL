use warnings;
use strict;

use Module::Build;

# ----------------

my $class = Module::Build->subclass(code => <<'EOF');

sub ACTION_authortest
{
	my($self) = @_;

	$self->depends_on('build');
	$self->depends_on('manifest');
	$self->depends_on('distmeta');

	$self->test_files( qw< t xt/author > );
	$self->recursive_test_files(1);

	$self->depends_on('test');

	return;
}
EOF

$class -> new
(
	module_name    => 'App::Office::CMS',
	license        => 'artistic_2',
	dist_abstract  => 'The Canny, Microlight and Simple CMS',
	dist_author    => 'Ron Savage <ron@savage.net.au>',
	build_requires =>
	{
		'Test::More' => 1.001014,
		'Test::Pod' => 1.48,
	},
	configure_requires =>
	{
		'Module::Build' => 0.4211,
	},
	requires =>
	{
		'Any::Moose' => 0.13,
		'Brannigan' => 0.5,
		'Capture::Tiny' => 0.08,
		'CGI' => 3.49,
		'CGI::Application' => 4.31,
		'CGI::Application::Dispatch' => 2.17,
		'CGI::Untaint' => 1.26,
		'Config::Tiny' => 2.12,
		'Data::Session' => 1.01,
		'Date::Format' => 2.24,
		'DBD::SQLite' => 1.29,
		'DBI' => 1.611,
		'DBIx::Admin::CreateTable' => 2.04,
		'File::Path' => 2.08,
		'File::Spec' => 3.31,
		'File::Slurp' => 9999.13,
		'FindBin' => 1.49,
		'JSON::XS' => 2.29,
		'Log::Handler' => 0.68,
		'parent' => 0.218,
		'Path::Class' => 0.18,
		'String::Dirify' => 1.01,
		'Tree::DAG_Node' => 1.06,
		'Tree::DAG_Node::Persist' => 1.03,
		'Try::Tiny' => 0.06,
		'Text::Xslate' => 0.1051,
	},
);

$builder -> add_build_element('conf');
$builder -> create_build_script();

