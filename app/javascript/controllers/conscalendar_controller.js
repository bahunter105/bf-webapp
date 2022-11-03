import { Controller } from "@hotwired/stimulus"
import { end } from "@popperjs/core";
import flatpickr from "flatpickr"
require("flatpickr/dist/flatpickr.css")

export default class extends Controller {
  connect() {
    // console.log("Hello, Stimulus!")
    // console.log(gon.result)

    // connect date picker
    flatpickr("[data-behavior='flatpickr']",{
      altInput: true,
      altFormat: "F j, Y",
      dateFormat: "Y-m-d",
      // minDate: "today",
      minDate: new Date().fp_incr(1),
      maxDate: new Date().fp_incr(180), // 180 days from now
    })

    let consultbtns = document.querySelectorAll(".consultbtn")
    consultbtns.forEach((btn) => {
      let hidden_input = btn.parentElement.querySelectorAll('input')[2]
      hidden_input.setAttribute('name', 'consult_category')
      hidden_input.setAttribute('value', gon.category)

      hidden_input = btn.parentElement.querySelectorAll('input')[3]
      hidden_input.setAttribute('name', 'notes')
    })
    // set listener event for notes
    document.querySelector('#textarea1').addEventListener('keyup', function(e) {
      // console.log(e.target.value)
      let consultbtns = document.querySelectorAll(".consultbtn")
      consultbtns.forEach((btn) => {
        btn.parentElement.querySelectorAll("input")[3].setAttribute("value", e.target.value)
      })
    })

    // add event listener to date picker
    document.querySelector("#consultation_date_time").addEventListener('change', function(e) {
      let date_string = document.querySelector("#consultation_date_time").value.toString()
      let yr = date_string.slice(0,4)
      let mo = date_string.slice(5,7) - 1
      let day = date_string.slice(8,10)
      let today = new Date(yr, mo, day)

      // Show & enable all buttons. Update hidden form fields with correct time and timezone
      let consultbtns = document.querySelectorAll(".consultbtn")
      const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
      let tznumber = today.getTimezoneOffset()/60 * -1
      let tz_string
      if (tznumber >= 0 && tznumber < 10) {
        tz_string = ` GMT+0${tznumber}00`
      } else if (tznumber > 10){
        tz_string = ` GMT+${tznumber}00`
      } else if (tznumber <= -10) {
        tz_string = ` GMT${tznumber}00`
      } else {
        tz_string = ` GMT-0${-1*tznumber}00`
      }

      // Update hidden values on the consultation buttons.
      consultbtns.forEach((btn) => {
        btn.style.display = "";
        let hidden_input = btn.parentElement.querySelectorAll('input')[1]
        let st = hidden_input.getAttribute('id')
        hidden_input.setAttribute('name', 'date_time')
        let value_date_st = `${yr}-${mo+1}-${day}${st.slice(29,38)}${tz_string}`
        hidden_input.setAttribute('value', value_date_st)

        let date_st = value_date_st.slice(0,19)
        let in_twentyfour_hours = new Date()
        in_twentyfour_hours.setHours(in_twentyfour_hours.getHours()+24)
        let btn_start_date = new Date(date_st)

        if (btn_start_date <= in_twentyfour_hours) {
          btn.disabled = true
        } else {
          btn.disabled = false
        }
      })

      // If none, return.
      if (gon.result.length == 0) return null

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
          let hidden_input = btn.parentElement.querySelectorAll('input')[1]
          let date_st = hidden_input.getAttribute('value').slice(0,19)
          let btn_start_date = new Date(date_st)
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
