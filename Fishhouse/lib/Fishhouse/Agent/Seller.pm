package Fishhouse::Agent::Seller {
    use Moo;
    use namespace::sweep;

    use Log::Any qw( $log );

    with 'Fishhouse::Agent';

    use Fishhouse::Order::Ask;
    use Fishhouse::Order::Sell;

    use constant type => 'seller';

    has supply => (
        is => 'ro',
        required => 1,
    );

    sub ask {
        my $self = shift;
        my $price = shift;
        my $ask = Fishhouse::Order::Ask->new({
            agent => $self,
            price => $price,
        });
        $self->unit_transmitted($ask);
        return $ask;
    }

    sub sell {
        return Fishhouse::Order::Sell->new({agent => $_[0]});
    }

    sub wta {
        my $self = shift;
        my $wta = $self->supply->($self->units + 1);
        return $wta;
    }

    sub decide {
        my $self = shift;
        my $asks = shift;
        my $bids = shift;

        my $wta = $self->wta;
        return $self->ask($wta) if rand > 0.5;
        return $self->pass unless $bids->size;
        return $self->pass unless $wta <= $bids->best_price;
        return $self->sell;
    }
    __PACKAGE__;
}

