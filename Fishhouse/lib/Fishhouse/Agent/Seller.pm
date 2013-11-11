package Fishhouse::Agent::Seller {
    use Moo;
    use namespace::sweep;

    with 'Fishhouse::Agent';

    use Fishhouse::Order::Ask;
    use Fishhouse::Order::Sell;

    has supply => (
        is => 'ro',
        required => 1,
    );

    sub ask {
        my $self = shift;
        my $ask = Fishhouse::Order::Ask->new({
            agent => $_[0],
            price => $_[1],
        });
        $self->unit_transmitted($ask);
        return;
    }

    sub sell {
        return Fishhouse::Order::Sell->new({agent => $_[0]});
    }

    sub wta {
        my $self = shift;
        return $self->supply->($self->units + 1);
    }

    sub decide {
        my $self = shift;
        my $asks = shift;
        my $bids = shift;

        my $wta = $self->wta;
        return $self->ask($wta) if rand > 0.5;
        return $self->pass unless $bids->size;
        return $self->pass unless $wta >= $bids->best_price;
        return $self->sell;
    }
    __PACKAGE__;
}

