class Diagnosis < ApplicationRecord
  before_create :generate_token
  before_save :set_result_type

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
      # ランダムの英数字(A-Z, a-z, 0-9)を6桁生成
      self.token = SecureRandom.alphanumeric(6)
      break unless Diagnosis.exists?(token: token)
    end
  end

  def set_result_type
    if sharpness_score >= 4
      self.result_type = :sharpness
    elsif sleepiness_score >= 4
      self.result_type = :sleepiness
    elsif nod_score >= 4
      self.result_type = :nod
    elsif stealth_score >= 4
      self.result_type = :stealth
    elsif fade_score >= 4
      self.result_type = :fade
    else
      self.result_type = :balance
    end
  end

  def result_type_label
    I18n.t("activerecord.attributes.diagnosis.result_type_labels.#{result_type}")
  end
end
