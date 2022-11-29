import { Controller } from "@hotwired/stimulus"


// Connects to data-controller="navbar"
export default class extends Controller {
  connect() {
    console.log('connect');
  }

  updateNavbar() {
    console.log('scroll');
    if (window.scrollY >= 100) {
      this.element.classList.add("navbar-lewagon-white")
    } else {
      this.element.classList.remove("navbar-lewagon-white")
    }
  }
}
