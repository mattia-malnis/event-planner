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
end
