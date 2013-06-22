requires 'perl', '5.014';

requires 'Class::Component';
requires 'Object::Event';

on 'test' => sub {
    requires 'Test::More', '0.98';
};

on 'configure' => sub {
    requires 'Module::Build';
};
