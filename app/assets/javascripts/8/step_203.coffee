$ -> 
  try
    if $("#step-203").length > 0
      $(document).ajaxError () ->
        error = 'an error occured in the file'
        $.post('/lessons?type=ajax&id=203&error=' + error)
#content
      $(".bottom-forward").hide()
      
      getIndex = ()->
        tempIndex = parseInt(Math.random() * list.length)
        index = list[tempIndex]
        list.splice(tempIndex, 1)
        return index
      
      begin = () ->
        $("#answer-" + index).hide() for index in [1..3]
        $("#button-field").hide()
        $("#timer").hide()
        $("#error").hide()
        $("#error").html("")
      
      reset = () ->
        $("#button-field").hide()
        $("#submit-step-button").show()
        $("#timer").hide()
        $("#error").show()
        $("#error").html("You have finished the game. Press submit to see your score.")
      
      setTimer = () ->
        count = 10
        id =  setInterval () ->
          count--
          if count == 0
            $("#error").html("You ran out of time. Loading next question in 3 seconds")
            $("#error").show()
            time = 3
            count = 13
            $("#answer-" + object["index"]).find("[value='Timeout']").prop("checked", true)
            $("#answer-" + object["index"]).hide()
            $("#timer-field").hide()
            temp = setInterval () ->
              time--
              time = 0 if list.length == 0
              $("#error").html("You ran out of time. Loading next question in #{time} seconds") unless list.length == 0
              if time == 0
                clearInterval(temp)
                $("#timer-field").show()
                $("#error").html("")
                $("#error").hide()
                if list.length > 0
                  object["index"] = getIndex()
                  $("#answer-" + object["index"]).show()
                else
                  clearInterval(id)
                  reset()
      
            , (if list.length == 0 then 0 else 1000)
          $("#timer-field").html(count)
        ,1000
        return id
      
      list = []
      object = {index: 0}
      timer = ""
      begin()
      $("#begin-button").on 'click', (event) ->
        begin()
        $("#timer").show()
        list = [1, 2, 3]
        object["index"] = getIndex()
        $("#button-field").show()
        $(this).hide()
        $("#answer-" + object["index"]).show()
        timer = setTimer()
      
      process = (timer, value) ->
        $("#timer-field").html(10)
        clearInterval(timer)
        $("#answer-" + object["index"]).find("[value='" + value + "']").prop("checked", true)
        $("#answer-" + object["index"]).hide()  
        if list.length > 0
          object["index"] = getIndex()
          $("#answer-" + object["index"]).show()
          timer = setTimer()  
          return timer
        else
          $("#timer").hide()
          reset()
          return null
      
      $(".btn-success").on 'click', () ->
        timer = process(timer, "Yes")
      
      $(".btn-danger").on 'click', () ->
        timer = process(timer, "No")
#content
      document.passed='OK'
  catch e
    document.passed='error'
    array = e.stack.split('\n')[1].split(':')
    line_num = parseInt(array[array.length - 2]) - 7
    message = e.message + ' at line ' + line_num
    $.post('/lessons?type=coffee&id=203&error=' + message)
