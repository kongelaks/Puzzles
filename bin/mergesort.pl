use v5.14;
use warnings;
use List::Util qw/shuffle/;
use Data::Dumper qw/Dumper/;
use Carp qw/confess longmess/;

$| = 1;

for my $test_num (2 .. 1000) {
  my @numbers = shuffle map { $_ } (1 .. $test_num);
  my $sorted = mergesort(\@numbers);
  for my $idx (1 .. $test_num) {
    if ($sorted->[$idx - 1] ne $idx) {
      say "FAIL";
      say Dumper(\@numbers);
      last;
    }
  }
}

sub mergesort {
  my $nums = shift;
  if (@$nums > 1) {
    my $end_of_first = int($#$nums/2.0);
    my $start_of_scnd = $end_of_first + 1;
    my @first_split = @$nums[0 .. $end_of_first];
    my @second_split = @$nums[$start_of_scnd .. $#$nums];
    return [ merge(mergesort([@first_split]), mergesort([@second_split])) ]; 
  } else {
    return $nums;
  }
}
sub merge {
  my ($a1, $a2) = @_;
  my @result;
  if (@$a1 == 0) {
    push @result, @$a2;
    return @result;
  }
  if (@$a2 == 0) {
    push @result, @$a1;
    return @result;
  }
  if ($a1->[0] <= $a2->[0]) {
    my $lowest = shift @$a1;
    return ($lowest, merge([@$a1], $a2));
  } else {
    my $lowest = shift @$a2;
    return ($lowest, merge($a1, [@$a2]));
  }
}

#sub mergesort {
#  my @numbers =  @_;
#  if (@numbers > 1) {
#    my $end_idx = int(@numbers/2.0) - 1;
#    my $start_idx = $end_idx;
#    say Dumper(\@numbers);
#    say "END OF 1st SEGMENT $end_idx, START OF 2nd $start_idx";
#    return merge(mergesort(@numbers[0 .. $end_idx]), mergesort(@numbers[$start_idx .. $#numbers]));
#  } else {
#    return \@numbers;
#  }
#}
#
#sub merge {
#  my ($nums1, $nums2) = @_;
#  my @result;
#  if (@$nums1 == 0) {
#    @result = @$nums2;
#    return \@result; 
#  }
#  if (@$nums2 == 0) {
#    @result = @$nums1;
#    return \@result; 
#  }
#
#  if ($nums1->[0] <= $nums2->[0]) {
#    push @result, $nums1->[0], @{merge(\@$nums1[1 .. $#$nums1], $nums2)};
#    return \@result;
#  } else {
#    push @result, $nums2->[0], @{merge($nums1, @$nums2[ 1 .. $#$nums2])};
#    return \@result;
#  }
#}
