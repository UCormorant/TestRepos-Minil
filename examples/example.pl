use strict;
use warnings;
use lib qw(../lib lib);
use TestRepos::Minil;
my $obj = TestRepos::Minil->new({
    config => {
        Hello => {
            msg => 'world'
        }
    }
});
$obj->hello; # hello world を表示
print $obj->run_hook( 'bar' )->[0]; # bog を表示
print $obj->baz; # news を表示
