class Admin::PlatformsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  layout "admin"

  def index
    @platforms = Platform.all
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

  private

  def platform_params
    params.require(:platform).permit(:moto_type)
  end
end
