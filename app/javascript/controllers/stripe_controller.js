import { Controller } from 'stimulus';
export default class extends Controller {
  static targets = [ "linkbtn", "video" ]

  play(event) {
    event.preventDefault()
    this.linkbtnTarget.style.opacity = '100%'
    this.videoTarget.style.display = ''
  }
}
