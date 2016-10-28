class RadarsController < ApplicationController

  def create
    axes = params.require(:axes).map { |axis| create_axis(axis) }
    radar = Radar.create_with_axes(axes)
    render json: radar, status: :created
  end

  def result
    radar = Radar.find(params.require(:id))
    render json: RadarResultSerializer.new(radar, {}).to_json , status: :ok
  end

  def show
    radar = Radar.find(params.require(:id))
    render json: radar, status: :ok
  end

  private
  def create_axis(axis)
    Axis.create!(description: axis.require(:description))
  end
end
