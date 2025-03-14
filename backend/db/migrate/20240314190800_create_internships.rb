class CreateInternships < ActiveRecord::Migration[7.0]
  def change
    create_table :internships do |t|
      t.references :company_profile, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.string :location
      t.boolean :remote_available, default: false
      t.string :duration
      t.date :start_date
      t.date :end_date
      t.date :application_deadline
      t.integer :status, default: 0
      t.string :required_skills
      t.text :responsibilities
      t.text :qualifications
      t.text :benefits
      t.integer :positions_available, default: 1

      t.timestamps
    end
  end
end 