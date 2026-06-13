# clauderepo: Meta-Analysis Research Compendium

## Overview

`clauderepo` is an R package collecting a small set of meta-analysis helpers
for clinical evidence synthesis. It wraps `metafor` for pairwise pooling and
provides a data-standardization layer plus exploratory Bayesian and network
helpers.

## Modules

- **Pairwise meta-analysis** (`R/meta_analysis.R`): `robust_rma()` wraps
  `metafor::rma()` with Hartung-Knapp-Sidik-Jonkman (HKSJ / `test = "knha"`)
  adjustment and a fallback to standard errors when HKSJ fails. `cbamm()`
  standardizes input and runs the pairwise pipeline.
- **Data standardization** (`R/utils.R`): `standardize_data()` maps common
  column aliases (`TE`/`seTE`, `effect`/`se`, etc.) to `yi`/`se`/`vi` and
  fails closed when a required effect-size or standard-error column is absent.
- **Bayesian helper** (`R/bayesian.R`): `run_bayesian()` fits a normal-normal
  hierarchical model via `rjags` when available, with a manual
  Metropolis-Hastings fallback for the location parameter when JAGS is missing.
- **Network helper** (`R/network.R`): `network_meta_analysis()` is a thin
  `metafor::rma.mv()` wrapper for arm-level network data. `assess_inconsistency()`
  is a placeholder and does not yet perform node-splitting.

## Project structure

- `R/`: package source (analytical helpers).
- `tests/testthat/`: unit tests for the dependency-free utilities.
- `vignettes/`: reproducibility walkthrough.
- `e156-submission/`: E156 micro-paper capsule and dashboard.

## Status and limitations

- The Bayesian fallback samples the location parameter only; the
  heterogeneity parameter is held fixed. Prefer the `rjags` path for inference.
- Network inconsistency assessment is a placeholder.
- Tests cover the standardization utilities; the `metafor`/`rjags` paths are
  exercised by the vignette rather than the unit suite.

## Installation

```r
# install.packages("remotes")
remotes::install_github("mahmood726-cyber/clauderepo")
```

## Author

- **Mahmood Ahmad** - maintainer
