extractValueFromVector = function(target, keyword, ignore_case = T) {
    index <- grep(x = target, pattern = keyword, ignore.case = ignore_case)
    result <- target[index]
    return(result)
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

findFood = function(keyword, food_group = NULL) {
    data("food_composition")
    if (is.character(food_group)) {
        food_composition <- extractSubsetFromFoodGroup(food_group)
    }
    subset_food <- subset(food_composition, grepl(keyword, food_composition$food_and_description,ignore.case = T))
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
        stop("not found enter food group.")
    }
    return(head(food_composition, n))
}
