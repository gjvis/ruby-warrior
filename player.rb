class Player
  attr_accessor :direction
  attr_reader :full_health

  def play_turn(warrior)
    @w = warrior
    @full_health ||= @w.health

    return rest_until_strong! if need_rest?

    turn_around if feel.wall?

    case
    when feel.captive? then rescue!
    when feel.enemy? then attack!
    else walk!
    end
  ensure
    @previous_health = @w.health
    @space = nil
    @w = nil
  end

  def rest_until_strong!
    return walk_backwards! if took_damage?
    @w.rest!
    @resting = hurt?
  end

  def need_rest?
    !attack_time? && !feel.enemy? && (@resting || @w.health < full_health)
  end

  def took_damage?
    @previous_health ||= full_health

    @w.health < @previous_health
  end

  def hurt?
    @w.health < full_health
  end

  def attack_time?
    took_damage? && @previous_health == full_health
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

