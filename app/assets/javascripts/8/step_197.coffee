$ -> 
  try
    if $("#step-197").length > 0
      $(document).ajaxError () ->
        error = 'an error occured in the file'
        $.post('/lessons?type=ajax&id=197&error=' + error)
#content
      index = 0
      $("#answer-1").hide()
      $("#answer-2").hide()
      $("#answer-3").hide()
      $("#submit-step-button").hide()
      answers = ["OfVNU6DUQ4cEcn_FuDQHZQ", "qP2h4GmEVvuRO5i0b5-R9A", "70T1qF3cEa7vJTBZOP7mVw"]
      $(".bottom-forward").on "click", (event) ->
        index++
        $("#answer-" + index).show()
        $("#answer-" + index).find("#answer-field-1").val(answers[index - 1])
        setTimeout(( () -> window.location.hash = "#answer-" + index), 100)
        if index == 3
          $("#submit-step-button").show()
          $(".bottom-forward").hide()
      
      $(".edit_user_progress").on "submit", (event) ->
        unless index >= 3
          event.preventDefault()
#content
      document.passed='OK'
  catch e
    document.passed='error'
    array = e.stack.split('\n')[1].split(":")
    line_num =  parseInt(array[array.length - 2]) - 13
    message = e.message + ' at line ' + line_num
    $.post('/lessons?type=coffee&id=197&error=' + message)
