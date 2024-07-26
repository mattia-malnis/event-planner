module ApplicationHelper
  def alert_error(messages, title = "")
    return if messages.blank?

    messages = messages.join("<br>") if messages.is_a? Array

    content_tag :div, class: "bg-red-100 border-l-4 border-red-500 text-red-700 p-4", role: "alert" do
      concat content_tag :p, title, class: "font-bold" if title.present?
      concat content_tag :p, messages.html_safe
    end
  end

  def to_date(date)
    return if date.blank?

    date.strftime("%b %d, %Y")
  end

  def to_datetime(date)
    return if date.blank?

    date.strftime("%b %d, %Y - %H:%M")
  end

  def menu_item(name, path, link_options = {})
    link_class = controller_matches?(path) ? "text-indigo-600" : ""
    content_tag(:li) do
      link_to path, link_options.merge(class: [ "flex-none group relative block transition duration-300 px-3 py-2.5 hover:text-indigo-600", link_class ]) do
        safe_join([
          name,
          content_tag(:span, "", class: "absolute inset-x-1 h-px bg-gradient-to-r from-indigo-500/0 from-10% via-indigo-400 to-indigo-500/0 to-90% transition duration-300 -bottom-0.5 opacity-0 scale-x-0 group-hover:opacity-100 group-hover:scale-x-100"),
          content_tag(:span, class: "overflow-hidden absolute inset-0 transition origin-bottom duration-300 opacity-0 scale-0 group-hover:opacity-100 group-hover:scale-100") do
            content_tag(:span, "", class: "absolute inset-x-4 -bottom-2 h-full bg-gradient-to-t from-indigo-500/20 to-transparent blur rounded-t-full")
          end
        ])
      end
    end
  end

  def controller_and_action_for_path(path)
    # The route "destroy_user_session | DELETE /users/sign_out(.:format) | devise/sessions#destroy"
    # is not recognized but is not a problem because we don't need it on the menu
    Rails.application.routes.recognize_path(path)
  rescue ActionController::RoutingError
    {}
  end

  def controller_matches?(path)
    recognized = controller_and_action_for_path(path)
    recognized[:controller] == controller_name
  end
end