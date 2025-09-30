require "sinatra"
require "poker_ranking"
require "json"

get "/rank" do
  cards = JSON.parse(params['cards'])
  if cards.length >= 5
    JSON.generate PokerRanking::Hand.new(cards).data
  else
    halt 400, "Bad request: not enough cards"
  end
end

post "/rank" do
  p params['cards']
  cards = JSON.parse(params['cards'])
  p cards
  if cards.length >= 5
    JSON.generate PokerRanking::Hand.new(cards).data
  else
    halt 400, "Bad request: not enough cards"
  end
end
