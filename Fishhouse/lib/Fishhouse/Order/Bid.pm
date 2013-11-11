package Fishhouse::Order::Bid 0.001 {
    use Moo;
    use namespace::sweep;

    with 'Fishhouse::Order';

    use constant type => 'bid';

    has price => (
        is => 'ro',
        required => 1,
    );

    __PACKAGE__;
}

