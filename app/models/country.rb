class Country < ApplicationRecord
  has_many :events

  validates :iso, presence: true, length: { is: 2 }
  validates :iso, uniqueness: { case_sensitive: false }, if: :iso_changed?
  validates :name, presence: true

  before_validation :normalize_fields

  private

  def normalize_fields
    self.iso = iso&.split&.join&.downcase
    self.name = name&.split&.join(" ")
  end
end
