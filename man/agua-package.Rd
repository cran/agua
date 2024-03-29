% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/agua-package.R
\docType{package}
\name{agua-package}
\alias{agua-package}
\alias{_PACKAGE}
\alias{agua}
\title{tidymodels integration with h2o}
\description{
agua allows users to fit and tune models using the H2O
platform with tidymodels syntax. The package provides a new parsnip
computational engine 'h2o' for various models and sets up additional
infrastructure for tune.
}
\details{
The package uses code initially written by Steven Pawley in his h2oparsnip
package. Addition work was done by Qiushi Yan as a Posit summer intern.

There are two main components in agua:
\itemize{
\item New parsnip engine \code{'h2o'} for many models, see the
\href{https://agua.tidymodels.org/articles/agua.html}{vignette} for a
complete list.
\item Infrastructure for the tune package.
}

When fitting a parsnip model, the data are passed to the h2o server
directly. For tuning, the data are passed once and instructions are
given to \code{h2o.grid()} to process them.

This work is based on @stevenpawley’s
\href{https://github.com/stevenpawley/h2oparsnip}{h2oparsnip} package.
Additional work was done by Qiushi Yan for his 2022 summer internship at
Posit.
\subsection{Installation}{

The CRAN version of the package can be installed via

\if{html}{\out{<div class="sourceCode r">}}\preformatted{install.packages("agua")
}\if{html}{\out{</div>}}

You can also install the development version of agua using:

\if{html}{\out{<div class="sourceCode r">}}\preformatted{require(pak)
pak::pak("tidymodels/agua")
}\if{html}{\out{</div>}}
}

\subsection{Examples}{

The following code demonstrates how to create a single model on the h2o
server and how to make predictions.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{library(tidymodels)
library(agua)

# Start the h2o server before running models
h2o_start()

# Demonstrate fitting parsnip models: 
# Specify the type of model and the h2o engine 
spec <-
  rand_forest(mtry = 3, trees = 1000) \%>\%
  set_engine("h2o") \%>\%
  set_mode("regression")

# Fit the model on the h2o server
set.seed(1)
mod <- fit(spec, mpg ~ ., data = mtcars)
mod
#> parsnip model object
#> 
#> Model Details:
#> ==============
#> 
#> H2ORegressionModel: drf
#> Model ID:  DRF_model_R_1665517828283_1 
#> Model Summary: 
#>   number_of_trees number_of_internal_trees model_size_in_bytes min_depth
#> 1            1000                     1000              285916         4
#>   max_depth mean_depth min_leaves max_leaves mean_leaves
#> 1        10    6.70600         10         27    18.04100
#> 
#> 
#> H2ORegressionMetrics: drf
#> ** Reported on training data. **
#> ** Metrics reported on Out-Of-Bag training samples **
#> 
#> MSE:  4.354
#> RMSE:  2.087
#> MAE:  1.658
#> RMSLE:  0.09849
#> Mean Residual Deviance :  4.354

# Predictions
predict(mod, head(mtcars))
#> # A tibble: 6 × 1
#>   .pred
#>   <dbl>
#> 1  20.9
#> 2  20.8
#> 3  23.3
#> 4  20.4
#> 5  17.9
#> 6  18.7

# When done
h2o_end()
}\if{html}{\out{</div>}}

Before using the \code{'h2o'} engine, users need to run \code{agua::h2o_start()}
or \code{h2o::h2o.init()} to start the h2o server, which will be storing
data, models, and other values passed from the R session.

There are several package vignettes including:
\itemize{
\item \href{https://agua.tidymodels.org/articles/agua.html}{Introduction to agua}
\item \href{https://agua.tidymodels.org/articles/tune.html}{Model tuning}
\item \href{https://agua.tidymodels.org/articles/auto_ml.html}{Automatic machine learning}
\item \href{https://agua.tidymodels.org/articles/parallel.html}{Parallel processing with agua and h2o}
}
}
}
\seealso{
Useful links:
\itemize{
  \item \url{https://agua.tidymodels.org/}
  \item \url{https://github.com/tidymodels/agua}
  \item Report bugs at \url{https://github.com/tidymodels/agua/issues}
}

}
\author{
\strong{Maintainer}: Qiushi Yan \email{qiushi.yann@gmail.com}

Authors:
\itemize{
  \item Max Kuhn \email{max@posit.co} (\href{https://orcid.org/0000-0003-2402-136X}{ORCID})
  \item Steven Pawley \email{dr.stevenpawley@gmail.com}
}

Other contributors:
\itemize{
  \item Posit Software, PBC [copyright holder, funder]
}

}
\keyword{internal}
