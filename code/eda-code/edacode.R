## ---- packages --------
#load needed packages. make sure they are installed.
#install.packages("hrbrthemes")
library(tidyverse) #for data processing/cleaning; includes ggplot2, tidyr, readr, dplyr, stringr, purr, forcats
library(skimr) #for nice visualization of data 
library(here) #to set paths
library(renv) #for package management
library(knitr) #for nice tables
library(kableExtra) #for nice tables
library(gt) #for nice tables
library(gtsummary) #for summary tables
library(ggplot2) #for plotting
library(hrbrthemes) #for nice themes
library(flextable) #for nice tables
hrbrthemes::import_roboto_condensed() #import needed fonts for hrbrthemes
rm(list=ls()) #clear the environment

## ---- loaddata --------
#Path to summary data. Note the use of the here() package and not absolute paths
data_location <- here::here("data","processed-data","ML_summary_processed.rds")
#load data
ML_summary <- readRDS(data_location)

## ---- createsummary --------
# Create summary
summary = skimr::skim(ML_summary)
print(summary)
# save to file
summarytable_file = here("results", "tables", "summarytable.rds")
saveRDS(summary, file = summarytable_file)

## ---- age --------
# Create histogram plot
age_plot <- ML_summary %>% filter(!is.na(Age)) %>% # Filter out NAs
  ggplot(aes(x = Age)) +
  geom_histogram(binwidth = 0.5, width= 0.8, fill="#69b3a2") +
  geom_vline(xintercept = c(15, 49), linetype = "dashed", color = "red") +  # Add vertical lines that mark reproductive age
  theme_ipsum() +
  theme(plot.title = element_text(size=15))
plot(age_plot)
# Save plot to file
figure_file = here("results","figures", "age_distribution.png")
ggsave(filename = figure_file, plot=age_plot, bg="white") #background is white

## ---- Birthweight --------
# Create histogram plot
weight_plot <- ML_summary %>% filter(!is.na(Weightgrams)) %>% #filter out NAs
  ggplot(aes(x = Weightgrams)) +
  geom_histogram(binwidth = 25, fill="#69b3a2") +
  geom_vline(xintercept = c(2500, 4000), linetype = "dashed", color = "red") +  # Add vertical lines that mark normal birthweight
  theme_ipsum() +
  theme(plot.title = element_text(size=15))
plot(weight_plot)
# Save plot to file
figure_file = here("results","figures", "weight_distribution.png")
ggsave(filename = figure_file, plot=weight_plot, bg="white") #background is white

## ---- Birthlength --------
# Create histogram plot
length_plot <- ML_summary %>% filter(!is.na(Lengthcentimeters)) %>% #filter out NAs
  ggplot(aes(x = Lengthcentimeters)) +
  geom_histogram(binwidth = 1, fill="#69b3a2") +
  geom_vline(xintercept = c(49), linetype = "dashed", color = "red") +  # Add vertical lines that mark average birth length for both sexes
  theme_ipsum() +
  theme(plot.title = element_text(size=15))
plot(length_plot)
# Save plot to file
figure_file = here("results","figures","length_distribution.png")
ggsave(filename = figure_file, plot=length_plot, bg="white") #background is white

## ---- Heightweight --------
#Create plot
length_weight <- ML_summary %>%
  filter(!is.na(Lengthcentimeters) & !is.na(Weightgrams)) %>% #filter out NAs
  ggplot(aes(x=Lengthcentimeters, y=Weightgrams)) + geom_point() + geom_smooth(method='lm')
plot(length_weight)
#Save file
figure_file = here("results","figures","length_weight.png")
ggsave(filename = figure_file, plot=length_weight, bg="white") #background is white

## ---- Heightweightsex --------
#Create plot
length_weight_sex <- ML_summary %>% filter(!is.na(Lengthcentimeters) & !is.na(Weightgrams) & !is.na(Sex)) %>% 
  ggplot(aes(x=Lengthcentimeters, y=Weightgrams, color = Sex)) + geom_point() + geom_smooth(method='lm')
plot(length_weight_sex)
#Save file
figure_file = here("results","figures","length_weight_sex.png")
ggsave(filename = figure_file, plot=length_weight_sex, bg="white") #background is white

## ---- Dummyvariables1 --------
# Create dummy variables
# Recode factor using dplyr
ML_summary$ModifiedColor <- recode_factor(ML_summary$Color, "Parda" = "AfroDescent", "Preta" = "AfroDescent", "Branca" = "EuroDescent")
# Create dummy variables for status and change to English
ML_summary$ModifiedStatus <- recode_factor(ML_summary$Status, "Secundigesta" = "Multiparous", "Trigesta" = "Multiparous", "Multigesta" = "Multiparous", "Secundipara" = "Multiparous", "Multipara" = "Multiparous", "Primigesta" = "Nulliparous", "Nulipara" = "Nulliparous", "Primipara" = "Nulliparous")
# Create dummy variables for nationality and change to English
ML_summary$ModifiedNationality <- recode_factor(ML_summary$Nationality, "Alema" = "European", "Argentina" = "LatinAmerican", "Austriaca" = "European", "Brasileira" = "Brazilian", "Espanhola" = "European", "Francesa" = "European", "Italiana" = "European", "Paraguaya" = "LatinAmerican", "Polaca" = "European", "Portuguesa" = "European", "Rumania" = "European", "Russa" = "European", "Suiça" = "European", "Siria" = "MiddleEastern", "Uruguaya" = "LatinAmerican")
# Create dummy variables for birth weight for infants born to Black, mixed-race, and White mothers for summary table. Create dummy variables for birth weight according to fetal sex.
ML_summary <- ML_summary %>%
  mutate(
    Weightblack = factor(if_else(Color == "Preta", "Yes", "No"), levels = c("No", "Yes")),
    Weightmixed = factor(if_else(Color == "Parda", "Yes", "No"), levels = c("No", "Yes")),
    Weightwhite = factor(if_else(Color == "Branca", "Yes", "No"), levels = c("No", "Yes")),
    Weightfemale = factor(if_else(Sex == "F", "Yes", "No"), levels = c("No", "Yes")),
    Weightmale = factor(if_else(Sex == "M", "Yes", "No"), levels = c("No", "Yes")),
    WeightgramsBlack = if_else(Weightblack == "Yes", Weightgrams, NA_real_),
    WeightgramsWhite = if_else(Weightwhite == "Yes", Weightgrams, NA_real_),
    WeightgramsMixed = if_else(Weightmixed == "Yes", Weightgrams, NA_real_),
    WeightgramsFemale = if_else(Weightfemale == "Yes", Weightgrams, NA_real_),
    WeightgramsMale = if_else(Weightmale == "Yes", Weightgrams, NA_real_))
# Create dummy variables for birth weight category by maternal skin color for summary table
ML_summary <- ML_summary %>%
  mutate(
    Afro_LBW = ifelse(BirthweightCategory == "LBW" & (!is.na(WeightgramsBlack) | !is.na(WeightgramsMixed)), 1, 0),
    Afro_NBW = ifelse(BirthweightCategory == "NBW" & (!is.na(WeightgramsBlack) | !is.na(WeightgramsMixed)), 1, 0),
    Euro_LBW = ifelse(BirthweightCategory == "LBW" & !is.na(WeightgramsWhite), 1, 0),
    Euro_NBW = ifelse(BirthweightCategory == "NBW" & !is.na(WeightgramsWhite), 1, 0),
  )
# Change value to missing for opposite skin color infants for summary statistics. This uses the wrong denominator (all mothers regardless of whether we have their infants' birth weights, so I will use code below.)
#ML_summary <- ML_summary %>%
#mutate(Afro_LBW = case_when(ModifiedColor == "EuroDescent" ~ NA_real_, TRUE ~ Afro_LBW),
#Euro_LBW = case_when(ModifiedColor == "AfroDescent" ~ NA_real_,TRUE ~ Euro_LBW))
# Verify new variables
str(ML_summary[, c("Weightblack", "Weightmixed", "Weightwhite", "Weightfemale", "Weightmale", "WeightgramsBlack", "WeightgramsMixed", "WeightgramsWhite", "WeightgramsFemale", "WeightgramsMale")])
# View the updated dataframe
print(head(ML_summary))
# See LBW and NBW with true denominator
LBW_percentage <- ML_summary %>%
  # Remove NAs from both variables
  filter(!is.na(ModifiedColor) & !is.na(BirthweightCategory)) %>%
  # Group by ModifiedColor
  group_by(ModifiedColor) %>%
  # Calculate the percentage for each group
  summarise(
    total_count = n(),
    lbw_count = sum(BirthweightCategory == "LBW"),
    lbw_percentage = (lbw_count / total_count) * 100
  )
# Print the result
print(LBW_percentage)

## ---- Dummyvariables2 --------
# Change observations from Portuguese to English
ML_summary <- ML_summary %>%
  mutate(
    ModifiedColor = recode_factor(ModifiedColor, "AfroDescent" = "Afro-Descent", "EuroDescent" = "Euro-Descent"),
    ModifiedNationality = recode_factor(ModifiedNationality, "European" = "European", "LatinAmerican" = "Latin American", "MiddleEastern" = "Middle Eastern", "Brazilian" = "Brazilian"),
    Color = recode_factor(Color, "Preta" = "Black", "Parda" = "Mixed Race", "Branca" = "White"),
    Nationality = recode_factor(Nationality, "Alema" = "German", "Argentina" = "Argentine", "Austriaca" = "Austrian", "Brasileira" = "Brazilian", "Espanhola" = "Spanish", "Francesa" = "French", "Italiana" = "Italian", "Paraguaya" = "Paraguayan", "Polaca" = "Polish", "Portuguesa" = "Portuguese", "Rumania" = "Romanian", "Russa" = "Russian", "Suiça" = "Swiss", "Siria" = "Syrian", "Uruguaya" = "Uruguayan"),
    Birth = recode_factor(Birth, "aborto" = "Abortion", "intervencionista" = "Interventionist", "natural" = "Natural", "operatório" = "Operative"),
    MaternalOutcome = recode_factor(MaternalOutcome, "alta" = "Discharged", "morta" = "Death", "transferência" = "Hospital transferal"),
    FetalOutcome = recode_factor(FetalOutcome, "vivo" = "Live Birth", "morto" = "Stillbirth or Neonatal Death"),
    Status = recode_factor(Status, "Multigesta" = "Multigravida", "Trigesta" = "Trigravida", "Secundigesta" = "Secundigravida", "Secundipara" = "Secundiparous", "Multipara" = "Multiparous", "Primigesta" = "Primigravida", "Nulipara" = "Nulliparous", "Primipara" = "Primiparous")
  )
# Save new summary data with recoded factor variables
saveRDS(ML_summary, file = here("data", "processed-data", "ML_summary.rds"))
#Summarize missing data using dplyr
missing_data_summary <- ML_summary %>% dplyr::summarise_all(list(~sum(is.na(.))))
missing_data_summary

## ---- Summarystats --------
# Create gtsummary table full table for supplemental analysis
table_supplemental <- 
  ML_summary %>%
  tbl_summary(
    include = c(Color, ModifiedColor, Status, ModifiedStatus, Age, Nationality, ModifiedNationality, Birth, MaternalOutcome, FetalOutcome, Sex, Lengthcentimeters, Weightgrams),
    missing = "no",
    label = list(ModifiedColor ~ "Ancestry", Status ~ "Parity or Gravidity", ModifiedStatus ~ "Parity", Age ~ "Maternal Age", ModifiedNationality ~ "Combined Nationality", Birth ~ "Birth Outcome", MaternalOutcome ~ "Maternal Outcome", FetalOutcome ~ "Fetal Outcome", Lengthcentimeters ~ "Birth Length (cms)", Weightgrams ~ "Birth Weight (grms)"),
    statistic = list(all_continuous() ~ "{mean} ({sd})")
  ) %>%
  add_n()
table_supplemental
#Save table
saveRDS(table_supplemental, file = here::here("results", "tables", "table_supplemental_final.rds"))
# Create gtsummary table for final analysis
table1 <- 
  ML_summary %>%
  mutate(
    WeightgramsBlack = if_else(Weightblack == "Yes", Weightgrams, NA_real_),
    WeightgramsWhite = if_else(Weightwhite == "Yes", Weightgrams, NA_real_),
    WeightgramsMixed = if_else(Weightmixed == "Yes", Weightgrams, NA_real_),
    WeightgramsFemale = if_else(Weightfemale == "Yes", Weightgrams, NA_real_),
    WeightgramsMale = if_else(Weightmale == "Yes", Weightgrams, NA_real_)
  ) %>%
  tbl_summary(
    include = c(Color, ModifiedColor, ModifiedStatus, Age, ModifiedNationality, Birth, MaternalOutcome, FetalOutcome, Sex, Lengthcentimeters, Weightgrams, WeightgramsBlack, WeightgramsMixed, WeightgramsWhite, WeightgramsFemale, WeightgramsMale, BirthweightCategory),
    missing = "no",
    label = list(
      Color ~ "Color (n = 2,695)",
      ModifiedColor ~ "Ancestry (n = 2,695)", 
      ModifiedStatus ~ "Parity (n = 2,836)", 
      Age ~ "Maternal Age (n = 2,783)", 
      ModifiedNationality ~ "Combined Nationality (n = 2,773)", 
      Birth ~ "Birth Outcome (n = 2,761)", 
      MaternalOutcome ~ "Maternal Outcome (n = 2,829)", 
      FetalOutcome ~ "Fetal Outcome (n = 2,666)", 
      Sex ~ "Sex (n = 2,534)",
      Lengthcentimeters ~ "Birth Length (cm) (n = 2,405)", 
      Weightgrams ~ "Birth Weight (g) (n = 2,384)",
      WeightgramsBlack ~ "Black (g) (n = 643)",
      WeightgramsMixed ~ "Mixed-Race (g) (n = 675)",
      WeightgramsWhite ~ "White (g) (n = 950)",
      WeightgramsFemale ~ "Female (g) (n = 1,074)",
      WeightgramsMale ~ "Male (g) (n = 1,270)",
      BirthweightCategory ~ "Birth Weight Category (n = 2,231)"
    ),
    statistic = list(
      all_continuous() ~ "{mean} ({sd})",
      WeightgramsBlack ~ "{mean} ({sd})",
      WeightgramsMixed ~ "{mean} ({sd})",
      WeightgramsWhite ~ "{mean} ({sd})",
      WeightgramsFemale ~ "{mean} ({sd})",
      WeightgramsMale ~ "{mean} ({sd})"
    ),
    digits = list(WeightgramsBlack ~ 0, WeightgramsMixed ~ 0, WeightgramsWhite ~ 0, WeightgramsFemale ~ 0, WeightgramsMale ~ 0)
  ) %>%
  #add_n() #%>%
  modify_table_body( #indent these three rows
    ~.x %>%
      mutate(label = case_when(
        variable == "WeightgramsBlack" ~ paste0("\u00A0\u00A0\u00A0\u00A0", label),
        variable == "WeightgramsWhite" ~ paste0("\u00A0\u00A0\u00A0\u00A0", label),
        variable == "WeightgramsMixed" ~ paste0("\u00A0\u00A0\u00A0\u00A0", label),
        variable == "WeightgramsFemale" ~ paste0("\u00A0\u00A0\u00A0\u00A0", label),
        variable == "WeightgramsMale" ~ paste0("\u00A0\u00A0\u00A0\u00A0", label),
        TRUE ~ label
      ))
  )
table1
#Save table
saveRDS(table1, file = here::here("results", "tables", "table1_final.rds"))

## ---- Summarystats2 --------
#Path to summary data. Note the use of the here() package and not absolute paths
data_location <- here::here("data","processed-data","Mean_Birthweights_processed.rds")
#load data
Mean_Birthweights <- readRDS(data_location)
# Replace NA with a dash for each column
Mean_Birthweights <- Mean_Birthweights %>%
  mutate(across(where(is.numeric), ~ ifelse(is.na(.), "-", as.character(.)))) %>%
  mutate(across(where(is.character), ~ replace_na(., "-")))
# Display the table using flextable
table2 <- flextable(Mean_Birthweights) %>%
  set_caption("Mean Birth Weight Comparison") %>%
  align(j = 2, align = "left", part = "all") %>%
  align(j = 4, align = "right", part = "all") %>%
  set_header_labels(
    Sample = "Sample",
    Year = "Year", 
    Mean = "Mean (grams)",
    Source = "Source"
  ) %>%
  bold(part = "header") %>%
  #autofit() %>%
  set_table_properties(layout = "autofit", width = 1, align = "center")
table2

#Save table
saveRDS(table2, file = here::here("results", "tables", "table2_final.rds"))

## ---- Summarystats3 --------
# Calculate frequencies of birth category without abortion
birth_freq2 <- ML_summary %>%
  filter(!is.na(Birth)) %>% # Exclude rows with NA in birth variable
  filter(Birth != "abortion") %>% # Exclude rows with abortion
  count(Birth, na.rm = TRUE) %>% # Calculate frequencies while excluding NAs
  mutate(Total_Sample_Size = sum(n)) %>% # Calculate total sample size 
  mutate(Percent = n/sum(n)*100) # Calculate percentage of each category
print(birth_freq2)

## ---- MMR/SBR/SRaB --------
#MMR Maternal mortality ratio
maternal_deaths <-23
live_births <- 2440
MMR <- (maternal_deaths / live_births) * 10000
MMR
#Stillbirth rate SBR
still_births <- 226
total_births <- 2666
SBR <- (still_births / total_births) * 1000
SBR
#Sex ratio at birth (live male births/live female births)*100
sex_ratio <- ML_summary %>%
  filter(!Birth %in% c("Abortion") & !FetalOutcome %in% c("Stillbirth or Neonatal Death")) %>% # Exclude rows with abortion and stillbirth
  filter(!is.na(Sex) & !is.na(Birth) & !is.na(FetalOutcome)) %>%
  group_by(Sex) %>%
  summarise(count = n()) %>%
  spread(key = Sex, value = count) %>%
  mutate(SexRatio = M / F) * 100
sex_ratio

##---- LinearData --------
#Path to summary data. Note the use of the here() package and not absolute paths
data_location <- here::here("data","processed-data","ML_linear_processed.rds")
#load data
ML_linear <- readRDS(data_location)
# Create dummy variables
#Check pre-structure
str(ML_linear)
# Create dummy variables using recode factor from dplyr
ML_linear$ModifiedColor <- recode_factor(ML_linear$Color, "Preta" = "Afro-Descent", "Parda" = "Afro-Descent", "Branca" = "Euro-Descent")
# Create dummy variables for status and change to English
ML_linear$ModifiedStatus <- recode_factor(ML_linear$Status, "Secundigesta" = "Multiparous", "Trigesta" = "Multiparous", "Multigesta" = "Multiparous", "Secundipara" = "Multiparous", "Multipara" = "Multiparous", "Primigesta" = "Nulliparous", "Nulipara" = "Nulliparous", "Primipara" = "Nulliparous")
# Create dummy variables for nationality and change to English
ML_linear$ModifiedNationality <- recode_factor(ML_linear$Nationality, "Alema" = "European", "Argentina" = "LatinAmerican", "Austriaca" = "European", "Brasileira" = "Brazilian", "Espanhola" = "European", "Francesa" = "European", "Italiana" = "European", "Paraguaya" = "LatinAmerican", "Polaca" = "European", "Portuguesa" = "European", "Rumania" = "European", "Russa" = "European", "Suiça" = "European", "Siria" = "MiddleEastern", "Uruguaya" = "LatinAmerican")
# Change observations from Portuguese to English
ML_linear <- ML_linear %>%
  mutate(
    ModifiedNationality = recode_factor(ModifiedNationality, "European" = "European", "LatinAmerican" = "Latin American", "MiddleEastern" = "Middle Eastern", "Brazilian" = "Brazilian"),
    Color = recode_factor(Color, "Preta" = "Black", "Parda" = "Mixed Race", "Branca" = "White"),
    Nationality = recode_factor(Nationality, "Alema" = "German", "Argentina" = "Argentine", "Austriaca" = "Austrian", "Brasileira" = "Brazilian", "Espanhola" = "Spanish", "Francesa" = "French", "Italiana" = "Italian", "Paraguaya" = "Paraguayan", "Polaca" = "Polish", "Portuguesa" = "Portuguese", "Rumania" = "Romanian", "Russa" = "Russian", "Suiça" = "Swiss", "Siria" = "Syrian", "Uruguaya" = "Uruguayan"),
    Birth = recode_factor(Birth, "aborto" = "Abortion", "intervencionista" = "Interventionist", "natural" = "Natural", "operatório" = "Operative"),
    MaternalOutcome = recode_factor(MaternalOutcome, "alta" = "Discharged", "morta" = "Death", "transferência" = "Hospital transferal"),
    FetalOutcome = recode_factor(FetalOutcome, "vivo" = "Live Birth", "morto" = "Stillbirth or Neonatal Death")
  )

str(ML_linear)
# Save new summary data with recoded factor variables
saveRDS(ML_linear, file = here("data", "processed-data", "ML_linear.rds"))