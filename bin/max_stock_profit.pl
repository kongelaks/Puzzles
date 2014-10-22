use v5.14;
use warnings;

# given a 40 day range of min/max/open prices of a stock
# find the day to purchase and the day to sell (must buy/sell at open price)

package DayPrice {
use Moo;

has min => (is => 'ro', required => 1);
has max => (is => 'ro', required => 1);
has open => (is => 'ro', required => 1);
}

my $prices = [
  DayPrice->new(min => 3, max => 3, open => 3),
  DayPrice->new(min => 4, max => 4, open => 4),
  DayPrice->new(min => 2, max => 2, open => 2),
  DayPrice->new(min => 6, max => 6, open => 6),
  DayPrice->new(min => 3, max => 3, open => 3),
];


# the simplest solution is to loop over all open prices (x1)
# and then loop over all prices following (x1), computing the profit/loss
# keep the highest values
{
  my ($result_low_idx, $result_high_idx);
  my $result_profit = 0;
  for (my $low_idx = 0; $low_idx < (@$prices - 1); $low_idx++) {
    for (my $high_idx = $low_idx + 1; $high_idx < @$prices; $high_idx++) {
      my $start_price = $prices->[$low_idx]->open;
      my $end_price = $prices->[$high_idx]->open;
      my $profit = $end_price - $start_price;
      if ($profit > $result_profit) {
        $result_low_idx = $low_idx;
        $result_high_idx = $high_idx;
        $result_profit = $profit;
      }
    }
  }
  if ($result_profit == 0) {
    say "no profit could be made";
  } else {
    my $buy_price = $prices->[$result_low_idx]->open;
    my $sell_price = $prices->[$result_high_idx]->open;
    my $buy_day = $result_low_idx + 1;
    my $sell_day = $result_high_idx + 1;
    say "Maximum profit (\$$result_profit) would be achieved by buying on day $buy_day (\$$buy_price) and selling on day $sell_day (\$$sell_price)";
  }
}
