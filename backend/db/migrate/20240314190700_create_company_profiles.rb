class CreateCompanyProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :company_profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :company_name, null: false
      t.text :description
      t.string :industry
      t.string :location
      t.string :website
      t.integer :company_size
      t.integer :founding_year

      t.timestamps
    end
  end
end 