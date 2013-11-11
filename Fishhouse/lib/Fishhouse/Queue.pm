package Fishhouse::Queue 0.001 {
    use Moo::Role;
    use namespace::sweep;

    requires 'compare';

    has best_price => (
        is => 'rwp',
        default => sub { undef },
        init_arg => undef,
    );

    has queue => (
        is => 'ro',
        default => sub { {} },
        init_arg => undef,
    );

    sub _update_best_price {
        my $self = shift;
        my $price = (
            sort { $self->compare($a, $b) }
            keys %{ $self->queue }
        )[0];
        $self->_set_best_price($price);
        return;
    }

    sub display {
        my $self = shift;
        my $queue = $self->queue;
        my @orders = map
            sprintf('%d @ $%s', scalar @{ $queue->{$_}}, $_),
            sort { $self->compare($a, $b) }
            keys %$queue
        ;
        return \@orders;
    }

    sub insert {
        my $self = shift;
        my $order = shift;
        push @{ $self->queue->{$order->price} }, $order;
        $self->_update_best_price;
        return;
    }

    sub size {
        return scalar keys %{ $_[0]->queue };
    }

    sub top {
        my $self = shift;
        my $queue = $self->queue;

        my $best_price = $self->best_price;
        my $orders = $queue->{$best_price};
        my $order = shift @$orders;

        unless (@$orders) {
            delete $queue->{$best_price};
        }

        return $order;
    }
    __PACKAGE__;
}

