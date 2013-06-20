package TestRepos::Minil::Plugin::Hello;
use strict;
use warnings;
use base 'Class::Component::Plugin';

sub hello :Method {
    my($self, $c, $args) = @_;
    print 'hello ' . $self->config->{msg};
}

sub hello_hello :Hook('bar') {
    my($self, $c, $args) = @_;
    'bog'
}
1;
