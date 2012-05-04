#!perl -w
use strict;
use ExtUtils::MakeMaker qw(WriteMakefile);

#use Config;
#use lib qw(inc);

# Prompt the user here for any paths and other configuration

my @tests = map { glob $_ } 't/*.t', 't/*/*.t';
my $module = 'Dancer::Layout::Bootstrap';
(my $module_pm = "lib/$module.pm") =~ s!::!/!g;
(my $repo = lc $module) =~ s!::!-!g;

# I should maybe use something like Shipwright...
regen_README($module_pm);
#regen_EXAMPLES();

WriteMakefile1(
    MIN_PERL_VERSION => '5.006',
    META_MERGE => {
        resources => {
            repository => "http://github.com/Corion/$repo",
        },
    },
    BUILD_REQUIRES => {
                        'Exporter'   => '0',
                        'Carp'       => '0',
    },
    'NAME'          => $module,
    'LICENSE'       => 'perl',
    'VERSION_FROM'  => $module_pm,
    'PREREQ_PM'     => {
                       'Template' => 2, # for output to HTML
                       'Test::More' => 0,
                       'YAML'       => 0,
                       'Dancer'     => 0, # Was developped under 1.3095
                       'Dancer::Plugin::FlashMessage' => 0,
                      }, # e.g., Module::Name => 1.1
    ABSTRACT_FROM   => $module_pm, # retrieve abstract from module
    AUTHOR          => 'Max Maischein <corion@cpan.org>',
    test            => { TESTS => join( ' ', @tests ) },
);

1;

sub WriteMakefile1 {  #Written by Alexandr Ciornii, version 0.21. Added by eumm-upgrade.
    my %params=@_;
    my $eumm_version=$ExtUtils::MakeMaker::VERSION;
    $eumm_version=eval $eumm_version;
    die "EXTRA_META is deprecated" if exists $params{EXTRA_META};
    die "License not specified" if not exists $params{LICENSE};
    if ($params{BUILD_REQUIRES} and $eumm_version < 6.5503) {
        #EUMM 6.5502 has problems with BUILD_REQUIRES
        $params{PREREQ_PM}={ %{$params{PREREQ_PM} || {}} , %{$params{BUILD_REQUIRES}} };
        delete $params{BUILD_REQUIRES};
    }
    delete $params{CONFIGURE_REQUIRES} if $eumm_version < 6.52;
    delete $params{MIN_PERL_VERSION} if $eumm_version < 6.48;
    delete $params{META_MERGE} if $eumm_version < 6.46;
    delete $params{META_ADD} if $eumm_version < 6.46;
    delete $params{LICENSE} if $eumm_version < 6.31;
    delete $params{AUTHOR} if $] < 5.005;
    delete $params{ABSTRACT_FROM} if $] < 5.005;
    delete $params{BINARY_LOCATION} if $] < 5.005;
    
    WriteMakefile(%params);
}

sub regen_README {
    eval {
        require Pod::Readme;

        my $parser = Pod::Readme->new();

        # Read POD from Module.pm and write to README
        $parser->parse_from_file($_[0], 'README');
    };
    eval {
        require Pod::Markdown;

        my $parser = Pod::Markdown->new();

        # Read POD from Module.pm and write to README
        $parser->parse_from_file($_[0]);
        open my $fh, '>', 'README.mkdn'
            or die "Couldn't open 'README.mkdn': $!";
        print $fh $parser->as_markdown;
    };
}

sub regen_EXAMPLES {
    my $perl = $^X;
    (my $target = $module_pm) =~ s!\.pm$!/Examples.pm!;
    
    if( -d 'examples' ) {
        warn "(Re)Creating $target\n";
        if ($perl =~/\s/) {
            $perl = qq{"$perl"};
        };
        my $examples = `$perl -w examples/gen_examples_pod.pl $module`;
        if ($examples) {
            $examples =~ s/\r\n/\n/g;
            if (open my $out, '>', $target) {
                binmode $out;
                print $out $examples;
            };
        };
    };
};
