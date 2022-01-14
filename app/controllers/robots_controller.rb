# frozen_string_literal: true

class RobotsController < ApplicationController
  def new
    @robot = Robot.new
  end

  def create
    RobotService.call(params[:robot])

    render :new
  end
end
