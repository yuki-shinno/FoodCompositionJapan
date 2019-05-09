extractValueFromVector = function(target, keyword, ignore_case = T) {
    index <- grep(x = target, pattern = keyword, ignore.case = ignore_case)
    return(target[index])
}

extractSubsetFromFoodGroup = function(target_food_group) {
    subset_food_composition <- subset(x = food_composition, food_composition$food_group == target_food_group)
    return(subset_food_composition)
}

deleteBrackets = function(target) {
    target <- gsub(pattern = "\\(", replacement = "", x = target)
    target <- gsub(pattern = ")", replacement = "", x = target)
    return(target)
}

getNutrientNames = function() {
    data("food_composition")
    col_names <- colnames(food_composition)
    return(extractValueFromVector(target = col_names, keyword = ")"))
}

getFoodGroups = function() {
    data("food_composition")
    return(unique(food_composition$food_group))
}

menufindFood <- function() {
    group <- getFoodGroups()[menu(getFoodGroups(), graphics = TRUE)]
    keyword = readline("please input keyword...")
    res1 <- findFood(keyword = keyword, food_group = group)
    return(res1[menu(res1[, "food_and_description"], graphics = TRUE), ])
}

findFood = function(keyword, food_group = NULL) {
    data("food_composition")
    if (is.character(food_group)) {
        food_composition <- extractSubsetFromFoodGroup(food_group)
    }
    subset_food <- subset(food_composition, grepl(keyword, food_composition$food_and_description, ignore.case = T))
    if (dim(subset_food)[1] == 0) {
        stop("not found input keyword.")
    }
    return(subset_food)
}

subsetFoodRichIn = function(nutrient_name, food_group = NULL, n = 10) {
    if (is.character(food_group)) {
        food_composition <- extractSubsetFromFoodGroup(food_group)
    }

    index <- (grep(x = deleteBrackets(colnames(food_composition)), pattern = deleteBrackets(nutrient_name)))
    if (length(index) > 1) {
        stop("multiple food groups were matched. Enter unique food groups.")
    }

    food_composition <- food_composition[order(food_composition[index], decreasing = T), ]
    if (dim(food_composition)[1] == 0) {
        stop("not found input food group.")
    }
    return(head(food_composition, n))
}

getFoodNamesByFoodNumbers = function(food_numbe_list) {
    data("food_composition")
    return(food_composition[food_numbe_list, "food_and_description"])
}

calcNutrientMultipledays = function(food_list_multiple) {
    if (is.data.frame(food_list_multiple)) {
        stop("If you want to calculate a meal for one day, use the calcNutrient().")
    }
    ret <- sapply(food_list_multiple, calcNutrient)
    mean_nutrient <- round(rowMeans(ret), 3)
    return(mean_nutrient)
}

calcNutrient = function(food_list = food1) {
    data("food_composition")
    food_number <- food_list$food_number
    food_weight <- food_list$food_weight
    # this nutrient_data is nutrient value only.
    # in addition, 6 is index that nutrient start (energy).
    # last nutrient item (Yield) is not included.
    nutrient_data <- food_composition[food_number, 6:ncol(food_composition) - 1]
    nutrient_result <- nutrient_data * 0.01 * food_list$weight
    nutrient_total <- colSums(nutrient_result)
    return(nutrient_total)
}
