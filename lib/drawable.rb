module Drawable
  
  def center_x
    x + image.width / 2
  end  

  def center_y
    y + image.height / 2
  end
  
  def draw_center_lines
    @window.draw_line(center_x, 0, 0xffff0000, center_x, @window.height, 0xffff0000)
    @window.draw_line(0, center_y, 0xffff0000, @window.width, center_y, 0xffff0000)
  end
  
  def highlight_tile
    color = 0x4400ff00
    
    @window.draw_quad(
      (board_x + 1) * @window.board.tile_size, board_y * @window.board.tile_size, color,
      (board_x + 1) * @window.board.tile_size, (board_y + 1) * @window.board.tile_size, color,
      board_x * @window.board.tile_size, board_y * @window.board.tile_size, color,
      board_x * @window.board.tile_size, (board_y + 1) * @window.board.tile_size, color
    )
  end
  
  def board_x
    ((center_x + 3) / @window.board.tile_size).to_i
  end
  
  def board_y
    ((center_y + 3) / @window.board.tile_size).to_i
  end
end