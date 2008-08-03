module Drawable
  def draw_center_lines
    @window.draw_line(center_x, 0, 0xffff0000, center_x, @window.height, 0xffff0000)
    @window.draw_line(0, center_y, 0xffff0000, @window.width, center_y, 0xffff0000)
  end
  
  def highlight_grid
    color = 0xaa00ff00
    @window.draw_quad(
      (grid_x + 1) * GameWindow::GRID_WIDTH, grid_y * GameWindow::GRID_HEIGHT, color,
      (grid_x + 1) * GameWindow::GRID_WIDTH, (grid_y + 1) * GameWindow::GRID_HEIGHT, color,
      grid_x * GameWindow::GRID_WIDTH, grid_y * GameWindow::GRID_HEIGHT, color,
      grid_x * GameWindow::GRID_WIDTH, (grid_y + 1) * GameWindow::GRID_HEIGHT, color
    )
  end
end