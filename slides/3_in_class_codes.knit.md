---
title: "Basic R - Inclass - Codes"
format: html
editor: visual
---



#### Read in a csv file


::: {.cell}

```{.r .cell-code}
# Read in a csv file
df <-  read.csv('https://bryantstats.github.io/math421/data/WHO-COVID-19-global-data.csv')
```
:::

::: {.cell}

```{.r .cell-code}
# Show the names of the columns
names(df)
```

::: {.cell-output .cell-output-stdout}
```
[1] "Date_reported"     "Country_code"      "Country"          
[4] "WHO_region"        "New_cases"         "Cumulative_cases" 
[7] "New_deaths"        "Cumulative_deaths"
```
:::
:::

::: {.cell}

```{.r .cell-code}
# structure of the data in general
str(df)
```

::: {.cell-output .cell-output-stdout}
```
'data.frame':	232023 obs. of  8 variables:
 $ Date_reported    : chr  "2020-01-03" "2020-01-04" "2020-01-05" "2020-01-06" ...
 $ Country_code     : chr  "AF" "AF" "AF" "AF" ...
 $ Country          : chr  "Afghanistan" "Afghanistan" "Afghanistan" "Afghanistan" ...
 $ WHO_region       : chr  "EMRO" "EMRO" "EMRO" "EMRO" ...
 $ New_cases        : int  0 0 0 0 0 0 0 0 0 0 ...
 $ Cumulative_cases : int  0 0 0 0 0 0 0 0 0 0 ...
 $ New_deaths       : int  0 0 0 0 0 0 0 0 0 0 ...
 $ Cumulative_deaths: int  0 0 0 0 0 0 0 0 0 0 ...
```
:::

```{.r .cell-code}
# Show first few rows
head(df)
```

::: {.cell-output .cell-output-stdout}
```
  Date_reported Country_code     Country WHO_region New_cases Cumulative_cases
1    2020-01-03           AF Afghanistan       EMRO         0                0
2    2020-01-04           AF Afghanistan       EMRO         0                0
3    2020-01-05           AF Afghanistan       EMRO         0                0
4    2020-01-06           AF Afghanistan       EMRO         0                0
5    2020-01-07           AF Afghanistan       EMRO         0                0
6    2020-01-08           AF Afghanistan       EMRO         0                0
  New_deaths Cumulative_deaths
1          0                 0
2          0                 0
3          0                 0
4          0                 0
5          0                 0
6          0                 0
```
:::
:::

::: {.cell}
::: {.cell-output .cell-output-stdout}
```
[1] "2021-05-06"
```
:::

::: {.cell-output .cell-output-stdout}
```
Time difference of 910 days
```
:::
:::

::: {.cell}

```{.r .cell-code}
df$Date_reported
```
:::

