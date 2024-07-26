class User < ApplicationRecord
  has_and_belongs_to_many :events
  has_secure_token :api_key

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable

  validates :api_key, uniqueness: true, presence: true

  def signed_up_for_event?(event)
    raise ArgumentError, "Invalid event" unless event.is_a?(Event)

    events.exists? event.id
  end

  # Toggles the user's subscription status for an event.
  # If the user is already signed up, it removes the subscription; otherwise, it adds a new subscription.
  def toggle_event!(event)
    signed_up_for_event?(event) ? events.delete(event) : events << event
  end
end
