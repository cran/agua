## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 8,
  fig.height = 5.75,
  out.width = "95%"
)
options(digits = 3)

## ----startup, eval = FALSE----------------------------------------------------
#  library(tidymodels)
#  library(agua)
#  library(ggplot2)
#  tidymodels_prefer()
#  theme_set(theme_bw())
#  
#  # start h2o server
#  h2o_start()
#  
#  data(concrete, package = "modeldata")
#  concrete <-
#    concrete %>%
#    group_by(across(-compressive_strength)) %>%
#    summarize(compressive_strength = mean(compressive_strength),
#              .groups = "drop")
#  
#  concrete
#  #> # A tibble: 992 × 9
#  #>    cement blast_furn…¹ fly_ash water super…² coars…³ fine_…⁴   age compr…⁵
#  #>     <dbl>        <dbl>   <dbl> <dbl>   <dbl>   <dbl>   <dbl> <int>   <dbl>
#  #>  1   102          153        0  192        0    887     942      3    4.57
#  #>  2   102          153        0  192        0    887     942      7    7.68
#  #>  3   102          153        0  192        0    887     942     28   17.3
#  #>  4   102          153        0  192        0    887     942     90   25.5
#  #>  5   108.         162.       0  204.       0    938.    849      3    2.33
#  #>  6   108.         162.       0  204.       0    938.    849      7    7.72
#  #>  7   108.         162.       0  204.       0    938.    849     28   20.6
#  #>  8   108.         162.       0  204.       0    938.    849     90   29.2
#  #>  9   116          173        0  192        0    910.    892.     3    6.28
#  #> 10   116          173        0  192        0    910.    892.     7   10.1
#  #> # … with 982 more rows, and abbreviated variable names
#  #> #   ¹​blast_furnace_slag, ²​superplasticizer, ³​coarse_aggregate,
#  #> #   ⁴​fine_aggregate, ⁵​compressive_strength

## ----rf-fit, eval = FALSE-----------------------------------------------------
#  set.seed(1501)
#  concrete_split <- initial_split(concrete, strata = compressive_strength)
#  concrete_train <- training(concrete_split)
#  concrete_test  <- testing(concrete_split)
#  
#  rf_spec <- rand_forest(mtry = 3, trees = 500) %>%
#    set_engine("h2o", histogram_type = "Random") %>%
#    set_mode("regression")
#  
#  normalized_rec <-
#    recipe(compressive_strength ~ ., data = concrete_train) %>%
#    step_normalize(all_predictors())
#  
#  rf_wflow <- workflow() %>%
#    add_model(rf_spec) %>%
#    add_recipe(normalized_rec)
#  
#  rf_fit <- fit(rf_wflow, data = concrete_train)
#  rf_fit
#  #> ══ Workflow [trained] ════════════════════════════════════════════════════
#  #> Preprocessor: Recipe
#  #> Model: rand_forest()
#  #>
#  #> ── Preprocessor ──────────────────────────────────────────────────────────
#  #> 1 Recipe Step
#  #>
#  #> • step_normalize()
#  #>
#  #> ── Model ─────────────────────────────────────────────────────────────────
#  #> Model Details:
#  #> ==============
#  #>
#  #> H2ORegressionModel: drf
#  #> Model ID:  DRF_model_R_1665503649643_6
#  #> Model Summary:
#  #>   number_of_trees number_of_internal_trees model_size_in_bytes min_depth
#  #> 1             500                      500             2652880        15
#  #>   max_depth mean_depth min_leaves max_leaves mean_leaves
#  #> 1        20   17.97600        375        450   417.48000
#  #>
#  #>
#  #> H2ORegressionMetrics: drf
#  #> ** Reported on training data. **
#  #> ** Metrics reported on Out-Of-Bag training samples **
#  #>
#  #> MSE:  26.5
#  #> RMSE:  5.15
#  #> MAE:  3.7
#  #> RMSLE:  0.169
#  #> Mean Residual Deviance :  26.5

## ----rf-predict, eval = FALSE-------------------------------------------------
#  predict(rf_fit, new_data = concrete_test)
#  #> # A tibble: 249 × 1
#  #>    .pred
#  #>    <dbl>
#  #>  1  6.42
#  #>  2  9.54
#  #>  3  9.20
#  #>  4 25.5
#  #>  5  6.60
#  #>  6 28.6
#  #>  7 10.0
#  #>  8 31.9
#  #>  9 12.1
#  #> 10 11.4
#  #> # … with 239 more rows

## ----rf-fitresample, eval = FALSE---------------------------------------------
#  concrete_folds <-
#    vfold_cv(concrete_train, strata = compressive_strength)
#  
#  fit_resamples(rf_wflow, resamples = concrete_folds)
#  #> # Resampling results
#  #> # 10-fold cross-validation using stratification
#  #> # A tibble: 10 × 4
#  #>    splits           id     .metrics         .notes
#  #>    <list>           <chr>  <list>           <list>
#  #>  1 <split [667/76]> Fold01 <tibble [2 × 4]> <tibble [0 × 3]>
#  #>  2 <split [667/76]> Fold02 <tibble [2 × 4]> <tibble [0 × 3]>
#  #>  3 <split [667/76]> Fold03 <tibble [2 × 4]> <tibble [0 × 3]>
#  #>  4 <split [667/76]> Fold04 <tibble [2 × 4]> <tibble [0 × 3]>
#  #>  5 <split [667/76]> Fold05 <tibble [2 × 4]> <tibble [0 × 3]>
#  #>  6 <split [668/75]> Fold06 <tibble [2 × 4]> <tibble [0 × 3]>
#  #>  7 <split [671/72]> Fold07 <tibble [2 × 4]> <tibble [0 × 3]>
#  #>  8 <split [671/72]> Fold08 <tibble [2 × 4]> <tibble [0 × 3]>
#  #>  9 <split [671/72]> Fold09 <tibble [2 × 4]> <tibble [0 × 3]>
#  #> 10 <split [671/72]> Fold10 <tibble [2 × 4]> <tibble [0 × 3]>

## ---- eval = FALSE------------------------------------------------------------
#  library(vip)
#  
#  rf_fit %>%
#    extract_fit_parsnip() %>%
#    vip()

## ---- echo = FALSE------------------------------------------------------------
knitr::include_graphics("../man/figures/vip.png")

