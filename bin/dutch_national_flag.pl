use v5.14;
use warnings;
use Test::More;
use Data::Dumper qw/Dumper/;

# required: @$items > 0
# modifies $items aref in place
# space O(1)
# time O(N)
sub flag_order2 {
  my ($items, $idx) = @_;
  my $middle_item = $items->[$idx];
  my $gt_idx = $#$items;
  my $lt_idx = 0;
  my $eq_idx = 0;
  while ($eq_idx <= $gt_idx) {
    if ($items->[$eq_idx] lt $middle_item) {
      ($items->[$eq_idx], $items->[$lt_idx]) = ($items->[$lt_idx], $items->[$eq_idx]);
      $eq_idx++;
      $lt_idx++;
    } elsif ($items->[$eq_idx] eq $middle_item) {
      $eq_idx++;
    } else {
      ($items->[$eq_idx], $items->[$gt_idx]) = ($items->[$gt_idx], $items->[$eq_idx]);
      $gt_idx--;
    }
  }
  return $items;
}

# required: @$items > 0
# space O(N)
# time O(N)
sub flag_order1 {
  my ($items, $idx) = @_;
  my $middle_item = $items->[$idx];
  my @result;
  foreach my $item (@$items) {
    push @result, $item if ($item eq $middle_item);
  }
  foreach my $item (@$items) {
    if ($item lt $middle_item) {
      unshift @result, $item;
    } elsif ($item gt $middle_item) {
      push @result, $item;
    }
  }
  return \@result;
}

# required: @$items > 0
# modifies $items aref in place
# space O(1)
# time O(N)
sub flag_order {
  my ($items, $idx) = @_;
  my $middle_item = $items->[$idx];
  my $middle_item_ct = 0;
  my $lt_middle_ct = 0;
  my $gt_middle_ct = 0;
  foreach my $item (@$items) {
    if ($item eq $middle_item) {
      $middle_item_ct++;
    } elsif ($item gt $middle_item) {
      $gt_middle_ct++;
    } else {
      $lt_middle_ct++;
    }
  }
  my $lt_begin = 0;
  my $lt_end = $lt_begin + $lt_middle_ct - 1;
  my $eq_begin = $lt_end + 1;
  my $eq_end = $eq_begin + $middle_item_ct - 1;
  my $gt_begin = $eq_end + 1;
  my $gt_end = $#$items;

  my $eq_ct = $eq_begin;
  for (my $i = $lt_begin; $i <= $lt_end; $i++) {
    my $item = $items->[$i];
    if ($item eq $middle_item) {
      while ($items->[$eq_ct] eq $middle_item) {
        $eq_ct++;
      }
      ($items->[$i], $items->[$eq_ct]) = ($items->[$eq_ct], $items->[$i]);
      $eq_ct++;
    }
  }
  for (my $i = $gt_begin; $i <= $gt_end; $i++) {
    my $item = $items->[$i];
    if ($item eq $middle_item) {
      while ($items->[$eq_ct] eq $middle_item) {
        $eq_ct++;
      }
      ($items->[$i], $items->[$eq_ct]) = ($items->[$eq_ct], $items->[$i]);
      $eq_ct++;
    }
  }

  my $gt_ct = $gt_begin;
  for (my $i = $lt_begin; $i <= $lt_end; $i++) {
    my $item = $items->[$i];
    if ($item gt $middle_item) {
      while ($items->[$gt_ct] gt $middle_item) {
        $gt_ct++;
      }
      ($items->[$i], $items->[$gt_ct]) = ($items->[$gt_ct], $items->[$i]);
      $gt_ct++;
    }
  }
  return $items;
}

sub test_flag_order {
  my ($strategy, $items, $middle_idx) = @_;
  my $middle_item = $items->[$middle_idx];
  my $result = $strategy->($items, $middle_idx);
  my $sorted_result = [sort @$result];
  my $sorted_items = [sort @$items];
  is_deeply($sorted_result, $sorted_items, 'identical array elements');
  my ($first_middle_idx) = grep { $result->[$_] eq $middle_item } 0 .. $#$result;
  my ($last_middle_idx) = reverse(grep { $result->[$_] eq $middle_item } 0 .. $#$result);
  if ($first_middle_idx > 0) {
    for (0 .. ($first_middle_idx - 1)) {
      ok($result->[$_] lt $middle_item, 'smaller item less than middle item');
    }
  }
  for ($first_middle_idx .. $last_middle_idx) {
    ok($result->[$_] eq $middle_item, 'middle item equal to middle item');
  }
  if ($last_middle_idx < $#$result) {
    for (($last_middle_idx + 1) .. $#$result) {
      ok($result->[$_] gt $middle_item, 'bigger item gt middle item');
    }
  }
}

my @flag_orders = (\&flag_order, \&flag_order1, \&flag_order2);
my $tests = [];
for (0 .. 4) {
  push @$tests, {
    idx => $_,
    items => [ (1 .. 5) ]
  };
}
foreach my $flag_order (@flag_orders) {
  foreach my $test (@$tests) {
    test_flag_order($flag_order, $test->{items}, $test->{idx});
  }
  is_deeply($flag_order->([1], 0), [1], '1 item array');
  is_deeply($flag_order->([2,1], 0), [1,2], '2 item array (middle item largest)');
  is_deeply($flag_order->([2,1], 1), [1,2], '2 item array (middle item smallest)');
  is_deeply($flag_order->([1,1,1,1,1], 0), [1,1,1,1,1], 'only middle item array');
}

done_testing();
