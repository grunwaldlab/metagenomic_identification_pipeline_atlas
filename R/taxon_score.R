taxon_labels <- c(
  bacteria = "Bacteria",
  archaea = "Archaea",
  viruses = "Viruses",
  fungi = "Fungi",
  plants = "Plants",
  animals = "Animals",
  protists = "Protists"
)

score_taxa <- function(data) {
  taxon_columns <- names(taxon_labels)
  capability_weights <- c("Y" = 1, "~" = 0.5, "DB" = 0.25, "—" = 0)

  data$score <- vapply(seq_len(nrow(data)), function(i) {
    intended <- data$intended_groups[i]
    if (is.na(intended)) intended <- ""
    intended <- strsplit(intended, ";", fixed = TRUE)[[1]]

    points <- vapply(taxon_columns, function(taxon) {
      code <- as.character(data[i, taxon])
      if (taxon %in% intended) {
        c("Y" = 2, "~" = 1.25, "DB" = 1, "—" = 0)[[code]]
      } else {
        capability_weights[[code]]
      }
    }, numeric(1))

    round(sum(points) / 14, 3)
  }, numeric(1))

  data[order(-data$score, data$name), ]
}
