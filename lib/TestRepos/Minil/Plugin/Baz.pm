package TestRepos::Minil::Plugin::Baz;
use strict;
use warnings;
use base 'Class::Component::Plugin';

sub baz :Method :News {
    my($self, $c, $args) = @_;
    'hello baz method'
}
1;
