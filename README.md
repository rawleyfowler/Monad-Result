# Monad-Result

[![SparrowCI](https://ci.sparrowhub.io/project/gh-rawleyfowler-Monad-Result/badge?)](https://ci.sparrowhub.io)

An implementation of the result monad from OCaml. This allows the developer to completely avoid exceptions.
Note the result type is not generic, and cannot be statically typed. I think this makes it more flexible overall, 
compared to OCaml's result monad. (Gradual typing ftw)!

## How to use (default)
```raku
use Monad::Result;

sub my-error-causing-function($value --> Monad::Result) {
  return Monad::Result.error('Bad value!') if $value eq 'bad';
  Monad::Result.ok('Value was good!');
}

# Bind operator: >>=:
my-error-causing-function('bad') >>=: -> $value {
  say $value; # Is not called because this is not bindable (it is an error!)
  return Monad::Result.ok($value);
};

my-error-causing-function('abc') >>=: -> $value {
  say $value; # Is said because this is bindable, it is OK!
  return Monad::Result.ok($value);
};

# Map operator: >>=?
# Since this call results in OK, we can map it!
my $result = (my-error-causing-function('abc') >>=? -> $value {
  $value ~ ' HELLO WORLD';
}); # Results Ok('abc HELLO WORLD');

say $result.is-ok; # True
# NOTE UNWRAP IS DANGEROUS (In this case we know it's okay though!)
say $result.unwrap; # 'abc HELLO WORLD';
```

## How to use (subs)

Subs exist as a separate import, because they interfere with a lot of common packages.

```raku
use Monad::Result :subs;

sub my-error-causing-function($value --> Monad::Result) {
  return error('Bad value!') if $value eq 'bad';
  ok('Value was good!');
}

# Bind operator: >>=:
my-error-causing-function('bad') >>=: -> $value {
  say $value; # Is not called because this is not bindable (it is an error!)
  return ok($value);
};

my-error-causing-function('abc') >>=: -> $value {
  say $value; # Is said because this is bindable, it is OK!
  return ok($value);
};

# Map operator: >>=?
# Since this call results in OK, we can map it!
my $result = (my-error-causing-function('abc') >>=? -> $value {
  $value ~ ' HELLO WORLD';
}); # Results Ok('abc HELLO WORLD');

say $result.is-ok; # True
# NOTE UNWRAP IS DANGEROUS!
say $result.unwrap; # 'abc HELLO WORLD';
```

## How to install
```bash
zef install Monad-Result
```

## LICENSE
Monad::Result is provided under the Artistic-2.0 license.
