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

# Week 5: data wrangling part

# load the data, examine structure and dimensions
human <- read.csv("~/Desktop/kurssit-syksy-2020/IODS-project/data/human.csv")

str(human)
dim(human)

# The data consists of two original data sets that consist of indicators for long and 
# healthy life, knowledge, living standards, and gender inequality for various countries/areas.

# The variables are:
# "gii.rank": gender inequality index (GII) rank
# "country": country
# "gii": gender inequality index (GII)
# "mmr": maternal mortality ratio
# "birthrate": adolescent birth rate
# "parliament": the percentage of seats in parliament held by women
# "edu.f": the percentage of women with some secondary education
# "edu.m": the percentage of men with some secondary education
# "lab.f": the percentage of women aged 15 and older in the labour force     
# "lab.m": the percentage of men aged 15 and older in the labour force 
# "edu.ratio": ratio of women/men with some secondary education (calculated from edu.f and edu.m)
# "lab.ratio": ratio of women/men in the labour force (calculated from lab.f and lab.m)
# "hdi.rank": the human development index (HDI) rank
# "hdi": the human development index (HDI)
# "life.exp": life expectancy at birth (years)
# "edu.exp": expected years of schooling
# "edu.mean": mean years of schooling
# "gni": gross national income (GNI) per capita
# "rank.diff": the GNI per capita rank minus HDI rank

# transform GNI to numeric
require(stringr)
human$gni <- str_replace(human$gni, pattern=",", replace ="") %>% as.numeric

# exclude unneeded variables
keep <- c("country", "edu.ratio", "lab.ratio", "life.exp", "edu.exp", "gni", "mmr", "birthrate", "parliament")

human <- select(human, all_of(keep))

# remove rows with missing values
comp <- complete.cases(human)
human <- filter(human, comp == TRUE)

# remove obs related to regions, not countries
human <- human[1:(nrow(human)-7), ]

# row names = countries
rownames(human) <- human$country
human <- select(human, -"country")

dim(human)

# save data
write.csv(human, file = "~/Desktop/kurssit-syksy-2020/IODS-project/data/human.csv", row.names = T)
