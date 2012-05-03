package Dancer::Layout::Bootstrap;
use Dancer ':syntax';
use Dancer::Plugin::FlashMessage;

=head1 NAME

Dancer::Layout::Bootstrap - Boostrap layout for Dancer

=head1 SYNOPSIS

  # 1. Copy the included template files to your dancer application
  # 2. Change the "layout" parameter in config.yml to "bootstrap"
  # 3. Dance On!

  # Preview the layout
  perl -Ilib -w bin\app.pl

=head1 ABSTRACT

Template and dummy application that applies the
Bootstrap CSS to Dancer.

=head1 SUPPORTED FEATURES

If you want to show alerts etc., the main
template already provides support for that
via L<Dancer::Plugin::FlashMessage>.

    flash success => sprintf "Welcome back, %s",
        session('user')->{name};

... will produce a nice, green "Welcome back"
message for the user.

All flash message output is HTML escaped for security reasons.

=head1 NEEDED MODULES

The simple templating included with Dancer does not properly
support user log-in / log out, so the template needs
L<Template::Toolkit>.

=head1 SEE ALSO

L<http://twitter.github.com/bootstrap/> - Bootstrap

L<http://bootswatch.com/> - Themes for Bootstrap

L<http://glyphicons.com/> - Icons from Glyphicons Free, licensed under CC BY 3.0.

L<http://jquery.com/> - jQuery 1.7.2

=cut

our $VERSION = '0.1';

get '/' => sub {
    template 'index';
};

get '/user/login' => sub {
    session user => { name => 'Bob' };

    flash success => sprintf "Welcome back, %s",
        session('user')->{name};
    
    redirect '/';
};

get '/user/logout' => sub {
    my $user= session('user')->{name};
    session user => undef;

    flash success => sprintf "Goodbye, %s",
        $user;
    
    redirect '/';
};

true;
