package Fishhouse::Order::Buy 0.001 {
    use Moo;
    use namespace::sweep;

    with 'Fishhouse::Order';

    use constant type => 'buy';

    __PACKAGE__;
}

