# frozen_string_literal: true

class RobotService < ApplicationService
  def initialize(params = {})
    @x_coordinate = params[:x_coordinate]
    @y_coordinate = params[:y_coordinate]
    @facing = params[:facing] || ''
    @commands = params[:commands] || ''
    @report = nil
    @size_grid = initialize_size_grid
  end

  def call
    initialize_size_grid
  end

  private

  def initialize_size_grid
    @size_grid_x, @size_grid_y = 5, 5
  end
end
