Is TWiV getting longer?
================
Neil Saunders
compiled 2021-09-01 20:19:31

-   [Introduction](#introduction)
-   [Get the XML](#get-the-xml)
-   [Make the data frame](#make-the-data-frame)
-   [Is TWiV getting longer?](#is-twiv-getting-longer)
    -   [Scatter plot](#scatter-plot)
    -   [Summarise by year](#summarise-by-year)
    -   [Distribution of duration](#distribution-of-duration)
-   [Conclusions](#conclusions)
    -   [This Week in Microbiology
        (TWiM)](#this-week-in-microbiology-twim)
    -   [This Week in Parasitism (TWiP)](#this-week-in-parasitism-twip)
-   [Other ways to analyse the feed
    data](#other-ways-to-analyse-the-feed-data)
    -   [Keywords](#keywords)

# Introduction

Is science podcast [This Week In Virology](http://www.microbe.tv/twiv/)
getting longer? And some other TWiV trivia.

# Get the XML

Data for every podcast episode is contained in [the RSS
feed](http://twiv.microbeworld.libsynpro.com/twiv). RSS is XML, so
reading it into R is very easy. Details for each episode are found in
the `item` nodes.

# Make the data frame

There is sure to be a clever and elegant way to map straight into a data
frame using *e.g.* `purrr`. This is not that way.

-   `pubDate` is converted to date-time
-   `enclosure length` (bytes) is converted to numeric values
-   `duration` is pre-pended with “00” where hours are absent, then
    converted to seconds as numeric values

The end result is a data frame with rows that look like this:

``` {r-df-rows}
twiv_df %>%
  top_n(5, wt = pubDate) %>%
  kable()
```

# Is TWiV getting longer?

Some time in 2016, I started to form the impression that most episodes
of TWiV were around the two hour mark or more. Unfortunately, this
prompted my decision to stop listening since I listen to several other
podcasts and could not justify 2 hours each week for just one of them.

## Scatter plot

Let’s start with a scatter plot.

There’s a clear increase in duration for the first 4 years of the
podcast, which then levels off. There’s also quite a lot of noise due to
“outliers”: special episodes that tend to be much shorter than average.

![](../../figures/twiv-scatter-1.png)<!-- -->

## Summarise by year

How about if we plot the mean episode duration by year?

Mean duration passed 90 minutes in 2011 and approached 100 minutes in
2015. There is a very slight decrease in the mean duration in the
episodes aired so far for 2017.

![](../../figures/twiv-bar-1.png)<!-- -->

## Distribution of duration

The “ridge line” plot shows duration distributions by year.

This clearly shows the duration creeping towards two hours in 2016, but
dropping back a little in 2017.

![](../../figures/twiv-joy-1.png)<!-- -->

# Conclusions

TWiV duration moved to around 90 minutes on average in 2010 - 2011, then
moved again closer to 100 - 120 minutes in 2015 - 2016. However, the
duration seems to have dropped back a little in 2017.

How about some of the other Microbe TV podcasts?

## This Week in Microbiology (TWiM)

Let’s try comparing these in the same plot.
![](../../figures/twim-joy-1.png)<!-- -->

Side by side might be better? ![](../../figures/twim-joy2-1.png)<!-- -->

## This Week in Parasitism (TWiP)

We’ll try these side by side. ![](../../figures/twip-joy-1.png)<!-- -->

# Other ways to analyse the feed data

## Keywords

A word cloud of the podcast keywords. We remove stop words plus the
words “virus”, “viruses”, “virology”, “viral”, “twiv”.

Keywords occurring 10 or more times:
![](../../figures/twiv-wordcloud-1.png)<!-- -->
