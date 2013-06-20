requires 'perl', '5.008001';

requires 'Class::Component';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

on 'configure' => sub {
    requires 'Module::Build';
};
