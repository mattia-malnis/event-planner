module ApplicationHelper
  def alert_error(messages, title = "")
    return if messages.blank?

    messages = messages.join("<br>") if messages.is_a? Array

    content_tag :div, class: "bg-red-100 border-l-4 border-red-500 text-red-700 p-4", role: "alert" do
      concat content_tag :p, title, class: "font-bold" if title.present?
      concat content_tag :p, messages.html_safe
    end
  end
end
