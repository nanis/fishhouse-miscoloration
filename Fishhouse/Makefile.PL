use 5.014;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Fishhouse',
    AUTHOR           => q{A. Sinan Unur <nanis@cpan.org>},
    VERSION_FROM     => 'lib/Fishhouse.pm',
    ABSTRACT_FROM    => 'lib/Fishhouse.pm',
    LICENSE          => 'Artistic_2_0',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.014,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'Carp' => 0,
        'DateTime::TimeZone::Local' => 0,
        'Digest::SHA' => 0,
        'Log::Any' => 0,
        'Log::Any::Adapter' => 0,
        'Moo' => 0,
        'Moo::Role' => 0,
        'namespace::sweep' => 0,
        'Time::HiRes' => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Fishhouse-*' },
);
