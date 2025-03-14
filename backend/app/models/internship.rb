class Internship < ApplicationRecord
  belongs_to :company_profile
  has_many :applications, dependent: :destroy
  has_many :scouts, dependent: :nullify

  # ステータス定義: open（募集中）, closed（締切）, filled（募集終了）
  enum status: { open: 0, closed: 1, filled: 2 }

  # バリデーション
  validates :title, presence: true
  validates :description, presence: true
  validates :start_date, presence: true
  validates :application_deadline, presence: true
  
  # 募集中のインターンシップを取得するスコープ
  scope :active, -> { where(status: :open).where('application_deadline >= ?', Date.today) }
  
  # 特定のスキルを持つインターンシップを検索するスコープ
  scope :with_skills, ->(skills) { where('required_skills LIKE ?', "%#{skills}%") }
end 