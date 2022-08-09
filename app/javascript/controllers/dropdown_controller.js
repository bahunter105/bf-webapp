import * as bootstrap from 'bootstrap'

import { Controller } from 'stimulus';
export default class extends Controller {

  connect() {
    var dropdownTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="dropdown"]'))
    var dropdownList = dropdownTriggerList.map(function (dropdownTriggerEl) {
      return new bootstrap.Dropdown(dropdownTriggerEl)
    })
  }
}
