import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="day-focus"
export default class extends Controller {
  connect() {
  }

  scroll(event) {
    const day = event.target.dataset.day
    // console.log(day)
    const div = document.getElementById(day)
    // console.log(div)
    const navbarHeight = document.querySelector(".navbar-lewagon").clientHeight;
    window.scroll({
      top: div.offsetTop-(navbarHeight),
      left: 0,
      behavior: "smooth"
    })
  }
}
