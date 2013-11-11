package Fishhouse::Agent::Buyer {
    use Moo;
    use namespace::sweep;

    with 'Fishhouse::Agent';

    use Fishhouse::Order::Bid;
    use Fishhouse::Order::Buy;

    has demand => (
        is => 'ro',
        required => 1,
    );

    sub bid {
        my $self = shift;
        my $bid = Fishhouse::Order::Bid->new({
            agent => $_[0],
            price => $_[1],
        });
        $self->unit_transmitted($bid);
        return $bid;
    }

    sub buy {
        return Fishhouse::Order::Buy->new({agent => $_[0]});
    }

    sub wtp {
        my $self = shift;
        return $self->demand->($self->units + 1);
    }

    sub decide {
        my $self = shift;
        my $asks = shift;
        my $bids = shift;

        my $wtp = $self->wtp;
        return $self->bid($wtp) if rand > 0.5;
        return $self->pass unless $asks->size;
        return $self->pass unless $wtp >= $asks->best_price;
        return $self->buy;
    }
    __PACKAGE__;
}

