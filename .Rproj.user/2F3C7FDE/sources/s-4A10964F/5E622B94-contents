searchByVector = function(target_vector, search_string, ignore_case=T){
  index <- grep(x=target_vector, pattern=search_string, ignore.case = ignore_case)
  ret <- target_vector[index]
  return(ret)
}

getNutrientNames = function() {
  data("food_composition")
  col_names <- colnames(food_composition)
  return(searchByVector(target_vector = col_names, search_string = ")"))
}

getFoodGroups = function(){
  data("food_composition")
  return(unique(food_composition$food_group))
}

findFoodName = function(keyword, food_group=NULL){
  data("food_composition")
  if(is.null(food_group)){}
  else{
    food_composition <- subset(food_composition ,`Food Group`== food_group)
  }
  food_name_list <- food_composition$`Food and Description`
  return(searchByVector(target_vector = food_name_list, search_string = keyword))
}
