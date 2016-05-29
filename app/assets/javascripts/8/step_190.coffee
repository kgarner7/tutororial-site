$ -> 
  try
    if $("#step-190").length > 0
      $(document).ajaxError () ->
        error = 'an error occured in the file'
        $.post('/lessons?type=ajax&id=190error=' + error)
#content
      index = 0
      $("#submit-step-button").hide()
      $(".bottom-previous").hide()
      reset = false
      locations = {1:{}, 2:{left: '800px', top: '80px'}, 3:{left: '220px', top: '300px'}, 4:{top: "450px", left: "825px"}, 5:{left: "185px", top: "0px"}}
      values = ["fG_bVBdFZte3jmzyHZlvHA", "JJ0aAFbUMSI8QRpDKfqSTw", "XimPOQhmDxSCoOCbLQ15yQ", "8Yr-2oa47dfHARcOyqSNTg", "zImuJDXs44AKTcwAa5vGMw", "DbdTfTXIjsExiM6IFqYVgA"]
      $("#answer-1").hide()
      $("#answer-2").hide()
      $("#answer-3").hide()
      $("#answer-4").hide()
      $("#answer-5").hide()
      $("#answer-6").hide()
      $(".bottom-forward").on "click", (event) ->
        index++
        if reset
          index = 6
          $("#question").css("opacity", 1)
          $("#answer-6").css("opacity", 1)
          $("#answer-6").show()
          $("#answer-" + index).find("#answer-field-1").val(values[index - 1])
          setTimeout(( () -> window.location.hash = "#question"), 50)
          $("#submit-step-button").show()
          return
      
        $("#answer-" + index).show()
        $("#answer-" + index).find("#answer-field-1").val(values[index - 1])
        if reset
          setTimeout(( () -> window.location.hash = "#image-1"), 50)
          return
        $("#bob").animate(locations[index])
      
        if index > 4
          index = 1
          reset = true
          setTimeout(( () -> window.location.hash = "#image-1"), 50)
        else if index != 1
          setTimeout(( () -> window.location.hash = "#image-" + index), 50)
      
#content
      document.passed = "OK"
  catch e
    document.passed='error'
    array = e.stack.split('\n')[1].split(":")
    line_num =  parseInt(array[array.length - 2]) - 13
    message = e.message + ' at line ' + line_num
    $.post('/lessons?type=coffee&id=190&error=' + message)
