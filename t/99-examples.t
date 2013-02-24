#!perl -w

use warnings;
use strict;
use Test::More;
use File::Find;

plan 'no_plan';

sub check {
    return if (! m{\.pl \z}xms);    
    my $output = `"$^X" -c $_ 2>&1`;
    like( $output, qr/$_ syntax OK/, "$_ compiles" )
}

if( -d 'examples') {
    find({wanted => \&check, no_chdir => 1}, 'examples');
} else {
    ok "No 'examples' directory found";
};
