package TestRepos::Minil::Attribute::Event;
use strict;
use warnings;
use base 'Class::Component::Attribute';

sub register {
    my($class, $plugin, $c, $method, $value, $code) = @_;

    warn $value;
    $c->reg_cb($value => $code);
}
1;
