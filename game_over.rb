#new game button click event
def new_game
    GameWindow.new.show
    
  end

  #exit button click event
  def exit
    close
  end


class GameOver < Gosu::Window

  def initialize 
    super 640,480 
    self.caption = 'GAME OVER'
    @background = Gosu::Image.new( 'images/env/green.png')
    @name = Gosu::Image.new('images/menu/GAME_OVER.png')
    @icon = Gosu::Image.new( 'images/menu/icon.png')
    @new = Gosu::Image.new( 'images/menu/new.png')
    @exit = Gosu::Image.new('images/menu/exit.png')
    @music = Gosu::Song.new('sounds/music.mp3')
    @text = Gosu::Font.new(20)
    @font = Gosu::Font.new(15)
  end

  def draw
      @background.draw(0,0,ZOrder::BACKGROUND)
      @name.draw(150, 25, 2)
      @text.draw("Coins collected: #{$coins}", 150, 100, 2)
     @text.draw("Distance Travelled: #{$distance}", 150, 120, 2)
      @text.draw("BETTER LUCK NEXT TIME!", 200, 200, 2)
      @font.draw("Game by: BILAL RIZNY", 25, 450, ZOrder::PLAYER, 0.75, 0.75, Gosu::Color::BLACK)
      
      @icon.draw(175, 100, 2)
      @new.draw(250, 335, 2)
      @exit.draw(250, 375, 2)
  end

  def update
    @music.play(looping = false)
    if 250 < mouse_x && mouse_x < 370 && 335 < mouse_y && mouse_y < 370 && (button_down? Gosu::MsLeft)
      new_game
    elsif 250 < mouse_x && mouse_x < 370 && 375 < mouse_y && mouse_y < 410 && (button_down? Gosu::MsLeft)
      exit
    end
  end

end