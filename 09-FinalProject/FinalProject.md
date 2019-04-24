Final Project
================
Biology Student
24 Apr 2019

  - [Loading Libraries](#loading-libraries)
  - [Guidelines](#guidelines)
  - [Suggested directory structure](#suggested-directory-structure)
  - [Background](#background)
  - [Pre-analysis](#pre-analysis)
  - [Analysis](#analysis)
  - [Results](#results)
  - [Conclusions](#conclusions)
  - [Acknowledgements](#acknowledgements)

## Loading Libraries

Be sure to annotate all of your code with comments that describe the
purpose. If the annotation is true for a whole code chunk, leave it
outside of the code chunk. If it only applies to a single line, use
comments within the code chunk.

## Guidelines

This suggested template is optional. You may use different organization
if it is better for your project.

## Suggested directory structure

Adapted from
\[<https://github.com/Reproducible-Science-Curriculum/rr-init>\]

    project
    |- data            # raw and primary data, are not changed once created 
    |  |- raw/         # raw data, will not be altered
    |  +- clean/       # cleaned data, will not be altered once created
    |
    |- code/           # any programmatic code
    |- results         # all output from workflows and analyses
    |  |- figures/     # graphs
    |  +- tables/      # tables
    |
    |- scratch/        # temporary files that can be safely deleted or lost
    |- README          # the top level description of content
    |- preanalysis.Rmd # the preanalysis document
    |- study.Rmd       # executable Rmarkdown for this study, if applicable
    |- study.Rproj     # RStudio project for this study, if applicable

## Background

Summarize the dataset and the reason for the analysis. Provide links to
sources of the data. Provide citations to papers, including DOI links in
the format: [Prof. Field’s Science
paper](https://www.doi.org/10.1126/science.aar2038)

## Pre-analysis

Provide a link to the [Preanalysis document](./preanalysis.Rmd)

## Analysis

Follow the guidelines used throughout the semester about Confirmatory
vs. Exploratory data analysis. Clearly avoid any QRPs\!

This section could either include R code chunks:

Bash code chunks:

``` bash
```

or links to [R scripts](script.R),

Annotate the purpose of each section of code.

## Results

Provide a summary of your key results and interpretations.

Figures generated outside of the Rmd can be inserted as
[links](./results/figures/fig1.png)

or as code chunks:
<img src="results/figures/fig1.png" title="A caption" alt="A caption" width="25%" />

Tables could be inserted in the markdown:

    First Header  | Second Header
    ------------- | -------------
    Content Cell  | Content Cell
    Content Cell  | Content Cell

Or using Kable:

    ## Warning in if (drop) {: the condition has length > 1 and only the first
    ## element will be used

|                   |  mpg | cyl | disp |  hp | drat |    wt |  qsec | vs | am | gear | carb |
| ----------------- | ---: | --: | ---: | --: | ---: | ----: | ----: | -: | -: | ---: | ---: |
| Mazda RX4         | 21.0 |   6 |  160 | 110 | 3.90 | 2.620 | 16.46 |  0 |  1 |    4 |    4 |
| Mazda RX4 Wag     | 21.0 |   6 |  160 | 110 | 3.90 | 2.875 | 17.02 |  0 |  1 |    4 |    4 |
| Datsun 710        | 22.8 |   4 |  108 |  93 | 3.85 | 2.320 | 18.61 |  1 |  1 |    4 |    1 |
| Hornet 4 Drive    | 21.4 |   6 |  258 | 110 | 3.08 | 3.215 | 19.44 |  1 |  0 |    3 |    1 |
| Hornet Sportabout | 18.7 |   8 |  360 | 175 | 3.15 | 3.440 | 17.02 |  0 |  0 |    3 |    2 |

A table caption

## Conclusions

You know what goes here.

## Acknowledgements

And here too\!
