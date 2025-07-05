class AddUniqueIndexToDiagnosesToken < ActiveRecord::Migration[7.2]
  def change
    add_index :diagnoses, :token, unique: true
  end
end
