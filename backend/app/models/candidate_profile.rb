class CandidateProfile < ApplicationRecord
  belongs_to :user
  has_many :applications, dependent: :destroy
  has_many :scouts, foreign_key: 'candidate_id', dependent: :destroy

  # 例: name, resume, skills, education などのカラムを追加
  validates :name, presence: true
end 