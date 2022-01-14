# frozen_string_literal: true

class RobotsController < ApplicationController
  def new
    @robot = Robot.new
  end

  def create
    @robot = RobotService.call(params[:robot])
    @report = @robot.report

    render :new
  end
end
