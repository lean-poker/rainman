# Rain Man

Ranking service for Lean Poker running on `http://rainman.leanpoker.org/rank` during each sit'n'go. This service returns a JSON data structure representing a hand, once it is provided a list of cards.

## How to call the ranking service

The ranking service expects a GET request with a variable named `cards` that contains a JSON encoded array of cards, in the following format: 

```
{
    "rank":"5",         // String representation of the 
                        //     cards rank. Valid values are: 
                        //     2 through 10, and J,Q,K,A. 

    "suit":"diamonds"   // The suit of the card. Valid values
                        //     are: clubs, spades, hearts and diamonds
}
```

As an example this is how one can call the ranking service from command line:

```
curl -XGET -d 'cards=[
    {"rank":"5","suit":"diamonds"},
    {"rank":"6","suit":"diamonds"},
    {"rank":"7","suit":"diamonds"},
    {"rank":"7","suit":"spades"},
    {"rank":"8","suit":"diamonds"},
    {"rank":"9","suit":"diamonds"}
]' http://rainman.leanpoker.org/rank
```
## Hand 

Bellow is an example response for the `curl` call above. The `rank` specifies the type of hand
that was recognized. The meaning of the `value`, `second_value` and `kickers` variables depends
on the type of hand, and will be discussed after the example. 

The `cards_used` array is a list of cards that make up the best hand. This variable is useful 
when more than 5 cards are passed to the service. In the `cards` array the original input is returned. 

```
{
    "rank": 8,
    "value": 9,
    "second_value": 9,
    "kickers": [9, 8, 6, 5],
    "cards_used": [
        {
            "rank": "5",
            "suit": "diamonds"
        },
        {
            "rank": "6",
            "suit": "diamonds"
        },
        {
            "rank": "7",
            "suit": "diamonds"
        },
        {
            "rank": "8",
            "suit": "diamonds"
        },
        {
            "rank": "9",
            "suit": "diamonds"
        }
    ],
    "cards": [
        {
            "rank": "5",
            "suit": "diamonds"
        },
        {
            "rank": "6",
            "suit": "diamonds"
        },
        {
            "rank": "7",
            "suit": "diamonds"
        },
        {
            "rank": "7",
            "suit": "spades"
        },
        {
            "rank": "8",
            "suit": "diamonds"
        },
        {
            "rank": "9",
            "suit": "diamonds"
        }
    ]
}
```

For detailed definitions of poker hands, and their properties (such as probability of appearing during the game)
check the [List of poker hands](http://en.wikipedia.org/wiki/List_of_poker_hands) page on Wikipedia. 

The value of a card is its rank in case of numeric ranks. For Jack the value is 11, for Queen it's 12 and for 
King it is 13. The value of Ace depends on its position: it has a value of 1 when it's at the end of a straight 
formed by number cards 2 to 5 and the Ace. In all other cases the value of the Ace is 14. 
 
| rank id |    hand name    |     example     |                    first_value                   |                second_value               |                            kickers                            |
|:-------:|:---------------:|:---------------:|:------------------------------------------------:|:-----------------------------------------:|:-------------------------------------------------------------:|
|    0    |    High card    |  K♥ J♥ 8♣ 7♦ 4♠ |             Value of the highest card            |               Same as value               |       Values of all five cards used in descending order       |
|    1    |       Pair      | 4♥ 4♠ K♠ 10♦ 5♠ |        Value of the cards forming the pair       |               Same as value               | Values of the three cards not in the pair in descending order |
|    2    |    Two pairs    |  J♥ J♣ 4♣ 4♠ 9♥ |    Value of the cards forming the higher pair    | Value of the cards forming the lower pair |                Value of the single kicker card                |
|    3    | Three of a kind |  2♦ 2♠ 2♣ K♠ 6♥ | The value of the three cards with the same value |               Same as value               |       Values of the two extra cards in descending order       |
|    4    |     Straight    | Q♣ J♠ 10♠ 9♥ 8♥ |             Value of the highest card            |               Same as value               |       Values of all five cards used in descending order       |
|    5    |      Flush      | Q♣ 10♣ 7♣ 6♣ 4♣ |             Value of the highest card            |               Same as value               |       Values of all five cards used in descending order       |
|    6    |    Full house   |  3♣ 3♠ 3♦ 6♣ 6♥ |        Value of the three identical cards        |      Value of the two identical cards     |                          Empty array                          |
|    7    |  Four of a kind |  9♣ 9♠ 9♦ 9♥ J♥ |         Value of the four identical cards        |               Same as value               |                Value of the single kicker card                |
|    8    |  Straight flush | Q♣ J♣ 10♣ 9♣ 8♣ |             Value of the highest card            |               Same as value               |       Values of all five cards used in descending order       |
