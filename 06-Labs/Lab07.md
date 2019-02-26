Lab 07
================
Biology Student
20 Feb 2019

Loading Libraries
-----------------

Objectives for Lab 6
--------------------

1.  Introduction to RNA-Seq
2.  Become familiar with NGS file formats
3.  Using Galaxy on BisonNet
4.  Quality control of fastq files

**This .rmd file will be turned in before lab next week as Homework 05**

Background
----------

We will be using the dataset the following paper: <https://genome.cshlp.org/content/21/2/193.full>

The paper is also available in the Readings directory of the class repo.

The Dataset is from Deep Sequencing of Poly(A)+ RNA from the Drosophila melanogaster S2-DRSC cells that have been RNAi depleted of mRNAs encoding RNA binding proteins.

For the tutorial, you will need use the following files in Galaxy: Untreated: SRR031711, SRR031714, SRR031716 RNAi: SRR031718, SRR031724, SRR031726

These files were obtained from the NCBI's Sequence Read Archive: <https://www.ncbi.nlm.nih.gov/sra> Look up each of the Run Accession numbers and record the needed information below.

The number of reads is listed as "\# of Spots".

``` r
SRAsummary <- data.frame(matrix(ncol = 5, nrow = 0))
names(SRAsummary) <- c("SampleName", "LongName", "Layout", "Reads", "Bases")
SRAsummary %>% 
  add_row(
    SampleName = "SRR031711", 
    LongName = "S2_DRSC_Untreated-1", 
    Layout = "SINGLE", 
    Reads = 6064911, 
    Bases = 272.9 * 10^6) -> SRAsummary
```

Calculate how long each read is expected to be:

``` r
SRAsummary %>%
  mutate(ReadLength = round(Bases / (Reads * (1 + (Layout == "PAIRED"))))) -> SRAsummary
print(SRAsummary)
```

    ##   SampleName            LongName Layout   Reads     Bases ReadLength
    ## 1  SRR031711 S2_DRSC_Untreated-1 SINGLE 6064911 272900000         45

``` r
write_csv(SRAsummary, path = "SRAsummary.csv")
```

Study Design
------------

Review the material at <https://rnaseq.uoregon.edu/>, in the paper, and in the SRA to answer the following questions:

1.  What are the conditions that we are going to compare?

2.  How many biological replicates are we studying for each condition?

3.  What sequencing platform was used?

4.  What selection scheme (if any) was performed on the RNA?

5.  What was the depth of sequencing for each sample (min, max, and mean)?

6.  Was a stranded library prep protocol used? If so, what is the strandedness of the reads?

7.  Were the sequences single-end or paired end?

8.  What is the length of the reads?

Next Generation Sequencing Files
--------------------------------

The first type of file that we will examine is a fastq file. The "q" is for quality scores. It is a sequence file (usually DNA) that includes a quality score for every base. Fastq files are flat text files, but they are often found gzipped to save space, with the extension .fastq.gz or .fq.gz

To look at fastq files in R, we will use the ShortRead package: <https://kasperdanielhansen.github.io/genbioconductor/html/ShortRead.html>

``` r
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("ShortRead", version = "3.8")
```

    ## Bioconductor version 3.8 (BiocManager 1.30.4), R 3.5.2 (2018-12-20)

    ## Installing package(s) 'ShortRead'

    ## also installing the dependencies 'formatR', 'matrixStats', 'lambda.r', 'futile.options', 'DelayedArray', 'futile.logger', 'snow', 'SummarizedExperiment', 'RCurl', 'GenomeInfoDbData', 'BiocGenerics', 'BiocParallel', 'Biostrings', 'Rsamtools', 'GenomicAlignments', 'Biobase', 'S4Vectors', 'IRanges', 'GenomeInfoDb', 'GenomicRanges', 'hwriter', 'zlibbioc', 'XVector'

    ## 
    ## The downloaded binary packages are in
    ##  /var/folders/dr/rlkxn8vx5_700djh1yj20z5m0007_6/T//RtmpTcB4Zd/downloaded_packages

    ## installing the source package 'GenomeInfoDbData'

    ## Update old packages: 'dtplyr', 'sf', 'sys'

``` r
library(ShortRead)
```

    ## Loading required package: BiocGenerics

    ## Loading required package: parallel

    ## 
    ## Attaching package: 'BiocGenerics'

    ## The following objects are masked from 'package:parallel':
    ## 
    ##     clusterApply, clusterApplyLB, clusterCall, clusterEvalQ,
    ##     clusterExport, clusterMap, parApply, parCapply, parLapply,
    ##     parLapplyLB, parRapply, parSapply, parSapplyLB

    ## The following objects are masked from 'package:dplyr':
    ## 
    ##     combine, intersect, setdiff, union

    ## The following objects are masked from 'package:stats':
    ## 
    ##     IQR, mad, sd, var, xtabs

    ## The following objects are masked from 'package:base':
    ## 
    ##     anyDuplicated, append, as.data.frame, basename, cbind,
    ##     colMeans, colnames, colSums, dirname, do.call, duplicated,
    ##     eval, evalq, Filter, Find, get, grep, grepl, intersect,
    ##     is.unsorted, lapply, lengths, Map, mapply, match, mget, order,
    ##     paste, pmax, pmax.int, pmin, pmin.int, Position, rank, rbind,
    ##     Reduce, rowMeans, rownames, rowSums, sapply, setdiff, sort,
    ##     table, tapply, union, unique, unsplit, which, which.max,
    ##     which.min

    ## Loading required package: BiocParallel

    ## Loading required package: Biostrings

    ## Loading required package: S4Vectors

    ## Loading required package: stats4

    ## 
    ## Attaching package: 'S4Vectors'

    ## The following objects are masked from 'package:dplyr':
    ## 
    ##     first, rename

    ## The following object is masked from 'package:tidyr':
    ## 
    ##     expand

    ## The following object is masked from 'package:base':
    ## 
    ##     expand.grid

    ## Loading required package: IRanges

    ## 
    ## Attaching package: 'IRanges'

    ## The following objects are masked from 'package:dplyr':
    ## 
    ##     collapse, desc, slice

    ## The following object is masked from 'package:purrr':
    ## 
    ##     reduce

    ## Loading required package: XVector

    ## 
    ## Attaching package: 'XVector'

    ## The following object is masked from 'package:purrr':
    ## 
    ##     compact

    ## 
    ## Attaching package: 'Biostrings'

    ## The following object is masked from 'package:base':
    ## 
    ##     strsplit

    ## Loading required package: Rsamtools

    ## Loading required package: GenomeInfoDb

    ## Loading required package: GenomicRanges

    ## Loading required package: GenomicAlignments

    ## Loading required package: SummarizedExperiment

    ## Loading required package: Biobase

    ## Welcome to Bioconductor
    ## 
    ##     Vignettes contain introductory material; view with
    ##     'browseVignettes()'. To cite Bioconductor, see
    ##     'citation("Biobase")', and for packages 'citation("pkgname")'.

    ## Loading required package: DelayedArray

    ## Loading required package: matrixStats

    ## 
    ## Attaching package: 'matrixStats'

    ## The following objects are masked from 'package:Biobase':
    ## 
    ##     anyMissing, rowMedians

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     count

    ## 
    ## Attaching package: 'DelayedArray'

    ## The following objects are masked from 'package:matrixStats':
    ## 
    ##     colMaxs, colMins, colRanges, rowMaxs, rowMins, rowRanges

    ## The following object is masked from 'package:Biostrings':
    ## 
    ##     type

    ## The following object is masked from 'package:purrr':
    ## 
    ##     simplify

    ## The following objects are masked from 'package:base':
    ## 
    ##     aperm, apply

    ## 
    ## Attaching package: 'GenomicAlignments'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     last

    ## 
    ## Attaching package: 'ShortRead'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     id

    ## The following object is masked from 'package:purrr':
    ## 
    ##     compose

    ## The following object is masked from 'package:tibble':
    ## 
    ##     view

The ShortRead package was one of the first Bioconductor packages to deal with low-level analysis of high-throughput sequencing data. Some of its functionality has now been superseded by other packages, but there is still relevant functionality left.

Reading FASTQ files The FASTQ file format is the standard way of representing raw (unaligned) next generation sequencing reads, particular for the Illumina platform. The format basically consists of 4 lines per read, with the lines containing

1.  Read name (sometimes includes flowcell ID or other information).
2.  Read nucleotides
3.  Either empty or a repeat of line 1
4.  Encoded read quality scores

Paired-end reads are (usually) stored in two separate files, where the reads are ordered the same (this is obviously fragile; what if reads are re-ordered in one file and not the other).

These files are read by `readFastq()` which produces an object of class `ShortReadQ`.

``` r
list.files()
```

    ##  [1] "acne.csv"                      "acne2.csv"                    
    ##  [3] "Lab02.pdf"                     "Lab02.Rmd"                    
    ##  [5] "Lab04.md"                      "Lab04.Rmd"                    
    ##  [7] "Lab05.Rmd"                     "Lab05warmup_files"            
    ##  [9] "Lab05warmup.md"                "Lab05warmup.Rmd"              
    ## [11] "Lab06_files"                   "Lab06.md"                     
    ## [13] "Lab06.Rmd"                     "Lab07.Rmd"                    
    ## [15] "SetupLab05warmup.R"            "SRAsummary.csv"               
    ## [17] "SRR031714_1.head400.fastq"     "SRR031714_2.head400.fastq"    
    ## [19] "UgandaBatsFilteredMetrics.csv"

``` r
read_1 <- readFastq("SRR031714_1.head400.fastq")
read_2 <- readFastq("SRR031714_2.head400.fastq")
```

The ShortReadQ class has an id and two sets of strings: one for the read nucleotides and one for the base qualities. We can check these strings for the first ten reads and also that the ids match between read\_1 and read\_2.

``` r
id(read_1)[1:10]
```

    ##   A BStringSet instance of length 10
    ##      width seq
    ##  [1]    47 SRR031714.1 HWI-EAS299_130MNEAAXX:2:1:785:591/1
    ##  [2]    48 SRR031714.2 HWI-EAS299_130MNEAAXX:2:1:1703:586/1
    ##  [3]    48 SRR031714.3 HWI-EAS299_130MNEAAXX:2:1:1788:543/1
    ##  [4]    48 SRR031714.4 HWI-EAS299_130MNEAAXX:2:1:1729:593/1
    ##  [5]    49 SRR031714.5 HWI-EAS299_130MNEAAXX:2:1:1247:1030/1
    ##  [6]    48 SRR031714.6 HWI-EAS299_130MNEAAXX:2:1:1747:596/1
    ##  [7]    48 SRR031714.7 HWI-EAS299_130MNEAAXX:2:1:1588:584/1
    ##  [8]    48 SRR031714.8 HWI-EAS299_130MNEAAXX:2:1:1758:603/1
    ##  [9]    48 SRR031714.9 HWI-EAS299_130MNEAAXX:2:1:1744:583/1
    ## [10]    49 SRR031714.10 HWI-EAS299_130MNEAAXX:2:1:1738:523/1

``` r
sread(read_1)[1:10]
```

    ##   A DNAStringSet instance of length 10
    ##      width seq
    ##  [1]    37 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    ##  [2]    37 GTAATTTTTTTGGAGAGTTCATATCGATAAAAAAGAT
    ##  [3]    37 GTTTGTGAAAAATAGATTGCTGGATCAAGAAATTAAA
    ##  [4]    37 GCCGGGAAGAGGATACGTCCGTCGATCGTGTGTCCAG
    ##  [5]    37 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    ##  [6]    37 GTGTAAGGCACTAAAGTATATCTCCTTTTAACATCTC
    ##  [7]    37 GGAGTTCCCCCCTCTGGGTCGCTTCGCTGCGCGTGAC
    ##  [8]    37 GTGATATTAAACGTGATATGAGCGAAAACAAGTCGAA
    ##  [9]    37 GCGGTAATGTATAGGTATACAACTTAAGCGCCATCCA
    ## [10]    37 GCAGAGTGGATTACGTAATTTCGCTCTACCAAACAAA

``` r
quality(read_1)[1:10]
```

    ## class: FastqQuality
    ## quality:
    ##   A BStringSet instance of length 10
    ##      width seq
    ##  [1]    37 IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
    ##  [2]    37 IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIB
    ##  [3]    37 IIIIIIIIIIIIIIIIIIII'IIIIIIIIIIIIIIII
    ##  [4]    37 IIIIIIIIIIIIIIIIIIIIIEIII$II(I8I;II63
    ##  [5]    37 IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
    ##  [6]    37 IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
    ##  [7]    37 IIIIIIIIIIIIIIIIII$IIII3III64&III>I;I
    ##  [8]    37 IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIH<
    ##  [9]    37 IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII9
    ## [10]    37 IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIDI

``` r
# Check that ids match
id(read_2)[1:10]
```

    ##   A BStringSet instance of length 10
    ##      width seq
    ##  [1]    47 SRR031714.1 HWI-EAS299_130MNEAAXX:2:1:785:591/2
    ##  [2]    48 SRR031714.2 HWI-EAS299_130MNEAAXX:2:1:1703:586/2
    ##  [3]    48 SRR031714.3 HWI-EAS299_130MNEAAXX:2:1:1788:543/2
    ##  [4]    48 SRR031714.4 HWI-EAS299_130MNEAAXX:2:1:1729:593/2
    ##  [5]    49 SRR031714.5 HWI-EAS299_130MNEAAXX:2:1:1247:1030/2
    ##  [6]    48 SRR031714.6 HWI-EAS299_130MNEAAXX:2:1:1747:596/2
    ##  [7]    48 SRR031714.7 HWI-EAS299_130MNEAAXX:2:1:1588:584/2
    ##  [8]    48 SRR031714.8 HWI-EAS299_130MNEAAXX:2:1:1758:603/2
    ##  [9]    48 SRR031714.9 HWI-EAS299_130MNEAAXX:2:1:1744:583/2
    ## [10]    49 SRR031714.10 HWI-EAS299_130MNEAAXX:2:1:1738:523/2

``` r
# The end of each id is different for read 1 and read 2 (as expected).
# To remove this we will use gsub
?gsub
sum(gsub("/1", "", id(read_1)) == gsub("/2", "", id(read_2)))
```

    ## [1] 100

``` r
sum(gsub("/1", "", id(read_1)) != gsub("/2", "", id(read_2)))
```

    ## [1] 0

Note how the quality scores are listed as characters. You can convert them into standard 0-40 integer quality scores by

``` r
as(quality(read_1), "matrix")[1:10,1:37]
```

    ##       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10] [,11] [,12] [,13]
    ##  [1,]   40   40   40   40   40   40   40   40   40    40    40    40    40
    ##  [2,]   40   40   40   40   40   40   40   40   40    40    40    40    40
    ##  [3,]   40   40   40   40   40   40   40   40   40    40    40    40    40
    ##  [4,]   40   40   40   40   40   40   40   40   40    40    40    40    40
    ##  [5,]   40   40   40   40   40   40   40   40   40    40    40    40    40
    ##  [6,]   40   40   40   40   40   40   40   40   40    40    40    40    40
    ##  [7,]   40   40   40   40   40   40   40   40   40    40    40    40    40
    ##  [8,]   40   40   40   40   40   40   40   40   40    40    40    40    40
    ##  [9,]   40   40   40   40   40   40   40   40   40    40    40    40    40
    ## [10,]   40   40   40   40   40   40   40   40   40    40    40    40    40
    ##       [,14] [,15] [,16] [,17] [,18] [,19] [,20] [,21] [,22] [,23] [,24]
    ##  [1,]    40    40    40    40    40    40    40    40    40    40    40
    ##  [2,]    40    40    40    40    40    40    40    40    40    40    40
    ##  [3,]    40    40    40    40    40    40    40     6    40    40    40
    ##  [4,]    40    40    40    40    40    40    40    40    36    40    40
    ##  [5,]    40    40    40    40    40    40    40    40    40    40    40
    ##  [6,]    40    40    40    40    40    40    40    40    40    40    40
    ##  [7,]    40    40    40    40    40     3    40    40    40    40    18
    ##  [8,]    40    40    40    40    40    40    40    40    40    40    40
    ##  [9,]    40    40    40    40    40    40    40    40    40    40    40
    ## [10,]    40    40    40    40    40    40    40    40    40    40    40
    ##       [,25] [,26] [,27] [,28] [,29] [,30] [,31] [,32] [,33] [,34] [,35]
    ##  [1,]    40    40    40    40    40    40    40    40    40    40    40
    ##  [2,]    40    40    40    40    40    40    40    40    40    40    40
    ##  [3,]    40    40    40    40    40    40    40    40    40    40    40
    ##  [4,]    40     3    40    40     7    40    23    40    26    40    40
    ##  [5,]    40    40    40    40    40    40    40    40    40    40    40
    ##  [6,]    40    40    40    40    40    40    40    40    40    40    40
    ##  [7,]    40    40    40    21    19     5    40    40    40    29    40
    ##  [8,]    40    40    40    40    40    40    40    40    40    40    40
    ##  [9,]    40    40    40    40    40    40    40    40    40    40    40
    ## [10,]    40    40    40    40    40    40    40    40    40    40    40
    ##       [,36] [,37]
    ##  [1,]    40    40
    ##  [2,]    40    33
    ##  [3,]    40    40
    ##  [4,]    21    18
    ##  [5,]    40    40
    ##  [6,]    40    40
    ##  [7,]    26    40
    ##  [8,]    39    27
    ##  [9,]    40    24
    ## [10,]    35    40

In this conversion, each letter is matched to an integer between 0 and 40. This matching is known as the “encoding” of the quality scores and there has been different ways to do this encoding. Unfortunately, it is not stored in the FASTQ file which encoding is used, so you have to know or guess the encoding. The ShortRead package does this for you.

These numbers are related to the probability that the reported base is different from the template fragment (ie. a sequence error).

Galaxy!
-------

Log in at <http://galaxy.bucknell.edu>

You must be on campus or connected to the VPN to access Galaxy on BisonNet.

Take the interactive tours on the `Galaxy UI` and the `History`.

Moving shared data into your history
------------------------------------

Click on the `Shared Data > Data Libraries` tab.

Click the Pasilla Datset. Select all of the files and then `To History > as Datasets`.

Click `Analyze Data` and verify that the 10 data files have been moved to the History.

Click the eye icon next to each to verify that the files look like they are in the proper fastq format and that the reads are the expected length:
<https://support.illumina.com/bulletins/2016/04/fastq-files-explained.html>

Running FastQC
--------------

In the Tools section, type FastQC in the search box and then click the matching tool.

Run FastQC on one of the files and then wait for it to complete.

View the results by clicking on the eye icon for the Webpage output.

Run FastQC on each of the fastq files.

When all of the jobs are complete (this may take a little while), run the MultiQC tool to aggregate all of the FastQC results into a single report. To select multiple files as input, use command-click (Mac) or ctrl-click (PC).

After MultiQC is run compare the samples to determine if there are any large differences in quality problems between them. You may need to download the MultiQC webpage, unzip it, and open the html file in a browser. Download a file from Galaxy by clicking on it in the History area and then clicking the disk icon.

QC Summary
----------

<http://www.bioinformatics.babraham.ac.uk/projects/fastqc/>

Review the examples of "Good" and "Bad" Illumina data and summarize your impressions of this dataset.

Trimmomatic
-----------

<http://www.usadellab.org/cms/index.php?page=trimmomatic>

To try to improve the quality of this dataset, we will use trimmomatic. Trimmomatic performs a variety of useful trimming tasks for illumina paired-end and single ended data.

Use Galaxy to run trimmomatic on each of the files, paying close attention to the PAIRED files and processing them as `two separate input files`.

Use the following trimmomatic parameters (<http://journal.frontiersin.org/article/10.3389/fgene.2014.00013/full>):

1.  "Perform initial ILLUMINACLIP step?" should be changed to Yes and the settings changed to TruSeq2 (single or paired, as appropriate) and 2:40:15:8. Note that the adapter sequences to be used should match the sequencing technology used to obtain the reads. According to the SRA metadata, these files were obtained using a Genome Analyzer II (GAII) and so TruSeq2 is the correct primer file.

2.  "SLIDINGWINDOW" should be changed to "Average quality required" = 5

3.  Then "Insert trimmomatic operation" and set it to "MINLEN" = 25

Run trimmomatic on each set of files (a total of 6 times).

For the paired files, trimmomatic will produce 4 output files: R1 Paired, R2 Paired, R1 Unpaired, and R2 Unpaired. The unpaired files contain reads that were orphaned when their mate was discarded due to the trimming settings. They can be used in some analyses, but we will not be needing them, so it is best to delet them at this point so they don't confuse us later.

FastQC and MultiQC
------------------

Now run FastQC and MultiQC on the trimmed data. Has it improved? Is it "good" yet?

1.  How many reads were removed from each file during the trimming step?

2.  What are the read lengths of each file after trimming (min, max, mean)?

3.  After trimming, how do the quality of the single-end reads compare to the paired-end reads (within each treatment group)?

4.  After trimming, how do the quality of the RNAi treated reads compare to the control reads (within each sequencing layout type)?

5.  Do you anticipate any problems using this data to compare differential transcript expression between the two treatment groups?

Helpful RNA-Seq Links
---------------------

RNA-seqlopedia: <https://rnaseq.uoregon.edu/>

RNA-Seq Blog: <http://www.rna-seqblog.com/>

QCFAIL Blog: <https://sequencing.qcfail.com/> (Unfortunately it looks like they are no longer posting, but they have some great posts about problems with certain Illumina sequencers.)

QCFAIL post about SRA file corruption: <https://sequencing.qcfail.com/articles/data-can-be-corrupted-upon-extraction-from-sra-files/> (This is why it is so important to look at the raw fastq files and check the lengths of the reads before trimming.)
