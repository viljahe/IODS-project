# Vilja Helminen / 10 Nov 2020
# Script for data wrangling for exercise 3, original data from: https://archive.ics.uci.edu/ml/datasets/Student+Performance

# Necessary packages
library(dplyr)

# Read student-mat.csv and student-por.csv 

por <- read.table("~/Desktop/kurssit-syksy-2020/IODS-project/data/student-por.csv", sep = ";", header = T)
math <- read.table("~/Desktop/kurssit-syksy-2020/IODS-project/data/student-mat.csv", sep = ";", header = T)

# Explore the structure and dimensions of the data

str(por)
dim(por)

str(math)
dim(math)

# Join the two data sets using the variables "school", "sex", "age", "address", "famsize", 
# "Pstatus", "Medu", "Fedu", "Mjob", "Fjob", "reason", "nursery","internet" as identifiers. 
# Keep only the students present in both data sets.

# for later comparing purposes, create an id to one of the datasets, in the same way as in the example script
id.p <- por %>% mutate(id.p=1000+row_number())

# define the columns that aren't shared between datasets
free_cols <- c("id.p","failures","paid","absences","G1","G2","G3")

# define columns that are shared between datasets (used in joining)
join_cols <- setdiff(colnames(por),free_cols)

# join datasets keeping all columns from math which has fewer students
math_por <- inner_join(math, id.p, by = join_cols, suffix = c(".m", ".p"))

# use the function from DataCamp exercises for the duplicate variables

for(column_name in free_cols) {
  two_columns <- select(math_por, starts_with(column_name))
  second_column <- select(two_columns, 1)[[1]]
  
  if(is.numeric(second_column)) {
    math_por[column_name] <- as.integer(round(rowMeans(two_columns)))
  } else { 
    math_por[column_name] <- second_column
  }
}

# calculate the variables alc_use and high_use
math_por <- mutate(math_por, alc_use = (Walc + Dalc) / 2)
math_por <- mutate(math_por, high_use = alc_use > 2)


# Let's check if this results in the same data set as the corrected example

# install and load packge "arsenal" for comparing datasets
require(arsenal)

# read the example data
alc <- read.table('https://github.com/rsund/IODS-project/raw/master/data/alc.csv', sep=",", header=TRUE)

# print summary of the comparedf, which compares the dataframes
summary(comparedf(math_por, alc, by = "id.p"))

# There is only one variable (not counting the "unnecessary" variables not included 
# in my dataset), paid, where there are differences between the datasets
# let's have a closer look at the variable paid, and where it's derived from:

cbind(table(math_por$paid.p), table(math_por$paid.m), table(math_por$paid))
cbind(table(alc$paid.p), table(alc$paid.m), table(alc$paid))

# We can see that the provided example script takes the value of paid from the portuguese dataset 
# (because it binds the datasets together in different order), whereas my code results
# in paid being derived from the math dataset. This hardly matters, since we are picking
# the value of paid at random either way, so I really can't be bothered to try to "fix" it.

glimpse(math_por)

# all looks fine, let's save this thing
setwd("~/Desktop/kurssit-syksy-2020/IODS-project/")
write.csv(math_por, file = "alc.csv", row.names = F)

# and test that it works
alc1 <- read.csv("alc.csv")
glimpse(alc1)
