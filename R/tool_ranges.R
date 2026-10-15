max_range_gb <- function(x) {
  if (is.na(x) || !nzchar(x)) return(NA_real_)
  if (grepl("^\\s*none\\b", x, ignore.case = TRUE)) return(0)

  pattern <- "([0-9]+(?:\\.[0-9]+)?)\\s*\\+?\\s*(TB|TiB|GB|GiB|MB|MiB|KB|KiB)\\b"
  matches <- regmatches(x, gregexpr(pattern, x, ignore.case = TRUE, perl = TRUE))[[1]]

  if (length(matches) == 0) {
    estimates <- numeric()
    if (grepl("roughly input-sized|proportional to|few GB", x, ignore.case = TRUE)) estimates <- c(estimates, 10)
    if (grepl("several GB|multiple GB", x, ignore.case = TRUE)) estimates <- c(estimates, 20)
    if (grepl("many GB|10s of GB|tens of GB", x, ignore.case = TRUE)) estimates <- c(estimates, 100)
    if (grepl("hundreds of GB|hundreds GB|tens to hundreds", x, ignore.case = TRUE)) estimates <- c(estimates, 300)
    if (grepl("hundreds MB", x, ignore.case = TRUE)) estimates <- c(estimates, 1)
    if (grepl("GB-scale", x, ignore.case = TRUE)) estimates <- c(estimates, 10)
    if (grepl("MB-scale|usually MB|generally MB|tables small|summary.*small", x, ignore.case = TRUE)) estimates <- c(estimates, 0.1)
    if (length(estimates)) return(max(estimates))
    return(NA_real_)
  }

  numbers <- as.numeric(sub(pattern, "\\1", matches, ignore.case = TRUE, perl = TRUE))
  units <- tolower(sub(pattern, "\\2", matches, ignore.case = TRUE, perl = TRUE))
  factors <- c(tb = 1024, tib = 1024, gb = 1, gib = 1, mb = 0.001, mib = 0.001,
               kb = 0.000001, kib = 0.000001)
  max(numbers * unname(factors[units]))
}

speed_rank <- function(x) {
  ranks <- c(Low = 1, `Low-Medium` = 1.5, Medium = 2, High = 3, `N/A` = 4)
  unname(ranks[x])
}
