use v6.d;

unit class Monad::Result;

role Ok {
    has $.type = 'Ok';
}

role Error {
    has $.type = 'Error';
}

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
method bind(&f --> Monad::Result) {
	return self if self.is-error;
	&f(self);
}

method map(&f --> Monad::Result) {
	return self if self.is-error;
	Monad::Result.new(value => &f($!value)) but Ok;
}

method throw { die $!value if self.is-error }

method raku {
	"$.type ( $!value )";
}

# Bind : Result T -> (f : T -> Result U) -> Result U
sub infix:<\>\>=:>(Monad::Result:D $result, &f --> Monad::Result) is export {
	return $result if $result.is-error;
	&f($result.unwrap);
}

# Map : Result T -> (f : T -> U) -> Result U
sub infix:<\>\>=?>(Monad::Result:D $result, &f --> Monad::Result) is export {
	return $result if $result.is-error;
	Monad::Result::ok(&f($result.unwrap));
}

our sub ok($value --> Monad::Result) is export { Monad::Result.new(:$value) but Ok }
our sub error($value --> Monad::Result) is export { Monad::Result.new(:$value) but Error }
our sub unwrap(Monad::Result $result --> Any) is export { $result.unwrap }
our sub unwrap-error(Monad::Result $result --> Any) is export { $result }

# vim: expandtab shiftwidth=4
