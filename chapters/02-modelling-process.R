
# Chapter 2 - Modelling Process -------------------------------------------


# Prerequisites  ----------------------------------------------------------

automatically_install_functions("dplyr", 
                                "ggplot2", 
                                "rsample",
                                "caret",
                                "h2o",
                                "AmesHousing",
                                "modeldata")

# h2o set-up 
h2o.no_progress()
h2o.init()

# Ames housing data
ames <- AmesHousing::make_ames()
ames.h2o <- as.h2o(ames)

# Job attrition data
churn <- attrition %>% 
  mutate_if(is.ordered, .funs = factor, ordered = FALSE)
churn.h2o <- as.h2o(churn)




# Data Splitting ----------------------------------------------------------



# Simple Random Sampling --------------------------------------------------

#Using Base R
set.seed(123)
index_1 <- sample(1:nrow(ames), round(nrow(ames) * 0.7))
train_1 <- ames[index_1, ]
test_1 <- ames[-index_1, ]


# OR R Sample Package

set.seed(123)
split_1 <- initial_split(ames, prop = 0.7)
train_2 <- training(split_1)
test_2 <- testing(split_1)



# Stratified Sampling -----------------------------------------------------

table(churn$Attrition) %>% prop.table() * 100

# stratified sampling with the rsample package
set.seed(123)

split_strat <- initial_split(churn, 
                             prop = 0.7, 
                             strata = "Attrition")

train_strat <- training(split_strat)
test_strat <- testing(split_strat)

# consistent response ratio between train & test
table(train_strat$Attrition) %>% prop.table()

table(test_strat$Attrition) %>% prop.table()
#
