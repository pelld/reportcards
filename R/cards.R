#' Create a single metric card
#'
#' @param name Card heading.
#' @param metric Main value displayed on the card.
#' @param colour Accent colour used for the top border and metric.
#' @param band Optional small text shown above the metric.
#' @param detail Optional text shown below the metric.
#' @param min_height Minimum card height in pixels.
#'
#' @return An htmltools tag.
#' @export
card <- function(name, metric, colour = "#005eb8", band = NULL,
                 detail = NULL, min_height = 150) {

  tag <- htmltools::div(
    class = "report-card",
    style = paste0(
      "--report-card-colour:", colour, ";",
      "--report-card-min-height:", as.numeric(min_height), "px;"
    ),
    htmltools::tags$h4(name),
    if (!is.null(band)) htmltools::div(class = "report-card__band", band),
    htmltools::div(class = "report-card__metric", metric),
    if (!is.null(detail)) htmltools::div(class = "report-card__detail", detail)
  )

  attach_reportcards_dependency(tag)
}


#' Create a responsive grid of metric cards
#'
#' Vector arguments define the cards. Scalar values are recycled across all
#' cards, making it easy to apply one colour or band to a whole grid.
#'
#' @param name Character vector of card headings.
#' @param metric Vector of metrics shown prominently on the cards.
#' @param colour Accent colour. Supply one value for all cards or one per card.
#' @param band Optional small text above each metric. Supply one value for all
#'   cards or one per card.
#' @param detail Optional detail text below each metric. Supply one value for all
#'   cards or one per card.
#' @param columns Number of columns on wider screens.
#' @param min_height Minimum card height in pixels.
#'
#' @return An htmltools tag.
#' @export
card_grid <- function(name, metric, colour = "#005eb8", band = NULL,
                      detail = NULL, columns = 3, min_height = 150) {

  n <- max(
    length(name),
    length(metric),
    length(colour),
    if (is.null(band)) 1L else length(band),
    if (is.null(detail)) 1L else length(detail)
  )

  validate_length(name, n, "name")
  validate_length(metric, n, "metric")
  validate_length(colour, n, "colour")
  validate_length(band, n, "band")
  validate_length(detail, n, "detail")

  columns <- as.integer(columns)

  if (length(columns) != 1L || is.na(columns) || columns < 1L) {
    stop("columns must be a single positive integer.", call. = FALSE)
  }

  name <- rep_len(name, n)
  metric <- rep_len(metric, n)
  colour <- rep_len(colour, n)
  band <- recycle_optional(band, n)
  detail <- recycle_optional(detail, n)

  cards <- Map(
    function(name, metric, colour, band, detail) {
      card(
        name = name,
        metric = metric,
        colour = colour,
        band = band,
        detail = detail,
        min_height = min_height
      )
    },
    name = name,
    metric = metric,
    colour = colour,
    band = band,
    detail = detail
  )

  tag <- do.call(
    htmltools::div,
    c(
      list(
        class = "report-card-grid",
        style = paste0("--report-card-columns:", columns, ";")
      ),
      cards
    )
  )

  attach_reportcards_dependency(tag)
}


validate_length <- function(x, n, argument) {

  if (is.null(x)) {
    return(invisible(NULL))
  }

  if (!length(x) %in% c(1L, n)) {
    stop(
      argument,
      " must contain either 1 value or ",
      n,
      " values.",
      call. = FALSE
    )
  }

  invisible(NULL)
}


recycle_optional <- function(x, n) {

  if (is.null(x)) {
    return(rep(list(NULL), n))
  }

  as.list(rep_len(x, n))
}


attach_reportcards_dependency <- function(tag) {
  htmltools::attachDependencies(
    tag,
    reportcards_dependency(),
    append = TRUE
  )
}


reportcards_dependency <- function() {
  htmltools::htmlDependency(
    name = "reportcards",
    version = "0.1.0",
    src = c(file = system.file("css", package = "reportcards")),
    stylesheet = "reportcards.css"
  )
}
