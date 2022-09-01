import { Controller } from 'stimulus';
export default class extends Controller {
  static targets = [ "bmicon" ]

  savetoggle(event) {
    event.preventDefault()
    console.log(event.target.className)
    // this.linkbtnTarget.style.opacity = '100%'
    // this.videoTarget.style.display = ''
    if (event.target.className == 'btn fa-regular fa-bookmark text-primary') {
      event.target.outerHTML="<% bm=Bookmark.new %> <% bm.user = current_user %> <% bm.workshop = workshop %> <% bm.save %><i class=\"fa-solid fa-bookmark text-primary\"></i>"
    }else if (event.target.className == 'btn fa-solid fa-bookmark text-primary') {
      event.target.outerHTML="<% bm=current.bookmarks.find_by workshop:workshop %> <% bm.destroy %><i class=\"fa-regular fa-bookmark text-primary\"></i>"
    }
  }
}
