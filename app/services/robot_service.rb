# frozen_string_literal: true

class RobotService < ApplicationService
  def initialize(params = {})
    @robot = Robot.new
    @x_coordinate = params[:x_coordinate]
    @y_coordinate = params[:y_coordinate]
    @facing = params[:facing] || ''
    @commands = params[:commands] || ''
    @report = nil
    @size_grid = initialize_size_grid
  end

  def call
    initialize_size_grid
    execute_commands
    @robot
  end

  private

  def initialize_size_grid
    @size_grid_x = 5
    @size_grid_y = 5
  end

  def execute_commands
    return unless check_robot_is_placed?

    commands = @commands.gsub(/\r\n/, ' ')
    commands = commands.to_s.upcase.split(' ')
    commands.each_with_index do |command, index|
      place_initial_coordinates(commands[index + 1]) if command == 'PLACE'
      next if command == 'PLACE'

      case command
      when 'MOVE'
        move_into_new_position
      when 'LEFT'
        change_direction('LEFT')
      when 'RIGHT'
        change_direction('RIGHT')
      when 'REPORT'
        generate_report
        break
      end
    end
    # wrong_arguments
  end

  def check_robot_is_placed?
    if @commands.include?('PLACE')
      true
    else
      errors.add(:warning, 'You might need to place the robot first!')
      false
    end
  end

  def place_initial_coordinates(args)
    @x_coordinate, @y_coordinate, @facing = args.split(',')
    @x_coordinate = @x_coordinate.to_i
    @y_coordinate = @y_coordinate.to_i
  end

  def move_into_new_position
    case @facing
    when 'NORTH'
      @y_coordinate += 1 unless (@y_coordinate + 1) > (@size_grid_y - 1)
    when 'WEST'
      @x_coordinate -= 1 unless (@x_coordinate - 1).negative?
    when 'SOUTH'
      @y_coordinate -= 1 unless (@y_coordinate - 1).negative?
    when 'EAST'
      @x_coordinate += 1 unless (@x_coordinate + 1) > (@size_grid_x - 1)
    end
  end

  def change_direction(direction)
    case @facing
    when 'NORTH'
      @facing = direction.eql?('LEFT') ? 'WEST' : 'EAST'
    when 'WEST'
      @facing = direction.eql?('LEFT') ? 'SOUTH' : 'NORTH'
    when 'SOUTH'
      @facing = direction.eql?('LEFT') ? 'EAST' : 'WEST'
    when 'EAST'
      @facing = direction.eql?('LEFT') ? 'NORTH' : 'SOUTH'
    end
  end

  def generate_report
    @report = "#{@x_coordinate},#{@y_coordinate},#{@facing}"
    @robot.report = @report
  end

  def wrong_arguments
    # errors.add(:warning, 'Wrong direction! your robot is about to fall of..') unless check_warning
  end
end
