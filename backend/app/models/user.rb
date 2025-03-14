class User < ApplicationRecord
  # role: candidate, company などをenumで管理する例
  enum role: { candidate: 0, company: 1 }

  # 役割によって候補者か企業のプロフィールを持つ（1対1）
  has_one :candidate_profile, dependent: :destroy
  has_one :company_profile, dependent: :destroy

  # バリデーション例
  validates :email, presence: true, uniqueness: true
  has_secure_password
end 