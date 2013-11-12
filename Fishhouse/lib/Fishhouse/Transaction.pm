package Fishhouse::Transaction 0.001 {
    use Moo;
    use namespace::sweep;

    with 'Fishhouse::Timestamped';

    has buyer_id => (
        is => 'ro',
        required => 1,
    );

    has buyer_order_id => (
        is => 'ro',
        required => 1,
    );

    has price => (
        is => 'ro',
        required => 1,
    );

    has seller_id => (
        is => 'ro',
        required => 1,
    );

    has seller_order_id => (
        is => 'ro',
        required => 1,
    );

    sub to_string {
        my $self = shift;
        sprintf(
            '%s: Buyer: %s - Seller: %s - Price: %s',
            $self->timestamp_string,
            $self->buyer_id,
            $self->seller_id,
            $self->price,
        );
    }

    __PACKAGE__;
}

