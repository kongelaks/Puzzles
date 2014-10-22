use v5.14;
use warnings;
use Test::More;
use integer;
use Data::Dumper qw/Dumper/;

my $BITS_PER_BLOCK = 8;

# positive ints
# parity in a sequence of bits is true if the # of 1's in the seq. is odd
# parity is false if the # of 1's is even
sub parity0 {
  my $num = shift;
  my $result = 0;
  while ($num != 0) {
    if ($num & 1) {
      $result = !$result;
    }
    $num = $num >> 1;
  }
  return ($result) ? 1 : 0;
}

sub bulk_parity {
  my ($num, $parity_lookup, $bits_per_block) = @_;
  my $mask = 2**($bits_per_block) - 1;
  my $total = 0;
  my $bits_in_int = 64;
  my $shift_multiplier = 0;
  for (; $shift_multiplier < $bits_in_int/($bits_per_block + 0.0); $shift_multiplier++) {
    my $shift_amnt = ($shift_multiplier * $bits_per_block);
    my $num_segment = ($num >> ($shift_amnt)) & $mask;
    $total += $parity_lookup->{$num_segment};
  }
  return ($total % 2) ? 1 : 0;
}

# bits per block < size of int in bits
# size of int in bits % block size == 0
sub build_parity_lookup {
  my $bits_per_block = shift;
  my $parity_lookup = {};
  my $min = 0;
  my $max = (1 << ($bits_per_block)) - 1;
  for my $num ($min .. $max) {
    $parity_lookup->{$num} = parity0($num);
  }
  return $parity_lookup;
}

my $parity_lookup = build_parity_lookup($BITS_PER_BLOCK);

ok(parity0(1), 'parity0 true');
ok(parity0(4), 'parity0 true');
ok(parity0(256), 'parity0 true');
ok(parity0(1024), 'parity0 true');
ok(!parity0(3), 'parity0 false');
ok(!parity0(5), 'parity0 false');
ok(!parity0(257), 'parity0 false');
ok(!parity0(1025), 'parity0 false');

for (my $i = 0; $i <= 2**8-1; $i++) {
  is(parity0($i), $parity_lookup->{$i}, "parity of $i");
}
my @test_nums = (1, 2, 3, 4, 7, 8, 9, 63, 64, 65, 127, 128, 129, 254, 255, 256, 511, 512, 513, 1023, 1024, 1025, (2**20 - 1), 2**20, (2**20+1));
for (@test_nums) {
  is(parity0($_), bulk_parity($_, $parity_lookup, $BITS_PER_BLOCK), "parity of $_");
}

done_testing();
