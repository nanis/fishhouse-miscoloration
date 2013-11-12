package Fishhouse::Order {
    use Moo::Role;
    use namespace::sweep;

    requires 'type';
    with 'Fishhouse::Timestamped';

    use Digest::SHA qw( sha1_hex );
    use Log::Any qw( $log );

    has agent => (
        is => 'ro',
        required => 1,
    );

    has id => (
        is => 'ro',
        default => sub {
            sprintf ('%s-%s',
                __PACKAGE__,
                substr(sha1_hex(rand), 0, 8)
            );
        },
    );

    sub to_string {
        my $self = shift;
        sprintf(
            '%s: Agent: %s - ID: %s - Price: %s',
            $self->timestamp_string,
            $self->agent->id,
            $self->id,
            ($self->can('price') ? $self->price : ''),
        );
    }
    __PACKAGE__;
}

