# Author:        Ethan Murakami
# Date Created:  1/24/2025
# Date Edited:   1/30/2025
# Notes:         R file to build Medicare Advantage dataset for Econ/HLTH 470 Hwk 1



# Preliminaries -----------------------------------------------------------
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, ggplot2, dplyr, lubridate, stringr, readxl, data.table, gdata)


# Call individual scripts -------------------------------------------------

source("submission1/data-code/contract-enrollment.R")
source("submission1/data-code/service-area.R")
