resource_score <- function(data) {
  efficiency_rank <- function(x) {
    known <- !is.na(x)
    values <- rep(0.5, length(x))
    n <- sum(known)
    if (n > 1) {
      values[known] <- 1 - (rank(x[known], ties.method = "average") - 1) / (n - 1)
    }
    values
  }

  speed_values <- c(Low = 0, `Low-Medium` = 0.25, Medium = 0.5, High = 1, `N/A` = 0.5)
  data$speed_rank <- unname(c(Low = 1, `Low-Medium` = 1.5, Medium = 2, High = 3, `N/A` = 4)[data$relative_speed])
  speed_score <- unname(speed_values[data$relative_speed])
  speed_score[is.na(speed_score)] <- 0.5

  data$score <- round(rowMeans(cbind(
    ram = efficiency_rank(data$ram_max_gb),
    speed = speed_score,
    database = efficiency_rank(data$database_max_gb)
  )), 3)

  data[order(-data$score, data$name), ]
}
