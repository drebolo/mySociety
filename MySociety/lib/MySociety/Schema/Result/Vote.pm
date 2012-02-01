use utf8;
package MySociety::Schema::Result::Vote;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MySociety::Schema::Result::Vote

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<votes>

=cut

__PACKAGE__->table("votes");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 constituency_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 user_is_voting

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 0

=head2 party_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "constituency_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "user_is_voting",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 0 },
  "party_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 constituency

Type: belongs_to

Related object: L<MySociety::Schema::Result::Constituency>

=cut

__PACKAGE__->belongs_to(
  "constituency",
  "MySociety::Schema::Result::Constituency",
  { id => "constituency_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 party

Type: belongs_to

Related object: L<MySociety::Schema::Result::Party>

=cut

__PACKAGE__->belongs_to(
  "party",
  "MySociety::Schema::Result::Party",
  { id => "party_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-01-24 20:14:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0zRF8kEcVN06lAVsJVRJPg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
