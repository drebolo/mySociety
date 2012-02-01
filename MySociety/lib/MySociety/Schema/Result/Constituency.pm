use utf8;
package MySociety::Schema::Result::Constituency;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MySociety::Schema::Result::Constituency

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<constituencies>

=cut

__PACKAGE__->table("constituencies");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 constituency_name

  data_type: 'varchar'
  is_nullable: 0
  size: 64

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "constituency_name",
  { data_type => "varchar", is_nullable => 0, size => 64 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 parties_for_constituencies

Type: has_many

Related object: L<MySociety::Schema::Result::PartyForConstituencies>

=cut

__PACKAGE__->has_many(
  "parties_for_constituencies",
  "MySociety::Schema::Result::PartyForConstituencies",
  { "foreign.constituency_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 votes

Type: has_many

Related object: L<MySociety::Schema::Result::Vote>

=cut

__PACKAGE__->has_many(
  "votes",
  "MySociety::Schema::Result::Vote",
  { "foreign.constituency_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 parties

Type: many_to_many

Composing rels: L</parties_for_constituencies> -> party

=cut

__PACKAGE__->many_to_many("parties", "parties_for_constituencies", "party");


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-01-24 20:14:56
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Ng8TLKwMIeW51Z334Gwehw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
