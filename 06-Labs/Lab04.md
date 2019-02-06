Lab 04
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

The preferred syntax of *dplyr* will use a data frame first, followed by
a verb. The output will be another (altered) data frame. However, these
verbs can also be used like traditional R functions where you have the
verb(subject) syntax. We will use this traditional syntax to learn what
these functions do, and then introduce the preferred (pipeline) syntax.

## Loading data

For this exercise we will be using data from Prof. Reeder’s fieldwork in
Uganda. Epauletted fruit bats were collected at two different times of
the year for this study and a variety of health metrics were measured.

Note that this data should not be shared outside this class without
permission.

``` r
BatData <- read_csv("UgandaBatsFilteredMetrics.csv", 
    col_types = cols(`Collection date` = col_date(format = "%m/%d/%y")))
# The col_date format was used to make sure that the Collection date was interpretted properly.
# See ?as.Date for more information and examples.

# Below is a very handy way to eliminate those annoying spaces in the column names!
names(BatData) <- make.names(names(BatData))
```

After you load the data, check that it has loaded correctly by checking
the structure of the data frame. The `str()` function is very useful for
getting to know the structure of your data.

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

    ## [1] "Field.number"    "Collection.date" "Season"

``` r
BatData.subset <- select(BatData, Field.number:Season)
head(BatData.subset)
```

    ## # A tibble: 6 x 3
    ##   Field.number Collection.date Season
    ##   <chr>        <date>          <chr> 
    ## 1 DMR976       2017-03-11      DRY   
    ## 2 DMR957       2017-03-10      DRY   
    ## 3 DMR910       2017-03-05      DRY   
    ## 4 DMR955       2017-03-10      DRY   
    ## 5 DMR966       2017-03-11      DRY   
    ## 6 DMR959       2017-03-10      DRY

Note that the : normally cannot be used with names or strings, but
inside the select() function you can use it to specify a range of
variable names. You can also omit variables using the select() function
by using the negative sign. With select() you can do `select(BatData,
-(Collection.date:Season))`

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

Suppose we wanted to extract the rows where the Mass of the bat was less
than 55 g, which may indicate that the bat is a juvenile or subadult.

``` r
BatData.filter <- filter(BatData, Mass < 55)
str(BatData.filter)
```

    ## Classes 'tbl_df', 'tbl' and 'data.frame':    41 obs. of  12 variables:
    ##  $ Field.number       : chr  "DMR973" "DMR929" "DMR972" "DMR937" ...
    ##  $ Collection.date    : Date, format: "2017-03-11" "2017-03-07" ...
    ##  $ Season             : chr  "DRY" "DRY" "DRY" "DRY" ...
    ##  $ Sex                : chr  "Female" "Female" "Female" "Female" ...
    ##  $ Class              : chr  "FEMALE SUBADULT" "FEMALE SUBADULT" "FEMALE SUBADULT" "FEMALE SUBADULT" ...
    ##  $ Elevation          : num  1027 1027 1027 1030 1027 ...
    ##  $ Habitat.description: chr  "mixed rural agricultural/grasslands area, multiple tukals" "mixed rural agricultural/grasslands area, some tukals" "mixed rural agricultural/grasslands area, multiple tukals" "mixed rural agricultural/grasslands area" ...
    ##  $ Total.Length       : num  114 110 114 114 112 114 120 115 NA 121 ...
    ##  $ Hind.Foot          : num  18 18 18 19 19 18 18 19 NA 18 ...
    ##  $ Ear                : num  21 15 21 21 20 19 22 21 NA 22 ...
    ##  $ FA.length          : num  65.8 68.2 68.3 68.5 68.6 ...
    ##  $ Mass               : num  38.7 45.1 40.4 43.6 43.6 ...
    ##  - attr(*, "spec")=
    ##   .. cols(
    ##   ..   `Field number` = col_character(),
    ##   ..   `Collection date` = col_date(format = "%m/%d/%y"),
    ##   ..   Season = col_character(),
    ##   ..   Sex = col_character(),
    ##   ..   Class = col_character(),
    ##   ..   Elevation = col_double(),
    ##   ..   `Habitat description` = col_character(),
    ##   ..   `Total Length` = col_double(),
    ##   ..   `Hind Foot` = col_double(),
    ##   ..   Ear = col_double(),
    ##   ..   `FA length` = col_double(),
    ##   ..   Mass = col_double()
    ##   .. )

There are only 41 bats in this filtered list. Use summary() to compare
the Masses of this group of bats to those of the entire set.

You could also use filter to select based on more complex logical
sequences using the & operator (or other logical operators). Compare the
numbers of male bats that are under 55 g to the number of female bats
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
BatData <- arrange(BatData, Collection.date)
head(select(BatData, Field.number:Class))
```

    ## # A tibble: 6 x 5
    ##   Field.number Collection.date Season Sex    Class                   
    ##   <chr>        <date>          <chr>  <chr>  <chr>                   
    ## 1 DMR910       2017-03-05      DRY    Female FEMALE NONPREGNANT ADULT
    ## 2 DMR915       2017-03-06      DRY    Female FEMALE PREGNANT ADULT   
    ## 3 DMR916       2017-03-06      DRY    Female FEMALE SUBADULT         
    ## 4 DMR921       2017-03-06      DRY    Male   MALE SCROTAL ADULT      
    ## 5 DMR919       2017-03-06      DRY    Male   MALE JUVENILE           
    ## 6 DMR918       2017-03-06      DRY    Male   MALE JUVENILE

``` r
tail(select(BatData, Field.number:Class))
```

    ## # A tibble: 6 x 5
    ##   Field.number Collection.date Season Sex    Class             
    ##   <chr>        <date>          <chr>  <chr>  <chr>             
    ## 1 DMR1021      2017-07-19      RAINY  Male   MALE SCROTAL ADULT
    ## 2 DMR1024      2017-07-19      RAINY  Male   MALE JUVENILE     
    ## 3 DMR1030      2017-07-20      RAINY  Female FEMALE SUBADULT   
    ## 4 DMR1031      2017-07-20      RAINY  Female FEMALE SUBADULT   
    ## 5 DMR1032      2017-07-20      RAINY  Female FEMALE SUBADULT   
    ## 6 DMR1029      2017-07-20      RAINY  Male   MALE SCROTAL ADULT

Columns could also be arranged in descending order: `arrange(BatData,
desc(Collection.date))`

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
    ##   Id     Collection.date Season Sex    Class                   
    ##   <chr>  <date>          <chr>  <chr>  <chr>                   
    ## 1 DMR910 2017-03-05      DRY    Female FEMALE NONPREGNANT ADULT
    ## 2 DMR915 2017-03-06      DRY    Female FEMALE PREGNANT ADULT   
    ## 3 DMR916 2017-03-06      DRY    Female FEMALE SUBADULT         
    ## 4 DMR921 2017-03-06      DRY    Male   MALE SCROTAL ADULT      
    ## 5 DMR919 2017-03-06      DRY    Male   MALE JUVENILE           
    ## 6 DMR918 2017-03-06      DRY    Male   MALE JUVENILE

That’s nicer\!

## mutate()

The mutate() function exists to compute transformations of variables in
a data frame. Often, you want to create new variables that are derived
from existing variables and mutate() provides a clean interface for
doing that.

For example, we can use Forearm length and Mass to calculate a body
condition index (BCI) that will help us measure if a bat has a lower
than usual Mass for its size.

``` r
BatData <- mutate(BatData, BCI = Mass / FA.length)
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
summarize(BatClasses, Mass=mean(Mass, na.rm = TRUE), BCI=mean(BCI, na.rm = TRUE))
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
The pipeline is indicated by the pipe operator: `%>%`. Pipelines can be
used even if only a single verb is needed. For example, the code
`filter(BatData, Mass < 55)` can be rewritten as: `BatData %>%
filter(Mass < 55)`

The pipeline operater %\>% is very handy for stringing together multiple
dplyr functions in a sequence of operations. Notice above that every
time we wanted to apply more than one function, the sequence gets buried
in a sequence of nested function calls that is difficult to read:
`third(second(first(x)))` This nesting is not a natural way to think
about a sequence of operations. The %\>% operator allows you to string
operations in a left-to-right fashion: `first(x) %>% second %>% third`
or even: `x %>% first %>% second %>% third`

The example from the previous code chunk can be expressed more clearly
using a pipeline:

``` r
BatData %>% 
  group_by(Class) %>%
  summarize(Mass=mean(Mass, na.rm = TRUE), BCI=mean(BCI, na.rm = TRUE))
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
way or create a Massive nested sequence of function calls. Notice in the
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
