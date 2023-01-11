use v6;

unit module Monad::Result;

role Base {
    method gist {
        $.type.Str;
    }

    method Str {
        self.raku;
    }
}

role Ok {
    has $.type = 'Ok';
}

role Error {
    has $.type = 'Error';
}

role Result does Base {
    has $.value is required;

    method value {
        self.unwrap;
    }

    method unwrap {
        die "Tried to unwrap Ok of Error ($!value)" if self.is-error;
        $!value;
    }

    method error {
        die "Tried to unwrap Error of Ok ($!value)" if self.is-ok;
        $!value;
    }

    method is-ok {
        self ~~ Ok;
    }

    method is-error {
        self ~~ Error;
    }

    # Chainable bind and map for the Java hacker
    method bind(&f --> Result) {
        return self if self.is-error;
        &f(self);
    }

    method map(&f --> Result) {
        return self if self.is-error;
        Result.new(value => &f($!value)) but Ok;
    }

    method raku {
        "$.type ( $!value )";
    }
}

# Returns
our sub ok($value --> Result) is export { Result.new(:$value) but Ok; }
our sub error($value --> Result) is export { Result.new(:$value) but Error; }

# Bind : Result T -> (f : T -> Result U) -> Result U
sub infix:<\>\>=:>(Result $result, &f --> Result) is export {
    return $result if $result.is-error;
    &f($result.unwrap);
}

# Map : Result T -> (f : T -> U) -> Result U
sub infix:<\>\>=?>(Result $result, &f --> Result) is export {
    return $result if $result.is-error;
    Monad::Result::ok(&f($result.unwrap));
}

# Unsafe functions (these will kill your program)
sub unwrap(Result $result --> Any) is export { $result.unwrap; }
sub unwrap-error(Result $result --> Any) is export { $result.error; }

# vim: expandtab shiftwidth=4
