class Micropost < ApplicationRecord
  belongs_to :user
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.content_size}
  validate :picture_size
  scope :recent_post, ->{order created_at: :desc}

  private

  def picture_size
    return if picture.size < Settings.picture_size.megabytes
    errors.add(:picture, t("picture_size_less"))
  end
end
