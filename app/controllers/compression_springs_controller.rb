class CompressionSpringsController < ApplicationController
  before_action :authenticate_user!

  def index
    @compression_springs = CompressionSpring.order("id DESC").page(params[:page]).per(10) # kaminari 分页page(params[:page])
  end

  def show
    @compression_spring = CompressionSpring.find(params[:id])
  end

  def new
    @compression_spring = CompressionSpring.new

  end

  def edit
    @compression_spring = CompressionSpring.find(params[:id])
  end

  def create
    @compression_spring = CompressionSpring.new(compression_spring_params)

    if @compression_spring.save
      redirect_to step2_compression_spring_path(@compression_spring)
    else
      render "new"
    end
  end

  # def update
  #   @compression_spring = CompressionSpring.find(params[:id])
  #
  #   if@compression_spring.update(compression_spring_params)
  #     redirect_to compression_springs_path
  #   else
  #     render :edit
  #   end
  # end

  def spring_math
    @compression_spring = CompressionSpring.find(params[:id])
    compression_spring.total_num = @compression_spring.active_coil_num + 2
  end

  def step1
    @compression_spring = CompressionSpring.find(params[:id])
  end

  def step1_update
    @compression_spring = CompressionSpring.find(params[:id])

    if @compression_spring.update(compression_spring_params)
      redirect_to step2_compression_spring_path(@compression_spring)
    else
      render :step1
    end
  end

  def step2
    @compression_spring = CompressionSpring.find(params[:id])
  end

  def step2_update
    @compression_spring = CompressionSpring.find(params[:id])

    if @compression_spring.update(compression_spring_params)
      redirect_to step3_compression_spring_path(@compression_spring)
    else
      render :step2
    end
  end

  def step3
    @compression_spring = CompressionSpring.find(params[:id])
  end

  def step3_update
    @compression_spring = CompressionSpring.find(params[:id])

    if @compression_spring.update(compression_spring_params)
      flash[:notice] = "弹簧计算成功"
      redirect_to compression_spring_path(@compression_spring)
    else
      render "step3"
    end
  end

  private

  def compression_spring_params
    params.require(:compression_spring).permit(:product_name,:product_number , :min_force,:max_force, :od_length , :cd_length, :inside_diameter,
        :wire_diameter, :active_coil_num, :total_num, :free_lengh, :od_force, :cd_force)
  end

end
