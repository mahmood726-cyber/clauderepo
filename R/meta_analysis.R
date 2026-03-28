# R/meta_analysis.R - Platinum Meta-Analysis Engine

#' Robust Meta-Analysis with HKSJ Adjustment
#' @export
robust_rma <- function(yi, sei, data = NULL, method = "REML",
                       weights = NULL, mods = NULL, use_hksj = TRUE) {
  if (requireNamespace("metafor", quietly = TRUE)) {
    build_args <- function() {
      a <- list(yi = yi, sei = sei, method = method)
      if (!is.null(data))    a$data    <- data
      if (!is.null(weights)) a$weights <- weights
      if (!is.null(mods))    a$mods    <- mods
      if (isTRUE(use_hksj))  a$test    <- "knha"
      a
    }
    
    fit <- try(do.call(metafor::rma, build_args()), silent = TRUE)
    
    if (inherits(fit, "try-error") && isTRUE(use_hksj)) {
      warning("HKSJ failed, falling back to standard errors.")
      args <- build_args()
      args$test <- NULL
      fit <- try(do.call(metafor::rma, args), silent = TRUE)
    }
    return(fit)
  } else {
    stop("Package 'metafor' is required for this analysis.")
  }
}

#' Run Master Analytical Pipeline
#' @export
cbamm <- function(data, design = "pairwise", ...) {
  std_data <- standardize_data(data)
  
  results <- list(data = std_data)
  
  if (design == "pairwise") {
    results$meta <- robust_rma(std_data$yi, std_data$se, data = std_data, ...)
  }
  
  class(results) <- "cbamm_results"
  return(results)
}
