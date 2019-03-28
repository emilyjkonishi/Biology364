Takehome Midterm
================
Spectacular Student
20 Mar 2019

  - [Introduction](#introduction)
      - [Loading Libraries](#loading-libraries)
      - [Objectives for Midterm Exam](#objectives-for-midterm-exam)
      - [Background](#background)
      - [Feature Descriptions](#feature-descriptions)
  - [Takehome Exam Begins here](#takehome-exam-begins-here)
      - [(1) Data Wrangling](#data-wrangling)
      - [(2) What is the average number of cases of Dengue for each week
        of the year for each
        city?](#what-is-the-average-number-of-cases-of-dengue-for-each-week-of-the-year-for-each-city)
      - [(3) Data exploration of potential explanatory
        variables](#data-exploration-of-potential-explanatory-variables)
      - [(4) Dengue incidence model](#dengue-incidence-model)
      - [(5) Extend the Benchmark model](#extend-the-benchmark-model)
  - [Acknowledgements](#acknowledgements)

# Introduction

For the takehome midterm you will have 48 hours to complete the
objectives listed below. The deadline for submission is 28 March 2019 at
5pm EST.

Date/Time started: Date/Time completed:

You will be graded on the following criteria:

  - Completion of the objectives
  - Successful knitting of the pdf
  - Readability (tidyness) of Rmd code
  - Acknowledgement of resources

## Loading Libraries

Load all of your libraries in this code block. Indicate why each library
is necessary.

## Objectives for Midterm Exam

  - [ ] Import, clean, merge data tables
  - [ ] Present graphical summary of Dengue incidence data
  - [ ] Data exploration of potential explanatory variables
  - [ ] Test Benchmark model of Dengue incidence
  - [ ] Improve model of Dengue incidence

## Background

This dataset should be familiar from Lab 6. We will be using the Dengue
dataset from a Driven Data competition:
<https://www.drivendata.org/competitions/44/dengai-predicting-disease-spread/>

The data for this competition comes from multiple sources aimed at
supporting the Predict the Next Pandemic Initiative
(<https://www.whitehouse.gov/blog/2015/06/05/back-future-using-historical-dengue-data-predict-next-epidemic>).
Dengue surveillance data is provided by the U.S. Centers for Disease
Control and prevention, as well as the Department of Defense’s Naval
Medical Research Unit 6 and the Armed Forces Health Surveillance Center,
in collaboration with the Peruvian government and U.S. universities.
Environmental and climate data is provided by the National Oceanic and
Atmospheric Administration (NOAA), an agency of the U.S. Department of
Commerce.

The data is provided in two separate files:

1.  dengue\_features\_train: weekly weather and vegetation data for two
    cities
2.  dengue\_labels\_train: weekly number of dengue cases in each city

There are two cities, San Juan, Puerto Rico and Iquitos, Peru, with test
data for each city spanning 5 and 3 years respectively. The data for
each city have been concatenated along with a city column indicating the
source: *sj* for San Juan and *iq* for Iquitos.

``` r
dengue_features_train <- read_csv("https://s3.amazonaws.com/drivendata/data/44/public/dengue_features_train.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_double(),
    ##   city = col_character(),
    ##   week_start_date = col_date(format = "")
    ## )

    ## See spec(...) for full column specifications.

``` r
dengue_labels_train <- read_csv("https://s3.amazonaws.com/drivendata/data/44/public/dengue_labels_train.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   city = col_character(),
    ##   year = col_double(),
    ##   weekofyear = col_double(),
    ##   total_cases = col_double()
    ## )

## Feature Descriptions

You are provided the following set of information on a (year,
weekofyear) timescale:

(Where appropriate, units are provided as a \_unit suffix on the feature
name.)

City and date indicators

  - city – City abbreviations: sj for San Juan and iq for Iquitos
  - week\_start\_date – Date given in yyyy-mm-dd format

NOAA’s GHCN daily climate data weather station measurements

  - station\_max\_temp\_c – Maximum temperature
  - station\_min\_temp\_c – Minimum temperature
  - station\_avg\_temp\_c – Average temperature
  - station\_precip\_mm – Total precipitation
  - station\_diur\_temp\_rng\_c – Diurnal temperature range

PERSIANN satellite precipitation measurements (0.25x0.25 degree scale)

  - precipitation\_amt\_mm – Total precipitation

NOAA’s NCEP Climate Forecast System Reanalysis measurements (0.5x0.5
degree scale)

  - reanalysis\_sat\_precip\_amt\_mm – Total precipitation
  - reanalysis\_dew\_point\_temp\_k – Mean dew point temperature
  - reanalysis\_air\_temp\_k – Mean air temperature
  - reanalysis\_relative\_humidity\_percent – Mean relative humidity
  - reanalysis\_specific\_humidity\_g\_per\_kg – Mean specific humidity
  - reanalysis\_precip\_amt\_kg\_per\_m2 – Total precipitation
  - reanalysis\_max\_air\_temp\_k – Maximum air temperature
  - reanalysis\_min\_air\_temp\_k – Minimum air temperature
  - reanalysis\_avg\_temp\_k – Average air temperature
  - reanalysis\_tdtr\_k – Diurnal temperature range

Satellite vegetation - Normalized difference vegetation index (NDVI) -
NOAA’s CDR Normalized Difference Vegetation Index (0.5x0.5 degree scale)
measurements

  - ndvi\_se – Pixel southeast of city centroid
  - ndvi\_sw – Pixel southwest of city centroid
  - ndvi\_ne – Pixel northeast of city centroid
  - ndvi\_nw – Pixel northwest of city centroid

# Takehome Exam Begins here

As a reminder, you may consult your previous homework and group
projects, textbook and other readings, and online resources. Online
resources may be used to research ways to solve each problem, but you
may not pose questions in online forums about the specific assignment.
You may consult with Prof. Field or with other classmates about
technical problems (e.g. where to find a file), but not about how to
answer any of the questions.

## (1) Data Wrangling

Use this section to manipulate the two data frames. 1. Follow the
Exploratory Data Analysis Checklist (below) to verify the imported data
a. Ensure that each variable is the appropriate data class and has
values that makes sense b. For external verification, at a minimum,
check that the annual Dengue incidence numbers for each city are
realistic 2. Merge the two data frames, verifying that no information
was lost during the merge 3. Check the data for NAs both before and
after the merge (note that eliminating all rows or columns with NAs will
have consequences)

### Check the packaging

### Run str()

### Look at the top and the bottom of your data

### Check your “n”s

### Validate with at least one external data source

### Merging the features and labels data frames

Although there are dplyr functions for data frame merging, the base
`merge()` function is easier to use.

### Dealing with the NAs

Check out the tidyr function `fill()` for the tidy way to take care of
NAs.

## (2) What is the average number of cases of Dengue for each week of the year for each city?

Provide a publication-quality graphic to present this comparison. The
graph should span a single year, with the average incidence for each
week of the year. You are encouraged to explore options, but only your
final graph in this section will be used to evaluate this objective.
Consider the most effective way to illustrate any trends or important
comparisons within the data.

## (3) Data exploration of potential explanatory variables

Consider whether transforming any of the variables might increase the
statistical power available. Explore the correlation of the potential
explanatory variables with each other and with dengue incidence. Present
a few publication-quality graphics to illustrate your most important
findings.

### Exploration

Explore the data here.

### Presentation

Present your most important results here.

## (4) Dengue incidence model

Use a generalized linear model to determine the best model for the
weekly incidence of Dengue. At a first pass consider the “Benchmark”
model described here:
<https://shaulab.github.io/DrivenData/DengAI/Benchmark.html> This model
is calculated separately for San Jose and Iquitos and only uses the
following variables: - reanalysis\_specific\_humidity\_g\_per\_kg -
reanalysis\_dew\_point\_temp\_k - station\_avg\_temp\_c -
station\_min\_temp\_c The code for the Benchmark model uses a machine
learning approach to optimize the model. You should use the model
selection approach that we have used in BIOL 364, instead. The
total\_cases outcome variable is a count - statistically it is a
binomial variable that has been summed up over a period of time (a week,
in this case). Generalized linear models should use a negative binomial
distribution (as opposed to a Gaussian distribution, which is what
`glm()` assumes) for this type of data. To fit a negative binomial
distribution use `glm.nb()` from the package `MASS` instead of the
`glm()` function from `stats`.

## (5) Extend the Benchmark model

Consider and test the inclusion of additional explanatory variables to
improve the Benchmark model.

# Acknowledgements

Cite online sources used.
