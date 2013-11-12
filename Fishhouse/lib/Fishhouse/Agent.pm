package Fishhouse::Agent 0.001 {
    use Moo::Role;
    use namespace::sweep;

    use Digest::SHA qw( sha1_hex );
    use Log::Any qw( $log );

    requires 'type';

    use Fishhouse::Order::Pass;

    has id => (
        is => 'ro',
        default => sub {
            sprintf ('%s-%s',
                ref $_[0],
                substr(sha1_hex(rand), 0, 8)
            );
        },
    );

    has pass_probability => (
        is => 'ro',
        default => sub { 0.25 },
    );

    has units => (
        is => 'rwp',
        default => sub { 0 },
    );

    sub pass {
        return Fishhouse::Order::Pass->new({agent => $_[0]});
    }

    sub transaction_completed {
        my $self = shift;
        my $transaction = shift;

        # TODO

        return;
    }

    sub unit_transmitted {
        my $self = shift;
        $self->_set_units($self->units + 1);
        return;
    }

    __PACKAGE__;
};

