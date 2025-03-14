class Application < ApplicationRecord
  belongs_to :candidate_profile
  belongs_to :internship

  # 応募状態を管理するenum
  enum status: { pending: 0, reviewing: 1, accepted: 2, rejected: 3 }

  # バリデーション
  validates :candidate_profile_id, uniqueness: { scope: :internship_id, message: "すでにこのインターンシップに応募しています" }
  
  # スコープ
  scope :latest, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }
  scope :for_company, ->(company_profile_id) { 
    joins(:internship).where(internships: { company_profile_id: company_profile_id }) 
  }
  
  # 応募をレビュー中に変更するメソッド
  def start_review
    update(status: :reviewing, reviewed_at: Time.current)
  end
  
  # 応募を受け入れるメソッド
  def accept
    update(status: :accepted, notification_sent_at: Time.current)
  end
  
  # 応募を拒否するメソッド
  def reject(reason = nil)
    update(
      status: :rejected, 
      rejection_reason: reason,
      notification_sent_at: Time.current
    )
  end
  
  # 応募からインターンシップの企業プロファイルを取得する
  def company_profile
    internship.company_profile
  end
  
  # 応募が新しいかどうか（レビュー開始前）
  def new_application?
    pending? && reviewed_at.nil?
  end
end 