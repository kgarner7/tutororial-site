$ -> 
  try
    if $("#step-198").length > 0
      $(document).ajaxError () ->
        error = 'an error occured in the file'
        $.post('/lessons?type=ajax&id=198&error=' + error)
#content
      index = 0
      count = 0
      $("#submit-step-button").hide()
      $("#questions").hide()
      $("#answer").hide()
      $(".bottom-forward").hide()
      questions = {
      1:{
      "Is there a vertex of degree 0?": "yes", 
      "What is the degree of vertex B?": 1, 
      "What is the degree of vertex D?": 2
      },
      2:{
      "Is there more than one vertex of degree two?": "yes", 
      "Are vertices A and B adjacent?": "yes",
      "Are vertices A and C adjacent?": "yes",
      "Are vertices A and D adjacent?": "yes",
      "What is the degree of vertex B?": 2, 
      "What is the degree of vertex D?": 2
      },
      3: {
      "Is there more than one vertex of degree two?": "yes", 
      "Are vertices A and B adjacent?": "yes",
      "Are vertices A and D adjacent?": "yes",
      "What is the degree of vertex B?": 2, 
      "What is the degree of vertex D?": 2
      },
      4: {
      "Is there a vertex of degree 0?": "yes", 
      "What is the degree of vertex B?": 1, 
      "What is the degree of vertex D?": 1
      }
      }
      
      $("#begin-button").on "click", (event) ->
        $(this).hide()
        $("#questions").show()
        index = parseInt(Math.random() * 4) + 1
        $(".questions-field").html("")
      
      $(".question").on "click", (event) ->
        count++
        string = $(this).html()
        if questions[index][string]?
          string = "<strong>" + string + "</strong>  " + questions[index][string]
        else
          string = "<strong>" + string + "</strong>  no"
        if $(".questions-field").html() == ""
          $(".questions-field").html(string)
        else
          $(".questions-field").html($(".questions-field").html() + "<br>" + string)
        $("." + $(this).attr("class").split(" ")[1]).attr("disabled", true)
        if count == 3
          $("#questions").hide()
          $("#answer").show()
          $(".answer").on "click", () ->
            if parseInt($(this).val()) == index
              $("#answer-1").find("#answer-field-1").val("sMOrNN8tfmdZyMNNBzLo4w")
            $(".questions-field").html("Are you correct? Press submit to find out")
            $("#submit-step-button").show()
            $(".answer").off "click"
      
      $(".questions-field").on "change", (event) ->
        $(".questions-field").html("That choice is incorrect. The correct graph is <strong>Graph " + index + "</strong>")
        count = 0
        $("#begin-button").show()
      
      $(".edit_user_progress").on "submit", (event) ->
        unless count >= 3
          event.preventDefault()
#content
      document.passed='OK'
  catch e
    document.passed='error'
    array = e.stack.split('\n')[1].split(":")
    line_num =  parseInt(array[array.length - 2]) - 13
    message = e.message + ' at line ' + line_num
    $.post('/lessons?type=coffee&id=198&error=' + message)
