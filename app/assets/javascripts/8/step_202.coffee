$ -> 
  try
    if $("#step-202").length > 0
      $(document).ajaxError () ->
        error = 'an error occured in the file'
        $.post('/lessons?type=ajax&id=202&error=' + error)
#content
      index = 0
      $("#answer-" + i).hide() for i in [1..10]
      $("#content-" + i).hide() for i in [3..10]
      answers = ["9fWGsiJ_byjN11g4yCe-ZA", "9Q-P9lCMK8rD2YxrDHmh5Q", "jWnlZXaNS5k_WQlE1-QgFA", "BsKc8t_tplKlMeTB8kIOig", "FsAmbYHpOV0Gh_6UozAQQA", "CpBSdkya4rsi-Db0mahTuw", "zvQkU2ADqbZtlWDNvKiFVw", "Q8uj1MbiBIZL0AgRGH-_wg", "M4y-sdJ4Qr2jxFN-Ji9y0g", "CMDM-9HRPdfx9EdvwN7fIw"]
      $(".bottom-forward").on "click", (event) ->
        index++
        $("#answer-" + index).show()
        $("#answer-" + index).find("#answer-field-1").val(answers[index - 1])
        $("#content-" + index).show()
        if index == 5
          setTimeout( ( () -> window.location.href = "#stuff"), 50) 
        else
          setTimeout( ( () -> window.location.href = "#answer-" + index), 50) 
        if index == 10
          $("#submit-step-button").show()
#content
      document.passed='OK'
  catch e
    document.passed='error'
    array = e.stack.split('\n')[1].split(':')
    line_num = parseInt(array[array.length - 2]) - 7
    message = e.message + ' at line ' + line_num
    $.post('/lessons?type=coffee&id=202&error=' + message)
