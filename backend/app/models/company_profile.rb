class CompanyProfile < ApplicationRecord
  belongs_to :user
  has_many :internships, dependent: :destroy
  has_many :scouts, foreign_key: 'company_id', dependent: :destroy

  # 例: company_name, description, industry, location などのカラムを追加
  validates :company_name, presence: true
end 