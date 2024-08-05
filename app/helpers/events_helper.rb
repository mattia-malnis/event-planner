module EventsHelper
  def temp_details(humidity, min, max)
    text = []
    text << "Temperature: #{min}°C to #{max}°C" if min.present? && max.present?
    text << "Humidity: #{humidity}%" if humidity.present?
    text.join(", ")
  end

  def date(event)
    return if event.blank?

    r = [ to_datetime(event.date_start), to_datetime(event.date_end) ]
    safe_join(r.compact_blank, tag.br)
  end

  def subscribed_mark(event)
    return if event.blank?
    return unless current_user.signed_up_for_event?(event)

    inline_svg_tag("check-circle.svg", class: "size-6 absolute text-white drop-shadow-md right-2.5 top-2.5")
  end

  def action_button(event)
    return unless event.open_for_registration?

    if current_user.signed_up_for_event?(event)
      button_to "Cancel registration", toggle_subscription_event_path(event), class: "py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-red-600 hover:bg-red-700"
    else
      button_to "Sign Up Now", toggle_subscription_event_path(event), class: "py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700"
    end
  end
end
