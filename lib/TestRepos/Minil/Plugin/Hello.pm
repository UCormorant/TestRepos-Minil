package TestRepos::Minil::Plugin::Hello;
use 5.014;
use strict;
use warnings;
use base 'Class::Component::Plugin';

sub hello :Event('Hello') {
    my($self, $handle) = @_;
    say 'send: hello';
    $handle->push_write("hello\015\012");
}

sub bye :Event('Bye') {
    my($self, $handle) = @_;
    say 'send: bye';
    $handle->push_write("bye\015\012");
    $handle->push_shutdown;
}

1;
