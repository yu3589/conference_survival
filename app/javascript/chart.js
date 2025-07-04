import Chart from 'chart.js/auto';

document.addEventListener("turbo:load", function () {
  const ctx = document.getElementById("radarChart");
  if (ctx) {
    new Chart(ctx, {
      type: 'radar',
      data: {
        labels: ["発言の切れ味", "寝落ちスキル", "適当相槌力", "内職バレない力", "空気読み回避力"],
        datasets: [{
          label: "会議サバイバル力",
          data: [3, 4, 2, 5, 1],
          backgroundColor: 'rgba(255, 99, 132, 0.2)',
          borderColor: 'rgba(255, 99, 132, 1)',
          borderWidth: 1
        }]
      },
      options: {
        scales: {
          r: {
            min: 0,
            max: 5,
            ticks: {
              stepSize: 1
            }
          }
        }
      }
    });
  }
});