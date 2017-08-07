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
// })
