#!perl -w
use strict;
use Test::More tests => 1;
use Data::Dumper;

=head1 NAME

01-template-list.t - check that the POD lists all relevant files

=cut

my $module_pm = shift || 'lib/Dancer/Layout/Bootstrap.pm';

open my $MANIFEST, '<', 'MANIFEST'
    or die "Couldn't read MANIFEST: $!";
my %copy= map { (split /\t/)[0] => $_ }
          grep /\t.*(Bootstrap|Glyphicons|jQuery)/,
          <$MANIFEST>;
          
open my $MODULE, '<', $module_pm
    or die "Couldn't read '$module_pm': $!";
my @have= map {/\s+(\S+)/}
          grep /^=head2 LIST OF FILES TO COPY/../^=head1/,
          <$MODULE>;

delete @copy{ @have };

if(! is 0+keys %copy, 0, "All files that need copying are listed") {
    diag $_ for sort values %copy;
};