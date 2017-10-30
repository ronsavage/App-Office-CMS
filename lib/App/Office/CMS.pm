package App::Office::CMS;

our $VERSION = '0.93';

# -----------------------------------------------

1;

=pod

=head1 NAME

App::Office::CMS - The Canny, Microlight and Simple CMS

=head1 Synopsis

The scripts discussed here, I<cms.cgi> and I<cms.psgi>, are shipped with this module.

A classic CGI script, I<cms.cgi>:

	#!/usr/bin/env perl

	use strict;
	use warnings;

	use CGI;
	use CGI::Application::Dispatch;

	# ---------------------

	my($cgi) = CGI -> new;

	CGI::Application::Dispatch -> dispatch
	(
		args_to_new => {QUERY => $cgi},
		prefix      => 'App::Office::CMS::Controller',
		table       =>
		[
		''              => {app => 'Initialize', rm => 'display'},
		':app'          => {rm => 'display'},
		':app/:rm/:id?' => {},
		],
	);

A L<Plack> script, I<cms.psgi>:

	#!/usr/bin/env perl

	use strict;
	use warnings;

	use CGI::Application::Dispatch::PSGI;

	use Plack::Builder;

	# ---------------------

	my($app) = CGI::Application::Dispatch -> as_psgi
	(
		prefix => 'App::Office::CMS::Controller',
		table  =>
		[
		''              => {app => 'Initialize', rm => 'display'},
		':app'          => {rm => 'display'},
		':app/:rm/:id?' => {},
		],
	);

	builder
	{
		enable "Static",
		path => qr!^/(assets|favicon|yui)/!,
		root => '/var/www';
		$app;
	};

For more on L<Plack>, see my intro to Plack:
L<http://savage.net.au/Perl/html/plack.for.beginners.html>.

=head1 Description

L<App::Office::CMS> is the Canny, Microlight and Simple Content Management System.

=over 4

=item o Canny

The canniness comes in observing that almost all web sites have a menu for navigation.

So, this module gives you (the content manager) a menu designer.

The idea is that the menu you design is 'live', so you use the web site's own menu
to design both the menu itself and the whole web site.

=item o Microlight

This means L<Any::Moose> to get L<Mouse> rather than L<Moose>.

For the same reason, L<DBIx::Simple> rather than L<DBIx::Class>.

And hence L<Brannigan> rather than L<Data::Verifier>, because the latter uses
Moose::Util::TypeConstraints, and hence a whole slew of Moose::Meta::* modules.

Lastly, I'm not claiming this package is as small as it could possibly be. For example,
I could replace Text::Xslate with HTML::Template to shrink it, but I don't want to do that.

=item o Simple

The other motivation is to deliver an application which anyone, with minimal training,
can master.

=back

=head1 Overview

Up to V 1.00, 99.99% of the effort went into the structure of the code, i.e. the
mangement of a web site, and not into supporting content generation.

That's why the features provided for generating content are minimalistic.

The end-user docs are discussed below, under FAQ, and are strongly recommended
reading.

This is a simplified version:

=over 4

=item o Multiple web sites

You can create any number of web sites.

=item o Multiple designs per web site

Each web site can have any number of designs.

Every design has a menu of web pages.

=item o Multiple web pages per design

As expected, each design consists of any number of web pages.

=item o Auto-generation of web pages and assets.

When you create a new site and design, a default web page is created.

This also happens if you change the name of a web site or of a design, and
click Save.

This web page has a default asset (output file template), and default (empty) content.

=item o Why is the name of the homepage in the config file?

To make it easy to edit!

Also note that there are 2 template files shipped with this distro, one for the homepage
and one for any other page. These templates are not fancy, they are just there as guidelines
for how you should develop your own templates.

See htdocs/assets/templates/app/office/cms/page.templates/*.tx for the templates.

See also data/asset_types.txt for the other place template information is stored.

=item o Web page attributes

So far, each web page is given a small number of attributes, including the
template to be used to create the corresponding output web page (at generation time).

Using the Javascript editor, you create the content for each page.

=item o Output

Web pages are generated by pouring the content into the template.

Two (2) sample templates are provided.

=item o Configuration

See lib/App/Office/CMS/.htoffice.cms.conf.

=item o Errors

As far as possible, L<Try::Tiny> is used to catch non-DBI errors.

DBI errors are caught using the HandleError attribute key in the call to
DBI's connect() method.

=back

=head1 Security

Minimal effort has been made to sanitize error messages, so there's a risk
that information you don't wish to leak out may be displayed on the end-user's
screen.

Feel free to recommend changes in this area.

CGI form field data is passed thru CGI::Untaint and, optionally, HTML::Defang.

=head1 Distributions

This module is available as a Unix-style distro (*.tgz).

See L<http://savage.net.au/Perl-modules/html/installing-a-module.html>
for help on unpacking and installing distros.

=head1 Installation Pre-requisites

=head2 The Yahoo User Interface (YUI)

This module does not ship with YUI. You can get it from:
L<http://developer.yahoo.com/yui>.

All development was done using V 2.8.1.

Currently, I have no plans to port this code to V 3 of YUI.

See also lib/App/Office/CMS/.htoffice.cms.conf, where it specifies the
URL used by the code to find YUI's JavaScript files.

The output templates use these 5 YUI files:

=over 4

=item o CSS: yui/build/treeview/assets/skins/sam/treeview.css

=item o JS: yui/build/yahoo/yahoo-min.js

=item o JS: yui/build/dom/dom-min.js

=item o JS: yui/build/event/event-min.js

=item o JS: yui/build/treeview/treeview.js

=back

=head2 More on Configuration

At various places I refer to a file, lib/App/Office/CMS/.htoffice.cms.conf,
shipped in this distro.

Please realize that if you edit this file, you must ensure the copy you are editing
is the one used by the code at run-time.

After a module such as this is installed, the code will look for that file
in the directory where I<Build.PL> or I<Makefile.PL> has installed the code.

The module which reads the file is C<App::Office::CMS::Util::Config>.

Both I<Build.PL> or I<Makefile.PL> install .htoffice.cms.conf along with the
Perl modules.

So, if you unpack the distro and edit the file within the unpacked code,
you'll still need to copy the patched version into the installed code's
directory structure.

There is no need to restart your web server after updating this file.

=head2 Creating the database

OK, here we go...

I use SQLite because it's shipped with recent versions of Perl.

Running scripts/create.tables.pl (below) will create the database.

If you use Postgres, do this to create the database:

	shell>psql -U postgres
	psql>create role cms login password 'cms';
	psql>create database cms owner cms encoding 'UTF8';
	psql>\q

=head2 Creating and populating the database tables

The distro contains a set of text files which are used to populate constant tables.
All such data is in the data/ directory.

This data is loaded into the database using programs in the distro.
All such programs are in the scripts/ directory.

After unpacking the distro, create and populate the database thus:

	shell>cd App-Office-CMS-1.00
	# Naturally, you only drop /pre-existing/ tables :-),
	# so use drop.tables.pl later, when re-building the db.
	#shell>perl -Ilib scripts/drop.tables.pl -v
	shell>perl -Ilib scripts/create.tables.pl -v
	shell>perl -Ilib scripts/populate.tables.pl -v
	shell>perl -Ilib scripts/report.tables.pl -v

See also scripts/new.db.sh.

Note: The '-Ilib' means 2 things:

=over 4

=item o Perl looks in the current directory structure for the modules

That is, Perl does not use the installed version of the code, if any.

=item o The code looks in the current directory structure for .htoffice.cms.conf

That is, it does not use the installed version of this file, if any.

=back

So, if you leave out the '-Ilib', Perl will use the version of the code which has been
previously installed, and then the code will look in the same place for
.htoffice.cms.conf.

=head1 Installing the module

Install L<App::Office::CMS> as you would for any C<Perl> module:

Run:

	cpanm App::Office::CMS

or run:

	sudo cpan App::Office::CMS

or unpack the distro, and then either:

	perl Build.PL
	./Build
	./Build test
	sudo ./Build install

or:

	perl Makefile.PL
	make (or dmake)
	make test
	make install

Either way, you need to install all the other files which are shipped in the distro.

=head2 Install the L<Text::Xslate> (HTML and Javascript) template files

Copy the distro's htdocs/assets/ directory to your web server's doc root.

Specifically, my doc root is /dev/shm/html, so I end up with /dev/shm/html/assets/.

/dev/shm is Debian's RAM disk. Your doc root might be /var/www, or even /var/www/html.

=head2 Install the FAQ web page

This FAQ is for using C<App::Office::CMS> via its CGI scripts, not for the generated web site.

In lib/App/Office/CMS/.htoffice.cms.conf there is a line:

	program_faq_url=/assets/templates/app/office/cms/cms.help.html

This page is displayed when the user clicks FAQ on the About tab.

A sample page is shipped in docs/html/cms.help.html. It has been built from
docs/pod/cms.help.pod (by running a script I wrote, pod2html.pl, which in turn
is a simple wrapper around L<Pod::Simple::HTML>).

So, copy the sample HTML file into your web server's doc root, or generate another version
of the page, using docs/pod/cms.faq.pod as input.

=head2 Install the trivial CGI script and the Plack script

Copy the distro's httpd/cgi-bin/office/ directory to your web server's cgi-bin/
directory, and make I<cms.cgi> executable.

If I used Apache, my cgi-bin/ dir would be /usr/lib/cgi-bin/, so I would end up
with /usr/lib/cgi-bin/office/cms.cgi.

Actually, I run nginx (Engine X) L<http://wiki.nginx.org/Main>, which does not serve
CGI scripts, and tiny (thttpd) L<http://acme.com/software/thttpd/>, which does.

See L<http://wiki.nginx.org/ThttpdCGI> for patching tiny.

See also L<http://savage.net.au/Perl/html/env.report.html>.

=head2 Start testing

Try:

	starman -l 127.0.0.1:5006 --workers 1 httpd/cgi-bin/office/cms.psgi &

Or, for good debug output:

	plackup -l 127.0.0.1:5006 httpd/cgi-bin/office/cms.psgi &

Or, install cms.cgi and point your browser at:

	http://127.0.0.1/cgi-bin/cms.cgi.

=head1 The Generate Button

Mostly, you'll be working on the Edit Content tab, so that's where the [Generate] button is.

Clicking [Generate] generates all of the pages in the current design. You do not have to be
editing content for the homepage to use the [Generate] button.

The disk directory structure created matches the tree structure you have created via the Edit Pages tab.

So, if you created a page called Offices, and under that 2 children called Locations and Staff, then
these files will be output:

=over 4

=item o offices.html

=item o offices/locations.html

=item o offices/staff.html

=back

There are various things to note:

=over 4

=item o Case: File and Directory names are output in lower case

This conversion is done with L<String::Dirify>.

=item o Hierarchy: Child nodes are in a sub-directory under their parent

This structure is generated by tracing the ancestors of each page up the tree of pages,
to the root (but excluding the root), and using the parent, grand-parent, etc, names as
directory names.

=item o Root directory

When a site is created, you specify an output directory, and the directories mentioned in
the previous items are created under the site's directory.

So, if this site's output directory was in Debian's RAM disk at /dev/shm/html, then the output files'
full paths would be:

=over 4

=item o /dev/shm/html/offices.html

=item o /dev/shm/html/offices/locations.html

=item o /dev/shm/html/offices/staff.html

=back

L<Path::Class> is used to construct these paths in an OS-independent manner, which means you must
provide the site's output directory in a format suitable for your OS.

=back

=head1 FAQ

=over 4

=item o This module doesn't really create entire web sites!

True, but since it's Open Source, you can extend it yourself.

=item o But why don't you add millions of features!

I can give you 3 reasons for that: Canny, Microlight and Simple.

=item o Can I have 2 pages with the same name?

No. When user input is being checked, the page is searched for by name,
and a match means the new input is an update for the existing page.

=item o How is the code structured?

MVC (Model-View-Controller).

The sample scripts I<cms.cgi> and I<cms.psgi> use

	prefix => 'App::Office::CMS::Controller'

so the files in lib/App/Office/CMS/Controller are the modules which are run to respond
to http requests.

Files in lib/App/Office/CMS/View implement views, and those in
lib/App/Office/CMS/Database implement the model.

Files in lib/App/Office/CMS/Util are a mixture:

=over 4

=item o Config.pm

This is used by all code.

=item o Create.pm

This is just used to create tables, populate them, and drop them.

Hence it won't be used by L<CGI> scripts, unless you write such a script yourself.

=item o Logger.pm

This simplifies logging by allowing me to say:

	$self -> log(debug => 'A message');
	$self -> log(info  => 'Another message');

=item o Validator.pm

This is used to validate CGI form data.

=back

=item o What's the database schema?

See docs/cms.schema.png.

The file was created with scripts/schema.sh, which uses dbigraph.pl.

dbigraph.pl ships with L<GraphViz::DBI>. I patched it to use L<GraphViz::DBI::General>.

=item o Does the database server have pre-requisites?

The code is DBI-based, of course.

Also, the code assumes the database server supports $dbh -> last_insert_id(undef, undef, $table_name, undef).

=item o How do I back up the database?

See the config file .htoffice.cms.conf:

	backup_command = pg_dump -U cms cms
	backup_file = /tmp/pg.cms.backup.dat

When backup_command has a value, the Edit Contents tab gets a [Backup] button, and when this button
is clicked:

=over 4

=item o The command is run

=item o STDOUT and STDERR are captured

=item o If STDERR contains anything, the program exits

=item o Otherwise, STDOUT is written to the output file

=back

So, why are there 2 lines, and not something like 'pg_dump -U cms cms > /tmp/pg.cms.backup.dat'?

Because I use L<Capture::Tiny>, which does not want you to use redirection.

Lastly, the output is written using L<File::Slurp>.

=item o What's this thing called 'context' in the menus and pages tables?

It's the value ("$site_id/$design_id") which ties those 2 tables together, just like a foreign key.

=item o What are these fields menu_orientation_id and os_type_id in the designs table?

I originally allowed the user to select a horizontal or vertical menu format, when generating pages.

The vertical menu is just the tree I ended up with.

I decided not to support horizontal menus, at least in the short term, because of the width of such a menu
when the page names became long. It would have appeared just above the site map on the Edit Pages tab, and
would have been clickable in the same way the site map tree is.

The os_type_id is for the unsupported code which generates pages in a directory structure for an OS
different from the one the code is running on.

You can ignore these 2 fields, and the other 2 tables, menu_orientations and os_types.

=item o I added a field to update_page_form, but it's data vanishes.

Basdically, copy the code dealing with 'homepage'.

At the very least, ensure you've updated:

=over 4

=item o App::Office::CMS::Util::Create.create_pages_table()

=item o App::Office::CMS::Database.build_default_page()

=item o App::Office::CMS::Controller::Page

=over 4

=item o build_page_hash()

=item o build_success_result()

=item o check_page_name()

=item o update()

=back

=item o App::Office::CMS::Util::Validator.validate_page()

=item o App::Office::CMS::Database::Page.save_page_record()

=item o App::Office::CMS::View::Page.build_update_page_html()

=back

For site data, start with App::Office::CMS::Controller.build_site_hash().

=item o How to I replace the fundamental editing functionality?

Simply.

=over 4

=item o The 'Edit design' button

This is in site.tx. It's id is submit_edit_design. Leave it as is.

=item o The 'Edit design' Javascript

Clicking [Edit design] triggers a call to update_site_onsubmit(). This is in site.js.

=item o Calling the update_page_callback() function (1 of 2)

This is called from within update_site_onsubmit(). The call is in site.js.

The path info is 'page/edit', which is added to the base '$form_action/'.

As per L<CGI::Application::Dispatch>, this calls C<App::Office::Controller::Page>'s
edit() method.

Change this path info to call a different module. So, 'custom_page/my_edit' will
call C<App::Office::Controller::CustomPage>'s my_edit() method.

=item o CustomPage.pm

You write *::Controller::CustomPage.pm, based (obviously) on *::Controller::Page.pm.

You can still let *::View::Page process your updated page.tx and page.js
templates. See below for details.

=item o Validator.pm

This is C<App::Office::CMS::Util::Validator>. You'll have to edit the
validate_design() method.

=item o The declaration of update_page_callback() (2 of 2)

This is in page.js. This is the Javascript function which receives the output
of CustomPage.pm.

Replace the code in this function as needed.

=item o *::View::Page

You'll need to patch the build_head_js() and build_update_page_html() methods
in this class.

=item o page.tx

This is populated by code in the *::View::Page::build_update_page_html() method.

=item o page.js

This is populated by code in *::View::Page::build_head_js() method.

=item o Site attributes 'v' Design attributes

When a site/design is submitted for saving, some attributes are saved with the
site, and some with the design.

If writing to the database fails, it's probably because the attributes for the
design were not copied from the CGI form fields.

Check C<App::Office::CMS::Database::Design>'s site2design() method.

=back

=item o Please explain the program, text file, and database table names

Programs are shipped in scripts/, and data files in data/.

I prefer to use '.' to separate words in the names of programs.

However, for database table names, I use '_' in case '.' would case problems.

Programs such as create.tables.pl and populate.tables.pl, use table names for their data files'
names. Hence the '_' in the names of their data files.

=item o Will you re-write it to use a different Javascript library?

No, that would be an unproductive use of my time.

Other such libraries might do a good job, but I don't believe they'll do a better job.

I have published a review of various Javascript libraries [1],
and IMHO YUI is the best.

[1] L<http://use.perl.org/~Ron+Savage/journal/37726>.

=item o How do I change the generated page formats?

The templates used for generating pages are found via the config option
page_template_path.

All *.tx files in this directory are put into the page template menu on the
'Update Design' page.

The default homepage template is home.page.tx.

The default generic page template is generic.page.tx.

=item o Why didn't you use accessors::classic/Class::Accessor/Object::Tiny/...?

For various reasons:

=over 4

=item o accessors::classic ...

... does not parse the parameters to new().

=item o I wanted ...

... to have BUILD() (or even init() ) called after new().

=item o Class::Accessor::Constructor ...

... will call init(), but it also drags in another set of dependencies.

=item o Object::Tiny ...

... does not have attribute setters.

=item o With Mouse, ....

... a syntax-friendly upgrade path the Moose is preserved.

=back

=item o Will you adopt DBIx::Connector?

Probably.

=item o Do I need Apache?

No. L<Starman>, part of Perl's L<Plack> project, is recommended.

See the sample code in httpd/cgi-bin/office.

=item o What other CMS's are there?

Heaps: L<http://cmsmatrix.org/>.

=item o Lastly, a plea

With your co-operation, I'd like to reserve the namespace C<App::Office::CMS>,
and perhaps even C<App::Office::Wiki>, for my own code.

Of course, you're I<much> better off using a TiddlyWiki
L<http://tiddlywiki.org/wiki/Main_Page> than waiting for me to start writing a wiki.

For massive wikiness (as distinct from wickedness :-) I draw your attention to
both L<Silki> and L<http://foswiki.org/Home/WebHome>.

=back

=head1 TODO

=over 4

=item o Adopt Git::Repository for versioned backup

=item o Clean up error handling

For example, when build_error_result is called, rather than build_success_result, the
data sent to Javascript must be handled slightly differently.

This includes HandleError in DBI's connect() attributes.

=item o Make asset handling more sophisticated

=item o Add begin/end transaction

=item o Probably need Javascript hash for menu item <-> id

This would allow the client to pass the menu item's id to the server, instead of the text

=item o Need to document handling of &amp;

=item o Do we need separate editor windows for each page's head and body?

=item o How will we handle moving sub-menus?

We don't.

=item o Ship with SQLite activated, not Postgres

=item o Consider using <span> instead of <div>

=item o Auto-generate a site

=item o Auto-generate a design for a site

=item o Enhance New Site tab with an Edit Site button

This saves the user the effort of going to the Search tab to find a site or design

=item o When clicking on the site map, the Edit Pages fields are updated, but the Edit Content fields are not

=item o Add an option, perhaps, to escape entities when inputting HTML

=item o Adopt DBIx::Connector

=item o Implement user-initiated backup and restore

=item o Change class hierarchy

This is so View does not have to pass so many parameters to its 'has-a' attributes

=item o Adopt L<CGI::Untaint::html> or L<HTML::Defang>

Considered and rejected: L<HTML::Sanitizer>, L<HTML::Scrubber>.

=item o Test CGI::Untaint as to its handling of <script>...</script>

=item o Investigate Quicki's revision system

=back

=head1 Repository

L<https://github.com/ronsavage/App-Office-CMS.git>

=head1 Support

Email the author, or log a bug on RT:

L<https://rt.cpan.org/Public/Dist/Display.html?Name=App-Office-CMS>.

=head1 Author

L<App::Office::CMS> was written by Ron Savage I<E<lt>ron@savage.net.auE<gt>> in 2010.

Homepage: L<http://savage.net.au/index.html>.

=head1 Copyright

Australian copyright (c) 2010, Ron Savage.

	All Programs of mine are 'OSI Certified Open Source Software';
	you can redistribute them and/or modify them under the terms of
	The Perl License, a copy of which is available at:
	http://dev.perl.org/licenses/

=cut

