package Fishhouse::Order::Sell {
    use Moo;
    use namespace::sweep;

    with 'Fishhouse::Order';
    use constant type => 'sell';

    __PACKAGE__;
}

