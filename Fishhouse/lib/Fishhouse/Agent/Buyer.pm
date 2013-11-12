package Fishhouse::Agent::Buyer {
    use Moo;
    use namespace::sweep;

    with 'Fishhouse::Agent';

    use Log::Any qw( $log );

    use Fishhouse::Order::Bid;
    use Fishhouse::Order::Buy;

    use constant type => 'buyer';

    has demand => (
        is => 'ro',
        required => 1,
    );

    sub bid {
        my $self = shift;
        my $price = shift;
        my $bid = Fishhouse::Order::Bid->new({
            agent => $self,
            price => $price,
        });
        $self->unit_transmitted($bid);
        return $bid;
    }

    sub buy {
        return Fishhouse::Order::Buy->new({agent => $_[0]});
    }

    sub wtp {
        my $self = shift;
        my $wtp = $self->demand->($self->units + 1);
        return $wtp;
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

