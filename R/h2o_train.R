#' Model wrappers for h2o
#'
#' Basic model wrappers for h2o model functions that include data conversion,
#' seed configuration, and so on.
#'
#' @inheritParams h2o::h2o.randomForest
#' @inheritParams h2o::h2o.xgboost
#' @inheritParams h2o::h2o.glm
#' @param x A data frame of predictors
#' @param y A vector of outcomes.
#' @param model A character string for the model. Current selections are
#' `"randomForest"`, `"xgboost"`, and `"glm"`. Use [h2o::h2o.xgboost.available()]
#' to see if that model can be used on your OS/h2o server.
#' @param ... Other options to pass to the h2o model functions (e.g.,
#' [h2o::h2o.randomForest()]).
#' @return An h2o model object.
#' @examples
#' # start with h2o::h2o.init()
#'
#' if (h2o_running()) {
#'   # -------------------------------------------------------------------------
#'   # Using the model wrappers:
#'   h2o_train_glm(mtcars[, -1], mtcars$mpg)
#'
#'   # -------------------------------------------------------------------------
#'   # using parsnip:
#'
#'   spec <-
#'     rand_forest(mtry = 3, trees = 1000) %>%
#'     set_engine("h2o") %>%
#'     set_mode("regression")
#'
#'   set.seed(1)
#'   mod <- fit(spec, mpg ~ ., data = mtcars)
#'   mod
#'
#'   predict(mod, head(mtcars))
#' }
#' @export
h2o_train <- function(x, y, model, ...) {
  opts <- get_fit_opts(...)
  x <- as.data.frame(x)
  x_names <- names(x)
  x$.outcome <- y
  x <- as_h2o(x)$data

  mod_fun <- paste0("h2o.", model)
  cl <-
    rlang::call2(
      mod_fun,
      .ns = "h2o",
      x = quote(x_names),
      y = ".outcome",
      training_frame = quote(x),
      !!!opts
    )
  rlang::eval_tidy(cl)
}

get_fit_opts <- function(...) {
  opts <- list(...)
  if (!any(names(opts) == "seed")) {
    opts$seed <- sample.int(10^5, 1)
  }
  opts
}

#' @export
#' @rdname h2o_train
h2o_train_rf <- function(x, y, ntrees = 50, mtries = -1, min_rows = 1, ...) {
  h2o_train(
    x,
    y,
    model = "randomForest",
    ntrees = ntrees,
    mtries = mtries,
    min_rows = min_rows,
    ...
  )
}



#' @export
#' @rdname h2o_train
h2o_train_xgboost <-
  function(x,
           y,
           ntrees = 50,
           max_depth = 6,
           min_rows = 1,
           learn_rate = 0.3,
           sample_rate = 1,
           col_sample_rate = 1,
           min_split_improvement = 0,
           stopping_rounds = 0,
           ...) {
    h2o_train(
      x,
      y,
      model = "xgboost",
      ntrees = ntrees,
      max_depth = max_depth,
      min_rows = min_rows,
      learn_rate = learn_rate,
      sample_rate = sample_rate,
      col_sample_rate = col_sample_rate,
      stopping_rounds = stopping_rounds,
      ...
    )
  }

#' @export
#' @rdname h2o_train
h2o_train_glm <-
  function(x,
           y,
           lambda = NULL,
           alpha = NULL,
           ...) {
    h2o_train(
      x,
      y,
      model = "glm",
      lambda = lambda,
      alpha = alpha,
      ...
    )
  }

