require "test_helper"
require "mtgsim"

class CombatTest < MiniTest::Unit::TestCase
  def setup
    @game = Game.new [Player.new, Player.new]
    prepare_game
    @player = @game.current_player_index
    @opponent = @game.current_player_index == 0 ? 1 : 0
  end
  
  def prepare_game
    @game.roll_dices
    @game.start_player(@game.die_winner, @game.die_winner)
    @game.draw_hands
    @game.keep(0)
    @game.keep(1)
    @game.start()
  end
  
  def test_simple_attack_and_damage
    creature = Cards::DelverofSecrets.new
    @game.players(@player).board.push(creature)
    
    @game.phase_manager.jump_to :attackers
    
    # Declare Delver as attacker
    @game.attack(@game.current_player_index, [0])
    @game.pass(@game.current_player_index)
    @game.pass(@game.opponent_index)
    
    # No blockers are declared
    @game.pass(@game.opponent_index)
    @game.pass(@game.current_player_index)
    
    # Damage Phase
    assert_equal 19, @game.players(@game.opponent_index).life
  end
end