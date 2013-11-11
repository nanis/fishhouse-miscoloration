#!/usr/bin/env perl

use 5.014;
use strict;
use warnings;
use warnings qw(FATAL);

use Log::Any::Adapter qw( Stdout );

use Fishhouse::Agent::Buyer;
use Fishhouse::Agent::Seller;
use Fishhouse::Market;

package main {
    run(\@ARGV);

    sub run {
        my $argv = shift;

        my $market = Fishhouse::Market->new;

        $market->add_agents(map Fishhouse::Agent::Buyer->new({
                    demand => sub { 50 - $_[0] },
                }),
            1 .. 10
        );
        $market->add_agents(map Fishhouse::Agent::Seller->new({
                    supply => sub { 10 + 2 * $_[0] },
                }),
            1 .. 10
        );

        $market->run(1);

        return;
    }
}

