class CreateCandidateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :candidate_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.text :bio
      t.string :university
      t.string :major
      t.integer :graduation_year
      t.string :skills
      t.text :interests

      t.timestamps
    end
  end
end 