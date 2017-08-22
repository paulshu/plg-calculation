require 'csv'
class CompressionSpringsController < ApplicationController
  before_action :authenticate_user!

  def index
    @compression_springs = CompressionSpring.order("id DESC").page(params[:page]).per(10) # kaminari 分页page(params[:page])
  end

  def show
    @compression_spring = CompressionSpring.find(params[:id])

    respond_to do |format| # 以下代码用于导出CSV文件
      format.html
      format.csv {
        #@compression_springs = @compression_spring.reorder("id ASC") 因为这里只有一个产品
        csv_string = CSV.generate do |csv|
          csv << ["输入参数"]
          csv << ["开门弹簧长度L1","关门弹簧长度L2","开门最小负荷","关门最大负荷"]
          cs = @compression_spring
            csv << [cs.od_length, cs.cd_length, cs.min_force, cs.max_force]
          csv << ["输出参数"]
          csv << ["开门弹簧力F1","关门弹簧力F2","弹簧有效圈数",
            "弹簧总圈数","弹簧线径","弹簧内径","弹簧自由长度","弹簧螺旋升角"]
          csv << [ cs.od_force.round(3), cs.cd_force.round(3), cs.active_coil_num,
            cs.total_num, cs.wire_diameter, cs.inside_diameter, cs.free_length, cs.spring_helix_angle.round(3)]
        end
        send_data csv_string, :filename => "#{@compression_spring.product_name}-压缩弹簧设计参数-#{@compression_spring.product_number}.csv"
      }
      format.xlsx {
        response.headers['Content-Disposition'] = 'attachment; filename="压缩弹簧设计参数.xlsx"'
      }
    end

    bg_colors = ['rgba(255, 99, 132, 0.2)',
                 'rgba(54, 162, 235, 0.2)',
                 'rgba(255, 206, 86, 0.2)',
                 'rgba(75, 192, 192, 0.2)',
                 'rgba(153, 102, 255, 0.2)',
                 'rgba(255, 159, 64, 0.2)'
                ]
    bd_colors = [
                'rgba(255,99,132,1)',
                'rgba(54, 162, 235, 1)',
                'rgba(255, 206, 86, 1)',
                'rgba(75, 192, 192, 1)',
                'rgba(153, 102, 255, 1)',
                'rgba(255, 159, 64, 1)'
                ]
    @data1 = {
        labels: ["开门位置", "关门位置"],
        datasets: [{
            label: '理论弹簧力值曲线',
            fill: false, # 取消这行将填充面积
            data: [@compression_spring.min_force, @compression_spring.max_force ],
            backgroundColor: bg_colors,
            borderColor: bd_colors,
            borderWidth: 1,

          },{
            label: '实际弹簧力值曲线',
            fill: false,
            data: [@compression_spring.od_force, @compression_spring.cd_force ],
            backgroundColor: bg_colors,
            borderColor: bd_colors,
            borderWidth: 1,
            borderDash: [5, 5],
          }]
    }
    gon.data = @data1

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
        :wire_diameter, :active_coil_num, :total_num, :free_length, :od_force, :cd_force, :flocking)
  end

end
