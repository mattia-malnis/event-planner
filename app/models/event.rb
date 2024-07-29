class Event < ApplicationRecord
  has_and_belongs_to_many :users
  belongs_to :country

  validates :title, length: { maximum: 255 }
  validates :title, :date_start, :city, presence: true
  validates :lat, numericality: { in: -90..90 }
  validates :long, numericality: { in: -180..180 }
  validate :end_date_after_start_date, if: -> { date_end.present? }

  def self.ordered
    order(:date_start)
  end

  def country_name
    country.name
  end

  private

  def end_date_after_start_date
    return if date_start.blank? || date_end.blank?

    if date_end < date_start
      errors.add(:date_end, "must be after the start date")
    end
  end
end
