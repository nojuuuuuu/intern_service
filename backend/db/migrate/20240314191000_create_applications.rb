class CreateApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :applications do |t|
      t.references :candidate_profile, null: false, foreign_key: true, index: true
      t.references :internship, null: false, foreign_key: true, index: true
      t.text :cover_letter
      t.text :additional_information
      t.integer :status, default: 0  # 0: pending, 1: reviewing, 2: accepted, 3: rejected
      t.datetime :reviewed_at
      t.text :rejection_reason
      t.text :feedback
      t.datetime :notification_sent_at

      t.timestamps
    end

    # 同じインターンシップに同じ候補者が複数応募できないように
    add_index :applications, [:candidate_profile_id, :internship_id], unique: true
  end
end 