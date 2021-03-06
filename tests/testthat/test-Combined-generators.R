
context("Combined-generators")

n.test <- 5
test.identity <- FALSE
test.extended <- TRUE

## Assume that lower-level generator functions are working correctly.
## Only check that valid objects are created, and that the error-checking
## works as expected.

## CombinedModel ######################################################################

test_that("initialCombinedModel creates object of class CombinedModelBinomial from valid inputs", {
    initialCombinedModel <- demest:::initialCombinedModel
    spec <- Model(y ~ Binomial(mean ~ sex + time))
    exposure <- Counts(array(as.integer(rpois(n = 12, lambda = 100)),
                             dim = c(2, 6),
                             dimnames = list(sex = c("f", "m"), time = 2000:2005)),
                       dimscales = c(time = "Intervals"))
    y <- Counts(array(as.integer(rbinom(n = 12, size = exposure, prob = 0.8)),
                             dim = c(2, 6),
                      dimnames = list(sex = c("f", "m"), time = 2000:2005)),
                dimscales = c(time = "Intervals"))
    x <- initialCombinedModel(object = spec, y = y, exposure = exposure, weights = NULL)
    expect_true(validObject(x))
    expect_is(x, "CombinedModelBinomial")
    expect_is(x@model, "BinomialVarying")
    ## y has NA
    spec <- Model(y ~ Binomial(mean ~ sex + time))
    exposure <- Counts(array(as.integer(rpois(n = 12, lambda = 100)),
                             dim = c(2, 6),
                             dimnames = list(sex = c("f", "m"), time = 2000:2005)),
                       dimscales = c(time = "Intervals"))
    y <- Counts(array(as.integer(rbinom(n = 12, size = exposure, prob = 0.8)),
                             dim = c(2, 6),
                      dimnames = list(sex = c("f", "m"), time = 2000:2005)),
                dimscales = c(time = "Intervals"))
    y[1:3] <- NA
    exposure[1:2] <- NA
    x <- initialCombinedModel(object = spec, y = y, exposure = exposure, weights = NULL)
    expect_true(validObject(x))
    expect_is(x, "CombinedModelBinomial")
    expect_is(x@model, "BinomialVarying")
    expect_identical(sum(is.na(x@y)), 3L)
    expect_identical(sum(is.na(x@exposure)), 2L)
})

test_that("initialCombinedModel gives apprioriate warnings and errors with class SpecBinomial", {
    initialCombinedModel <- demest:::initialCombinedModel
    spec <- Model(y ~ Binomial(mean ~ 1))
    exposure <- Counts(array(rpois(n = 12, lambda = 100),
                             dim = c(2, 6),
                             dimnames = list(sex = c("f", "m"), time = 2000:2005)),
                       dimscales = c(time = "Intervals"))
    weights <- Counts(array(rbeta(n = 12, shape1 = 1, shape2 = 1),
                             dim = c(2, 6),
                            dimnames = list(sex = c("f", "m"), time = 2000:2005)),
                      dimscales = c(time = "Intervals"))
    y <- Counts(array(rbinom(n = 12, size = exposure, prob = 0.8),
                             dim = c(2, 6),
                      dimnames = list(sex = c("f", "m"), time = 2000:2005)),
                dimscales = c(time = "Intervals"))
    ## weights argument supplied
    expect_warning(initialCombinedModel(object = spec, y = y, exposure = exposure, weights = weights),
                   "'weights' argument ignored when distribution is Binomial")
    ## y is Values
    expect_error(initialCombinedModel(object = spec, y = as(y, "Values"), exposure = exposure,
                                      weights = NULL),
                 "'y' has class \"Values\" : in a Binomial model 'y' must have class \"Counts\"")
    ## no exposure argument supplied
    expect_error(initialCombinedModel(object = spec, y = y, exposure = NULL,
                                      weights = NULL),
                 "a Binomial model requires an 'exposure' argument, but no 'exposure' argument supplied")
    ## y > exposure
    y.wrong <- y
    y.wrong[1] <- exposure[1] + 1
    expect_error(initialCombinedModel(object = spec, y = y.wrong, exposure = exposure,
                                      weights = NULL),
                 "'y' greater than 'exposure'")
})

test_that("initialCombinedModel creates object of class CombinedModelNormal from valid inputs", {
    initialCombinedModel <- demest:::initialCombinedModel
    ## model is NormalVaryingVarsigmaKnown
    spec <- Model(y ~ Normal(mean ~ sex + time, sd = 2.3))
    y <- Counts(array(rnorm(n = 12),
                      dim = c(2, 6),
                      dimnames = list(sex = c("f", "m"), time = 2000:2005)),
                dimscales = c(time = "Intervals"))
    x <- initialCombinedModel(object = spec, y = y, exposure = NULL, weights = NULL)
    expect_true(validObject(x))
    expect_is(x, "CombinedModelNormal")
    expect_is(x@model, "NormalVaryingVarsigmaKnown")
    expect_identical(x@model@w,
                     rep(1, times = 12))
    ## y has NA
    spec <- Model(y ~ Normal(mean ~ sex + time, sd = 2.3))
    y <- Counts(array(rnorm(n = 12),
                      dim = c(2, 6),
                      dimnames = list(sex = c("f", "m"), time = 2000:2005)),
                dimscales = c(time = "Intervals"))
    y[3] <- NA
    x <- initialCombinedModel(object = spec, y = y, exposure = NULL, weights = NULL)
    expect_true(validObject(x))
    expect_is(x, "CombinedModelNormal")
    expect_is(x@model, "NormalVaryingVarsigmaKnown")
    expect_identical(x@model@w,
                     rep(1, times = 12))
    expect_identical(sum(is.na(x@y)), 1L)
})

test_that("initialCombinedModel gives apprioriate warning with class SpecNormal", {
    initialCombinedModel <- demest:::initialCombinedModel
    spec <- Model(y ~ Normal(mean ~ 1))
    exposure <- Counts(array(rpois(n = 12, lambda = 100),
                             dim = c(2, 6),
                             dimnames = list(sex = c("f", "m"), time = 2000:2005)),
                       dimscales = c(time = "Intervals"))
    weights <- Counts(array(rbeta(n = 12, shape1 = 1, shape2 = 1),
                            dim = c(2, 6),
                            dimnames = list(sex = c("f", "m"), time = 2000:2005)),
                      dimscales = c(time = "Intervals"))
    y <- Counts(array(as.double(rbinom(n = 12, size = exposure, prob = 0.8)),
                      dim = c(2, 6),
                      dimnames = list(sex = c("f", "m"), time = 2000:2005)),
                dimscales = c(time = "Intervals"))
    expect_warning(initialCombinedModel(object = spec, y = y, exposure = exposure, weights = weights),
                   "'exposure' argument ignored when distribution is Normal")
})

test_that("initialCombinedModel creates object of class CombinedModelPoisson from valid inputs", {
    initialCombinedModel <- demest:::initialCombinedModel
    spec <- Model(y ~ Poisson(mean ~ sex + time))
    y <- Counts(array(as.integer(rbinom(n = 12, size = 10, prob = 0.8)),
                             dim = c(2, 6),
                      dimnames = list(sex = c("f", "m"), time = 2000:2005)),
                dimscales = c(time = "Intervals"))
    x <- initialCombinedModel(object = spec, y = y, exposure = NULL, weights = NULL)
    expect_true(validObject(x))
    expect_is(x, "CombinedModelPoissonNotHasExp")
    expect_is(x@model, "PoissonVaryingNotUseExp")
    ## y has NA
    spec <- Model(y ~ Poisson(mean ~ sex + time))
    exposure <- Counts(array(as.numeric(rpois(n = 12, lambda = 100)),
                             dim = c(2, 6),
                             dimnames = list(sex = c("f", "m"), time = 2000:2005)),
                       dimscales = c(time = "Intervals"))
    y <- Counts(array(as.integer(rbinom(n = 12, size = exposure, prob = 0.8)),
                             dim = c(2, 6),
                      dimnames = list(sex = c("f", "m"), time = 2000:2005)),
                dimscales = c(time = "Intervals"))
    y[1:5] <- NA
    x <- initialCombinedModel(object = spec, y = y, exposure = NULL, weights = NULL)
    expect_true(validObject(x))
    expect_is(x, "CombinedModelPoissonNotHasExp")
    expect_is(x@model, "PoissonVaryingNotUseExp")
    expect_identical(sum(is.na(x@y)), 5L)
})

test_that("initialCombinedModel gives apprioriate warnings and errors with class SpecPoisson", {
    initialCombinedModel <- demest:::initialCombinedModel
    ## 'weights' supplied
    spec <- Model(y ~ Poisson(mean ~ 1))
    exposure <- Counts(array(as.double(rpois(n = 12, lambda = 100)),
                             dim = c(2, 6),
                             dimnames = list(sex = c("f", "m"), time = 2000:2005)),
                       dimscales = c(time = "Intervals"))
    weights <- Counts(array(rbeta(n = 12, shape1 = 1, shape2 = 1),
                            dim = c(2, 6),
                            dimnames = list(sex = c("f", "m"), time = 2000:2005)),
                      dimscales = c(time = "Intervals"))
    y <- Counts(array(as.integer(rbinom(n = 12, size = exposure, prob = 0.8)),
                      dim = c(2, 6),
                      dimnames = list(sex = c("f", "m"), time = 2000:2005)),
                dimscales = c(time = "Intervals"))
    expect_warning(initialCombinedModel(object = spec, y = y, exposure = exposure, weights = weights),
                   "'weights' argument ignored when distribution is Poisson")
    ## y is Counts
    spec <- Model(y ~ Poisson(mean ~ 1))
    exposure <- Counts(array(as.double(rpois(n = 12, lambda = 100)),
                             dim = c(2, 6),
                             dimnames = list(sex = c("f", "m"), time = 2000:2005)),
                       dimscales = c(time = "Intervals"))
    y <- Counts(array(as.double(rbinom(n = 12, size = exposure, prob = 0.8)),
                      dim = c(2, 6),
                      dimnames = list(sex = c("f", "m"), time = 2000:2005)),
                dimscales = c(time = "Intervals"))
    expect_error(initialCombinedModel(object = spec, y = as(y, "Values"),
                                      exposure = exposure, weights = NULL),
                 "'y' has class \"Values\" : in a Poisson model 'y' must have class \"Counts\"")
})


## CombinedModel - Predict ############################################################

test_that("test that initialCombinedModelPredict works with with CombinedModelNormal", {
    initialCombinedModelPredict <- demest:::initialCombinedModelPredict
    initialCombinedModel <- demest:::initialCombinedModel
    y <- Values(array(rnorm(n = 30),
                      dim = c(2, 3, 5),
                      dimnames = list(sex = c("f", "m"), age = 0:2, time = 2000:2004)),
                dimscales = c(time = "Intervals"))
    weights <- Counts(array(runif(n = 30),
                            dim = c(2, 3, 5),
                            dimnames = list(sex = c("f", "m"), age = 0:2, time = 2000:2004)),
                      dimscales = c(time = "Intervals"))
    spec <- Model(y ~ Normal(mean ~ age + time))
    combined <- initialCombinedModel(spec, y = y, exposure = NULL, weights = weights)
    ans <- initialCombinedModelPredict(combined = combined,
                                       along = 3L,
                                       labels = NULL,
                                       n = 2,
                                       covariates = NULL,
                                       aggregate = NULL,
                                       lower = NULL,
                                       upper = NULL,
                                       yIsCounts = FALSE)
    expect_is(ans, "CombinedModelNormal")
    expect_is(ans@y, "Values")
    expect_true(all(is.na(ans@y)))
})

test_that("test that initialCombinedModelPredict works with with CombinedModelPoissonNotHasExp", {
    initialCombinedModelPredict <- demest:::initialCombinedModelPredict
    initialCombinedModel <- demest:::initialCombinedModel
    y <- Counts(array(as.integer(rpois(n = 30, lambda = 20)),
                      dim = c(2, 3, 5),
                      dimnames = list(sex = c("f", "m"), age = 0:2, time = 2000:2004)),
                dimscales = c(time = "Intervals"))
    spec <- Model(y ~ Poisson(mean ~ age + time))
    combined <- initialCombinedModel(spec, y = y, exposure = NULL, weights = NULL)
    ans <- initialCombinedModelPredict(combined = combined,
                                       along = 3L,
                                       labels = NULL,
                                       n = 2,
                                       covariates = NULL,
                                       aggregate = NULL,
                                       lower = NULL,
                                       upper = NULL,
                                       yIsCounts = TRUE)
    expect_is(ans, "CombinedModelPoissonNotHasExp")
    expect_is(ans@y, "Counts")
    expect_true(all(is.na(ans@y)))
})

test_that("test that initialCombinedModelPredict works with with CombinedModelBinomial", {
    initialCombinedModelPredict <- demest:::initialCombinedModelPredict
    initialCombinedModel <- demest:::initialCombinedModel
    exposure <- Counts(array(as.integer(rpois(n = 30, lambda = 10)),
                             dim = c(2, 3, 5),
                             dimnames = list(sex = c("f", "m"), age = 0:2, time = 2000:2004)),
                       dimscales = c(time = "Intervals"))
    y <- Counts(array(as.integer(rbinom(n = 30, size = exposure, prob = 0.5)),
                      dim = c(2, 3, 5),
                      dimnames = list(sex = c("f", "m"), age = 0:2, time = 2000:2004)),
                dimscales = c(time = "Intervals"))
    spec <- Model(y ~ Binomial(mean ~ sex * age + time))
    combined <- initialCombinedModel(spec, y = y, exposure = exposure, weights = NULL)
    ans <- initialCombinedModelPredict(combined = combined,
                                       along = 3L,
                                       labels = NULL,
                                       n = 2,
                                       covariates = NULL,
                                       aggregate = NULL,
                                       lower = NULL,
                                       upper = NULL,
                                       yIsCounts = TRUE)
    expect_is(ans, "CombinedModelBinomial")
    expect_is(ans@y, "Counts")
    expect_true(all(is.na(ans@y)))
})

test_that("test that initialCombinedModelPredict works with with CombinedModelPoissonHasExp", {
    initialCombinedModelPredict <- demest:::initialCombinedModelPredict
    initialCombinedModel <- demest:::initialCombinedModel
    exposure <- Counts(array(runif(30, max = 50),
                             dim = c(2, 3, 5),
                             dimnames = list(sex = c("f", "m"), age = 0:2, time = 2000:2004)),
                       dimscales = c(time = "Intervals"))
    y <- Counts(array(as.integer(rpois(n = 30, lambda = 0.5 * exposure)),
                      dim = c(2, 3, 5),
                      dimnames = list(sex = c("f", "m"), age = 0:2, time = 2000:2004)),
                dimscales = c(time = "Intervals"))
    spec <- Model(y ~ Poisson(mean ~ sex * age + time))
    combined <- initialCombinedModel(spec, y = y, exposure = exposure, weights = NULL)
    ans <- initialCombinedModelPredict(combined = combined,
                                       along = 3L,
                                       labels = NULL,
                                       n = 2,
                                       covariates = NULL,
                                       aggregate = NULL,
                                       lower = NULL,
                                       upper = NULL,
                                       yIsCounts = TRUE)
    expect_is(ans, "CombinedModelPoissonHasExp")
    expect_is(ans@y, "Counts")
    expect_true(all(is.na(ans@y)))
})


## CombinedCounts #####################################################################

test_that("initialCombinedCounts creates object of class CombinedCountsPoissonNotHasExp from valid inputs", {
    initialCombinedCounts <- demest:::initialCombinedCounts
    makeCollapseTransformExtra <- dembase::makeCollapseTransformExtra
    ## no subtotals
    object <- Model(y ~ Poisson(mean ~ age * sex))
    y <- Counts(array(c(1:23, NA),
                      dim = 2:4,
                      dimnames = list(sex = c("f", "m"), region = 1:3, age = 0:3)))
    datasets <- list(Counts(array(c(1:11, NA),
                                      dim = c(2, 3, 2),
                                      dimnames = list(sex = c("f", "m"), region = 1:3, age = 2:3))),
                     Counts(array(1:12,
                                  dim = 3:4,
                                  dimnames = list(region = 1:3, age = 0:3))))
    namesDatasets <- c("tax", "census")
    transforms <- list(makeTransform(x = y, y = datasets[[1]], subset = TRUE),
                       makeTransform(x = y, y = datasets[[2]], subset = TRUE))
    transforms <- lapply(transforms, makeCollapseTransformExtra)
    observation <- list(Model(tax ~ Poisson(mean ~ age + sex)),
                        Model(census ~ PoissonBinomial(prob = 0.9)))
    x <- initialCombinedCounts(object = object,
                               y = y,
                               exposure = NULL,
                               observation = observation,
                               datasets = datasets,
                               namesDatasets = namesDatasets,
                               transforms = transforms)
    expect_true(validObject(x))
    expect_is(x, "CombinedCountsPoissonNotHasExp")
    expect_true(!any(is.na(x@y)))
    ## with subtotals
    object <- Model(y ~ Poisson(mean ~ age * sex))
    y <- Counts(array(c(1:18, rep(NA, 6)),
                      dim = 2:4,
                      dimnames = list(sex = c("f", "m"), region = 1:3, age = 0:3)))
    subtotals <- Counts(array(5:6,
                              dim = c(2, 1),
                              dimnames = list(sex = c("f", "m"), age = 3)))
    y <- attachSubtotals(y, subtotals = subtotals)
    datasets <- list(Counts(array(c(1:11, NA),
                                  dim = c(2, 3, 2),
                                  dimnames = list(sex = c("f", "m"), region = 1:3, age = 2:3))),
                     Counts(array(1:12,
                                  dim = 3:4,
                                  dimnames = list(region = 1:3, age = 0:3))))
    namesDatasets <- c("tax", "census")
    transforms <- list(makeTransform(x = y, y = datasets[[1]], subset = TRUE),
                       makeTransform(x = y, y = datasets[[2]], subset = TRUE))
    transforms <- lapply(transforms, makeCollapseTransformExtra)
    observation <- list(Model(tax ~ Poisson(mean ~ age + sex)),
                        Model(census ~ PoissonBinomial(prob = 0.9)))
    x <- initialCombinedCounts(object = object,
                               y = y,
                               exposure = NULL,
                               observation = observation,
                               datasets = datasets,
                               namesDatasets = namesDatasets,
                               transforms = transforms)
    expect_true(validObject(x))
    expect_is(x, "CombinedCountsPoissonNotHasExp")
    expect_true(!any(is.na(x@y)))
    expect_true(is(x@y, "CountsWithSubtotalsInternal"))
})

test_that("initialCombinedCounts creates object of class CombinedCountsPoissonHasExp from valid inputs", {
    initialCombinedCounts <- demest:::initialCombinedCounts
    makeCollapseTransformExtra <- dembase::makeCollapseTransformExtra
    ## no subtotals
    object <- Model(y ~ Poisson(mean ~ age * sex))
    y <- Counts(array(1:24,
                      dim = 2:4,
                      dimnames = list(sex = c("f", "m"), region = 1:3, age = 0:3)))
    exposure <- y + 2
    y[24] <- NA
    datasets <- list(Counts(array(c(1:11, NA),
                                  dim = c(2, 3, 2),
                                  dimnames = list(sex = c("f", "m"), region = 1:3, age = 2:3))),
                     Counts(array(1:12,
                                  dim = 3:4,
                                  dimnames = list(region = 1:3, age = 0:3))))
    namesDatasets <- c("tax", "census")
    transforms <- list(makeTransform(x = y, y = datasets[[1]], subset = TRUE),
                       makeTransform(x = y, y = datasets[[2]], subset = TRUE))
    transforms <- lapply(transforms, makeCollapseTransformExtra)
    observation <- list(Model(tax ~ Poisson(mean ~ age + sex)),
                        Model(census ~ PoissonBinomial(prob = 0.9)))
    x <- initialCombinedCounts(object = object,
                               y = y,
                               exposure = exposure,
                               observation = observation,
                               datasets = datasets,
                               namesDatasets = namesDatasets,
                               transforms = transforms)
    expect_true(validObject(x))
    expect_is(x, "CombinedCountsPoissonHasExp")
    expect_true(!any(is.na(x@y)))
    ## with subtotals
    object <- Model(y ~ Poisson(mean ~ age * sex))
    y <- Counts(array(1:24,
                      dim = 2:4,
                      dimnames = list(sex = c("f", "m"), region = 1:3, age = 0:3)))
    exposure <- y + 2
    y[19:24] <- NA
    subtotals <- Counts(array(5:6,
                              dim = c(2, 1),
                              dimnames = list(sex = c("f", "m"), age = 3)))
    y <- attachSubtotals(y, subtotals = subtotals)
    datasets <- list(Counts(array(c(1:11, NA),
                                  dim = c(2, 3, 2),
                                  dimnames = list(sex = c("f", "m"), region = 1:3, age = 2:3))),
                     Counts(array(1:12,
                                  dim = 3:4,
                                  dimnames = list(region = 1:3, age = 0:3))))
    namesDatasets <- c("tax", "census")
    transforms <- list(makeTransform(x = y, y = datasets[[1]], subset = TRUE),
                       makeTransform(x = y, y = datasets[[2]], subset = TRUE))
    transforms <- lapply(transforms, makeCollapseTransformExtra)
    observation <- list(Model(tax ~ Poisson(mean ~ age + sex)),
                        Model(census ~ PoissonBinomial(prob = 0.9)))
    x <- initialCombinedCounts(object = object,
                               y = y,
                               exposure = exposure,
                               observation = observation,
                               datasets = datasets,
                               namesDatasets = namesDatasets,
                               transforms = transforms)
    expect_true(validObject(x))
    expect_is(x, "CombinedCountsPoissonHasExp")
    expect_true(!any(is.na(x@y)))
    expect_true(is(x@y, "CountsWithSubtotalsInternal"))
})

test_that("initialCombinedCounts creates object of class CombinedCountsBinomial from valid inputs", {
    initialCombinedCounts <- demest:::initialCombinedCounts
    makeCollapseTransformExtra <- dembase::makeCollapseTransformExtra
    object <- Model(y ~ Binomial(mean ~ age * sex))
    y <- Counts(array(1:24,
                      dim = 2:4,
                      dimnames = list(sex = c("f", "m"), region = 1:3, age = 0:3)))
    exposure <- y + 2
    y[24] <- NA
    datasets <- list(Counts(array(c(1:11, NA),
                                  dim = c(2, 3, 2),
                                  dimnames = list(sex = c("f", "m"), region = 1:3, age = 2:3))),
                     Counts(array(1:12,
                                  dim = 3:4,
                                  dimnames = list(region = 1:3, age = 0:3))))
    namesDatasets <- c("tax", "census")
    transforms <- list(makeTransform(x = y, y = datasets[[1]], subset = TRUE),
                       makeTransform(x = y, y = datasets[[2]], subset = TRUE))
    transforms <- lapply(transforms, makeCollapseTransformExtra)
    observation <- list(Model(tax ~ Poisson(mean ~ age + sex)),
                        Model(census ~ PoissonBinomial(prob = 0.9)))
    x <- initialCombinedCounts(object = object,
                               y = y,
                               exposure = exposure,
                               observation = observation,
                               datasets = datasets,
                               namesDatasets = namesDatasets,
                               transforms = transforms)
    expect_true(validObject(x))
    expect_is(x, "CombinedCountsBinomial")
    expect_true(!any(is.na(x@y)))
})


test_that("initialCombinedCounts throws appropriate errors with CombinedCountsBinomial", {
    initialCombinedCounts <- demest:::initialCombinedCounts
    makeCollapseTransformExtra <- dembase::makeCollapseTransformExtra
    object <- Model(y ~ Binomial(mean ~ age * sex))
    y <- Counts(array(1:24,
                      dim = 2:4,
                      dimnames = list(sex = c("f", "m"), region = 1:3, age = 0:3)))
    exposure <- y + 2
    y[24] <- NA
    datasets <- list(Counts(array(c(1:11, NA),
                                  dim = c(2, 3, 2),
                                  dimnames = list(sex = c("f", "m"), region = 1:3, age = 2:3))),
                     Counts(array(1:12,
                                  dim = 3:4,
                                  dimnames = list(region = 1:3, age = 0:3))))
    namesDatasets <- c("tax", "census")
    transforms <- list(makeTransform(x = y, y = datasets[[1]], subset = TRUE),
                       makeTransform(x = y, y = datasets[[2]], subset = TRUE))
    transforms <- lapply(transforms, makeCollapseTransformExtra)
    observation <- list(Model(tax ~ Poisson(mean ~ age + sex)),
                        Model(census ~ PoissonBinomial(prob = 0.9)))
    ## y > exposure
    y.wrong <- y
    y.wrong[1] <- exposure[1] + 1
    expect_error(initialCombinedCounts(object = object,
                                       y = y.wrong,
                                       exposure = exposure,
                                       observation = observation,
                                       datasets = datasets,
                                       namesDatasets = namesDatasets,
                                       transforms = transforms),
                 "'y' greater than 'exposure'")
})












