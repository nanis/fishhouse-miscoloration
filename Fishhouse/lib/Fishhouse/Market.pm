package Fishhouse::Market 0.001 {
    use Moo;
    use namespace::sweep;

    use Carp qw( croak );
    use Log::Any qw( $log );
    use Time::HiRes qw( usleep );

    use Fishhouse::Queue::Ask;
    use Fishhouse::Queue::Bid;
    use Fishhouse::Transaction;

    has agents => (
        is => 'ro',
        default => sub { [] },
    );

    has asks => (
        is => 'ro',
        default => sub { Fishhouse::Queue::Ask->new },
    );

    has bids => (
        is => 'ro',
        default => sub { Fishhouse::Queue::Bid->new },
    );

    has orders => (
        is => 'ro',
        default => sub { [] },
    );

    has transactions => (
        is => 'ro',
        default => sub { [ ] },
    );

    sub run {
        my $self = shift;
        my $duration = shift;

        while (time - $^T < $duration) {
            $self->turn;
            $self->display_queues;
            usleep 7_500;
        }
        return;
    }

    sub turn {
        my $self = shift;
        my $agent = $self->random_agent;
        my $order = $agent->decide($self->asks, $self->bids);
        my $handler = $self->get_handler($order->type);
        $self->$handler($order);

        return;
    }

    sub get_handler {
        my $self = shift;
        my $type = shift;
        return "${type}_received";
    }

    sub add_agents {
        my $self = shift;
        push @{ $self->agents }, @_;
        return;
    }

    sub ask_received {
        my $self = shift;
        $self->asks->insert(@_);
        return;
    }

    sub bid_received {
        my $self = shift;
        $self->bids->insert(@_);
        return;
    }

    sub buy_received {
        my $self = shift;
        my $buy = shift;

        unless ($self->asks->size) {
            return;
        }

        my $ask = $self->asks->top;

        my $transaction = $self->transaction_completed(
            $buy,
            $ask,
            $ask->price,
        );

        $buy->agent->transaction_completed($transaction);
        $ask->agent->transaction_completed($transaction);

        return;
    }

    sub pass_received {
        my $self = shift;
        return;
    }

    sub sell_received {
        my $self = shift;
        my $sell = shift;

        unless ($self->bids->size) {
            return;
        }

        my $bid = $self->bids->top;

        my $transaction = $self->transaction_completed(
            $bid,
            $sell,
            $bid->price,
        );

        $bid->agent->transaction_completed($transaction);
        $sell->agent->transaction_completed($transaction);

        return;
    }

    sub add_transaction {
        my $self = shift;
        my $transaction = shift;

        printf "Transaction @ %s\n", $transaction->price;

        push @{ $self->transactions }, $transaction;
        return;
    }

    sub transaction_completed {
        my $self = shift;
        my $buyer_order = shift;
        my $seller_order = shift;
        my $settled_price = shift;

        my $transaction = Fishhouse::Transaction->new({
            buyer_id => $buyer_order->agent->id,
            buyer_order_id => $buyer_order->id,
            seller_id => $seller_order->agent->id,
            seller_order_id => $seller_order->id,
            price => $settled_price,
        });

        $self->add_transaction($transaction);

        return $transaction;
    }

    sub random_agent {
        my $self = shift;
        return $self->agents->[rand @{ $self->agents }];
    }

    sub display_queues {
        my $self = shift;

        my $output;

        for my $queue ( qw(asks bids) ) {
            $output .= ucfirst $queue . ': ';

            unless ($self->$queue->size) {
                $output .= "\n";
                next;
            }

            my $orders = $self->$queue->display;
            $output .= join(' ', @$orders) ."\n";
        }

        print $output;
        return;
    }

    __PACKAGE__;
}

