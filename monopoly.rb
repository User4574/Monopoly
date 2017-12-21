#!/usr/bin/env ruby

require 'pp'

class Roll
  attr_reader :d1, :d2

  def initialize
    @d1 = rand(6) + 1
    @d2 = rand(6) + 1
  end

  def sum
    return @d1 + @d2
  end

  def double?
    return @d1 == @d2
  end
end

class Deck
  def initialize(cards, strategy)
    @draw = cards.shuffle
    @size = cards.length
    @strategy = strategy
    @discard = [] if strategy == :discard
  end

  def take
    this = @draw.shift

    case @strategy
    when :bottom
      @draw << this
    when :discard
      @discard << this
      if @draw.empty? then
        @draw = @discard.shuffle
        @discard = []
      end
    end

    return this
  end
end

class Chance < Deck
  def initialize(strategy)
    super([0, 24, 11, [12,28], [5,15,25,35], nil, nil, -3, 10, nil, nil, 5, 39, nil, nil, nil], strategy)
  end
end

class CommunityChest < Deck
  def initialize(strategy)
    super([0, nil, nil, nil, nil, 10, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil], strategy)
  end
end

space = 0
doubles = 0
stats = (0..39).map{|i|[i, 0]}.to_h

strat = (ARGV.shift || 'bottom').chomp.intern

chance = Chance.new(strat)
chest  = CommunityChest.new(strat)

(ARGV.shift || "10000000").chomp.to_i.times do
  r = Roll.new

  if r.double? then
    doubles += 1
  else
    doubles = 0
  end

  if doubles == 3 then
    space = 10
  else
    space = (space + r.sum) % 40
  end

  stats[space] += 1

  if space == 30 then
    space = 10
  end

  if [7,22,36].include?(space) then
    c = chance.take
    if c.is_a?(Integer) then
      if c >= 0 then
        space = 0
      else
        space = (space + c) % 40
      end
    elsif c.is_a?(Array) then
      try = c.drop_while{|x|x <= space}[0]
      if try.nil? then
        space = 0
      else
        space = try
      end
    end
  end

  if [2,17,33].include?(space) then
    c = chest.take
    if c.is_a?(Integer) then
      if c >= 0 then
        space = 0
      else
        space = (space + c) % 40
      end
    elsif c.is_a?(Array) then
      try = c.drop_while{|x|x <= space}[0]
      if try.nil? then
        space = 0
      else
        space = try
      end
    end
  end
end

stats.each do |k, v|
  puts "#{k}\t#{v}"
end
