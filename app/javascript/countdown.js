function startCountdown() {
  // ループの開始時点（6時間24分59秒）を秒に換算
  const START_HOURS = 6;
  const START_MINUTES = 24;
  const START_SECONDS = 59;

  // ループの終了時点（5時間24分59秒）を秒に換算
  const END_HOURS = 5;
  const END_MINUTES = 24;
  const END_SECONDS = 59;

  // 開始・終了を秒単位で計算
  const START_TOTAL_SECONDS = START_HOURS * 3600 + START_MINUTES * 60 + START_SECONDS;
  const END_TOTAL_SECONDS = END_HOURS * 3600 + END_MINUTES * 60 + END_SECONDS;

  // 現在の残り秒数（カウントダウンする変数）
  let remainingSeconds = START_TOTAL_SECONDS;

  function updateCountdown() {
    const hoursEl = document.getElementById('hours');
    const minutesEl = document.getElementById('minutes');
    const secondsEl = document.getElementById('seconds');

    // 要素が存在しない場合は処理しない
    if (!hoursEl || !minutesEl || !secondsEl) return;

    // 残り秒数から時・分・秒を計算
    const hours = Math.floor(remainingSeconds / 3600);
    const minutes = Math.floor((remainingSeconds % 3600) / 60);
    const seconds = remainingSeconds % 60;

    // カウントダウン表示を更新（DaisyUIの`--value`を使う）
    hoursEl.style.setProperty('--value', String(hours));
    minutesEl.style.setProperty('--value', String(minutes));
    secondsEl.style.setProperty('--value', String(seconds));

    // 1秒減らす
    remainingSeconds--;

    // ループ条件：設定した終了時刻まで到達したら、また最初に戻す
    if (remainingSeconds < END_TOTAL_SECONDS) {
      remainingSeconds = START_TOTAL_SECONDS;
    }
  }

  updateCountdown(); // 初回即時実行
  setInterval(updateCountdown, 1000); // 毎秒更新
}

// Turboと通常読み込みの両対応
document.addEventListener('turbo:load', startCountdown);
document.addEventListener('DOMContentLoaded', startCountdown);

