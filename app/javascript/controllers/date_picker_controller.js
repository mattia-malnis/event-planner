import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

// Connects to data-controller="date-picker"
export default class extends Controller {
  connect() {
    const config = {
      mode: "range",
      onChange: this.onChange.bind(this),
    };
    this.fp = flatpickr(this.element, config);
  }

  disconnect() {
    this.fp.destroy();
  }

  onChange(selectedDates, _dateStr, _instance) {
    // we need a range, dispatch the event only when 2 dates are selected
    if (selectedDates.length == 2) {
      const event = new Event("change", { bubbles: true });
      this.element.dispatchEvent(event);
    }
  }
}
