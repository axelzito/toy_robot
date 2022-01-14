# frozen_string_literal: true

class Robot
  include ActiveModel::Model

  attr_accessor :size_grid, :size_grid_x, :size_grid_y, :x_coordinate, :y_coordinate, :facing, :commands, :report
end
