class Diagnosis < ApplicationRecord
  before_create :generate_token
  before_validation :set_result_type

  enum result_type: {
    sharpness: 0,
    sleepiness: 1,
    nod: 2,
    stealth: 3,
    fade: 4,
    balance: 5
  }

  def generate_token
    loop do
      # ランダムの英数字(A-Z, a-z, 0-9)を8桁生成
      self.token = SecureRandom.alphanumeric(8)
      break unless Diagnosis.exists?(token: token)
    end
  end

  def set_result_type
    threshold = 75
    scores = {
      sharpness: sharpness_score,
      sleepiness: sleepiness_score,
      nod: nod_score,
      stealth: stealth_score,
      fade: fade_score
    }

    max_type, max_score = scores.max_by { |_, v| v }
    sorted_scores = scores.values.sort.reverse
    second_score = sorted_scores[1] || 0

    if scores.values.all? { |v| v >= 50 }
      self.result_type = :balance
    elsif max_score - second_score < 5 && max_score >= threshold
      self.result_type = :balance
    else
      self.result_type = max_type
    end
  end

  def result_type_label
    I18n.t("activerecord.attributes.diagnosis.result_type_labels.#{result_type}")
  end
end
