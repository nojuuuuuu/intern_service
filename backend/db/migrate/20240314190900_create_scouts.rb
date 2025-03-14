class CreateScouts < ActiveRecord::Migration[7.0]
  def change
    create_table :scouts do |t|
      t.references :company_profile, null: false, foreign_key: true, index: true
      t.references :candidate_profile, null: false, foreign_key: true, index: true
      t.references :internship, foreign_key: true
      t.string :title
      t.text :message
      t.integer :status, default: 0  # 0: pending, 1: accepted, 2: declined
      t.datetime :read_at
      t.datetime :responded_at

      t.timestamps
    end
  end
end 