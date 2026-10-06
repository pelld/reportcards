#' Create one or more metric cards
#'
#' Supply single values to create one card, or vectors to create a responsive
#' grid of cards. Scalar arguments are recycled across all cards.
#'
#' @param name Card heading. One value or one per card.
#' @param metric Main value displayed on the card. One value or one per card.
#' @param colour Accent colour used for the top border and metric. One value or
#'   one per card.
#' @param band Optional small text shown above the metric. One value or one per
#'   card.
#' @param detail Optional text shown below the metric. One value or one per card.
#' @param columns Optional number of grid columns. If `NULL`, the grid lays
#'   itself out responsively.
#' @param min_height Minimum card height in pixels.
#'
#' @return An htmltools tag.
#' @export
card <- function(name, metric, colour = "#005eb8", band = NULL,
                 detail = NULL, columns = NULL, min_height = 150) {

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

  name <- rep_len(name, n)
  metric <- rep_len(metric, n)
  colour <- rep_len(colour, n)
  band <- recycle_optional(band, n)
  detail <- recycle_optional(detail, n)

  if (n == 1L) {
    return(
      attach_reportcards_dependency(
        card_one(
          name = name[[1]],
          metric = metric[[1]],
          colour = colour[[1]],
          band = band[[1]],
          detail = detail[[1]],
          min_height = min_height
        )
      )
    )
  }

  if (!is.null(columns)) {
    columns <- as.integer(columns)

    if (length(columns) != 1L || is.na(columns) || columns < 1L) {
      stop("columns must be NULL or a single positive integer.", call. = FALSE)
    }
  }

  cards <- Map(
    function(name, metric, colour, band, detail) {
      card_one(
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

  grid_class <- "report-card-grid"
  grid_style <- NULL

  if (!is.null(columns)) {
    grid_class <- paste(grid_class, "report-card-grid--fixed")
    grid_style <- paste0("--report-card-columns:", columns, ";")
  }

  tag <- do.call(
    htmltools::div,
    c(
      list(class = grid_class, style = grid_style),
      cards
    )
  )

  attach_reportcards_dependency(tag)
}


card_one <- function(name, metric, colour, band, detail, min_height) {

  htmltools::div(
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
    version = "0.1.1",
    src = c(file = system.file("css", package = "reportcards")),
    stylesheet = "reportcards.css"
  )
}
