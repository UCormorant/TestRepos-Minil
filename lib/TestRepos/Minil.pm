package TestRepos::Minil;
use 5.014;
use strict;
use warnings;

our $VERSION = "0.04";

use parent qw(Class::Component Object::Event);

use AnyEvent::Socket qw(tcp_server);
use AnyEvent::Handle ();

use Carp qw(carp croak);
use Encode qw(find_encoding);
use Sys::Hostname qw(hostname);
use Scalar::Util qw(refaddr);
use IO::Socket::INET ();
use UNIVERSAL::which ();
use YAML::XS ();
use JSON::XS ();

use Class::Accessor::Lite (
    ro => [ qw(
        host
        port
        servername
        debug

        handles
    )],
);

our $MAXBYTE  = 512;
our $NUL      = "\0";
our $BELL     = "\07";
our $CRLF     = "\015\012";
our $SPECIAL  = '\[\]\\\`\_\^\{\|\}';
our $SPCRLFCL = " $CRLF:";
our %REGEX = (
    crlf     => qr{\015*\012},
    chomp    => qr{[$CRLF$NUL]+$},
    channel  => qr{^(?:[#+&]|![A-Z0-9]{5})[^$SPCRLFCL,$BELL]+(?:\:[^$SPCRLFCL,$BELL]+)?$},
    nickname => qr{^[\w][-\w$SPECIAL]*$}, # 文字数制限,先頭の数字禁止は扱いづらいのでしません
);

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{$_[0]} : @_;
    my $load_plugins = delete $args{load_plugins};
    my $self = $class->SUPER::new(\%args);

    $self->init_object_events();
    $self->load_plugins(@$load_plugins);

    # TODO: オプションの値チェック

    $self->{debug}        //= 0;
    $self->{host}         //= '127.0.0.1';
    $self->{port}         //= 6667;
    $self->{charset}      //= 'utf8';
    $self->{err_charset}  //= $^O eq 'MSWin32' ? 'cp932' : 'utf8';

    $self->{codec}     = find_encoding($self->charset);
    $self->{err_codec} = find_encoding($self->err_charset);

    $self->{handles} = {};

    $self;
}

sub run {
    my $self = shift;

    say "Starting server on @{[ $self->host.':'.$self->port ]}";

    tcp_server $self->host, $self->port, sub {
        my ($fh, $host, $port) = @_;
        my $handle = AnyEvent::Handle->new(
            fh => $fh,

            on_error => sub {
                my ($handle, $fatal, $message) = @_;
                $self->event('on_error', $handle, $fatal, $message);
                delete $self->handles->{refaddr($handle)} if $fatal;
            },
            on_eof => sub {
                my $handle = shift;
                $self->event('on_eof', $handle);
                delete $self->handles->{refaddr($handle)};
            },
        );
        $handle->on_read(sub {
            $_[0]->push_read(line => $REGEX{crlf}, sub {
                my ($handle, $line, $eol) = @_;
                $line =~ s/$REGEX{chomp}//g;
                say "recv: $line";
                $self->event($line, $handle);
            });
        });
        $self->handles->{refaddr($handle)} = $handle;
    }, sub {
        my ($fh, $host, $port) = @_;

        say "Bound to $host:$port";

        $self->reg_cb(
            on_eof => sub {
                my ($self, $handle) = @_;
            },
            on_error => sub {
                my ($self, $handle, $fatal, $message) = @_;
                carp "[$fatal] $message";
            },
        );
    };
}

# accessor

## read write
sub charset {
    return $_[0]->{charset} if not defined $_[1];
    $_[0]->{charset} = $_[1];
    $_[0]->{codec}   = find_encoding($_[1]);
}

sub err_charset {
    return $_[0]->{err_charset} if not defined $_[1];
    $_[0]->{err_charset} = $_[1];
    $_[0]->{err_codec}   = find_encoding($_[1]);
}

## read only
sub codec {
    $_[0]->{codec};
}

sub err_codec {
    $_[0]->{err_codec};
}


if ($0 eq __FILE__) {
    _main(@ARGV);
}

sub _main {
    use lib qw(../);
    my $inst = __PACKAGE__->new(load_plugins => [qw/Hello/], @ARGV);
    my $cv = AE::cv;
    $inst->run;
    $cv->recv;
}

1;
__END__

=encoding utf-8

=head1 NAME

TestRepos::Minil - It's new $module

=head1 SYNOPSIS

    use TestRepos::Minil;

=head1 DESCRIPTION

TestRepos::Minil is ...

=head1 LICENSE

Copyright (C) U=Cormorant.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

U=Cormorant E<lt>u@chimata.orgE<gt>

=cut

