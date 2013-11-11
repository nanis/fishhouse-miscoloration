package Fishhouse::Order::Ask 0.001 {
    use Moo;
    use namespace::sweep;

    with 'Fishhouse::Order';

    use constant type => 'ask';

    has price => (
        is => 'ro',
        required => 1,
    );

    __PACKAGE__;
}
