# This is the script for data wrangling for exercise 2 for IODS course in autumn 2020

library(dplyr)

dat <- read.table('http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt', sep="\t", header=TRUE)
dim(dat)
str(dat)

# The data contain 183 rows (participants) and 60 columns (variables). In addition to 56 variables that are 
# individual Likert items (1-5) asking about study skills and approaches, the data include demographics (age and 
# gender), and a measure of global attitude towards statistics as well as exam points.

# Select the "gender", "age", "attitude", and "points" variables to the new analysis data frame (getting rid of 
# those really annoying capital letters that do nothing but slow us down)

lrn_data <- dat %>% select (c(gender, age=Age, attitude=Attitude, points = Points))

# create lists to help in creating the summary variables
deep_qs <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surf_qs <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
stra_qs <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# create the summary variables (deep, surf, and stra) with few lines less than in the datacamp example
lrn_data$deep <- rowMeans(dat[c(deep_qs)])
lrn_data$surf <- rowMeans(dat[c(surf_qs)])
lrn_data$stra <- rowMeans(dat[c(stra_qs)])

# we can check that this produces the same results as the code from datacamp
deep_cols <- select(dat, one_of(deep_qs))
deep2 <- rowMeans(deep_cols)
istru <- lrn_data$deep == deep2
table(istru)

# scale the variable "attitude" as well, as it is a combination of ten original variables
lrn_data$attitude <- lrn_data$attitude/10

# Exclude observations where the exam points variable is zero.
lrn_data <- filter(lrn_data, points > 0)

# The data should then have 166 observations and 7 variables
dim(lrn_data)

# Save the data
setwd("~/Desktop/kurssit-syksy-2020/IODS-project/")
write.table(lrn_data, file = "learning2014.txt")

learn <- read.table("learning2014.txt")
str(learn)
head(learn, 3)
