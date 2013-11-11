package Fishhouse::Timestamped {
    use Moo::Role;
    use namespace::sweep;

    use DateTime::TimeZone::Local;
    use Time::HiRes;

    has timestamp => (
        is => 'ro',
        default => sub { join '+', Time::HiRes::gettimeofday() },
    );

    has tz => (
        is => 'ro',
        default => sub { DateTime::TimeZone::Local->TimeZone->name },
    );

    sub timestamp_string {
        my $self = shift;
        return sprintf '%s[%s]', $self->timestamp, $self->tz;
    }

    __PACKAGE__;
}

