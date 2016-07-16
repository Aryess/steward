# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

refresh_mp = (link) ->
  console.log(link)
  $.ajax
    type: "POST"
    url: "/reddit/" + link.getAttribute("data-account-id") + "/refresh"

  spin_and_wait link

refresh_all = ->
  console.log "hello"
  $.ajax
    type: "POST"
    url: "/reddit/refresh"

  $(".refreshMp").each (i, link) ->
    spin_and_wait link

spin_and_wait = (link) ->
  link.className += " refreshing"
  poll_for_update link.getAttribute("data-account-id"), link.getAttribute("data-last-modified"), link

poll_for_update = (account_id, last_modified, link) ->
  setTimeout (->
    $.ajax(
      type: "GET"
      url: "/accounts/" + account_id + ".json"
      headers:
        "If-Modified-Since": last_modified
    ).done (transport) ->
      if !transport || transport.status is 304
        poll_for_update account_id, last_modified, link
      else if transport
        hasmail = (if transport.has_notif then 'havemail' else 'nohavemail')
        console.log transport    
        console.log(transport.login + ': ' + hasmail)
        $('#acc_' + account_id + ' > a.mail')[0].className = 'refreshMp mail ' + hasmail
        $($('#acc_' + account_id + ' > a.mail')[0]).attr({'data-last-modified': transport.updated_at })
      else
        console.log ("tant pis")
        link.innerHTML = "error"

  ), 1000

$ ->
   $("a[data-account-id].refreshMp").click (e) ->
     e.preventDefault()
     refresh_mp(this)
  
   $("button.refreshMpAll").click (e) ->
     console.log "button clicked"
     refresh_all()
