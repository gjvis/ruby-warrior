class Player
  attr_accessor :direction

  def play_turn(warrior)
    @w = warrior

    return rest_until_strong! if need_rest?

    turn_around if feel.wall?

    case
    when feel.captive? then rescue!
    when feel.enemy? then attack!
    else walk!
    end
  ensure
    @space = nil
    @w = nil
  end

  def rest_until_strong!
    return walk_backwards! if took_damage?
    @w.rest!
    @resting = @w.health < 20
  end

  def need_rest?
    !took_damage? && !feel.enemy? && (@resting || @w.health < 20)
  end

  def took_damage?
    @health ||= @w.health

    @w.health < @health
  ensure
    @health = @w.health
  end

  def direction
    @direction ||= :backward
  end

  def turn_around
    @direction = backwards_direction
    @space = nil
  end

  def backwards_direction
    (direction == :forward) ? :backward : :forward
  end

  def feel
    @space ||= @w.feel(direction)
  end

  def rescue!
    @w.rescue!(direction)
  end

  def attack!
     @w.attack!(direction)
  end

  def walk!
    @w.walk!(direction)
  end

  def walk_backwards!
    @w.walk!(backwards_direction)
  end
end

