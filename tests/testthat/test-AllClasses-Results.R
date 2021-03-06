
context("AllClasses-Results")

n.test <- 5
test.identity <- FALSE
test.extended <- FALSE


test_that("can create valid object of class ResultsModelEst", {
    initialCombinedModel <- demest:::initialCombinedModel
    extractValues <- demest:::extractValues
    makeOutputModel <- demest:::makeOutputModel
    ## y is Counts
    call <- call("estimateModel", list("model"))
    filename <- "filename"
    mcmc <- c(nBurnin = 1000L, nSim = 1000L, nChain = 3L, nThin = 10L,
              nIteration = 300L)
    seed <- list(c(407L, 1:6), c(407L, 6:1), c(407L, 3:8))
    y <- Counts(array(as.integer(rpois(n = 24, lambda = 20)),
                      dim = 2:4,
                      dimnames = list(sex = c("f", "m"), age = 0:2, time = 2000:2003)),
                dimscales = c(time = "Intervals"))
    y[1] <- NA
    spec <- Model(y ~ Poisson(mean ~ sex * age + time))
    final <- replicate(n = 3,
                       initialCombinedModel(spec, y = y, exposure = NULL, weights = NULL))
    control <- list(call = call,
                    parallel = TRUE,
                    lengthIter = length(extractValues(final[[1L]])))
    model <- makeOutputModel(model = final[[1]]@model, pos = 1L, mcmc = mcmc)
    ans <- new("ResultsModelEst",
               mcmc = mcmc,
               control = control,
               final = final,
               model = model,
               y = y,
               seed = seed)
    expect_true(validObject(ans))
})


test_that("validity tests for ResultsModelEst inherited from Results work", {
    initialCombinedModel <- demest:::initialCombinedModel
    extractValues <- demest:::extractValues
    makeOutputModel <- demest:::makeOutputModel
    call <- call("estimateModel", list("model"))
    filename <- "filename"
    mcmc <- c(nBurnin = 1000L, nSim = 1000L, nChain = 3L, nThin = 10L,
              nIteration = 300L)
    spec <- Model(y ~ Poisson(mean ~ sex * age + time))
    seed <- list(c(407L, 1:6), c(407L, 6:1), c(407L, 3:8))
    y <- Counts(array(as.integer(rpois(n = 24, lambda = 20)),
                      dim = 2:4,
                      dimnames = list(sex = c("f", "m"), age = 0:2, time = 2000:2003)),
                dimscales = c(time = "Intervals"))
    final <- replicate(n = 3,
                       initialCombinedModel(spec, y = y, exposure = NULL, weights = NULL))
    control <- list(call = call,
                    parallel = TRUE,
                    lengthIter = length(extractValues(final[[1]])))
    model <- makeOutputModel(model = final[[1]]@model, pos = 1L, mcmc = mcmc)
    x <- new("ResultsModelEst",
             mcmc = mcmc,
             control = control,
             seed = seed,
             final = final,
             model = model,
             y = y)
    ## control has correct names
    x.wrong <- x
    names(x.wrong@control)[1] <- "wrong"
    expect_error(validObject(x.wrong),
                 "'control' has incorrect names")
    ## control has no missing values
    x.wrong <- x
    x.wrong@control[["parallel"]] <- NA
    expect_error(validObject(x.wrong),
                 "'parallel' is missing")
    ## parallel is logical
    x.wrong <- x
    x.wrong@control[["parallel"]] <- "FALSE"
    expect_error(validObject(x.wrong),
                 "'parallel' does not have type \"logical\"")
    ## lengthIter is integer
    x.wrong <- x
    x.wrong@control[["lengthIter"]] <- 49
    expect_error(validObject(x.wrong),
                 "'lengthIter' does not have type \"integer\"")
    ## valid L'Ecuyer seeds
    x.wrong <- x
    x.wrong@seed[[1]][1] <- 406L
    expect_error(validObject(x.wrong),
                 "element 1 of 'seed' is not a valid L'Ecuyer seed")
    x.wrong <- x
    x.wrong@seed[[2]] <- x.wrong@seed[[2]][1:6]
    expect_error(validObject(x.wrong),
                 "element 2 of 'seed' is not a valid L'Ecuyer seed")
    ## length of seed equal to 1
    x.wrong <- x
    x.wrong@control$parallel <- FALSE
    expect_error(validObject(x.wrong),
                 "'parallel' is FALSE but length of 'seed' is not equal to 1")
    ## all elements of 'final' have same class
    x.wrong <- x
    x.wrong@final[[3]] <- "wrong"
    expect_error(validObject(x.wrong),
                 "elements of 'final' have different classes")
    ## lengthIter consistent with final
    x.wrong <- x
    x.wrong@control$lengthIter <- 51L
    expect_error(validObject(x.wrong),
                 "'lengthIter' and 'final' inconsistent")
})

test_that("validity tests for ResultsModelEst inherited from ResultsEst work", {
    initialCombinedModel <- demest:::initialCombinedModel
    extractValues <- demest:::extractValues
    makeOutputModel <- demest:::makeOutputModel
    call <- call("estimateModel", list("model"))
    filename <- "filename"
    mcmc <- c(nBurnin = 1000L, nSim = 1000L, nChain = 3L, nThin = 10L,
              nIteration = 300L)
    spec <- Model(y ~ Poisson(mean ~ sex * age + time))
    seed <- list(c(407L, 1:6), c(407L, 6:1), c(407L, 3:8))
    y <- Counts(array(as.integer(rpois(n = 24, lambda = 20)),
                      dim = 2:4,
                      dimnames = list(sex = c("f", "m"), age = 0:2, time = 2000:2003)),
                dimscales = c(time = "Intervals"))
    final <- replicate(n = 3,
                       initialCombinedModel(spec, y = y, exposure = NULL, weights = NULL))
    control <- list(call = call,
                    parallel = TRUE,
                    lengthIter = length(extractValues(final[[1]])))
    model <- makeOutputModel(model = final[[1]]@model, pos = 1L, mcmc = mcmc)
    x <- new("ResultsModelEst",
             mcmc = mcmc,
             control = control,
             seed = seed,
             final = final,
             model = model,
             y = y)
    ## mcmc has correct names
    x.wrong <- x
    names(x.wrong@mcmc)[1] <- "wrong"
    expect_error(validObject(x.wrong),
                 "'mcmc' has incorrect names")
    ## mcmc has no missing values
    x.wrong <- x
    x.wrong@mcmc[["nBurnin"]] <- NA
    expect_error(validObject(x.wrong),
                 "'nBurnin' is missing")
    ## elements of mcmc that should be non-negative are non-negative
    x.wrong <- x
    x.wrong@mcmc[["nBurnin"]] <- -1L
    expect_error(validObject(x.wrong),
                 "'nBurnin' is negative")
    x.wrong <- x
    x.wrong@mcmc[["nSim"]] <- -1L
    expect_error(validObject(x.wrong),
                 "'nSim' is negative")
    ## elements of mcmc that should be positive are positive
    x.wrong <- x
    x.wrong@mcmc[["nChain"]] <- 0L
    expect_error(validObject(x.wrong),
                 "'nChain' is less than 1")
    ## nThin <= nSim if nSim > 0L
    x.wrong <- x
    x.wrong@mcmc[["nSim"]] <- 1L
    expect_error(validObject(x.wrong),
                 "'nThin' is greater than 'nSim'")
    ## nIteration == (nSim %/% nThin) * nChain
    x.wrong <- x
    x.wrong@mcmc[["nIteration"]] <- x.wrong@mcmc[["nIteration"]] + 1L
    expect_error(validObject(x.wrong),
                 "'nIteration', 'nSim', 'nThin', and 'nChain' inconsistent")
    ## length of seed equal to nChain
    x.wrong <- x
    x.wrong@seed <- x.wrong@seed[1:2]
    expect_error(validObject(x.wrong),
                 "'parallel' is TRUE but length of 'seed' is not equal to 'nChain'")
    ## length of final equal to nChain
    x.wrong <- x
    x.wrong@final <- x.wrong@final[1:2]
    expect_error(validObject(x.wrong),
                 "length of 'final' not equal to 'nChain'")
})

test_that("validity tests for ResultsModelEst inherited from ResultsModelEst work", {
    initialCombinedModel <- demest:::initialCombinedModel
    extractValues <- demest:::extractValues
    makeOutputModel <- demest:::makeOutputModel
    call <- call("estimateModel", list("model"))
    filename <- "filename"
    mcmc <- c(nBurnin = 1000L, nSim = 1000L, nChain = 3L, nThin = 10L,
              nIteration = 300L)
    y <- Counts(array(as.integer(rpois(n = 24, lambda = 20)),
                      dim = 2:4,
                      dimnames = list(sex = c("f", "m"), age = 0:2, time = 2000:2003)),
                dimscales = c(time = "Intervals"))
    spec <- Model(y ~ Poisson(mean ~ sex * age + time))
    final <- replicate(n = 3,
                       initialCombinedModel(spec, y = y, exposure = NULL, weights = NULL))
    control <- list(call = call,
                    parallel = TRUE,
                    lengthIter = length(extractValues(final[[1]])))
    model <- makeOutputModel(model = final[[1]]@model, pos = 1L, mcmc = mcmc)
    seed <- list(c(407L, 1:6), c(407L, 6:1), c(407L, 3:8))
    x <- new("ResultsModelEst",
             mcmc = mcmc,
             control = control,
             final = final,
             seed = seed,
             model = model,
             y = y)
    ## model is empty list iff nSim is 0
    x.wrong <- x
    x.wrong@mcmc[["nSim"]] <- 0L
    x.wrong@mcmc[["nIteration"]] <- 0L
    expect_error(validObject(x.wrong),
                 "'nSim' is 0 but 'model' is not an empty list")
    x.wrong <- x
    x.wrong@model <- list()
    expect_error(validObject(x.wrong),
                 "'nSim' is not 0 but 'model' is an empty list")
    ## all elements of final have class "CombinedModel"
    x.wrong <- x
    x.wrong@final <- rep(list(rep(1, length(extractValues(final[[1]])))),3)
    expect_error(validObject(x.wrong),
                 "'final' has elements not of class \"CombinedModel\"")
})

test_that("can create valid object of class ResultsModelExposureEst", {
    initialCombinedModel <- demest:::initialCombinedModel
    extractValues <- demest:::extractValues
    makeOutputModel <- demest:::makeOutputModel
    call <- call("estimateModel", list("model"))
    filename <- "filename"
    mcmc <- c(nBurnin = 1000L, nSim = 1000L, nChain = 3L, nThin = 10L,
              nIteration = 300L)
    exposure <- Counts(array(as.double(rpois(n = 24, lambda = 20)),
                      dim = 2:4,
                             dimnames = list(sex = c("f", "m"), age = 0:2, time = 2000:2003)),
                       dimscales = c(time = "Intervals"))
    y <- Counts(array(as.integer(rpois(n = 24, lambda = 2 * exposure)),
                      dim = 2:4,
                      dimnames = list(sex = c("f", "m"), age = 0:2, time = 2000:2003)),
                dimscales = c(time = "Intervals"))
    seed <- list(c(407L, 1:6), c(407L, 6:1), c(407L, 3:8))
    spec <- Model(y ~ Poisson(mean ~ sex * age + time))
    final <- replicate(n = 3,
                       initialCombinedModel(spec, y = y, exposure = exposure, weights = NULL))
    control <- list(call = call,
                    parallel = TRUE,
                    lengthIter = length(extractValues(final[[1]])))
    model <- makeOutputModel(model = final[[1]]@model, pos = 1L, mcmc = mcmc)
    ans <- new("ResultsModelExposureEst",
               mcmc = mcmc,
               control = control,
               final = final,
               model = model,
               seed = seed,
               y = y,
               exposure = exposure)
    expect_true(validObject(ans))
})

test_that("can create valid object of class ResultsModelPred", {
    initialCombinedModel <- demest:::initialCombinedModel
    extractValues <- demest:::extractValues
    makeOutputModel <- demest:::makeOutputModel
    call <- call("estimateModel", list("model"))
    filename <- "filename"
    mcmc <- c(nBurnin = 1000L, nSim = 1000L, nChain = 3L, nThin = 10L,
              nIteration = 300L)
    seed <- list(c(407L, 1:6), c(407L, 6:1), c(407L, 3:8))
    y <- Counts(array(as.integer(rpois(n = 24, lambda = 20)),
                      dim = 2:4,
                      dimnames = list(sex = c("f", "m"), age = 0:2, time = 2000:2003)),
                dimscales = c(time = "Intervals"))
    y[1] <- NA
    spec <- Model(y ~ Poisson(mean ~ sex * age + time))
    final <- replicate(n = 3,
                       initialCombinedModel(spec, y = y, exposure = NULL, weights = NULL))
    control <- list(call = call,
                    parallel = TRUE,
                    lengthIter = length(extractValues(final[[1L]])))
    model <- makeOutputModel(model = final[[1]]@model, pos = 1L, mcmc = mcmc)
    mcmc <- c(nIteration = 300L)
    ans <- new("ResultsModelPred",
               mcmc = mcmc,
               control = control,
               final = final,
               model = model,
               seed = seed)
    expect_true(validObject(ans))
})

test_that("validity tests for ResultsModelPred inherited from ResultsModelPred work", {
    initialCombinedModel <- demest:::initialCombinedModel
    extractValues <- demest:::extractValues
    makeOutputModel <- demest:::makeOutputModel
    call <- call("estimateModel", list("model"))
    filename <- "filename"
    mcmc <- c(nBurnin = 1000L, nSim = 1000L, nChain = 3L, nThin = 10L,
              nIteration = 300L)
    seed <- list(c(407L, 1:6), c(407L, 6:1), c(407L, 3:8))
    y <- Counts(array(as.integer(rpois(n = 24, lambda = 20)),
                      dim = 2:4,
                      dimnames = list(sex = c("f", "m"), age = 0:2, time = 2000:2003)),
                dimscales = c(time = "Intervals"))
    y[1] <- NA
    spec <- Model(y ~ Poisson(mean ~ sex * age + time))
    final <- replicate(n = 3,
                       initialCombinedModel(spec, y = y, exposure = NULL, weights = NULL))
    control <- list(call = call,
                    parallel = TRUE,
                    lengthIter = length(extractValues(final[[1L]])))
    model <- makeOutputModel(model = final[[1]]@model, pos = 1L, mcmc = mcmc)
    mcmc <- c(nIteration = 300L)
    x <- new("ResultsModelPred",
               mcmc = mcmc,
               control = control,
               final = final,
               model = model,
               seed = seed)
        ## all elements of final have class "CombinedModel"
    x.wrong <- x
    x.wrong@final <- rep(list(rep(1, length(extractValues(final[[1]])))),3)
    expect_error(validObject(x.wrong),
                 "'final' has elements not of class \"CombinedModel\"")
})

test_that("can create valid object of class ResultsCountsEst", {
    makeOutputModel <- demest:::makeOutputModel
    initialModel <- demest:::initialModel
    initialCombinedCounts <- demest:::initialCombinedCounts
    makeCollapseTransformExtra <- dembase::makeCollapseTransformExtra
    changeInPos <- demest:::changeInPos
    Skeleton <- demest:::Skeleton
    call <- call("estimateCounts", list("model"))
    filename <- "filename"
    mcmc <- c(nBurnin = 1000L, nSim = 1000L, nChain = 3L, nThin = 10L,
              nIteration = 300L)
    control <- list(call = call,
                    parallel = TRUE,
                    lengthIter = -1L)
    seed <- list(c(407L, 1:6), c(407L, 6:1), c(407L, 3:8))
    y.data <- Counts(array(as.integer(rpois(n = 24, lambda = 20)),
                           dim = 2:4,
                           dimnames = list(sex = c("f", "m"),
                               age = 0:2,
                               time = 2000:2003)),
                     dimscales = c(time = "Intervals"))
    spec <- Model(y ~ Poisson(mean ~ sex * age + time))
    datasets.data <- list(Counts(array(1:6, dim = c(2, 3, 1),
                                       dimnames = list(sex = c("f", "m"),
                                           age = 0:2,
                                           time = 2000)),
                                 dimscales = c(time = "Intervals")),
                          Counts(array(c(1:15, NA), dim = c(2, 2, 4),
                                       dimnames = list(sex = c("f", "m"), age = 1:2,
                                           time = 2000:2003)),
                                 dimscales = c(time = "Intervals")))
    namesDatasets <- c("census", "tax")
    observation.spec <- list(Model(census ~ PoissonBinomial(prob = 0.98)),
                             Model(tax ~ Poisson(mean ~ age)))
    transforms <- list(makeTransform(x = y.data,
                                     y = datasets.data[[1]],
                                     subset = TRUE),
                       makeTransform(x = y.data,
                                     y = datasets.data[[2]],
                                     subset = TRUE))
    transforms <- lapply(transforms, makeCollapseTransformExtra)
    final <- replicate(n = 3,
                       initialCombinedCounts(object = spec,
                                             y = y.data,
                                             exposure = NULL,
                                             observation = observation.spec,
                                             datasets = datasets.data,
                                             namesDatasets = namesDatasets,
                                             transforms = transforms))
    pos <- 1L
    model <- makeOutputModel(model = final[[1]]@model, pos = pos, mcmc = mcmc)
    pos <- pos + changeInPos(model)
    y <- Skeleton(y.data, first = pos)
    pos <- pos + changeInPos(y)
    obs1 <- makeOutputModel(final[[1]]@observation[[1]],
                            pos = pos,
                            mcmc = mcmc)
    pos <- pos + changeInPos(obs1)
    obs2 <- makeOutputModel(final[[1]]@observation[[2]],
                            pos = pos,
                            mcmc = mcmc)
    pos <- pos + changeInPos(obs2)
    observation <- list(census = obs1, tax = obs2)
    datasets <- replace(datasets.data,
                        list = 2,
                        values = list(new("SkeletonMissingDatasetPoisson",
                            data = datasets.data[[2]],
                            offsetsComponent = new("Offsets", c(1L, 24L)),
                            transformComponent = makeTransform(x = y.data, y = datasets.data[[2]],
                                subset = TRUE),
                            offsetsTheta = new("Offsets", c(101L, 116L)))))
    names(datasets) <- c("census", "tax")
    control$lengthIter <- pos - 1L
    x <- new("ResultsCountsEst",
             model = model,
             y = y,
             observation = observation,
             datasets = datasets,
             mcmc = mcmc,
             control = control,
             final = final,
             seed = seed)
    expect_true(validObject(x))
    expect_is(x, "ResultsCountsEst")
})

test_that("validity tests for ResultsCountsEst inherited from ResultsCountsEst work", {
    makeOutputModel <- demest:::makeOutputModel
    initialModel <- demest:::initialModel
    initialCombinedCounts <- demest:::initialCombinedCounts
    makeCollapseTransformExtra <- dembase::makeCollapseTransformExtra
    changeInPos <- demest:::changeInPos
    Skeleton <- demest:::Skeleton
    call <- call("estimateCounts", list("model"))
    filename <- "filename"
    mcmc <- c(nBurnin = 1000L, nSim = 1000L, nChain = 3L, nThin = 10L,
              nIteration = 300L)
    control <- list(call = call,
                    parallel = TRUE,
                    lengthIter = -1L)
    seed <- list(c(407L, 1:6), c(407L, 6:1), c(407L, 3:8))
    y.data <- Counts(array(as.integer(rpois(n = 24, lambda = 20)),
                           dim = 2:4,
                           dimnames = list(sex = c("f", "m"),
                               age = 0:2,
                               time = 2000:2003)),
                     dimscales = c(time = "Intervals"))
    spec <- Model(y ~ Poisson(mean ~ sex * age + time))
    datasets.data <- list(Counts(array(1:6, dim = c(2, 3, 1),
                                       dimnames = list(sex = c("f", "m"),
                                           age = 0:2,
                                           time = 2000)),
                                 dimscales = c(time = "Intervals")),
                          Counts(array(c(1:15, NA), dim = c(2, 2, 4),
                                       dimnames = list(sex = c("f", "m"), age = 1:2,
                                           time = 2000:2003)),
                                 dimscales = c(time = "Intervals")))
    namesDatasets <- c("census", "tax")
    observation.spec <- list(Model(census ~ PoissonBinomial(prob = 0.98)),
                             Model(tax ~ Poisson(mean ~ age)))
    transforms <- list(makeTransform(x = y.data,
                                     y = datasets.data[[1]],
                                     subset = TRUE),
                       makeTransform(x = y.data,
                                     y = datasets.data[[2]],
                                     subset = TRUE))
    transforms <- lapply(transforms, makeCollapseTransformExtra)
    final <- replicate(n = 3,
                       initialCombinedCounts(object = spec,
                                             y = y.data,
                                             exposure = NULL,
                                             observation = observation.spec,
                                             datasets = datasets.data,
                                             namesDatasets = namesDatasets,
                                             transforms = transforms))
    pos <- 1L
    model <- makeOutputModel(model = final[[1]]@model, pos = pos, mcmc = mcmc)
    pos <- pos + changeInPos(model)
    y <- Skeleton(y.data, first = pos)
    pos <- pos + changeInPos(y)
    obs1 <- makeOutputModel(final[[1]]@observation[[1]],
                            pos = pos,
                            mcmc = mcmc)
    pos <- pos + changeInPos(obs1)
    obs2 <- makeOutputModel(final[[1]]@observation[[2]],
                            pos = pos,
                            mcmc = mcmc)
    pos <- pos + changeInPos(obs2)
    observation <- list(census = obs1, tax = obs2)
    datasets <- replace(datasets.data,
                        list = 2,
                        values = list(new("SkeletonMissingDatasetPoisson",
                            data = datasets.data[[2]],
                            offsetsComponent = new("Offsets", c(1L, 24L)),
                            transformComponent = makeTransform(x = y.data, y = datasets.data[[2]],
                                subset = TRUE),
                            offsetsTheta = new("Offsets", c(101L, 116L)))))
    names(datasets) <- c("census", "tax")
    control$lengthIter <- pos - 1L
    x <- new("ResultsCountsEst",
             model = model,
             y = y,
             observation = observation,
             datasets = datasets,
             mcmc = mcmc,
             control = control,
             final = final,
             seed = seed)
    ## model is empty iff nSim is 0
    x.wrong <- x
    x.wrong@model <- list()
    expect_error(validObject(x.wrong),
                 "'nSim' is not 0 but 'model' is an empty list")
    ## observation is empty iff nSim is 0
    x.wrong <- x
    x.wrong@observation <- list()
    expect_error(validObject(x.wrong),
                 "'nSim' is not 0 but 'observation' is an empty list")
    ## all elements of 'final' have class "CombinedCounts"
    ## [can't figure out way of testing this without raising other errors]
    ## all elements of 'observation' have class "list"
    x.wrong <- x
    x.wrong@observation[[1]] <- "wrong"
    expect_error(validObject(x.wrong),
                 "'observation' has elements not of class \"list\"")
    ## 'observation' has names
    x.wrong <- x
    names(x.wrong@observation) <- NULL
    expect_error(validObject(x.wrong),
                 "'observation' does not have names")
    ## all elements of 'datasets' have class "Counts" or "SkeletonMissingDataset"
    x.wrong <- x
    x.wrong@datasets[[1]] <- "wrong"
    expect_error(validObject(x.wrong),
                 "'datasets' has elements not of class \"Counts\" or \"SkeletonMissingDataset\"")
    ## if an element of 'dataset' has class "Counts" it does not have any missing values
    x.wrong <- x
    x.wrong@datasets[[1]][1] <- NA
    expect_error(validObject(x.wrong),
                 "'datasets' has elements of class \"Counts\" with missing values")
    ## 'observation' and 'datasets' have same names
    x.wrong <- x
    names(x.wrong@datasets)[1] <- "wrong"
    expect_error(validObject(x.wrong),
                 "'observation' and 'datasets' have different names")
})

test_that("can create valid object of class ResultsCountsExposureEst", {
    makeOutputModel <- demest:::makeOutputModel
    initialModel <- demest:::initialModel
    initialCombinedCounts <- demest:::initialCombinedCounts
    makeCollapseTransformExtra <- dembase::makeCollapseTransformExtra
    changeInPos <- demest:::changeInPos
    Skeleton <- demest:::Skeleton
    call <- call("estimateCounts", list("model"))
    filename <- "filename"
    mcmc <- c(nBurnin = 1000L, nSim = 1000L, nChain = 3L, nThin = 10L,
              nIteration = 300L)
    control <- list(call = call,
                    parallel = TRUE,
                    lengthIter = -1L)
    seed <- list(c(407L, 1:6), c(407L, 6:1), c(407L, 3:8))
    y.data <- Counts(array(as.integer(rpois(n = 24, lambda = 20)),
                           dim = 2:4,
                           dimnames = list(sex = c("f", "m"),
                               age = 0:2,
                               time = 2000:2003)),
                     dimscales = c(time = "Intervals"))
    exposure <- Counts(array(runif(n = 24, max = 20),
                             dim = 2:4,
                             dimnames = list(sex = c("f", "m"),
                                 age = 0:2,
                                 time = 2000:2003)),
                       dimscales = c(time = "Intervals"))
    spec <- Model(y ~ Poisson(mean ~ sex * age + time))
    datasets.data <- list(Counts(array(1:6, dim = c(2, 3, 1),
                                       dimnames = list(sex = c("f", "m"),
                                           age = 0:2,
                                           time = 2000)),
                                 dimscales = c(time = "Intervals")),
                          Counts(array(1:16, dim = c(2, 2, 4),
                                       dimnames = list(sex = c("f", "m"), age = 1:2,
                                           time = 2000:2003)),
                                 dimscales = c(time = "Intervals")))
    namesDatasets <- c("census", "tax")
    observation.spec <- list(Model(census ~ PoissonBinomial(prob = 0.98)),
                             Model(tax ~ Poisson(mean ~ age)))
    transforms <- list(makeTransform(x = y.data,
                                     y = datasets.data[[1]],
                                     subset = TRUE),
                       makeTransform(x = y.data,
                                     y = datasets.data[[2]],
                                     subset = TRUE))
    transforms <- lapply(transforms, makeCollapseTransformExtra)
    final <- replicate(n = 3,
                       initialCombinedCounts(object = spec,
                                             y = y.data,
                                             exposure = exposure,
                                             observation = observation.spec,
                                             datasets = datasets.data,
                                             namesDatasets = namesDatasets,
                                             transforms = transforms))
    pos <- 1L
    model <- makeOutputModel(model = final[[1]]@model, pos = pos, mcmc = mcmc)
    pos <- pos + changeInPos(model)
    y <- Skeleton(y.data, first = pos)
    pos <- pos + changeInPos(y)
    obs1 <- makeOutputModel(final[[1]]@observation[[1]],
                            pos = pos,
                            mcmc = mcmc)
    pos <- pos + changeInPos(obs1)
    obs2 <- makeOutputModel(final[[1]]@observation[[2]],
                            pos = pos,
                            mcmc = mcmc)
    pos <- pos + changeInPos(obs2)
    observation <- list(census = obs1, tax = obs2)
    datasets <- datasets.data
    names(datasets) <- c("census", "tax")
    control$lengthIter <- pos - 1L
    x <- new("ResultsCountsExposureEst",
             model = model,
             y = y,
             exposure = exposure,
             observation = observation,
             datasets = datasets,
             mcmc = mcmc,
             control = control,
             final = final,
             seed = seed)
    expect_true(validObject(x))
    expect_is(x, "ResultsCountsExposureEst")
})


 
