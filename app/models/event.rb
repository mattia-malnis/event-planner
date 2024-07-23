class Event < ApplicationRecord
  has_and_belongs_to_many :users

  validates :title, :country, :date, presence: true
  validates :lat, numericality: { in: -90..90 }
  validates :long, numericality: { in: -180..180 }
end
