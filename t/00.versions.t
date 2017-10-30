#/usr/bin/env perl

use strict;
use warnings;

# I tried 'require'-ing modules but that did not work.

use App::Office::CMS; # For the version #.

use Test::More;

use Any::Moose;
use Brannigan;
use Capture::Tiny;
use CGI;
use CGI::Application;
use CGI::Application::Dispatch;
use CGI::Untaint;
use Config::Tiny;
use Data::Session;
use Date::Format;
use DBD::SQLite;
use DBI;
use DBIx::Admin::CreateTable;
use File::Path;
use File::Spec;
use File::Slurp;
use FindBin;
use JSON::XS;
use Log::Handler;
use parent;
use Path::Class;
use String::Dirify;
use Tree::DAG_Node;
use Tree::DAG_Node::Persist;
use Try::Tiny;
use Text::Xslate;

# ----------------------

pass('All external modules loaded');

my(@modules) = qw
/
	Any::Moose
	Brannigan
	Capture::Tiny
	CGI
	CGI::Application
	CGI::Application::Dispatch
	CGI::Untaint
	Config::Tiny
	Data::Session
	Date::Format
	DBD::SQLite
	DBI
	DBIx::Admin::CreateTable
	File::Path
	File::Spec
	File::Slurp
	FindBin
	JSON::XS
	Log::Handler
	parent
	Path::Class
	String::Dirify
	Tree::DAG_Node
	Tree::DAG_Node::Persist
	Try::Tiny
	Text::Xslate
/;

diag "Testing App::Office::CMS V $App::Office::CMS::VERSION";

for my $module (@modules)
{
	no strict 'refs';

	my($ver) = ${$module . '::VERSION'} || 'N/A';

	diag "Using $module V $ver";
}

done_testing;
