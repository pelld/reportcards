# reportcards

Simple, reusable metric cards for Quarto and R Markdown reports.

There is one main function: `card()`.

Give it one set of values and it returns one card. Give it vectors and it returns a responsive grid.

## Install

```r
remotes::install_github("pelld/reportcards")
```

## One card

```r
library(reportcards)

card(
  name = "Vacancy rate",
  metric = "8.4%",
  colour = "#005eb8",
  band = "Workforce",
  detail = "Latest available month"
)
```

## Multiple cards

```r
card(
  name = c("APCS", "ECDS", "OPA"),
  metric = c("7.4%", "9.1%", "5.8%"),
  colour = "#005eb8",
  band = c("Inpatient", "A&E", "Outpatients")
)
```

The number of cards is inferred from the values supplied. Scalar values are recycled across every card, so the single colour above is used for all three.

Each card can also have its own values:

```r
card(
  name = c("Good", "Watch", "Poor"),
  metric = c("92%", "78%", "61%"),
  colour = c("#007f3b", "#ed8b00", "#d5281b"),
  band = "Performance",
  detail = c("Above target", "Close to target", "Below target")
)
```

By default the grid lays itself out responsively. If you want a particular number of columns, specify it:

```r
card(
  name = c("One", "Two", "Three", "Four"),
  metric = c(10, 20, 30, 40),
  columns = 2
)
```

The CSS is bundled automatically with the package, so an HTML Quarto document only needs to load the package and call `card()`.
