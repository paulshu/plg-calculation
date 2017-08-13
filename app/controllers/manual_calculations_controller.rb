class ManualCalculationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @manual_calculations = ManualCalculation.order("id DESC").page(params[:page]).per(10) # kaminari 分页page(params[:page])
  end

  def new
    @manual_calculation = ManualCalculation.new
    @platforms = Platform.all.map { |p| [p.platform_name, p.id] } # 找对应的平台
  end

  def show
    @manual_calculation = ManualCalculation.find(params[:id])
  end

  def edit
    @manual_calculation = ManualCalculation.find(params[:id])
    @platforms = Platform.all.map { |p| [p.platform_name, p.id] } # 找对应的平台
  end

  def create
    @manual_calculation = ManualCalculation.new(manual_calculation_params)
    @manual_calculation.platform_id = params[:platform_id]
    if @manual_calculation.save
      redirect_to spring_calculation_manual_calculation_path(@manual_calculation)
    else
      @platforms = Platform.all.map { |p| [p.platform_name, p.id] }
      #此处主要解决验证失效返回重新构建下拉菜单失败报错的问题
      render :new
    end
  end

  def update
    @manual_calculation = ManualCalculation.find(params[:id])
    @manual_calculation.platform_id = params[:platform_id]

    if @manual_calculation.update(manual_calculation_params)
      redirect_to manual_calculations_path
    else
      render :edit
    end
  end

  def destroy
    @manual_calculation = ManualCalculation.find(params[:id])
    @manual_calculation.destroy
    flash[:alert] = "#{@manual_calculation.product_name}删除成功"
    redirect_to manual_calculations_path
  end

  def input_manual_calculation
    @manual_calculation = ManualCalculation.find(params[:id])
  end

  def input_manual_calculation_update
    @manual_calculation = ManualCalculation.find(params[:id])
    @manual_calculation.platform_id = params[:platform_id]
    if @manual_calculation.update(manual_calculation_params)
      redirect_to spring_calculation_manual_calculation_path
    else
      render :input_manual_calculation
    end
  end

  def spring_calculation
    @manual_calculation = ManualCalculation.find(params[:id])
  end

  def spring_calculation_update
    @manual_calculation = ManualCalculation.find(params[:id])
    if @manual_calculation.update(manual_calculation_params)
      redirect_to spring_calculation_manual_calculation_path
    else
      render :spring_calculation
    end
  end

  private

  def manual_calculation_params
    params.require(:manual_calculation).permit(:product_name,:product_number, :hinge_x, :hinge_y, :hinge_z, :centre_gravity_x, :centre_gravity_y, :centre_gravity_z,
            :door_weight, :body_a_x, :body_a_y, :body_a_z, :gate_b_x, :gate_b_y, :gate_b_z, :open_handle_x, :open_handle_y, :open_handle_z, :close_handle_x, :close_handle_y,
            :close_handle_z, :open_angle, :open_time, :close_time, :open_dynamic_friction, :close_dynamic_friction, :open_static_friction, :close_static_friction, :platform_id )
  end
end
