# reportcards

Simple, reusable metric cards for Quarto and R Markdown reports.

The package is deliberately general: pass ordinary values such as `name`, `metric`, `colour`, `band` and `detail`, and it renders a responsive grid.

## Install

```r
remotes::install_github("pelld/reportcards")
```

## Use

```r
library(reportcards)

card_grid(
  columns = 3,
  name = c("APCS", "ECDS", "OPA"),
  metric = c("7.4%", "9.1%", "5.8%"),
  colour = "#005eb8",
  band = c("Inpatient", "A&E", "Outpatients")
)
```

The number of cards is determined by the values supplied. A single value is recycled across all cards:

```r
card_grid(
  name = c("Activity", "Patients", "Rate", "Change"),
  metric = c("120,431", "88,091", "7.4%", "-0.8 pp"),
  colour = "#005eb8",
  band = "Latest month",
  columns = 4
)
```

Or give each card its own colour:

```r
card_grid(
  name = c("Good", "Watch", "Poor"),
  metric = c("92%", "78%", "61%"),
  colour = c("#007f3b", "#ed8b00", "#d5281b"),
  band = "Performance"
)
```

Optional detail text can also vary by card:

```r
card_grid(
  name = c("Waiting list", "12-hour waits"),
  metric = c("42,381", "7.1%"),
  colour = c("#005eb8", "#d5281b"),
  band = c("Patients", "A&E"),
  detail = c("Down 3.2% since last month", "Up 0.6 pp since last month"),
  columns = 2
)
```

For a single card:

```r
card(
  name = "Vacancy rate",
  metric = "8.4%",
  colour = "#005eb8",
  band = "Workforce",
  detail = "Latest available month"
)
```

The CSS is bundled automatically with the package, so an HTML Quarto document only needs to load the package and call the function.
