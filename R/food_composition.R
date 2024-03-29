extractValueFromVector = function(target, keyword, ignore_case = T) {
  index <- grep(x = target, pattern = keyword, ignore.case = ignore_case)
  return(target[index])
}

extractSubsetFromFoodGroup = function(target_food_group) {
  subset_food_composition <- subset(x = food_composition, food_composition$food_group == target_food_group)
  return(subset_food_composition)
}

getNutrientNames = function() {
  data("food_composition")
  col_names <- colnames(food_composition)
  return(col_names)
}

getFoodGroups = function() {
  data("food_composition")
  return(unique(food_composition$food_group))
}

menufindFood <- function(keyword = NULL, food_group = NULL) {
  if(is.null(food_group)){
    food_group <- getFoodGroups()[menu(getFoodGroups(), graphics = TRUE)]
  }
  if(is.null(keyword)){
    res1 <- findFood(readline("please input keyword..."), food_group)
  }else{
    res1 <- findFood(keyword, food_group)
  }
  return(res1[menu(res1[, "food_name"], graphics = TRUE), ])
}

findFood = function(keyword, food_group = NULL) {
  data("food_composition")
  if (is.character(food_group)) {
    food_composition <- extractSubsetFromFoodGroup(food_group)
  }
  subset_food <- subset(food_composition, grepl(keyword, food_composition$food_name, ignore.case = T))
  if (dim(subset_food)[1] == 0) {
    stop("not found input keyword.")
  }
  return(subset_food)
}

subsetFoodRichIn = function(nutrient_name, food_group = NULL, n = 10) {
  if (is.character(food_group)) {
    food_composition <- extractSubsetFromFoodGroup(food_group)
  }

  index <- (grep(x = colnames(food_composition), pattern = nutrient_name))
  if (length(index) > 1) {
    stop("multiple food groups were matched. Enter unique food groups.")
  }

  food_composition <- food_composition[order(food_composition[index], decreasing = T), ]
  if (dim(food_composition)[1] == 0) {
    stop("not found input food group.")
  }
  return(head(food_composition, n))
}

getFoodNameByFoodNumber = function(food_number) {
  data("food_composition")
  food_composition[food_composition$food_number==food_number,"food_name"]
}

calcNutrientMultipledays = function(food_list_multiple = sample_meal_multiple, is_trans = FALSE) {
  data("sample_meal_multiple")
  if (is.data.frame(food_list_multiple)) {
    stop("If you want to calculate a meal for one day, use the calcNutrient().")
  }
  ret <- sapply(food_list_multiple, calcNutrient)
  mean_nutrient <- round(rowMeans(ret), 3)
  if(is_trans){
    return(t(mean_nutrient))
  }
  return(mean_nutrient)
}

calcNutrient = function(food_list = sample_meal_day1, is_trans = FALSE) {
  data("sample_meal")
  data("food_composition")
  getNutrientResult <- function(food_list){
    nutrient_data <- food_composition[food_composition$food_number == food_list["food_number"], 5:ncol(food_composition) ]
    nutrient_result <- nutrient_data * 0.01 * as.numeric(food_list["weight"])
    return(nutrient_result)
  }
  nutrient_result <- apply(food_list, 1, getNutrientResult)
  nutrient_result_df = data.frame()
  for (row in nutrient_result) {
    nutrient_result_df <- rbind(nutrient_result_df, row)
  }
  nutrient_total <- colSums(nutrient_result_df)
  if (is_trans) {
    return(t(nutrient_total))
  }else{
    return(nutrient_total)
  }
}

createMeal = function(){
  df <- data.frame(matrix(rep(NA, 3), nrow=1))[numeric(0), ]
  colnames(df) <- c("food_number", "food_name", "weight")
  return(df)
}

createFood = function(food_number, weight){
  return(data.frame(
    food_number = food_number,
    food_name = getFoodNameByFoodNumber(food_number),
    weight = weight
  ))
}

createFoodBySearch = function(){
  group <- getFoodGroups()[menu(getFoodGroups(), graphics = TRUE)]
  keyword <- readline("please input search keyword...")
  subset <- findFood(keyword = keyword, food_group = group)
  index <- menu(subset[, "food_and_description"],graphics = TRUE)
  if(index==0){
    index <- index + 1
  }
  subset <- subset[index, ]
  weight <- as.numeric(readline("please input weight..."))
  return(createFood(subset$item_no, weight))
}

createFoodBySelect = function(){
  group <- getFoodGroups()[menu(getFoodGroups(), graphics = TRUE)]
  subset <- food_composition[food_composition$food_group==group,]
  index <- menu(subset[, "food_name"], graphics = TRUE)
  subset <- subset[index, ]
  weight <- as.numeric(readline("please input weight..."))
  return(createFood(subset$food_number, weight))
}

addFoodToMeal = function(meal, food){
  return(rbind(meal,food))
}
