# Monad-Result
An implementation of the result monad from OCaml. This allows the developer to completely avoid exceptions.

## How to use
```raku
use Monad::Result;

sub my-error-causing-function($value --> Result) {
  return Monad::Result::error('Bad value!') if $value eq 'bad'
  Monad::Result::ok('Value was good!');
}

# Bind operator: >>=:
my-error-causing-function('bad') >>=: -> $value {
  say $value; # Is not called because this is not bindable (it is an error!)
  return Monad::Result::ok($value);
};

my-error-causing-function('abc') >>=: -> $value {
  say $value; # Is said because this is bindable, it is OK!
  return Monad::Result::ok($value);
};

# Map operator: >>=?
# Since this call results in OK, we can map it!
my $result = (my-error-causing-function('abc') >>=? -> $value {
  $value ~ ' HELLO WORLD';
}); # Results in: Monad::Result::ok('abc HELLO WORLD');

say $result.is-ok; # True
# NOTE UNWRAP IS DANGEROUS!
say $result.unwrap; # 'abc HELLO WORLD';
```

## How to install
```bash
zef install Monad::Result
```