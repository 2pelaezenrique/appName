  var setClasification = function(){
    window.clasification = [];
    var MathsJSON = <%= raw @Maths %>;
    if ($( ".subjectSelector select option:selected").text() == "Matematicas") {
      window.clasification = MathsJSON;
    };
  };

  var setSchools = function(){
    window.schools = <%= raw @Schools %>
  }
  var update = function(typeOfElement){
    if (typeOfElement == "tags") {
      setClasification();
      $(".tag .selected").each(function(){
        window.Clasification = window.clasification[$(this).children().text];
      })
    }else{
      setSchools();
      $(".school .selected").each(function(){
        window.schools = window.schools[$(this).children().text];
      });
    };
  };

  var showNew = function(schoolsOrTags){
    var newElements = [];
    var position = "";
    if (schoolsOrTags == "schools") {
      if (!Array.isArray(window.schools)) {
        window.schools.each(function(key , value){newElements.push(key)})
      }else{
        position = "last";
        window.schools.each(function(key , value){newElements.push(value)})
      };
    }else{
      if (!Array.isArray(window.clasification)) {
        window.clasification.each(function(key , value){newElements.push(key)})
      }else{
        position = "last";
        window.clasification.each(function(key , value){newElements.push(value)})
      };
    };
    newElements.each(function(key, value){
      $("." + typeOfElement).append('<div class="element'+position+' noselected"  type="' + typeOfElement + '"><div class="tagName">' + value + '</div> +</div>');
    });
  };
  var selectElement= function(element){
    typeOfElement = element.attr("type");
    element.toggleClass("selected");
    element.toggleClass("noselected");
    element.text(element.text().replace("+","-"));
    $("div[type=typeOfElement]").not(".selected").remove();
    if (!element.hasClass("last")) {
      update(typeOfElement);
      showNew(typeOfElement);
    };
  };
  var resetValueOfInput = function(typeOfElement){
    var value = [];
    $("div[type=typeOfElement]").not(".noselected").each(function(){
      value.push($(this).children().text());
    });
    $("#material_" + typeOfElement).attr("value",value);
  }

  $(".subjectSelector select").change(function() {
      setClasification();
      $("div[type='tags']").remove();
      showNew("tags");
  }).trigger("change");
  
  $(document).delegate( '.noselected', "click", function() {
    selectElement($(this));
    resetValueOfInput(typeOfElement);
  });

  $(document).delegate( '.selected', "click", function() {
    typeOfElement = $(this).attr("type");
    $(this).remove();
    $("div[type=typeOfElement]").not(".noselected").remove();
    update(typeOfElement);
    showNew(typeOfElement);
    resetValueOfInput(typeOfElement);
  });
  setSchools();

/*
  var resetValueOfInput = function(nameOfInput){
    var value = [];
    $(".selected" + nameOfInput.capitalize()).each(function(){
      value.push($(this).children().text());
    });
    $("#material_" + nameOfInput).attr("value",value);
  }

  var addNewTags = function(typeOfTag){
    if ($(".last").length == 0) {
      resetClasifications();
      $.each( window.clasification, function( key, value ) {
        addTag("tags",key, "tag", "+");
    });
          
    }else{
      if(!Array.isArray(window.clasification)){
        window.clasification = window.clasification[$(".last").children().text()];
        
        if(!Array.isArray(window.clasification)){
          
          $.each(window.clasification, function(key , value){
            addTag("tags",key,"tag","+");
          });
        
        }else{
         
          $.each(window.clasification, function(key , value){
            addTag("tags",value,"tag","+");
          })
        
        };
      };
    };
    resetValueOfInput("tags");
  };

  var unselectTag = function(tagsOrSchools){
    if ($(".selected" + tagsOrSchools).length == 1) {
      createTags();
    }else{

      resetClasifications();
      $(".last" + tagsOrSchools).remove();
      if (tagsOrSchools == "tags") {
        $(".tag").remove();  
      }else{
        $(".school").remove();
      };
      $(".selectedTags").last().addClass("last");
      $(".last").append(" -")
      $(".selectedTags").not(".last").each(function(){
        window.clasification = window.clasification[$(this).children().text()];
      });
      
      addNewTags();


    };
  };
  var selectTag = function(selected){
    var alreadySelected = $(".selectedTags");
    $(".tags").html("");
    $.each(alreadySelected, function(){
      addTag("tags",$(this).children().text(),"selectedTags", "");
    })
    addTag("tags" , selected, "selectedTags lastTagSelected","-")
  }
  
  var addTag = function(tagsOrSchools, tagName, appearence, lastIcon){
    $('.' + tagsOrSchools).append('<div class="'+ appearence +'"><div class="tagName">' + tagName + '</div> '+lastIcon+'</div>');
  };
  var createTags = function(){
    var subject = $( ".subjectSelector select option:selected").text();
    $(".tags").html("");
    addNewTags("subject");
  };
  */