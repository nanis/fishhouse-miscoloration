package Fishhouse::Queue::Bid 0.001 {
    use Moo;
    use namespace::sweep;

    with 'Fishhouse::Queue';

    sub compare {
        my $self = shift;
        return $_[1] <=> $_[0];
    }
    __PACKAGE__;
}

