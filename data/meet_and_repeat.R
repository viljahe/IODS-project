# Vilja Helminen / 30 Nov 2020
# Script for data wrangling for exercise 6

# packages
library(tidyr)
library(dplyr)

# Load the data sets (BPRS and RATS) into R 
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = T)

# Check how the data sets look
View(BPRS)
View(RATS)

str(BPRS)
str(RATS)

summary(BPRS)
summary(RATS)

# Convert the categorical variables of both data sets to factors
BPRS <- mutate(BPRS, treatment = as.factor(treatment), subject = as.factor(subject))
RATS <- mutate(RATS, ID = as.factor(ID), Group = as.factor(Group))

# Convert the data sets to long form, add a week variable to BPRS and a Time variable to RATS.
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject) %>% 
  mutate(week = as.integer(substr(weeks, 5, 5)))

RATSL <- RATS %>% gather(key = WD, value = Weight, -ID, -Group) %>% 
  mutate(Time = as.integer(substr(WD, 3, 4)))

# Take a look at the new data sets and compare them with their wide form versions
str(BPRS)
str(RATS)

summary(BPRSL)
summary(RATSL)

# In the long format each there are multiple observations for each subject (i.e. multiple entries for each 
# subject in the variable "subject" or "ID"). This makes it possible to have each week/timepoint not as their
# own variable (e.g. one variable for the measurement for 1st timepoint, second variable for the measurement
# for 2nd timepoint...) but one variable denoting the timepoint, and other denoting the accompanying measurement.
# This means in the long format we have n * timepoints observations, so 40 * 9 = 360 for BPRS, and 16 * 11 = 176 for RATS

# Write the wrangled data sets to files in IODS-project data-folder.
write.csv(BPRSL, file = "~/Desktop/kurssit-syksy-2020/IODS-project/data/BPRSL.csv")
write.csv(RATSL, file = "~/Desktop/kurssit-syksy-2020/IODS-project/data/RATSL.csv")

