use v5.14;
use warnings;
use Data::Dumper qw/Dumper/;
use Test::More;

package Stack {
  use v5.14;
  use Moo;
  use warnings;

  has data => (is => 'rw', default => sub {[]});
  has max_data => (is => 'rw', default => sub {[]});

  sub push {
    my ($self, $elt) = @_;
    my $data = $self->data;
    my $max_data = $self->max_data;

    if (@$data == 0) {
      push @$max_data, $elt;
      push @$data, $elt;
    } elsif ($elt >= $data->[-1]) {
      push @$max_data, $elt;
      push @$data, $elt;
    } else {
      push @$data, $elt;
    }
  }

  sub pop {
    my $self = shift;
    my $popped = pop @{$self->data};

    if ($popped == $self->max_data->[-1]) {
      pop @{$self->max_data};
    }
    return $popped;
  }

  # returns max value in stack
  # must be O(1) time
  # can use O(N) storage
  sub max {
    my $self = shift;
    return $self->max_data->[-1];
  }
};

my $stack = Stack->new;
$stack->push(1);
is($stack->max, 1, 'proper max, 1 elt');
$stack->push(4);
is($stack->max, 4, 'proper max, 2 elt');
$stack->push(3);
is($stack->max, 4, 'proper max after pushing elt < max');
$stack->push(10);
is($stack->max, 10, 'proper max after non-max check');
is($stack->pop, 10, 'proper pop');
is($stack->max, 4, 'proper max after pop');
is($stack->pop, 3, 'proper 2nd pop');
is($stack->max, 4, 'proper max after 2 pops');
is($stack->pop, 4, 'proper 3rd pop');
is($stack->max, 1, 'proper max after n-1 pops');
is($stack->pop, 1, 'proper nth pop');

done_testing();
