# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if $("#wrapper2").length > 0
    $("#wrapper2").height(document.documentElement.offsetHeight - $("#header-wrapper").outerHeight() - $("#copyright").outerHeight())
    $(".main-form").height($("#wrapper2").height())
  if $(".step-field").length > 0
    $(".step-field").height(document.documentElement.offsetHeight - $("#header-wrapper").outerHeight() - 140)