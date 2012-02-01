package MySociety;
use Dancer ':syntax';
use Dancer::Plugin::DBIC qw(schema);
use Dancer::Plugin::Ajax;
use MySociety::Schema;
use Data::Dumper;

our $VERSION = '0.1';

set 'mysociety_schema' => schema 'mysociety';

get '/' => sub {
    template 'index';
};

ajax '/search_constituency' => sub {
    my $search_data       = lc( params->{term} );
    my $schema            = schema 'mysociety';
    my $constituencies_rs = $schema->resultset('Constituency')->search(
        { 'LOWER(constituency_name)' => { like => '%' . $search_data . '%' } },
        { columns => [qw/id constituency_name/], }
    );
    my $data = [];
    while ( my $constituency = $constituencies_rs->next ) {
        push @$data,
          {
            'id'    => $constituency->id,
            'label' => $constituency->constituency_name
          };
    }
    content_type 'application/json';
    return to_json($data);
};

ajax '/get_parties_for_constituency' => sub {
    my $schema          = schema 'mysociety';
    my $constituency_id = params->{constituency_id};
    my $inside_rs       = $schema->resultset('PartyForConstituencies')->search(
        { constituency_id => $constituency_id },
        { columns         => [qw/party_id/], }
    );
    my $parties_rs =
      $schema->resultset('Party')
      ->search(
        { id => { -in => $inside_rs->get_column('party_id')->as_query } } );
    my $data = [];
    while ( my $party = $parties_rs->next ) {
        push @$data,
          {
            'id'   => $party->id,
            'name' => $party->party_name
          };
    }
    content_type 'application/json';
    return to_json($data);
};

ajax '/save_poll_data' => sub {
    my $schema   = schema 'mysociety';
    my $new_vote = $schema->resultset('Vote')->new(
        {
            constituency_id => params->{constituencyId},
            user_is_voting  => params->{userWillVote} eq 'Yes' ? 1 : 0,
            party_id => params->{partyId} eq '' ? undef : params->{partyId}
        }
    );
    $new_vote->insert;
    content_type 'application/json';
    return to_json( {} );
};

get '/national_results' => sub {
    my $schema = schema 'mysociety';

    my $vote_rs = $schema->resultset('Vote')->search(
        {},
        {
            select   => [ { sum => '1' }, ],
            as       => ['sum'],
            group_by => [qw/user_is_voting/],
            columns  => [qw/ id user_is_voting/]

        }
    );
    my $data = {};
    while ( my $vote = $vote_rs->next ) {
        $data->{user_is_voting}{ $vote->user_is_voting } =
          $vote->get_column('sum');
    }
    my $non_voters_count = 0;
    my $non_voters_percentage = sprintf "%.2f", 0;

    if ( scalar keys %$data ) {

        $non_voters_count = (
            exists $data->{user_is_voting}{0}
            ? $data->{user_is_voting}{0}
            : 0 );
        my $voters_count = (
            exists $data->{user_is_voting}{1}
            ? $data->{user_is_voting}{1}
            : 0 );

        if ($non_voters_count) {
            $non_voters_percentage = sprintf "%.2f",
              ( $non_voters_count * 100 ) /
              ( $non_voters_count + $voters_count );
        }
    }
    template 'national_results',
      {
        non_voters_count      => $non_voters_count,
        non_voters_percentage => $non_voters_percentage
      };
};

ajax '/get_national_results' => sub {
    my $page  = params->{page};
    my $limit = params->{rows};

    my $sidx   = params->{sidx};
    my $sord   = params->{sord};
    my $schema = schema 'mysociety';

    if ( !$sidx ) { $sidx = 1 }

    my $search_options = '';

    my $search = { user_is_voting => 1 };

    my $records_count = $schema->resultset('Vote')->search(
        $search,
        {
            select   => [ { sum => '1' }, ],
            as       => ['sum'],
            group_by => [qw/party_id/],
            columns  => [qw/ id party_id user_is_voting/]

        }
    )->count;

    my $non_voters_count =
      $schema->resultset('Vote')->search( { user_is_voting => 0 }, {} )->count;

    my $total_pages;
    if ( $records_count > 0 and $limit > 0 ) {
        $total_pages = int( ($records_count) / $limit ) + 1;
    }
    else {
        $total_pages = 0;
    }

    my $vote_rs = $schema->resultset('Vote')->search(
        $search,
        {
            select   => [ { sum => '1' }, ],
            as       => ['sum'],
            group_by => [qw/party_id/],
            columns  => [qw/ id party_id user_is_voting/],
            page     => $page,
            rows     => $limit,
            join     => [qw /party/],
            order_by => { '-' . $sord => $sidx },
        }
    );
    my $data        = [];
    my $index       = 0;
    my $total_votes = 0;
    while ( my $vote = $vote_rs->next ) {
        $total_votes += $vote->get_column('sum');
        push @$data,
          {
            'id'   => $index,
            'cell' => [
                $index,
                (
                      $vote->user_is_voting
                    ? $vote->party()->party_name
                    : 'Non voters'
                ),
                $vote->get_column('sum')
            ]
          };
        $index++;
    }

    foreach my $row (@$data) {
        push @{ $row->{'cell'} }, sprintf "%.2f",
          ( $row->{'cell'}[2] * 100 ) / $total_votes;
    }

    return to_json(
        {
            page    => $page,
            total   => $total_pages,
            records => $records_count,
            rows    => $data
        }
    );
};

get '/constituency_results' => sub {
    template 'constituency_results';
};

ajax '/get_constituency_results/:number' => sub {

    my $page  = params->{page};
    my $limit = params->{rows};

    my $sidx   = params->{sidx};
    my $sord   = params->{sord};
    my $schema = schema 'mysociety';

    if ( !$sidx ) { $sidx = 1 }

    my $search_options = '';

    my $search = { constituency_id => params->{number}, user_is_voting => 1 };
    my $records_count = $schema->resultset('Vote')->search(
        $search,
        {
            select   => [ { sum => '1' }, ],
            as       => ['sum'],
            group_by => [qw/party_id/],
            columns => [qw/ id party_id user_is_voting constituency_id/]

        }
    )->count;

    my $total_pages;
    if ( $records_count > 0 and $limit > 0 ) {
        $total_pages = int( ($records_count) / $limit ) + 1;
    }
    else {
        $total_pages = 0;
    }
    my $vote_rs = $schema->resultset('Vote')->search(
        $search,
        {
            select   => [ { sum => '1' }, ],
            as       => ['sum'],
            group_by => [qw/party_id/],
            columns  => [qw/ id party_id user_is_voting constituency_id/],
            page     => $page,
            rows     => $limit,
            join     => [qw /party/],
            order_by => { '-' . $sord => $sidx },
        }
    );
    my $data        = [];
    my $index       = 0;
    my $total_votes = 0;
    while ( my $vote = $vote_rs->next ) {
        $total_votes += $vote->get_column('sum');
        push @$data,
          {
            'id'   => $index,
            'cell' => [
                $index,
                (
                      $vote->user_is_voting
                    ? $vote->party()->party_name
                    : 'Non voters'
                ),
                $vote->get_column('sum')
            ]
          };
        $index++;
    }
    foreach my $row (@$data) {
        push @{ $row->{'cell'} }, sprintf "%.2f",
          ( $row->{'cell'}[2] * 100 ) / $total_votes;
    }

    return to_json(
        {
            page    => $page,
            total   => $total_pages,
            records => $records_count,
            rows    => $data,
            teste   => 'treta'
        }
    );
};

ajax '/get_non_voter_for_constituency' => sub {
    my $schema = schema 'mysociety';

    my $vote_rs = $schema->resultset('Vote')->search(
        { constituency_id => params->{constituency_id} },
        {
            select   => [ { sum => '1' }, ],
            as       => ['sum'],
            group_by => [qw/user_is_voting/],
            columns  => [qw/ id user_is_voting/]

        }
    );

    my $data = {};
    while ( my $vote = $vote_rs->next ) {
        $data->{user_is_voting}{ $vote->user_is_voting } =
          $vote->get_column('sum');
    }
    my $non_voters_count = 0;
    my $non_voters_percentage = sprintf "%.2f", 0;

    if ( scalar keys %$data ) {

        $non_voters_count = (
            exists $data->{user_is_voting}{0}
            ? $data->{user_is_voting}{0}
            : 0 );
        my $voters_count = (
            exists $data->{user_is_voting}{1}
            ? $data->{user_is_voting}{1}
            : 0 );

        if ($non_voters_count) {
            $non_voters_percentage = sprintf "%.2f",
              ( $non_voters_count * 100 ) /
              ( $non_voters_count + $voters_count );
        }
    }
    return to_json(
        {
            non_voters_count      => $non_voters_count,
            non_voters_percentage => $non_voters_percentage
        }
    );
};

true;
