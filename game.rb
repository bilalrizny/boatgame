
# encoding: utf-8
require "gosu"


WIDTH, HEIGHT = 640, 480

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

class Log
    attr_accessor :x, :y, :image, :available

    def initialize(x,y)
        @x = x
        @y = y
        @image = Gosu::Image.new( "images/boat/log.png")
        @available = true
    end
end

class House 
    attr_accessor :x, :y, :house1, :house2, :house3, :house4

    def initialize(x,y)
        @x = x
        @y = y
        @house1 = Gosu::Image.new( "images/houses/house_1.png")
        @house2 = Gosu::Image.new( "images/houses/house_2.png")
        @house3 = Gosu::Image.new( "images/houses/house_3.png")
        @house4 = Gosu::Image.new( "images/houses/house_4.png")
    end
end

class Coin
    attr_accessor :x, :y, :image, :available

    def initialize(x,y)
        @x = x  
        @y = y  
        @image = Gosu::Image.new( "images/env/coin.png")
        @available = true
    end
end

class River
    attr_accessor :x, :y, :image

    def initialize
        @x = 120
        @y = 0
        @image = Gosu::Image.new( "images/env/river.png")
    end
end

class Boat
    attr_accessor :x, :y, :image, :crash_sound, :collect_sound, :music, :distance, :coins,  :lives, :collision

    def initialize
        @x = 250
        @y = 425
        @image = Gosu::Image.new( "images/boat/boat.png")
        @crash_sound = Gosu::Song.new( 'sounds/crash.ogg')
        @collect_sound = Gosu::Song.new( 'sounds/collect.ogg')
        @music = Gosu::Song.new( 'sounds/boat_sound.mp3')
        @distance = 0
        @coins = 0
        @lives = 3
        @collision = false
    end
end

class Tree
  attr_accessor :x, :y, :image

  def initialize(x,y)
    @x = x
    @y = y
    @image = Gosu::Image.new("images/houses/tree.png")
  end
    
end

#move boat left
def move_left(boat)
    boat.x -= 5
  if boat.x <= 120.0
    boat.x = 120.0
  else
    boat.x %= 640
  end
end

#move boat right
def move_right(boat)
     if boat.x <= 280.0
        boat.x += 5
     else
      boat.x %= 640
     end
  end

  #move boat forward
def go(boat)
    if boat.y >= 0
        boat.y -= 5.0
    else 
      boat.y %= 480
    end
end

  #brakeboat
def brake(boat)
    if boat.y <= 450.0
        boat.y += 2.0 
    else 
      boat.y %= 480
    end
end

def move_log (log)
  log.each do |i|
    if i.available
        i.y += 2.5
    end
    if i.y >= 480
     i.x, i.y = rand(122..280), rand(10..200)
     i.available = false
    end
  end
end


  #movehouse
  def move_house(house)
      house.y += 3.0
     house.y %= 480
  end

     #drawcoin
  def draw_coin(coin)
   
     if coin.available
        coin.image.draw(coin.x, coin.y, ZOrder::PLAYER)
     end
  end

  def draw_logs(log)
   
      if log.available
         log.image.draw(log.x, log.y, ZOrder::PLAYER)
      end
   end


  #updatecoin
  def update_coin(coin)
    if rand(100) == 1
      coin.available = true
    end
  end

  #movecoin
  def move_coin (coin)
    
    if coin.available
      coin.y += 4.0
    end
    if coin.y >= 480
      coin.y = 0
      change(coin)
    end
  end

  #changecoin
  def change(coin)
    coin.x,coin.y = rand(122..280), rand(10..200)
    coin.available = false
  end

  def draw_river(river)
    river.image.draw(river.x, river.y, ZOrder::BACKGROUND )
  end

  #drivingboat
  def driving( coin,boat)
    boat.music.volume = 0.8
      boat.music.play(looping = true) 
      if button_down? Gosu::KbLeft
        move_left(boat) 
      elsif button_down? Gosu::KbRight
        move_right(boat) 
      elsif button_down? Gosu::KbUp
        go(boat)
        if rand(10)==1
          @boat.distance += 0.5
        end
      elsif button_down? Gosu::KbDown
        brake(boat) 
      elsif button_down? Gosu::KbEscape
        close
        Menu.new.show
      end
    collect_coin(coin,boat)
  end

  def collect_coin(coin,boat)
    if (coin.x - boat.x).abs <= 30 && (coin.y - boat.y).abs <= 30.0 && (coin.available == true)
      boat.collect_sound.play
      boat.coins += 1
      coin.available = false
       if boat.music.playing?
        boat.music.stop
       end
      change(coin)
    end
  end

  def collision( log,boat)
    if (log.x - boat.x).abs <= 30.0 && (log.y - boat.y).abs <= 15.0 && (log.available == true)
      boat.crash_sound.play
      boat.collision = true
      log.available = false
       if boat.music.playing?
        boat.music.stop
       end
       boat.lives -= 1
       sleep 0.5
      if boat.lives == 0
        GameOver.new.show
        close
      end
    end

  end

  def draw_tree(tree)
    tree.image.draw(tree.x, tree.y, ZOrder::PLAYER)
  end

  def draw_house(house)
    house.house1.draw(house.x,house.y,ZOrder::PLAYER)
  end

  def draw_house2(house)
    house.house2.draw(house.x,house.y,ZOrder::PLAYER)
  end

  def draw_house3(house)
    house.house3.draw(house.x,house.y,ZOrder::PLAYER)
  end

  def draw_house4(house)
    house.house4.draw(house.x,house.y,ZOrder::PLAYER)
  end

  def draw_house5(house)
    house.house3.draw(house.x,house.y,ZOrder::PLAYER)
  end

  #movetree
  def move_tree(tree)
      tree.y += 3.0
      tree.y %= 480
  end

  def draw_controls
    font = Gosu::Font.new(20)
    name = Gosu::Font.new(15)

    font.draw("TASK:", 500, 130, ZOrder::PLAYER)
    font.draw("* Collect coins as boat moves.", 450, 160,0.75,0.75, ZOrder::PLAYER)
    font.draw("* Avoid collision with the logs.", 450, 185,0.75,0.75 ,ZOrder::PLAYER)
    font.draw("* Each collision", 450, 210,0.75,0.75, ZOrder::PLAYER)
    font.draw("  reduces the life by 1.", 450, 230,0.75,0.75, ZOrder::PLAYER)
    font.draw("controls:", 500, 300, ZOrder::PLAYER)
    font.draw("move - ↑ ↓ ← →", 485, 330, ZOrder::PLAYER)
    font.draw("quit - esc", 485, 355, ZOrder::PLAYER)
    name.draw("Game by: BILAL RIZNY", 500, 450, ZOrder::PLAYER, 0.75, 0.75, Gosu::Color::BLACK)
  end


  #generate trees
  def gen_trees
    trees = Array.new()
    (10..500).step(100) do |i| 
      trees << Tree.new(80,i)
      trees << Tree.new(325,i)
    end
    return trees
  end


  def gen_houses
    houses = Array.new()
    (20..600).step(100) do |i|
       houses << House.new(25,i)
    end
    return houses
  end

  #generate drivers
  def gen_logs(log)
    logs = Array.new() 
    (10..600).step(150) do |i|
      logs << Log.new(log.x,i)
    end
    return logs
  end

class GameWindow < Gosu::Window

  def initialize
    super WIDTH, HEIGHT
    self.caption = 'BOAT RIDE'
     
    @houses = gen_houses
    @trees = gen_trees
    @logs = Array.new()
    @background_image = Gosu::Image.new('images/env/green.png')
    @scoreboard = Gosu::Image.new('images/scboard/scboard.png')
    @boat = Boat.new()
    @tree = Tree.new(80,100)
    @coin = Coin.new(rand(225..280),rand(10..150))
    @text = Gosu::Font.new(20)
  end

  def draw 
    @background_image.draw(0, 0,ZOrder::BACKGROUND)
    river = River.new()
    draw_river(river)
    @trees.each do |i|
      draw_tree(i)
   end
   @houses.each do
    draw_house(@houses[0])
    draw_house2(@houses[1])
    draw_house3(@houses[2])
    draw_house4(@houses[3])
    draw_house5(@houses[4])
   end
    @logs.each do |log| 
      draw_logs(log)
    end
    @boat.image.draw(@boat.x,@boat.y,ZOrder::PLAYER)
    @scoreboard.draw(440, 0,ZOrder::BACKGROUND )
    draw_controls
    if @boat.collision
      explosion = Gosu::Image.new('images/env/explosion.png')
      image = explosion
      image.draw(@boat.x,@boat.y,ZOrder::PLAYER)
     @boat.image = Gosu::Image.new( "images/boat/boat.png")
     @boat.collision = false
     @boat.x, @boat.y = 250, 425
    end
    $coins = @boat.coins
    $distance = @boat.distance
    @text.draw("Coins: #{@boat.coins}", 485, 20, ZOrder::PLAYER)
    @text.draw("Distance: #{@boat.distance}", 485, 40, ZOrder::PLAYER)
    @text.draw("Lives: #{@boat.lives}", 485, 60, ZOrder::PLAYER)
    draw_coin(@coin)
    end

    def update
      driving(@coin, @boat)
      @logs.each do |log| 
        collision( log,@boat)
      end
     if (button_down? Gosu::KbUp) 
       @houses.each do |i|
         move_house(i)
       end 
       @trees.each do |i|
        move_tree(i)
       end
       move_coin(@coin)
      end
      move_log(@logs)
      update_coin(@coin)
      if rand(120) == 1
        @logs.push(Log.new(rand(122..280),rand(10..50)))
       end 
    end
  end 




    