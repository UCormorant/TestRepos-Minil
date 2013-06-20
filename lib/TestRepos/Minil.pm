package TestRepos::Minil;
use 5.008005;
use strict;
use warnings;

our $VERSION = "0.02";

use Class::Component;
__PACKAGE__->load_components(qw/ Autocall::Autoload /);
__PACKAGE__->load_plugins(qw/ Hello Baz /);


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

