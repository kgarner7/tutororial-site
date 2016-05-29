@resizeWrapper = () ->
  if $("#wrapper2").length > 0
    $("#wrapper2").height(document.documentElement.offsetHeight - $("#header-wrapper").outerHeight() - $("#copyright").outerHeight())
    $(".main-form").height($("#wrapper2").height())
  if $(".step-field").length > 0
    $(".step-field").height(document.documentElement.offsetHeight - $("#header-wrapper").outerHeight() - 140)

@doStuff = () ->
  document.index++
  index = document.index
  $("#answer_0_answer").attr({"name": "answer[" + index + "][answer]", "id": "answer_" + index + "_answer"})
  $("#answer_0_index").attr({"name": "answer[" + index + "][index]", "id": "answer_" + index + "_index", "value": index})
  $("#answer_0_correct").attr({"name": "answer[" + index + "][correct]", "id": "answer_" + index + "_correct"})
  $("[name='answer[0][correct]']").attr("name", "answer[" + index + "][correct]")
  $("#remove-answer-button-0").attr("id", "remove-answer-button-" + index)
  $("#remove-answer-button-" + index).on "click", (event) ->
    removeIndex = parseInt($(this).attr("id").replace("remove-answer-button-",""))
    $(this).parent().parent().remove()
    console.log $(this)
    document.index--
    $("[type='number'].col-xs-5").filter( () -> 
        return parseInt($(this).attr("id").replace("answer_","").replace("_index", "")) > removeIndex;
    ).each( () ->
      $(this).val($(this).val() - 1 )
    )
  

$ ->
  setTimeout(resizeWrapper(), 50)
  $(".step-action-form").on "submit", (event) ->
    count = 0
    $("[type=checkbox]").each () ->
      if $(this).prop("checked")
        count++
    if count == 0 && $("#step_action_action_type").val() != "multiple-select"
      $(".errors-content").html("You must select one correct answer")
      event.preventDefault()
    else if count > 1 && $("#step_action_action_type").val() != "multiple-select"
      $(".errors-content").html("You cannot have more than one correct answer")
      event.preventDefault()
      
  $("#step-modal").on "show.bs.modal", (event) ->
    source = $(event.relatedTarget)
    $(this).find("#step_name").val(source.data("name")) if source.data("name")?
    $(this).find("#step_index").val source.data("index")
    $(this).find(".step-form").attr("action", source.data("path"))
    
  $("#step-modal").on "hide.bs.modal", (event) ->
    $(this).find("#step_name").val ""
    
  $("#step_action_action_type").on "change", (event) ->
    if $(this).val().indexOf("multiple") == -1
      $("#add-answer-button").hide()
      $(".alternate").remove()
      $(".correct-field").hide()
    else
      $("#add-answer-button").show()
      $(".correct-field").show()
    if $(this).val() == "content"
      $(".answer-value").attr("required", false)
      $(".main-answer-fields").hide()
    else
      $(".answer-value").attr("required", true)
      $(".main-answer-fields").show()
        
  $("#step-action-modal").on "hide.bs.modal", (event) ->
    document.index = 1
    $("#add-answer-button").off "click"
  
  $(".file-field").on "focus", () ->
    $(".edit-box").hide()
    $(this).parent().show()
    $(this).parent().width("68%")
    $(this).parent().height("68%")
    
  $(".file-field").on "blur", () ->
    $(this).parent().height("18%")
    $(this).parent().width("1%")
    $(".edit-box").show()
    
  if $("#upload-result").length > 0
    $("#upload-image-modal").modal("show")
        
  $("#lesson-modal").on "show.bs.modal", (event) ->
    source = $(event.relatedTarget)
    $("#name").val(source.data("name"))
    $("#lesson-form").attr("action", source.data("path"))
    if source.data("removePath") == ""
      $(".remove-button").hide()
      $(".view-button").hide()
    else
      $(".remove-button").attr("href", source.data("removePath"))
      $(".view-button").attr("href", source.data("showPath"))
    $("[name='commit']").val(source.data("message"))
    
  $("#lesson-modal").on "hide.bs.modal", (event) ->
    $("#name").val("")
    $("#lesson-form").attr("action", "") 
    $(".remove-button").attr("href", "")
    $(".view-button").attr("href", "")
    $(".remove-button").show()
    $(".view-button").show()
    
  $("#submit-step-button").hide()
$( window ).resize () ->
  resizeWrapper()