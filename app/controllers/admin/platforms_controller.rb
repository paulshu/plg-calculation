class Admin::PlatformsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  layout "admin"

  def index
    @platforms = Platform.all
  end

  def show
    @platform = Platform.find(params[:id])
  end

  def new
    @platform = Platform.new
  end

  def create
    @platform = Platform.new(platform_params)

    if @platform.save
      redirect_to admin_platforms_path
    else
      render :new
    end
  end

    def edit
      @platform = Platform.find(params[:id])
    end

    def update
      @platform = Platform.find(params[:id])

      if @platform.update(platform_params)
        redirect_to admin_platforms_path
      else
        render :edit
      end
    end

    def destroy
      @platform = Platform.find(params[:id])

      @platform.destroy
      redirect_to admin_platforms_path
    end

  private

  def platform_params
    params.require(:platform).permit(:platform_name,:platform_number, :screw_name, :number, :pitch, :major_diameter, :lead,
            :thread_angle, :coefficient_friction, :screw_name)
  end
end
