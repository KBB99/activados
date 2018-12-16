App.room = App.cable.subscriptions.create "MessagingRoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server
  
  received: (data) ->
    unless data.message.blank?
      $('#messages-table').append data.message

$(document).on 'turbolinks:load', ->
  submit_message()
  scroll_bottom()

submit_message = () ->
  $('#message_body').on 'keydown', (event) ->
    if event.keyCode is 13 && !event.shiftKey
      $('#chat-send').click()
      event.target.value = ""
      event.preventDefault()

scroll_bottom = () ->
  $('#messages-table').scrollTop($('#messages-table')[0].scrollHeight)