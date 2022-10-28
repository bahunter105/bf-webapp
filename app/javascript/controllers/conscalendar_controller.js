import { Controller } from "@hotwired/stimulus"
import { end } from "@popperjs/core";

export default class extends Controller {
  connect() {
    // console.log("Hello, Stimulus!")
    // console.log(gon.result)
    document.querySelector("#consultation_date_time").addEventListener('change', function(e) {
      let date_string = document.querySelector("#consultation_date_time").value.toString()
      let yr = date_string.slice(0,4)
      let mo = date_string.slice(5,7) - 1
      let day = date_string.slice(8,10)
      let today = new Date(yr, mo, day)

      // Show & enable all buttons.
      let consultbtns = document.querySelectorAll(".consultbtn")
      consultbtns.forEach((btn) => {
        btn.style.display = "";
        btn.disabled = false
      })

      new Date(document.querySelector("#consultation_date_time").value).toDateString() ==
      new Date(gon.result[0].start.date_time).toDateString()

      // translate all date-times to current.
      // Select all js items with the same date.
      let todays_consultations = []
      gon.result.forEach((consultation) => {
        let start_date = new Date(consultation.start.date_time)
        let end_date = new Date(consultation.end.date_time)

        if (start_date.toDateString() == today.toDateString() || end_date.toDateString() == today.toDateString()) {
          todays_consultations.push(consultation)
        }
      })

      // If none, return.
      if (todays_consultations.length == 0) return null

      // Check js items start and end dates against each button.
      // If js item is within or equal to the button dates. Disable button.
      //   If js item start is >= button start & <= button end
      //     disable
      //   if js item start date is <= button start & js item end date >= button end
      //     disable
      //   if js  item end date is >= button start & <= button end
      //     enable

      todays_consultations.forEach((consultation) => {
        let cons_start_date = new Date(consultation.start.date_time)
        let cons_end_date = new Date(consultation.end.date_time)
        consultbtns.forEach((btn) => {
          let btn_start_date = new Date(btn.getAttribute('data-time'))
          btn_start_date.setFullYear(yr);
          btn_start_date.setMonth(mo);
          btn_start_date.setDate(day);
          let btn_end_date = new Date(btn_start_date)
          btn_end_date.setHours(btn_end_date.getHours() + 1);
          if (cons_start_date >= btn_start_date && cons_start_date < btn_end_date) {
            btn.disabled = true
          } else if (cons_start_date <= btn_start_date && cons_end_date >= btn_end_date) {
            btn.disabled = true
          } else if (cons_end_date > btn_start_date && cons_start_date < btn_end_date) {
            btn.disabled = true
          }
        })
      })
    });

  }
  greet(event){
    console.log(event)
  };
}
