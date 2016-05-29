$ -> 
  try
    if $("#step-201").length > 0
      $(document).ajaxError () ->
        error = 'an error occured in the file'
        $.post('/lessons?type=ajax&id=201&error=' + error)
#content
      $("#answer-" + i).hide() for i in [1..8]
      $("#text-" + i).hide() for i in [2..6]
      index = 0
      answers = ["IH8IvLQq1asi8XhH1FoOxw", "3mjpLGw60J6l6p-NSa8DHA", "IBd_rXlkuQyerRutZ1WKGA", "2PH8ZK6mkkvNr0f1rVlScQ", "lK6Mtq8fkUbsDfPgJ-JX4w", "qQX5GIt2og4a9tWJYkDWEQ", "JxiL8JbLX9qCvvZRLyN7cg", "AZQqsM8T9gHtCTN20iNrGQ"]
      $(".bottom-forward").on "click", (event) ->
        index++
        $("#answer-" + index).show()
        $("#answer-" + index).find("#answer-field-1").val(answers[index - 1])
        $("#text-" + index).show()
        setTimeout(( () -> window.location.hash = "#answer-" + index), 100)
        if index == 8
          $("#submit-step-button").show()
      
      $(".edit_user_progress").on "submit", (event) ->
        unless index >= 8
          event.preventDefault()
#content
      document.passed='OK'
  catch e
    document.passed='error'
    array = e.stack.split('\n')[1].split(':')
    line_num = parseInt(array[array.length - 2]) - 7
    message = e.message + ' at line ' + line_num
    $.post('/lessons?type=coffee&id=201&error=' + message)
