import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="autosubmit"
export default class extends Controller {
  static targets = ["submit"];

  onSelectChange() {
    this.handleInput();
  }

  handleInput = () => {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.element.requestSubmit();
    }, 500);
  };
}
