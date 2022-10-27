// src/controllers/hello_controller.js
import { Controller } from "@hotwired/stimulus"
import { end } from "@popperjs/core";

export default class extends Controller {
  connect() {
    console.log("Hello, Stimulus!")
    console.log(gon.result)
    document.querySelector("#consultation_date_time").addEventListener('change', function(e) {
      let date = document.querySelector("#consultation_date_time").value
      console.log(date)

      // enable all buttons.

      // translate all date-times to current.
      // Select all js items with the same date.
      // If none, return.

      // gon.result[0].start.date_time

      // Check js items start and end dates against each button.
      // If js item is within or equal to the button dates. Disable button.
      //   If js item start is >= button start & <= button end
      //     disable
      //   if js item start date is <= button start & js item end date >= button end
      //     disable
      //   if js  item end date is >= button start & <= button end
      //     enable

      // each do
      // document.querySelectorAll(".consultbtn")
      // if

      // .getAttribute('data-time')


        // if (event.target.className == 'btn fa-regular fa-bookmark text-primary') {
        //   event.target.outerHTML="<% bm=Bookmark.new %> <% bm.user = current_user %> <% bm.workshop = workshop %> <% bm.save %><i class=\"fa-solid fa-bookmark text-primary\"></i>"
        // }else if (event.target.className == 'btn fa-solid fa-bookmark text-primary') {
        //   event.target.outerHTML="<% bm=current.bookmarks.find_by workshop:workshop %> <% bm.destroy %><i class=\"fa-regular fa-bookmark text-primary\"></i>"
    // }
    });

  }
  greet(event){
    console.log(event)
  };
}
