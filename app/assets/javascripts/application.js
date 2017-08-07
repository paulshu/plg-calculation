// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require bootstrap/alert
//= require bootstrap/dropdown
//= require Chart.min
//= require_tree .

// $(document).ready(function() {
//   var ctx = document.getElementById("myChart");
//   var myChart = new Chart(ctx, {
//       type: 'line',
//       data: {
//           labels: ["开门位置", "关门位置"],
//           datasets: [{
//               label: '理论弹簧力值曲线',
//               fill: false, // 取消这行将填充面积
//               data: [12, 43],
//               backgroundColor: [
//                   'rgba(255, 99, 132, 0.2)',
//                   'rgba(54, 162, 235, 0.2)',
//                   'rgba(255, 206, 86, 0.2)',
//                   'rgba(75, 192, 192, 0.2)',
//                   'rgba(153, 102, 255, 0.2)',
//                   'rgba(255, 159, 64, 0.2)'
//               ],
//               borderColor: [
//                   'rgba(255,99,132,1)',
//                   'rgba(54, 162, 235, 1)',
//                   'rgba(255, 206, 86, 1)',
//                   'rgba(75, 192, 192, 1)',
//                   'rgba(153, 102, 255, 1)',
//                   'rgba(255, 159, 64, 1)'
//               ],
//               borderWidth: 1,
//           },{
//             label: '实际弹簧力值曲线',
//             fill: false, // 取消这行将填充面积
//             data: [12, 44],
//             backgroundColor: [
//                 'rgba(255, 99, 132, 0.2)',
//                 'rgba(54, 162, 235, 0.2)',
//                 'rgba(255, 206, 86, 0.2)',
//                 'rgba(75, 192, 192, 0.2)',
//                 'rgba(153, 102, 255, 0.2)',
//                 'rgba(255, 159, 64, 0.2)'
//             ],
//             borderColor: [
//                 // 'rgba(255,99,132,1)',
//                 'rgba(54, 162, 235, 1)',
//                 'rgba(255, 206, 86, 1)',
//                 'rgba(75, 192, 192, 1)',
//                 'rgba(153, 102, 255, 1)',
//                 'rgba(255, 159, 64, 1)'
//             ],
//             borderDash: [5, 5],
//             borderWidth: 1,
//           }]
//       },
//       options: {
//           responsive: true,
//           title:{
//               display:true,
//               fontSize: 20,
//               text:'弹簧曲线图'
//           },
//           // tooltips: {
//           //     mode: 'index',
//           //     intersect: false,
//           // },
//           // tooltips 可以设置鼠标悬停时同时显示多条曲线相同位置的值
//           hover: {
//               mode: 'nearest',
//               intersect: true
//           },
//           scales: {
//               xAxes: [{
//                   display: true,
//                   scaleLabel: {
//                       display: true,
//                       labelString: '长度位置'
//                   }
//               }],
//               yAxes: [{
//                   display: true,
//                   scaleStepWidth: 3,
//                   ticks: {
//                       beginAtZero:true
//                   }
//               }]
//           }
//       }
//   });


  Line.defaults = {

	//Boolean - If we show the scale above the chart data
	scaleOverlay : false,  // 网格线是否在数据线的上面

	//Boolean - If we want to override with a hard coded scale
	scaleOverride : false, // 是否用硬编码重写y轴网格线

	//** Required if scaleOverride is true **
	//Number - The number of steps in a hard coded scale
	scaleSteps : null, //y轴刻度的个数
	//Number - The value jump in the hard coded scale
	scaleStepWidth : null,  //y轴每个刻度的宽度
	//Number - The scale starting value
	scaleStartValue : null, //y轴的起始值

	//String - Colour of the scale line
	scaleLineColor : "rgba(0,0,0,.1)", // x轴y轴的颜色

	//Number - Pixel width of the scale line
	scaleLineWidth : 3, // x轴y轴的线宽

	//Boolean - Whether to show labels on the scale
	scaleShowLabels : false,

	//Interpolated JS string - can access value
	scaleLabel : "<%=value%>",

	//String - Scale label font declaration for the scale label
	scaleFontFamily : "'Arial'",

	//Number - Scale label font size in pixels
	scaleFontSize : 12,

	//String - Scale label font weight style
	scaleFontStyle : "normal",

	//String - Scale label font colour
	scaleFontColor : "#666",

	///Boolean - Whether grid lines are shown across the chart
	scaleShowGridLines : true,

	//String - Colour of the grid lines
	scaleGridLineColor : "rgba(0,0,0,.05)",

	//Number - Width of the grid lines
	scaleGridLineWidth : 1,

	//Boolean - Whether the line is curved between points
	bezierCurve : true,

	//Boolean - Whether to show a dot for each point
	pointDot : true,

	//Number - Radius of each point dot in pixels
	pointDotRadius : 3,

	//Number - Pixel width of point dot stroke
	pointDotStrokeWidth : 1,

	//Boolean - Whether to show a stroke for datasets
	datasetStroke : true,

	//Number - Pixel width of dataset stroke
	datasetStrokeWidth : 2,

	//Boolean - Whether to fill the dataset with a colour
	datasetFill : true,

	//Boolean - Whether to animate the chart
	animation : true,

	//Number - Number of animation steps
	animationSteps : 60,

	//String - Animation easing effect
	animationEasing : "easeOutQuart",

	//Function - Fires when the animation is complete
	onAnimationComplete : null

}

})
