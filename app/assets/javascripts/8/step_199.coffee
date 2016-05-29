$ -> 
  try
    if $("#step-199").length > 0
      $(document).ajaxError () ->
        error = 'an error occured in the file'
        $.post('/lessons?type=ajax&id=199&error=' + error)
#content
      index = 0
      $("#answer-" + i).hide() for i in [1..6]
      $(".answer-" + i).hide() for i in [2..4]
      $("#answer-" + i + "-label").hide() for i in [2..5]
      $("#submit-step-button").hide()
      answers = ["mEZrAN0DOH3CX2JxmFi62w", "UjLrTON6JD6cL7vF1wnLRQ", "feRjHNzpzuu1E8XDMcrxyg", "m6r0WmcmRCdm5Ma3YQJODw", "w_PcqqGWnwBLbHUe5CqcfA", "sbgWUE60yEAIFJXZ59E4dA"]
      $(".bottom-forward").on "click", (event) ->
        index++
        $("#answer-" + index).show()
        $(".answer-" + index).show()
        $("#answer-" + index + "-label").show()
      
        if $("#answer-" + index + "-label").length > 0
          setTimeout(( () -> window.location.hash = "#answer-" + index + "-label"), 100)
        else
          setTimeout(( () -> window.location.hash = "#answer-" + index), 100)
        $("#answer-" + index).find("#answer-field-1").val(answers[index - 1])
        if index == 6
          $("#submit-step-button").show()
          $(".bottom-forward").hide()
#content
      document.passed='OK'
  catch e
    document.passed='error'
    array = e.stack.split('\n')[1].split(":")
    line_num =  parseInt(array[array.length - 2]) - 13
    message = e.message + ' at line ' + line_num
    $.post('/lessons?type=coffee&id=199&error=' + message)
