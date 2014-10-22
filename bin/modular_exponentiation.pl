use v5.14;
use warnings;


# compute x^y mod n

sub modexp {
  my ($x, $y, $n) = @_;
  
  if ($y == 0) {
    return 1;
  }
  my $z = modexp($x, int($y/2.0), $n);
  if (!($y % 2)) {
    return ($z*$z) % $n;
  } else {
    return ($x*$z*$z) % $n;
  }
}

say modexp(10, 11, 11);
