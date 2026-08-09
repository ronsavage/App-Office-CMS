package App::Office::CMS::Database::Asset;

use strict;
use warnings;

use Date::Format;

use Moo;

extends 'App::Office::CMS::Database::Base';

our $VERSION = '0.93';

# --------------------------------------------------

sub add
{
	my($self, $asset) = @_;

	$self -> log(debug => "add()");
	$self -> log(debug => '-' x 50);
	$self -> log(debug => "Asset: $_ => $$asset{$_}") for sort keys %$asset;
	$self -> log(debug => '-' x 50);

	$self -> save_asset_record('add', $asset);

	return $$asset{id};

} # End of add.

# --------------------------------------------------

sub duplicate_assets
{
	my($self, $attr) = @_;

	$self -> log(debug => "duplicate_assets()");

	$$attr{asset_id2new_id} = {};

	my($asset);
	my($old_asset_id);

	for my $old_design_id (keys %{$$attr{page_id2new_id} })
	{
		$$attr{asset_id2new_id}{$old_design_id} = {};

		for my $old_page_id (keys %{$$attr{page_id2new_id}{$old_design_id} })
		{
			$asset = $self -> get_asset_by_page_id($old_page_id);

			$old_asset_id      = $$asset{id};
			$$asset{design_id} = $$attr{design_id2new_id}{$old_design_id};
			$$asset{page_id}   = $$attr{page_id2new_id}{$old_design_id}{$old_page_id};
			$$asset{site_id}   = $$attr{new_site_id};

			$self -> save_asset_record('add', $asset);

			$$attr{asset_id2new_id}{$old_design_id}{$old_asset_id} = $$asset{id};
		}
	}

} # End of duplicate_assets.

# --------------------------------------------------
# TODO. We assume the page has 1 asset, so we get it and not an arrayref.

sub get_asset_by_page_id
{
	my($self, $id) = @_;

	$self -> log(debug => "get_asset_by_page_id($id)");

	return $self -> db -> simple -> query('select * from assets where page_id = ?', $id) -> hash;

} # End of get_asset_by_page_id.

# --------------------------------------------------

sub get_asset_type_by_id
{
	my($self, $id) = @_;

	$self -> log(debug => "get_asset_type_by_id($id)");

	return $self -> db -> simple -> query('select * from asset_types where id = ?', $id) -> hash;

} # End of get_asset_type_by_id.

# --------------------------------------------------

sub get_asset_types
{
	my($self) = @_;

	$self -> log(debug => 'get_asset_types');

	return [$self -> db -> simple -> query('select * from asset_types') -> hashes];

} # End of get_asset_types.

# --------------------------------------------------

sub save_asset_record
{
	my($self, $context, $asset) = @_;

	$self -> log(debug => "save_asset_record($context, -)");

	my($table_name) = 'assets';
	my(@time)       = localtime;
	my($time)       = strftime('%Y-%m-%d %X', @time);
	my(@field)      = (qw/
asset_type_id
design_id
page_id
site_id
/);
	my($data) = {};

	for (@field)
	{
		$$data{$_} = $$asset{$_};
	}

	if ($context eq 'add')
	{
		$$asset{id} = $self -> db -> insert_hash_get_id($table_name, $data);
	}
	else
	{
		$self -> db -> simple -> update($table_name, $data, {id => $$asset{id} });
	}

	$self -> log(debug => "Saved ($context) asset with id $$asset{id}");

} # End of save_asset_record.

# --------------------------------------------------

sub update
{
	my($self, $page, $asset) = @_;

	$self -> log(debug => 'update()');
	$self -> log(debug => '-' x 50);
	$self -> log(debug => "Asset: $_ => $$asset{$_}") for sort keys %$asset;
	$self -> log(debug => '-' x 50);

	my($action) = $$page{exact_match} ? 'update' : 'add';

	$self -> save_asset_record($action, $asset);

	return ucfirst "$action asset";

} # End of update.

# --------------------------------------------------

1;

=pod

=head1 NAME

C<App::Office::CMS::Database::Asset> - Manage the Canny, Microlight and Simple CMS

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
