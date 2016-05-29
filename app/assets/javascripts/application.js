// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//=require_tree

function setClass(element, className, add){
	if (element.attr("class") == null){
		if (add){
			element.attr("class", className);
		}
	}
	else if (element.attr("class").search(className) == -1 && add){
		element.attr("class", (element.attr("class").length == 0 ? "": " ") + className);
	}
	else if (element.attr("class").search(className) != -1 && !add){
		element.attr("class", element.attr("class").replace(className, ""));
	}
}

function displayError(field, text, location){
	field.attr({
		"data-title": text,
		"data-toggle": "tooltip",
		"data-placement": location,
		"data-trigger": "manual"
	});
	field.tooltip();
	field.tooltip("show");
	setClass(field, "errors", true);
	
	setTimeout(function() {
		field.tooltip("hide");
		setClass(field, "errors", false);

	}, 3000);
}