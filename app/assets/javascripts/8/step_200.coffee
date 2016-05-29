$ -> 
  try
    if $("#step-200").length > 0
      $(document).ajaxError () ->
        error = 'an error occured in the file'
        $.post('/lessons?type=ajax&id=200&error=' + error)
#content
      $("#submit-step-button").hide()
      match = {48:49, 49:48, 50:52, 52:50, 51:53, 53:51, 54:55, 55:54}
      success = 0
      relation = {}
      relation[i] = 0 for i in [1..8]
      positions = [1..8]
      flipped = []
      $("#game-field").hide()
      $("#begin-button").on "click", () ->
        $("#game-field").show()
        $("#begin-field").hide()
      for i in [48..55]
        index = parseInt(Math.random() * positions.length)
        relation[positions[index]] = i
        $("#image-" + i).attr("id", "image-" + positions[index])
        positions.splice(index, 1)
      
      for id in [1..8]
        $("#image-" + id).on "click", () ->
          id = parseInt($(this).attr("id").replace("image-", ""))
          if flipped.length < 2
            flipped.push id
            $(this).find(".flipper").css("transform", "rotateY(180deg)")
            if flipped.length == 2
              setTimeout( () ->
                unless match[relation[flipped[0]]] ==relation[flipped[1]]
                  $("#image-" + flipped[0]).find(".flipper").css("transform", "rotateY(0deg)")
                  $("#image-" + flipped[1]).find(".flipper").css("transform", "rotateY(0deg)")
                else
                  success++
                  if success == 4
                    $("#answer-1").find("#answer-field-1").val("rDoU1Ve6ZEPqAYCewwVyVg")
                    $("#submit-step-button").show()
                flipped.pop() for i in [1..2]
              , 1500)
#content
      document.passed='OK'
  catch e
    document.passed='error'
    array = e.stack.split('\n')[1].split(":")
    line_num =  parseInt(array[array.length - 2]) - 13
    message = e.message + ' at line ' + line_num
    $.post('/lessons?type=coffee&id=200&error=' + message)
