$ -> 
  try
    if $("#step-196").length > 0
      $(document).ajaxError () ->
        error = 'an error occured in the file'
        $.post('/lessons?type=ajax&id=196&error=' + error)
#content
      index = 0
      $("#answer-" + i).hide() for i in [1..4]
      $("#submit-step-button").hide()
      answers = ["Gi4lEzGBEAP9JBVuTplRAA", "4Z7PFrBbwS4O9_t88L7CzQ", "Dr1yjj1QQzs48SK-vVD0DQ", "muKvKwJIf07bWE6rYMBmPQ"]
      $(".bottom-forward").on "click", (event) ->
        index++
        $("#answer-" + index).show()
        $("#answer-" + index).find("#answer-field-1").val(answers[index - 1])
        setTimeout(( () -> window.location.hash = "#answer-" + index), 100)
        if index == 4
          $("#submit-step-button").show()
      
      $(".edit_user_progress").on "submit", (event) ->
        unless index >= 4
          event.preventDefault()
#content
      document.passed='OK'
  catch e
    document.passed='error'
    array = e.stack.split('\n')[1].split(":")
    line_num =  parseInt(array[array.length - 2]) - 13
    message = e.message + ' at line ' + line_num
    $.post('/lessons?type=coffee&id=196&error=' + message)
