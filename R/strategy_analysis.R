balanced_features <- function(x) {
  x <- as.matrix(x)
  if (ncol(x) == 0) return(matrix(numeric(), nrow = nrow(x), ncol = 0))
  spread <- apply(x, 2, stats::sd)
  keep <- is.finite(spread) & spread > 0
  if (!any(keep)) return(matrix(numeric(), nrow = nrow(x), ncol = 0))
  z <- scale(x[, keep, drop = FALSE])
  z[!is.finite(z)] <- 0
  z / sqrt(ncol(z))
}

strategy_stage <- function(stage) {
  stage <- tolower(stage)
  if (grepl("report|visual|standardization", stage)) return("reporting")
  if (grepl("workflow orchestration", stage)) return("workflow")
  if (grepl("assembly", stage)) return("assembly")
  if (grepl("binning|genome|gene prediction|quality", stage)) return("genome_recovery")
  if (grepl("functional", stage)) return("functional_annotation")
  if (grepl("classification|profiling|abundance|taxonomy", stage)) return("read_taxonomy")
  if (grepl("mapping|alignment|host|reference", stage)) return("mapping_validation")
  if (grepl("read|preprocessing|filter|qc", stage)) return("read_preparation")
  "other"
}

strategy_pca_data <- function(pipelines, taxa, pipeline_tools, pipeline_groups, groups) {
  ids <- pipelines$pipeline_id
  tool_ids <- sort(unique(pipeline_tools$tool_id))
  tools <- matrix(0, nrow = length(ids), ncol = length(tool_ids),
                  dimnames = list(ids, paste0("tool_", tool_ids)))
  tools[cbind(match(pipeline_tools$pipeline_id, ids), match(pipeline_tools$tool_id, tool_ids))] <- 1

  taxon_columns <- c("bacteria", "archaea", "viruses", "fungi", "plants", "animals", "protists")
  taxon_data <- taxa[match(ids, taxa$pipeline_id), ]
  support_values <- c("Y" = 1, "~" = 0.5, "DB" = 0.25, "—" = 0)
  support <- sapply(taxon_columns, function(taxon) {
    unname(support_values[as.character(taxon_data[[taxon]])])
  })
  intended <- matrix(0, nrow = length(ids), ncol = length(taxon_columns),
                     dimnames = list(ids, paste0("intended_", taxon_columns)))
  for (i in seq_along(ids)) {
    scopes <- as.character(taxon_data$intended_groups[i])
    if (!is.na(scopes) && nzchar(scopes)) {
      intended[i, ] <- as.numeric(taxon_columns %in% strsplit(scopes, ";", fixed = TRUE)[[1]])
    }
  }

  method_names <- c(
    "read_taxonomy", "mapping_validation", "assembly", "genome_recovery",
    "functional_annotation", "read_preparation", "reporting", "workflow"
  )
  methods <- matrix(0, nrow = length(ids), ncol = length(method_names),
                    dimnames = list(ids, paste0("method_", method_names)))
  method_types <- vapply(pipeline_tools$stage, strategy_stage, character(1))
  methods[cbind(match(pipeline_tools$pipeline_id, ids), match(method_types, method_names))] <- 1

  feature_matrix <- do.call(cbind, list(
    balanced_features(tools),
    balanced_features(support),
    balanced_features(intended),
    balanced_features(methods)
  ))
  rownames(feature_matrix) <- ids
  pca <- stats::prcomp(feature_matrix, center = FALSE, scale. = FALSE)
  variance <- summary(pca)$importance[2, 1:2] * 100

  group_ids <- pipeline_groups$group_id[match(ids, pipeline_groups$pipeline_id)]
  group_names <- setNames(groups$group_name, groups$group_id)
  coords <- data.frame(
    pipeline_id = ids,
    pipeline = pipelines$name,
    strategy = unname(group_names[group_ids]),
    PC1 = pca$x[, 1],
    PC2 = pca$x[, 2],
    intended_scope = taxon_data$intended_scope,
    stringsAsFactors = FALSE
  )
  list(scores = coords, variance = variance, feature_count = ncol(feature_matrix))
}

tool_network_data <- function(tools, pipeline_tools) {
  tool_ids <- sort(unique(tools$tool_id))
  metadata <- tools[match(tool_ids, tools$tool_id), ]
  counts <- vapply(tool_ids, function(id) {
    length(unique(pipeline_tools$pipeline_id[pipeline_tools$tool_id == id]))
  }, integer(1))

  tool_category <- function(purpose) {
    purpose <- tolower(purpose)
    if (grepl("workflow orchestration", purpose)) return("Workflow")
    if (grepl("report|visualization|standardizes|typesets", purpose)) return("Reporting")
    if (grepl("viral", purpose)) return("Viral analysis")
    if (grepl("assembly", purpose)) return("Assembly")
    if (grepl("binning|genome|mag", purpose)) return("Genome recovery")
    if (grepl("functional|orthology|protein-domain|profile-hmm|covariance", purpose)) return("Functional annotation")
    if (grepl("alignment|mapping|homology|similarity search", purpose)) return("Alignment / search")
    if (grepl("quality|trimming|filtering|subsampling|manipulation", purpose)) return("Read preparation")
    "Taxonomy / profiling"
  }

  nodes <- data.frame(
    name = metadata$tool_name,
    pipeline_count = counts,
    category = vapply(metadata$purpose, tool_category, character(1)),
    stringsAsFactors = FALSE
  )

  pairs <- lapply(split(pipeline_tools$tool_id, pipeline_tools$pipeline_id), function(ids) {
    ids <- sort(unique(ids))
    if (length(ids) < 2) return(NULL)
    pair_matrix <- utils::combn(ids, 2)
    data.frame(source_id = pair_matrix[1, ], target_id = pair_matrix[2, ])
  })
  pairs <- do.call(rbind, pairs)
  links <- aggregate(rep(1L, nrow(pairs)), by = list(pairs$source_id, pairs$target_id), FUN = sum)
  names(links) <- c("source_id", "target_id", "weight")
  active_ids <- sort(unique(c(links$source_id, links$target_id)))
  nodes <- nodes[match(active_ids, tool_ids), ]
  tool_ids <- active_ids
  links$source <- match(links$source_id, tool_ids) - 1L
  links$target <- match(links$target_id, tool_ids) - 1L
  links <- links[, c("source", "target", "weight")]
  list(nodes = nodes, links = links)
}
