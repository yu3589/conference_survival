class CreateDiagnoses < ActiveRecord::Migration[7.2]
  def change
    create_table :diagnoses do |t|
      t.string :token
      t.integer :sharpness_score
      t.integer :sleepiness_score
      t.integer :nod_score
      t.integer :stealth_score
      t.integer :fade_score
      t.integer :result_type

      t.timestamps
    end
  end
end
