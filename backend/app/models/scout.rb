class Scout < ApplicationRecord
  belongs_to :company_profile
  belongs_to :candidate_profile
  belongs_to :internship, optional: true
  
  # ステータス定義: pending（未回答）, accepted（承諾）, declined（辞退）
  enum status: { pending: 0, accepted: 1, declined: 2 }
  
  # バリデーション
  validates :message, presence: true
  
  # スカウトが既読状態かどうかを確認するメソッド
  def read?
    read_at.present?
  end
  
  # スカウトを既読にするメソッド
  def mark_as_read
    update(read_at: Time.current) unless read?
  end
  
  # 回答済みかどうかを確認するメソッド
  def responded?
    status != 'pending'
  end
  
  # スカウトに回答するメソッド
  def respond(accept)
    new_status = accept ? :accepted : :declined
    update(status: new_status, responded_at: Time.current)
  end
end 