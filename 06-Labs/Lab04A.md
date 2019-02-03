Lab 04A
================
Biology Student
2/2/2019

## Loading Libraries

Use the following syntax to load any libraries that you need. This code
will prevent errors that will interfere with knitting of the Rmd file.
Also note that the `include=FALSE` option will prevent this code chunk
from appearing in the markdown file.

We will load the entire tidyverse library, which includes *dplyr*,
*ggplot2*, *readr*, and other packages.

## Objectives for Lab 4

1.  Introduction to *dplyr* grammar and functions
2.  Exploratory data analysis using *dplyr*

## Exploratory Data Analysis with R

This lab is adapted from Roger Peng’s *Exploratory Data Analysis with
R*, Chapter 4. <https://leanpub.com/exdata/read_full>

## Verbs in dplyr

One of the main parts of the *dplyr* data grammar is the use of verbs to
manipulate data frames. There are six main verbs in *dplyr*:

  - `filter()` to select cases based on their values.
  - `arrange()` to reorder the cases.
  - `select()` and `rename()` to select variables based on their names.
  - `mutate()` and `transmute()` to add new variables that are functions
    of existing variables.
  - `summarise()` to condense multiple values to a single value.
  - `sample_n()` and `sample_frac()` to take random samples.

The syntax of *dplyr* will always require a dataframe first, followed by
a verb. The output will be another (altered) data frame.

## Loading data

For this exercise we will be using data from Prof. Reeder’s fieldwork in
Uganda. Epauletted fruit bats were collected at two different times of
the year for this study and a variety of health metrics were measured.

Note that this data should not be shared outside this class without
permission.

Load the data in and then check that it has loaded correctly and check
out the structure of the data frame. The `str()` function is very useful
for getting to know the structure of your data.

``` r
BatData <- read_csv("UgandaBatsFilteredMetrics.csv")
```

    ## Parsed with column specification:
    ## cols(
    ##   .default = col_double(),
    ##   `Field number` = col_character(),
    ##   `Dissection date` = col_character(),
    ##   Season = col_character(),
    ##   Sex = col_character(),
    ##   Class = col_character(),
    ##   `HABITAT description` = col_character(),
    ##   K = col_character(),
    ##   Cl = col_character(),
    ##   BUN = col_character(),
    ##   Glu = col_character(),
    ##   Beecf = col_character()
    ## )

    ## See spec(...) for full column specifications.

``` r
# Below is a very handy way to eliminate those annoying spaces in the column names!
names(BatData) <- make.names(names(BatData))

## Begin data exploration here. 
```

## select()

The select() function can be used to select **columns** of a data frame
that you want to focus on. Often you’ll have a large data frame
containing “all” of the data, but any given analysis might only use a
subset of variables or observations. The select() function allows you to
get the few columns you might need.

Suppose we wanted to take the first 3 columns only. There are a few ways
to do this. We could for example use numerical indices. But we can also
use the names directly.

``` r
names(BatData)[1:3]
```

    ## [1] "Field.number"    "Dissection.date" "Season"

``` r
BatData.subset <- select(BatData, Field.number:Season)
head(BatData.subset)
```

    ## # A tibble: 6 x 3
    ##   Field.number Dissection.date Season
    ##   <chr>        <chr>           <chr> 
    ## 1 DMR976       3/11/17         DRY   
    ## 2 DMR957       3/10/17         DRY   
    ## 3 DMR910       3/5/17          DRY   
    ## 4 DMR955       3/10/17         DRY   
    ## 5 DMR966       3/11/17         DRY   
    ## 6 DMR959       3/10/17         DRY

Note that the : normally cannot be used with names or strings, but
inside the select() function you can use it to specify a range of
variable names. You can also omit variables using the select() function
by using the negative sign. With select() you can do `select(BatData,
-(Dissection.date:Season))`

The select() function also allows a special syntax that allows you to
specify variable names based on patterns. So, for example, if you wanted
to keep every variable that ends with a “2”, we could do `subset <-
select(chicago, ends_with("2"))`

Use select() to make a new BatData.subset that only contains the Field
number, Season, Class, Forearm length (FA length), and Mass for each
bat.

## filter()

The filter() function is used to extract subsets of **rows** from a data
frame. This function is similar to the existing subset() function in R
but is quite a bit faster.

Suppose we wanted to extract the rows where the mass of the bat was less
than 55 g, which may indicate that the bat is a juvenile or subadult.

``` r
BatData.filter <- filter(BatData, mass < 55)
str(BatData.filter)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    41 obs. of  27 variables:
    ##  $ Field.number       : chr  "DMR973" "DMR929" "DMR972" "DMR937" ...
    ##  $ Dissection.date    : chr  "3/11/17" "3/7/17" "3/11/17" "3/8/17" ...
    ##  $ Season             : chr  "DRY" "DRY" "DRY" "DRY" ...
    ##  $ Sex                : chr  "Female" "Female" "Female" "Female" ...
    ##  $ Class              : chr  "FEMALE SUBADULT" "FEMALE SUBADULT" "FEMALE SUBADULT" "FEMALE SUBADULT" ...
    ##  $ elevation          : num  1027 1027 1027 1030 1027 ...
    ##  $ HABITAT.description: chr  "mixed rural agricultural/grasslands area, multiple tukals" "mixed rural agricultural/grasslands area, some tukals" "mixed rural agricultural/grasslands area, multiple tukals" "mixed rural agricultural/grasslands area" ...
    ##  $ Total.Length       : num  114 110 114 114 112 114 120 115 NA 121 ...
    ##  $ Hind.Foot          : num  18 18 18 19 19 18 18 19 NA 18 ...
    ##  $ Ear                : num  21 15 21 21 20 19 22 21 NA 22 ...
    ##  $ FA.length          : num  65.8 68.2 68.3 68.5 68.6 ...
    ##  $ mass               : num  38.7 45.1 40.4 43.6 43.6 ...
    ##  $ A1C_1              : num  4.4 4.5 5.1 4.3 4.8 5.2 4.7 4.8 4.7 4.7 ...
    ##  $ ketone             : num  1.7 1.3 1.5 1.4 2.6 1.1 1.3 1.4 1.1 2 ...
    ##  $ Na                 : num  173 165 158 156 157 162 169 155 163 154 ...
    ##  $ K                  : chr  ">9" "5.6" ">9" ">9" ...
    ##  $ Cl                 : chr  "130" "139" "139" ">140" ...
    ##  $ TCO2               : num  20 21 20 18 17 21 23 22 23 22 ...
    ##  $ BUN                : chr  "125" "68" "81" "98" ...
    ##  $ Glu                : chr  "<20" "42" "<20" "26" ...
    ##  $ Hct                : num  60 54 59 56 54 56 53 59 5.6 50 ...
    ##  $ pH                 : num  7.11 7.15 7.13 7.15 7.12 ...
    ##  $ PCO2               : num  5.9 55.3 55.2 48.5 48.7 58.6 67.7 75.2 65.5 60.5 ...
    ##  $ HCO3               : num  17.9 19 18.3 17 15.9 18.9 20.9 19.6 21.4 20.1 ...
    ##  $ Beecf              : chr  "-12" "-10" "-11" "-12" ...
    ##  $ AnGap              : num  NA 13 NA NA NA 12 13 14 NA 14 ...
    ##  $ Hb                 : num  20.4 18.4 20.1 19 18.4 19 18 20.1 19 17 ...
    ##  - attr(*, "spec")=
    ##   .. cols(
    ##   ..   `Field number` = col_character(),
    ##   ..   `Dissection date` = col_character(),
    ##   ..   Season = col_character(),
    ##   ..   Sex = col_character(),
    ##   ..   Class = col_character(),
    ##   ..   elevation = col_double(),
    ##   ..   `HABITAT description` = col_character(),
    ##   ..   `Total Length` = col_double(),
    ##   ..   `Hind Foot` = col_double(),
    ##   ..   Ear = col_double(),
    ##   ..   `FA length` = col_double(),
    ##   ..   mass = col_double(),
    ##   ..   A1C_1 = col_double(),
    ##   ..   ketone = col_double(),
    ##   ..   Na = col_double(),
    ##   ..   K = col_character(),
    ##   ..   Cl = col_character(),
    ##   ..   TCO2 = col_double(),
    ##   ..   BUN = col_character(),
    ##   ..   Glu = col_character(),
    ##   ..   Hct = col_double(),
    ##   ..   pH = col_double(),
    ##   ..   PCO2 = col_double(),
    ##   ..   HCO3 = col_double(),
    ##   ..   Beecf = col_character(),
    ##   ..   AnGap = col_double(),
    ##   ..   Hb = col_double()
    ##   .. )

There are only 41 bats in this filtered list. Use summary() to compare
the masses of this group of bats to those of the entire set.

You could also use filter to select based on more complex logical
sequences using the & operator (or other logical operators). Compare the
numbers of male bats that are under 55 g to the number of femal bats
that are under 55 g using the filter() function.

## arrange()

The arrange() function is used to reorder rows of a data frame according
to one of the variables/columns. Reordering rows of a data frame (while
preserving corresponding order of other columns) is normally a pain to
do in R. The arrange() function simplifies the process quite a bit.

Here we can order the rows of the data frame by date, so that the first
row is the earliest (oldest) observation and the last row is the latest
(most recent) observation.

``` r
BatData <- arrange(BatData, Dissection.date)
head(select(BatData, Field.number:Class))
```

    ## # A tibble: 6 x 5
    ##   Field.number Dissection.date Season Sex    Class                   
    ##   <chr>        <chr>           <chr>  <chr>  <chr>                   
    ## 1 DMR957       3/10/17         DRY    Female FEMALE NONPREGNANT ADULT
    ## 2 DMR955       3/10/17         DRY    Female FEMALE NONPREGNANT ADULT
    ## 3 DMR959       3/10/17         DRY    Female FEMALE NONPREGNANT ADULT
    ## 4 DMR954       3/10/17         DRY    Female FEMALE PREGNANT ADULT   
    ## 5 DMR956       3/10/17         DRY    Female FEMALE PREGNANT ADULT   
    ## 6 DMR962       3/10/17         DRY    Female FEMALE PREGNANT ADULT

``` r
tail(select(BatData, Field.number:Class))
```

    ## # A tibble: 6 x 5
    ##   Field.number Dissection.date Season Sex    Class             
    ##   <chr>        <chr>           <chr>  <chr>  <chr>             
    ## 1 DMR1021      7/19/17         RAINY  Male   MALE SCROTAL ADULT
    ## 2 DMR1024      7/19/17         RAINY  Male   MALE JUVENILE     
    ## 3 DMR1030      7/20/17         RAINY  Female FEMALE SUBADULT   
    ## 4 DMR1031      7/20/17         RAINY  Female FEMALE SUBADULT   
    ## 5 DMR1032      7/20/17         RAINY  Female FEMALE SUBADULT   
    ## 6 DMR1029      7/20/17         RAINY  Male   MALE SCROTAL ADULT

Columns could also be arranged in descending order: `arrange(BatData,
desc(Dissection.date))`

## rename()

Renaming a variable in a data frame in R is surprisingly hard to do\!
The rename() function is designed to make this process easier. The first
column of our data frame is the Id number that was given to each bat in
the field. The syntax inside the rename() function is to have the new
name on the left-hand side of the = sign and the old name on the
right-hand side.

``` r
BatData <- rename(BatData, Id = Field.number)
head(select(BatData, Id:Class))
```

    ## # A tibble: 6 x 5
    ##   Id     Dissection.date Season Sex    Class                   
    ##   <chr>  <chr>           <chr>  <chr>  <chr>                   
    ## 1 DMR957 3/10/17         DRY    Female FEMALE NONPREGNANT ADULT
    ## 2 DMR955 3/10/17         DRY    Female FEMALE NONPREGNANT ADULT
    ## 3 DMR959 3/10/17         DRY    Female FEMALE NONPREGNANT ADULT
    ## 4 DMR954 3/10/17         DRY    Female FEMALE PREGNANT ADULT   
    ## 5 DMR956 3/10/17         DRY    Female FEMALE PREGNANT ADULT   
    ## 6 DMR962 3/10/17         DRY    Female FEMALE PREGNANT ADULT

That’s nicer\!

## mutate()

The mutate() function exists to compute transformations of variables in
a data frame. Often, you want to create new variables that are derived
from existing variables and mutate() provides a clean interface for
doing that.

For example, we can use Forearm length and mass to calculate a body
condition index (BCI) that will help us measure if a bat has a lower
than usual mass for its size.

``` r
BatData <- mutate(BatData, BCI = mass / FA.length)
summary(BatData$BCI)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##  0.5839  0.6773  0.8388  0.8185  0.9398  1.0702       1

Use the other two lengths that were measured (total body length and hind
foot length) to calculate alternative BCIs.

There is also the related transmute() function, which does the same
thing as mutate() but then drops all non-transformed variables.

## group\_by()

The group\_by() function is used to generate summary statistics from the
data frame within strata defined by a variable. For this dataset, the
column *class* can be used to segregate the bats by sex, age, and
reproductive status. In conjunction with the group\_by() function we
often use the summarize() function.

``` r
BatClasses <- group_by(BatData, Class)
summarize(BatClasses, Mass=mean(mass, na.rm = TRUE), BCI=mean(BCI, na.rm = TRUE))
```

    ## # A tibble: 6 x 3
    ##   Class                     Mass   BCI
    ##   <chr>                    <dbl> <dbl>
    ## 1 FEMALE NONPREGNANT ADULT  60.4 0.804
    ## 2 FEMALE PREGNANT ADULT     69.0 0.926
    ## 3 FEMALE SUBADULT           44.8 0.651
    ## 4 MALE JUVENILE             47.6 0.689
    ## 5 MALE SCROTAL ADULT        75.2 0.991
    ## 6 MALE SUBADULT             65.6 0.870

## Pipelines

The output of one verb can be used by another verb in a **pipeline**.
The pipeline is indicated by the pipe operator: `%>%`

The pipeline operater %\>% is very handy for stringing together multiple
dplyr functions in a sequence of operations. Notice above that every
time we wanted to apply more than one function, the sequence gets buried
in a sequence of nested function calls that is difficult to read:
`third(second(first(x)))` This nesting is not a natural way to think
about a sequence of operations. The %\>% operator allows you to string
operations in a left-to-right fashion: `first(x) %>% second %>% third`

The example from the previous code chunk can be expressed more clearly
using a pipeline:

``` r
group_by(BatData, Class) %>%
  summarize(Mass=mean(mass, na.rm = TRUE), BCI=mean(BCI, na.rm = TRUE))
```

    ## # A tibble: 6 x 3
    ##   Class                     Mass   BCI
    ##   <chr>                    <dbl> <dbl>
    ## 1 FEMALE NONPREGNANT ADULT  60.4 0.804
    ## 2 FEMALE PREGNANT ADULT     69.0 0.926
    ## 3 FEMALE SUBADULT           44.8 0.651
    ## 4 MALE JUVENILE             47.6 0.689
    ## 5 MALE SCROTAL ADULT        75.2 0.991
    ## 6 MALE SUBADULT             65.6 0.870

This way we don’t have to create a set of temporary variables along the
way or create a massive nested sequence of function calls. Notice in the
above code that I pass the BatData data frame to the first call to
group\_by(), but then afterwards I do not have to pass the first
argument to summarize(). Once you travel down the pipeline with %\>%,
the first argument is taken to be the output of the previous element in
the pipeline.

Use a pipeline to compare Mass and BCI of each of the Classes of bat in
each Season. (Hint: consider using group\_by twice)

## Summary

The dplyr package provides a concise set of operations for managing data
frames. With these functions we can do a number of complex operations in
just a few lines of code. In particular, we can often conduct the
beginnings of an exploratory analysis with the powerful combination of
group\_by() and summarize().
