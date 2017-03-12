package Dancer::Layout::Bootstrap;
use Dancer ':syntax';
use Dancer::Plugin::FlashMessage;

=head1 NAME

Dancer::Layout::Bootstrap - Boostrap layout for Dancer

=head1 SYNOPSIS

  # 1. Copy the included template files to your dancer application
  # 2. Change the "layout" parameter in config.yml to "bootstrap3"
  # 3. Dance On!

  # Preview the layout
  plackup -a bin\app.pl

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

=head1 TEMPLATE FILES IN THIS DISTRIBUTION

The meat of this package are the template and Bootstrap and jQuery files.
These don't get installed but live in the distribution. You will need to
copy the following files and directories into your application
directory, at least until L<Dancer> resp. the C<dancer> application comes
with a way to specify default layouts when generating a new application
scaffold.

You will likely want to use either Bootstrap 2 or Bootstrap 3. See the
appropriate list of files to copy.

=head2 LIST OF FILES TO COPY

=head3 Bootstrap 3

    public/css/bootstrap-3/bootstrap.css Bootstrap 3
    public/css/bootstrap-3/bootstrap.min.css Bootstrap 3
    public/css/fonts/glyphicons-halflings-regular.eot Bootstrap 3
    public/css/fonts/glyphicons-halflings-regular.svg Bootstrap 3
    public/css/fonts/glyphicons-halflings-regular.ttf Bootstrap 3
    public/css/fonts/glyphicons-halflings-regular.woff Bootstrap 3
    public/css/fonts/glyphicons-halflings-regular.woff2 Bootstrap 3
    public/javascripts/bootstrap-3/bootstrap.js Bootstrap 3
    public/javascripts/bootstrap-3/bootstrap.min.js Bootstrap 3
    public/javascripts/jQuery/jquery-1.11.3.min.js jQuery 1.11.3 (for Bootstrap 3)

=head3 Bootstrap 2

    public/css/bootstrap-responsive.css   Bootstrap 2.3.0
    public/css/bootstrap.css      Bootstrap 2.3.0
    public/css/bootstrap.min.css  Bootstrap 2.3.0
    public/images/glyphicons-halflings-white.png  Glyphicons
    public/images/glyphicons-halflings.png        Bootstrap 2.0.3
    public/javascripts/bootstrap-2.3.0/bootstrap-alert.js Bootstrap 2.3.0
    public/javascripts/bootstrap-2.3.0/bootstrap.js       Bootstrap 2.3.0
    public/javascripts/bootstrap-2.3.0/bootstrap.min.js   Bootstrap 2.3.0
    public/javascripts/jQuery/jquery-1.7.2.min.js jQuery 1.7.2
    public/javascripts/jQuery/jquery.ui.widget.js jQuery 1.7.2
    views/index.tt        Index page with Bootstrap layout
    views/layouts/bootstrap.tt    The Bootstrap layout

=head1 NEEDED MODULES

The simple templating included with Dancer does not properly
support user log-in / log out, so the template needs
L<Template::Toolkit>.

=head1 SEE ALSO

L<http://twitter.github.com/bootstrap/> - Bootstrap

L<http://bootswatch.com/> - Themes for Bootstrap

L<http://glyphicons.com/> - Icons from Glyphicons Free, licensed under CC BY 3.0.

L<http://jquery.com/> - jQuery 1.7.2

L<http://www.lavishbootstrap.com/> - create new colour schemes

=cut

our $VERSION = '0.03';

get '/' => sub {
    template 'index';
};

get '/user/login' => sub {
    template 'login';
};

post '/user/login' => sub {
    session user => { name => params->{'name'} };

    flash success => sprintf "Welcome back, %s",
        session->{user}->{name};
    
    return redirect '/';
};

get '/user/logout' => sub {
    my $user= session('user')->{name};
    session user => undef;

    flash success => sprintf "Goodbye, %s",
        $user;
    
    redirect '/';
};

true;

=head1 REPOSITORY

The public repository of this module is
L<https://github.com/Corion/dancer-layout-bootstrap>.

=head1 SUPPORT

The public support forum of this module is
L<https://perlmonks.org/>.

=head1 BUG TRACKER

Please report bugs in this module via the RT CPAN bug queue at
L<https://rt.cpan.org/Public/Dist/Display.html?Name=Dancer-SearchApp>
or via mail to L<dancer-layout-bootstrap-Bugs@rt.cpan.org>.

=head1 AUTHOR

Max Maischein C<corion@cpan.org>

=head1 COPYRIGHT (c)

Copyright 2014-2016 by Max Maischein C<corion@cpan.org>.

=head1 LICENSE

This module is released under the same terms as Perl itself.

=cut