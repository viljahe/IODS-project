# # Vilja Helminen / 19 Nov 2020
# Script for data wrangling for exercise 5
# Information on the original data sets: 
# http://hdr.undp.org/en/content/human-development-index-hdi
# http://hdr.undp.org/sites/default/files/hdr2015_technical_notes.pdf

# read the data
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# structure and dimensions
str(hd)
str(gii)

dim(hd)
dim(gii)

# rename the variables with shorter names (no love for those capital letters either)
colnames(hd) <- c("hdi.rank", "country", "hdi", "life.exp", "edu.exp", "edu.mean", "gni", "rank.diff")
colnames(gii) <- c("gii.rank", "country", "gii", "mmr", "birthrate", "parliament", "edu.f", "edu.m", "lab.f", "lab.m")

# new variables: secondary education female/male ratio, and labour force participation female/male ratio
gii <- gii %>% mutate(edu.ratio = edu.f/edu.m, lab.ratio = lab.f/lab.m)

# join using country as id, keep only countries in both data sets
gii_hd <- inner_join(gii, hd, by = "country")

# save the data in the data-folder
write.csv(gii_hd, file = "~/Desktop/kurssit-syksy-2020/IODS-project/data/human.csv", row.names = F)

