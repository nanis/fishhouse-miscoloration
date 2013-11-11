package Fishhouse::Queue::Ask 0.001 {
    use Moo;
    use namespace::sweep;

    with 'Fishhouse::Queue';

    sub compare {
        my $self = shift;
        return $_[0] <=> $_[1];
    }
    __PACKAGE__;
}

