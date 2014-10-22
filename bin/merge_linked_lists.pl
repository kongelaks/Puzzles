use v5.14;
use warnings;
use Data::Dumper qw/Dumper/;
use Test::More;

package Node {
  use v5.14;
  use Moo;
  use warnings;

  has data => (is => 'rw');
  has next => (is => 'rw');
};

# linked list => array ref
sub ll_to_aref {
  my $list = shift;
  my $aref = [];
  while (defined $list->next) {
    push @$aref, $list->data;
    $list = $list->next;
  }
  push @$aref, $list->data;
  return $aref;
}

# array ref => linked list
sub ll_from_aref {
  my $aref = shift;
  return undef if @$aref == 0;
  return Node->new(
    data => $aref->[0],
    next => ll_from_aref([splice(@$aref,1)])
   );
}

# Merge two sorted linked lists
# time O(N + M)
# space (N + M)
sub merge_lists {
  my ($list_a, $list_b) = @_;
  return $list_b if !$list_a;
  return $list_a if !$list_b;
  if ($list_a->data <= $list_b->data) {
    $list_a->next(merge_lists($list_a->next, $list_b));
    return $list_a;
  } else {
    $list_b->next(merge_lists($list_a, $list_b->next));
    return $list_b;
  }
}

my $cases = [
  {
    list1 => [2, 5, 7],
    list2 => [3, 11],
    expected => [2,3,5,7,11],
    message => 'standard case',
   },
  {
    list1 => [11],
    list2 => [1,2,3,7],
    expected => [1,2,3,7,11],
    message => 'l1 contains 1 node',
   },
  {
    list1 => [1,2,3,7],
    list2 => [11],
    expected => [1,2,3,7,11],
    message => 'l2 contains 1 node',
   },
  {
    list1 => [1,2,3,7],
    list2 => [],
    expected => [1,2,3,7],
    message => 'l2 is null',
   },
  {
    list1 => [],
    list2 => [1,2,3,7],
    expected => [1,2,3,7],
    message => 'l1 is null',
   },
  {
    list1 => [1,1],
    list2 => [1,2],
    expected => [1,1,1,2],
    message => 'l1 contains only 1 node val',
   },
  {
    list1 => [1,2,3,4],
    list2 => [5,6,7,8],
    expected => [1,2,3,4,5,6,7,8],
    message => 'all nodes in l2 > l1',
   },
  {
    list1 => [5,6,7,8],
    list2 => [1,2,3,4],
    expected => [1,2,3,4,5,6,7,8],
    message => 'all nodes in l1 > l2',
   },
 ];

foreach my $case (@$cases) {
  my $list_a = ll_from_aref($case->{list1});
  my $list_b = ll_from_aref($case->{list2});
  my $merged = merge_lists($list_a, $list_b);
  is_deeply(ll_to_aref($merged), $case->{expected}, $case->{message});
}

done_testing();

