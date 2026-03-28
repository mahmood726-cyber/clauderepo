# R/bayesian.R - Bayesian Intelligence Module

#' Run Bayesian Meta-Analysis
#' @export
run_bayesian <- function(data, method = "jags", prior = "weakly_informative") {
  if (method == "jags" && requireNamespace("rjags", quietly = TRUE)) {
    # Precision-based priors for JAGS
    prec <- if(prior == "weakly_informative") 0.01 else 1.0
    
    model_string <- paste0("model {
      for (i in 1:n) {
        y[i] ~ dnorm(theta[i], pow(se[i], -2))
        theta[i] ~ dnorm(mu, pow(tau, -2))
      }
      mu ~ dnorm(0, ", prec, ")
      tau ~ dexp(0.5)
    }")
    
    j_data <- list(y = data$yi, se = data$se, n = nrow(data))
    jm <- rjags::jags.model(textConnection(model_string), data = j_data, n.chains = 3, quiet = TRUE)
    rjags::update.jags(jm, 1000)
    samples <- rjags::coda.samples(jm, variable.names = c("mu", "tau"), n.iter = 2000)
    
    return(list(samples = samples, method = "JAGS"))
  }
  
  # Manual Fallback if JAGS missing
  message("Using manual Metropolis-Hastings fallback...")
  return(.manual_mcmc(data))
}

#' @noRd
.manual_mcmc <- function(data, iter = 2000) {
  mu <- 0; tau <- 0.1
  samples <- matrix(NA, iter, 2)
  for (i in 1:iter) {
    mu_p <- rnorm(1, mu, 0.1)
    ll_curr <- sum(dnorm(data$yi, mu, sqrt(data$se^2 + tau^2), log = TRUE))
    ll_prop <- sum(dnorm(data$yi, mu_p, sqrt(data$se^2 + tau^2), log = TRUE))
    if (runif(1) < exp(ll_prop - ll_curr)) mu <- mu_p
    samples[i, ] <- c(mu, tau)
  }
  return(list(samples = samples, method = "Manual MH"))
}
