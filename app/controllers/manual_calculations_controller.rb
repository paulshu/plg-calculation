class ManualCalculationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @manual_calculations = ManualCalculation.order("id DESC").page(params[:page]).per(10) # kaminari 分页page(params[:page])
  end

  def new
    @manual_calculation = ManualCalculation.new
  end

  def show
    @manual_calculation = ManualCalculation.find(params[:id])
  end

  def edit
    @manual_calculation = ManualCalculation.find(params[:id])
  end

  def create
    @manual_calculation = ManualCalculation.new(manual_calculation_params)

    if @manual_calculation.save
      redirect_to manual_calculations_path
    else
      render :new
    end
  end

  def update
    @manual_calculation = ManualCalculation.find(params[:id])

    if @manual_calculation.update(manual_calculation_params)
      redirect_to manual_calculations_path
    else
      render :edit
    end
  end

  def destroy
    @manual_calculation = ManualCalculation.find(params[:id])
    @manual_calculation.destroy

    redirect_to manual_calculations_path
  end

  private

  def manual_calculation_params
    params.require(:manual_calculation).permit()
  end
end
