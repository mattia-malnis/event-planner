class Event < ApplicationRecord
  has_and_belongs_to_many :users

  validates :title, length: { maximum: 255 }
  validates :title, :country, :date, presence: true
  validates :lat, numericality: { in: -90..90 }
  validates :long, numericality: { in: -180..180 }

  def self.ordered
    order(:date)
  end
end
