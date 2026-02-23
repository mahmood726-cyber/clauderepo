#' Standardize Meta-Analysis Data
#'
#' @param data Input data frame
#' @return Standardized data frame with consistent column names
#' @export
standardize_data <- function(data) {
  if (!is.data.frame(data)) stop("Input must be a data frame")
  
  std_data <- data
  
  # Standardize study identifier
  study_cols <- c("study", "studlab", "study_id", "trial")
  for (col in study_cols) {
    if (col %in% names(std_data)) {
      std_data$study_id <- std_data[[col]]
      break
    }
  }
  if (!"study_id" %in% names(std_data)) std_data$study_id <- paste0("Study_", 1:nrow(std_data))
  
  # Standardize effect size
  effect_cols <- c("yi", "TE", "effect", "effect_size", "estimate")
  for (col in effect_cols) {
    if (col %in% names(std_data)) {
      std_data$yi <- std_data[[col]]
      break
    }
  }
  
  # Standardize standard error
  se_cols <- c("se", "seTE", "sei", "standard_error")
  for (col in se_cols) {
    if (col %in% names(std_data)) {
      std_data$se <- std_data[[col]]
      break
    }
  }
  
  if ("se" %in% names(std_data)) std_data$vi <- std_data$se^2
  
  return(std_data)
}

#' Check package availability
#' @param pkg Name of the package
#' @export
check_pkg <- function(pkg) {
  requireNamespace(pkg, quietly = TRUE)
}
