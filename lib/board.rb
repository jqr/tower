class Board
  attr_accessor :grid, :rows, :columns, :tile_size

  def initialize(window, rows, columns, tile_size)
    @window = window
    self.rows = rows
    self.columns = columns
    self.tile_size = tile_size

    self.grid = Array.new(columns).collect { |a| Array.new(rows) }

    recalculate_grid
  end

  def recalculate_grid
    grid.each_with_index do |column, x|
      column.each_with_index do |cell, y|
        grid[x][y] = nil if grid[x][y].is_a?(Integer)
      end
    end
    
    columns.times do |x|
      grid[x][rows - 1] ||= 1
    end
    
    30.times do
      grid.each_with_index do |column, x|
        column.each_with_index do |cell, y|
          unless cell.is_a?(Tower)
            distances = surrounding_cells(x, y).select do |value|
              value.is_a?(Integer)
            end
          
            distances += [cell]
            distances.compact!
            
            if distances.size > 0
              min_distance = distances.min
              if grid[x][y] == nil || min_distance + 1 < grid[x][y]
                grid[x][y] = min_distance + 1
              end
            end
          end
        end
      end
    end
  end
  
  def surrounding_cells(x, y)
    distances = []
    if y + 1 < rows
      distances << grid[x][y + 1]
    end

    if x > 0
      distances << grid[x - 1][y]
    end

    if x + 1 < columns
      distances << grid[x + 1][y]
    end

    if y > 0
      distances << grid[x][y - 1]
    end
    
    distances
  end
  
  def draw(color)
    columns.times do |distance|
      @window.draw_line(tile_size * distance, 0, color, tile_size * distance, @window.height, color)
    end
    rows.times do |distance|
      @window.draw_line(0, tile_size * distance, color, @window.width, tile_size * distance, color)
    end
    
    grid.each_with_index do |column, x|
      column.each_with_index do |cell, y|
        unless cell.is_a?(Tower)
          @window.font.draw(cell, x * tile_size + 9, y * tile_size + 9, 0, 1.0, 1.0, color)
        end
      end
    end
  end

  def width
    columns * tile_size
  end

  def height
    rows * tile_size
  end
end
