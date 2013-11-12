package Fishhouse::Agent::Seller {
    use Moo;
    use namespace::sweep;

    use Log::Any qw( $log );

    with 'Fishhouse::Agent';

    use Fishhouse::Order::Ask;
    use Fishhouse::Order::Sell;

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
        $log->debug("wta=$wta");
        return $self->ask($wta) if rand > 0.5;
        $log->debug('Skipped ask');
        return $self->pass unless $bids->size;
        $log->debug('Bids have positive size');
        return $self->pass unless $wta <= $bids->best_price;
        $log->debug('wta is greater than best bid');
        return $self->sell;
    }
    __PACKAGE__;
}

