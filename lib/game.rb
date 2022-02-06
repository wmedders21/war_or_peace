require './lib/card'
require './lib/deck'
require './lib/player'
require './lib/turn'
require './lib/game'
require './lib/standard_deck'

class Game
attr_reader :card_split_1, :card_split_2, :hand1, :hand2, :player1, :player2
  def initialize
    fresh_cards = StandardDeck.new
    shuffled_cards = []
    52.times do
      shuffled_cards << fresh_cards.standard_deck.sample
    end
    @card_split_1 = shuffled_cards[0..25]
    @card_split_2 = shuffled_cards[26..51]
    @hand1 = Deck.new(card_split_1)
    @hand2 = Deck.new(card_split_2)
    @player1 = Player.new('Megan', hand1)
    @player2 = Player.new('Aurora', hand2)
  end

  def start

    play_count = 0

    turn = Turn.new(@player1, @player2)

#     1000000.times do
#       play_count += 1
#       turn.spoils_of_war.clear
#       turn.pile_cards
#       turn.award_spoils(winner)
# puts "turn:#{play_count} winner:#{winner.name} "
#     end
#     # require 'pry'; binding.pry

    until @player1.has_lost? == true || @player2.has_lost? == true || play_count == 1000000
      play_count +=1
      turn.spoils_of_war.clear
      if turn.type == :war
        turn.pile_cards
        card_czar = turn.winner
        turn.award_spoils(card_czar)
        if card_czar.class == String
          puts "Turn #{play_count}: *mutually assured destruction* 6 cards removed from play"
          turn.pile_cards
        else
          puts "Turn #{play_count}: WAR - #{card_czar.name} won 6 cards - M has #{player1.deck.cards.count}, A has #{player2.deck.cards.count}"
        end
      elsif turn.type == :basic
        turn.pile_cards
        card_czar = turn.winner
        turn.award_spoils(card_czar)
        if card_czar.class == String
          puts "Turn #{play_count}: *mutually assured destruction* 6 cards removed from play"
          turn.pile_cards
        else
          puts "Turn #{play_count}: #{card_czar.name} won 2 cards - M has #{player1.deck.cards.count}, A has #{player2.deck.cards.count}"
        end
      elsif turn.type == :mutally_assured_destruction
        turn.pile_cards
        puts "Turn #{play_count}: *mutually assured destruction* 6 cards removed from play"
      end
      if @player1.has_lost? == true
        puts "*~*~*~* #{@player2.name} has won the game! *~*~*~*"
      elsif @player2.has_lost? == true
        puts "*~*~*~* #{@player1.name} has won the game! *~*~*~*"
      elsif play_count >= 1000000
        puts "---- DRAW ----"
      end
    end
  end
end
