class Event < ApplicationRecord
  include ImageUploadable

  has_and_belongs_to_many :users
  belongs_to :country

  validates :title, length: { maximum: 255 }
  validates :title, :date_start, :city, presence: true
  validates :lat, numericality: { in: -90..90 }
  validates :long, numericality: { in: -180..180 }
  validate :end_date_after_start_date, if: -> { date_end.present? }

  scope :upcoming, -> { where("date_start >= ?", Time.current) }
  scope :past, -> { where("date_start < ?", Time.current) }
  scope :ordered, -> { order(date_start: :asc) }

  def self.ordered_with_country
    select("events.id, events.title, events.date_start, events.city, events.country_id, countries.name AS country_name")
    .with_attached_image
    .eager_load(:country)
    .ordered
  end

  def open_for_registration?
    date_end.present? ? Time.current <= date_end : Time.current <= date_start
  end

  private

  def end_date_after_start_date
    return if date_start.blank? || date_end.blank?

    if date_end < date_start
      errors.add(:date_end, "must be after the start date")
    end
  end
end
