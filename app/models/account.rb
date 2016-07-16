class Account < ActiveRecord::Base
  belongs_to :user
  has_many :contacts
  default_scope -> { order('created_at ASC') }

  validates :user_id,   presence: true
  validates :uid,       presence: true, :uniqueness => {scope: :user_id}
  validates :login,     presence: true
  validates :provider,  presence: true
  validates :token,     presence: true
  validates :jsondump,  presence: true

  def stale?
    return expiresat.past?
  end
end
