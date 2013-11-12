# Fishhouse: A market simulation in Perl

The kind of market simulated here consists of buyers and sellers of a single
homogenous commodity. Buyers have demand functions, sellers have supply
functions. The 'market' runs for a given number of seconds where it takes
turns asking randomly picked agents what they want to do.

Each agent can take a pass, or submit an order. Buyers can submit bid and
buy orders. Sellers can submit ask and sell orders.

## Order types

<dl>

<dt>Bid:</dt>

<dd>A buyer specifies the price she would be willing to pay for a unit of
the good.</dd>

<dt>Buy:</dt>

<dd>Buyer commits to buying a unit at the current best price offered by
sellers.</dd>

<dt>Ask:</dt>

<dd>A seller specifies the price at which she would be willing to sell a
unit of the good.</dd>

<dt>Sell:</dt>

<dd>Seller commits to buying a unit at the current best price offered by
sellers.</dd>

</dl>

Currently, buy and sell orders are handled in a funny way. If a buyer has an
outstanding bid, and sends a buy order, the outstanding bid remains in the
queue. Ditto for sellers. This might be odd, depending on your perspective.

Negative bids are definite possibility if the market goes on long enough.

Work up to this point was intended to get me a clear idea of how to put
together a market simulation with the least amount of code. The next step is
to write some tests so I can make actual progress.

## Order queues

The market object maintains two queues: One for asks, and one for bids.
Orders are partially ordered by price, and within each equivalence class,
they are ordered by order of arrival.

Bids are ordered from highest to lowest price. Asks are ordered from lowest
to highest price.

A transaction occurs when a buy or sell order is received by the market
object. For a buy order, the buyer buys one unit at the current lowest ask
price. For a sell order, the seller sells one unit at the current highest
bid price.

## Market price

The market price is the price paid in the last transaction by the close of
the market.

