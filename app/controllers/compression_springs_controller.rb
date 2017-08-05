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
    @compression_spring.current_step = 1
    if @compression_spring.save
      redirect_to step2_compression_spring_path(@compression_spring)
    else
      render "new"
    end
  end

  def update
    @compression_spring = CompressionSpring.find(params[:id])

    if@compression_spring.update(compression_spring_params)
      redirect_to compression_springs_path
    else
      render :edit
    end
  end

  def step1
    @compression_spring = CompressionSpring.find(params[:id])
  end

  def step1_update
    @compression_spring = CompressionSpring.find(params[:id])
    @compression_spring.current_step = 1

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
    @compression_spring.current_step = 2

    if @compression_spring.update(compression_spring_params)
      @compression_spring.od_force?
      @compression_spring.cd_force?
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
    @compression_spring.current_step = 3
    
    if @compression_spring.update(compression_spring_params)
      @compression_spring.total_num?
      @compression_spring.od_force?
      @compression_spring.cd_force?
      flash[:notice] = "弹簧更新成功"
      redirect_to step3_compression_spring_path(@compression_spring)
    else
      render "step3"
    end
  end

  def destroy
    @compression_spring = CompressionSpring.find(params[:id])
    @compression_spring.destroy
    flash[:warning] = "成功将 #{@compression_spring.product_name} 压簧参数从系统中删除!"
    redirect_to :back
  end

  private

  def compression_spring_params
    params.require(:compression_spring).permit(:product_name,:product_number , :min_force,:max_force, :od_length , :cd_length, :inside_diameter,
        :wire_diameter, :active_coil_num, :total_num, :free_lengh, :od_force, :cd_force)
  end

end