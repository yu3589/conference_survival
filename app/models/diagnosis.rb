class Diagnosis < ApplicationRecord
  before_create :generate_token

  def generate_token
    loop do
      # ランダムの英数字(A-Z, a-z, 0-9)を6桁生成
      self.token = SecureRandom.alphanumeric(6)
      break unless Diagnosis.exists?(token: token)
    end
  end

  enum result_type: {
    sharpness: 0,
    sleepiness: 1,
    nod: 2,
    stealth: 3,
    fade: 4,
    balance: 5
  }
end
