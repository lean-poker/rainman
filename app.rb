require "sinatra"
require "poker_ranking"
require "json"

get "/rank" do
  cards = JSON.parse(request[:cards])
  if cards.length >= 5
    JSON.generate PokerRanking::Hand.new(cards).data
  else
    halt 400, "Bad request: not enough cards"
  end
end

post "/rank" do
  p request[:cards]
  cards = JSON.parse(request[:cards])
  p cards
  if cards.length >= 5
    JSON.generate PokerRanking::Hand.new(cards).data
  else
    halt 400, "Bad request: not enough cards"
  end
end
