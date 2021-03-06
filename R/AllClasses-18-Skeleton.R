

## VIRTUAL CLASSES ###########################################################

## HAS_TESTS
setClass("Skeleton",
         contains = "VIRTUAL")


setClass("SkeletonDemographic",
         contains = "VIRTUAL")

## HAS_TESTS
setClass("SkeletonMetadata",
         slots = c(metadata = "MetaData"),
         contains = "VIRTUAL",
         validity = function(object) {
             metadata <- object@metadata
             ## 'metadata' does not have iteration or quantile dimensions
             dimtypes <- dembase::dimtypes(metadata, use.names = FALSE)
             for (dimtype in c("iteration", "quantile"))
                 if (dimtype %in% dimtypes)
                     return(gettextf("'%s' has dimension with dimtype \"%s\"",
                                     "metadata", dimtype))
             TRUE
         })

## HAS_TESTS
setClass("SkeletonFirst",
         slots = c(first = "integer"),
         contains = "VIRTUAL",
         validity = function(object) {
             first <- object@first
             ## 'first' has length 1
                 if (!identical(length(first), 1L))
                     return(gettextf("'%s' does not have length %d",
                                     "first", 1L))
             ## 'first' is not missing
                 if (is.na(first))
                     return(gettextf("'%s' is missing",
                                     "first"))
             ## 'first' is positive
             if (first < 1L)
                 return(gettextf("'%s' is less than %d",
                               "first", 1L))
             TRUE
         })

setClass("SkeletonOne",
         contains = c("VIRTUAL", "Skeleton", "SkeletonFirst"))

## HAS_TESTS
setClass("SkeletonMany",
         slots = c(last = "integer"),
         contains = c("VIRTUAL", "Skeleton", "SkeletonFirst"),
         validity = function(object) {
             first <- object@first
             last <- object@last
             ## 'last' has length 1
                 if (!identical(length(last), 1L))
                     return(gettextf("'%s' does not have length %d",
                                     "last", 1L))
             ## 'last' is not missing
                 if (is.na(last))
                     return(gettextf("'%s' is missing",
                                     "last"))
             ## 'last' >= 'first'
             if (last < first)
                 return(gettextf("'%s' is less than '%s'",
                               "last", "first"))
             TRUE
         })

## HAS_TESTS
setClass("SkeletonIndicesShow",
         slots = c(indicesShow = "integer"),
         contains = "VIRTUAL",
         validity = function(object) {
             indicesShow <- object@indicesShow
             first <- object@first
             last <- object@last
             ## 'indicesShow' has no missing values
             if (any(is.na(indicesShow)))
                 return(gettextf("'%s' has missing values",
                               "indicesShow"))
             ## 'indicesShow' has not duplicates
             if (any(duplicated(indicesShow)))
                 return(gettextf("'%s' has duplicates",
                               "indicesShow"))
             ## 'indicesShow' within valid range
             valid.range <- seq_len(last - first + 1L)
             if (!all(indicesShow %in% valid.range))
                 return(gettextf("'%s' has elements outside valid range",
                                 "indicesShow"))
             TRUE
         })            

## HAS_TESTS
setClass("SkeletonOffsetsHigher",
         slots = c(offsetsHigher = "list"),
         contains = "VIRTUAL",
         validity = function(object) {
             offsetsHigher <- object@offsetsHigher
             ## all elements of 'offsetsHigher' have class "Offsets"
             if (!all(sapply(offsetsHigher, is, "Offsets")))
                 return(gettextf("'%s' has elements not of class \"%s\"",
                                 "offsetsHigher", "Offsets"))
             TRUE
         })

## HAS_TESTS
setClass("SkeletonTransformsHigher",
         slots = c(transformsHigher = "list"),
         contains = "VIRTUAL",
         validity = function(object) {
             transformsHigher <- object@transformsHigher
             ## all elements of 'transformsHigher' have class "CollapseTransform"
             if (!all(sapply(transformsHigher, is, "CollapseTransform")))
                 return(gettextf("'%s' has elements not of class \"%s\"",
                                 "transformsHigher", "CollapseTransform"))
             TRUE
         })

## HAS_TESTS
setClass("SkeletonOffsetsTheta",
         slots = c(offsetsTheta = "Offsets"),
         contains = "VIRTUAL",
         validity = function(object) {
             data <- object@data
             offsetsTheta <- object@offsetsTheta
             ## 'data' and 'offsetsTheta' consistent
             if (!identical(length(data), offsetsTheta[2L] - offsetsTheta[1L] + 1L))
                 return(gettextf("'%s' and '%s' inconsistent",
                                 "data", "offsetsTheta"))
             TRUE
         })

## HAS_TESTS
setClass("SkeletonExposure",
         slots = c(exposure = "Counts"),
         contains = "VIRTUAL",
         validity = function(object) {
             data <- object@data
             exposure <- object@exposure
             ## 'data' and 'exposure' have same metadata
             if (!identical(data@metadata, exposure@metadata))
                 return(gettextf("'%s' and '%s' have different metadata",
                                 "data", "exposure"))
             TRUE
         })

## HAS_TESTS
setClass("SkeletonW",
         slots = c(w = "numeric"),
         contains = "VIRTUAL",
         validity = function(object) {
             data <- object@data
             w <- object@w
             ## 'data' and 'w' have same length
             if (!identical(length(data), length(w)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "data", "w"))
             TRUE
         })

## HAS_TESTS
setClass("SkeletonHasSubtotals",
         contains = "VIRTUAL",
         validity = function(object) {
             data <- object@data
             ## 'data' has class "HasSubtotals"
             if (!methods::is(data, "HasSubtotals"))
                 return(gettextf("'%s' does not have class \"%s\"",
                                 "data", "HasSubtotals"))
             TRUE
         })

## HAS_TESTS
setClass("SkeletonMissingData",
         slots = c(data = "DemographicArray"),
         contains = c("VIRTUAL", "Skeleton"),
         validity = function(object) {
             data <- object@data
             ## 'data' has missing values
             if (!any(is.na(data)))
                 return(gettextf("'%s' has no missing values",
                                 "data"))
             TRUE
         })

## HAS_TESTS
setClass("SkeletonMissingDataNormal",
         contains = c("VIRTUAL", "SkeletonMissingData",
             "SkeletonOffsetsTheta", "SkeletonW"))

## HAS_TESTS
setClass("SkeletonMissingDataset",
         slots = c(offsetsComponent = "Offsets",
                        transformComponent = "CollapseTransform"),
         contains = c("VIRTUAL", "SkeletonMissingData"),
         validity = function(object) {
             offsetsComponent <- object@offsetsComponent
             transformComponent <- object@transformComponent
             ## 'offsetsComponent' consistent with 'transformComponent'
             if (!identical(as.integer(prod(transformComponent@dimBefore)),
                            offsetsComponent[2L] - offsetsComponent[1L] + 1L))
                 return(gettextf("'%s' and '%s' inconsistent",
                                 "offsetsComponent", "transformComponent"))
             TRUE
         })


## NON-VIRTUAL CLASSES ########################################################

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonOneCounts",
         contains = c("SkeletonOne", "SkeletonDemographic"))

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonOneValues",
         contains = c("SkeletonOne", "SkeletonDemographic"))

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonManyCounts",
         contains = c("SkeletonMany", "SkeletonDemographic", "SkeletonMetadata"),
         validity = function(object) {
             metadata <- object@metadata
             first <- object@first
             last <- object@last
             ## dim(metadata) consistent with 'first', 'last'
             ## check 'implied.length' valid first, to avoid confusing error messages
             implied.length <- last - first + 1L
             implied.length.valid <- identical(length(implied.length), 1L) && !is.na(implied.length)
             if (implied.length.valid) {
                 if (!identical(as.integer(prod(dim(metadata))), implied.length))
                     return(gettextf("'%s', '%s', and '%s' inconsistent",
                                     "metadata", "first", "last"))
             }
             TRUE
         })

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonManyValues",
         contains = c("SkeletonMany", "SkeletonDemographic", "SkeletonMetadata"),
         validity = function(object) {
             metadata <- object@metadata
             first <- object@first
             last <- object@last
             ## dim(metadata) consistent with 'first', 'last'
             ## check 'implied.length' valid first, to avoid confusing error messages
             implied.length <- last - first + 1L
             implied.length.valid <- identical(length(implied.length), 1L) && !is.na(implied.length)
             if (implied.length.valid) {
                 if (!identical(as.integer(prod(dim(metadata))), implied.length))
                     return(gettextf("'%s', '%s', and '%s' inconsistent",
                                     "metadata", "first", "last"))
             }
             TRUE
         })

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonBetaIntercept",
         contains = c("SkeletonOneValues",
             "SkeletonOffsetsHigher"))


## HAS_TESTS
## HAS_FETCH
setClass("SkeletonBetaTerm",
         contains = c("SkeletonManyValues",
             "SkeletonOffsetsHigher",
             "SkeletonTransformsHigher"),
         validity = function(object) {
             offsetsHigher <- object@offsetsHigher
             transformsHigher <- object@transformsHigher
             ## 'offsetsHigher' and 'transformsHigher' have same length
             if (!identical(length(offsetsHigher), length(transformsHigher)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "offsetsHigher", "transformsHigher"))
             TRUE
         })

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonMu",
         slots = c(margins = "list",
                        offsets = "list"),
         contains = c("Skeleton", "SkeletonMetadata", "Margins"),
         validity = function(object) {
             margins <- object@margins
             offsets <- object@offsets
             ## all elements of 'offsets' have class "Offsets"
             if (!all(sapply(offsets, is, "Offsets")))
                 return(gettextf("'%s' has elements not of class \"%s\"",
                                 "offsets", "Offsets"))
             ## 'offsets' and 'margins' have same length
             if (!identical(length(offsets), length(margins)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "margins", "offsets"))
             TRUE
         })         

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonCovariates",
         slots = c(metadata = "MetaData"),
         contains = "SkeletonMany", 
         validity = function(object) {
             first <- object@first
             last <- object@last
             metadata <- object@metadata
             ## 'metadata' has only one dimension
             if (!identical(length(dim(metadata)), 1L))
                 return(gettextf("'%s' has more than one dimension",
                                 "metadata"))
             ## dimension has dimtype "state"
             if (!identical(dembase::dimtypes(metadata, use.names = FALSE), "state"))
                 return(gettextf("dimension does not have dimtype \"%s\"",
                                 "state"))
             ## dim(metadata) consistent with 'first', 'last',
             ## allowing for fact that metadata one element shorter
             if (!identical(dim(metadata), last - first))
                 return(gettextf("'%s', '%s', and '%s' inconsistent",
                                 "metadata", "first", "last"))
             TRUE
         })

## HAS_TESTS
setClass("SkeletonStateDLM",
         slots = c(metadata = "MetaData"),
         contains = c("VIRTUAL",
             "SkeletonMany",
             "SkeletonIndicesShow"),
         validity = function(object) {
             metadata <- object@metadata
             indicesShow <- object@indicesShow
             ## dim(metadata) consistent with 'indicesShow'
             if (!isTRUE(all.equal(prod(dim(metadata)),
                                   length(indicesShow))))
                 return(gettextf("'%s' and '%s' inconsistent",
                                 "metadata", "indicesShow"))
             TRUE
         })

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonTrendDLM",
         contains = "SkeletonStateDLM",
         validity = function(object) {
             metadata <- object@metadata
             indicesShow <- object@indicesShow
             ## dim(metadata) consistent with 'indicesShow'
             if (!isTRUE(all.equal(prod(dim(metadata)),
                                   length(indicesShow))))
                 return(gettextf("'%s' and '%s' inconsistent",
                                 "metadata", "indicesShow"))
             TRUE
         })

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonLevelDLM",
         slots = c(nSeason = "integer",
             firstSeason = "integer",
             lastSeason = "integer"),
         contains = c("SkeletonStateDLM",
             "IAlongMixin"),
         validity = function(object) {
             firstSeason <- object@firstSeason
             lastSeason <- object@lastSeason
             iAlong <- object@iAlong
             nSeason <- object@nSeason
             metadata <- object@metadata
             if (identical(nSeason, 1L)) {
                 ## if nSeason is 1L, firstSeason and lastSeason are both 0L...
                 for (name in c("firstSeason", "lastSeason")) {
                     value <- slot(object, name)
                     if (!identical(value, 0L))
                         return(gettextf("'%s' equals %d but '%s' does not equal %d",
                                         "nSeason", 1L, name, 0L))
                 }
             }
             else {
                 ## ... otherwise 'firstSeason', 'lastSeason', 'iAlong', 'metadata', 'nSeason' consistent
                 diff.obtained <- lastSeason - firstSeason
                 dim <- dim(metadata)
                 dim[iAlong] <- dim[iAlong] + 1L
                 diff.expected <- as.integer(prod(dim) * nSeason) - 1L
                 if (!identical(diff.obtained, diff.expected))
                     return(gettextf("'%s', '%s', '%s', '%s', and '%s' inconsistent",
                                     "firstSeason", "lastSeason", "iAlong", "metadata", "nSeason"))
             }
             TRUE
         })

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonSeasonDLM",
         slots = c(nSeason = "integer"),
         contains = c("SkeletonStateDLM",
             "IAlongMixin"),
         validity = function(object) {
             first <- object@first
             last <- object@last
             iAlong <- object@iAlong
             nSeason <- object@nSeason
             metadata <- object@metadata
             ## 'first', 'last', 'iAlong', 'metadata', 'nSeason' consistent
             diff.obtained <- last - first
             dim <- dim(metadata)
             dim[iAlong] <- dim[iAlong] + 1L
             diff.expected <- as.integer(prod(dim) * nSeason) - 1L
             if (!identical(diff.obtained, diff.expected))
                 return(gettextf("'%s', '%s', '%s', '%s', and '%s' inconsistent",
                                 "first", "last", "iAlong", "metadata", "nSeason"))
             TRUE
         })

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonAccept",
         slots = c(iFirstInChain = "integer"),
         contains = "SkeletonOne",
         validity = function(object) {
             iFirstInChain <- object@iFirstInChain
             ## 'iFirstInChain' has positive length
             if (identical(length(iFirstInChain), 0L))
                 return(gettextf("'%s' has length %d",
                                 "iFirstInChain", 0L))
             ## 'iFirstInChain' has no missing values
             if (any(is.na(iFirstInChain)))
                 return(gettextf("'%s' has missing values",
                                 "iFirstInChain"))
             ## 'iFirstInChain' has not non-positive values
             if (any(iFirstInChain < 1L))
                 return(gettextf("'%s' has values less than %d",
                                 "iFirstInChain", 1L))
             ## 'iFirstInChain' has no duplicates
             if (any(duplicated(iFirstInChain)))
                 return(gettextf("'%s' has duplicates",
                                 "iFirstInChain"))
             TRUE
         })

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonNAccept",
         slots = c(nAttempt = "integer"),
         contains = "SkeletonAccept",
         validity = function(object) {
             nAttempt <- object@nAttempt
             ## 'nAttempt' has length 1
             if (!identical(length(nAttempt), 1L))
                 return(gettextf("'%s' does not have length %d",
                                 "nAttempt", 1L))
             ## 'nAttempt' is not missing
             if (is.na(nAttempt))
                 return(gettextf("'%s' is missing",
                                 "nAttempt"))
             ## 'nAttempt' is positive
             if (nAttempt < 1L)
                 return(gettextf("'%s' is less than %d",
                                 "nAttempt", 1L))
             TRUE
         })

## DemographicArray objects with missing data

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonMissingDataNormalVarsigmaKnown",
         contains = c("SkeletonMissingDataNormal", "VarsigmaMixin"))
             
## HAS_TESTS
## HAS_FETCH
setClass("SkeletonMissingDataNormalVarsigmaUnknown",
         slots = c(offsetsVarsigma = "Offsets"),
         contains = "SkeletonMissingDataNormal",
         validity = function(object) {
             offsetsVarsigma <- object@offsetsVarsigma
             ## 'offsetsVarsigma' imply 'varsigma' has length 1
             if (!identical(offsetsVarsigma[1L], offsetsVarsigma[2L]))
                 return(gettextf("'%s' implies '%s' does not have length %d",
                                 "offsetsVarsigma", "varsigma", 1L))
             TRUE
         })

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonMissingDataPoissonNotUseExp",
         contains = c("SkeletonMissingData", "SkeletonOffsetsTheta"))

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonMissingDataPoissonNotUseExpSubtotals",
         contains = c("SkeletonMissingDataPoissonNotUseExp", "SkeletonHasSubtotals"))

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonMissingDataPoissonUseExp",
         contains = c("SkeletonMissingData", "SkeletonOffsetsTheta", "SkeletonExposure"))

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonMissingDataPoissonUseExpSubtotals",
         contains = c("SkeletonMissingDataPoissonUseExp", "SkeletonHasSubtotals"))

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonMissingDataBinomial",
         contains = c("SkeletonMissingData", "SkeletonOffsetsTheta", "SkeletonExposure"))

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonMissingDatasetPoisson",
         contains = c("SkeletonMissingDataset", "SkeletonOffsetsTheta"),
         validity = function(object) {
             data <- object@data
             transformComponent <- object@transformComponent
             ## 'data' consistent with 'transformComponent'
             if (!identical(transformComponent@dimAfter, dim(data)))
                 return(gettextf("'%s' and '%s' inconsistent",
                                 "data", "transformComponent"))
             TRUE
         })

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonMissingDatasetPoissonSubtotals",
         contains = c("SkeletonMissingDatasetPoisson", "SkeletonHasSubtotals"))

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonMissingDatasetBinomial",
         contains = c("SkeletonMissingDataset", "SkeletonOffsetsTheta"),
         validity = function(object) {
             data <- object@data
             transformComponent <- object@transformComponent
             ## 'data' consistent with 'transformComponent'
             if (!identical(transformComponent@dimAfter, dim(data)))
                 return(gettextf("'%s' and '%s' inconsistent",
                                 "data", "transformComponent"))
             TRUE
         })

## HAS_TESTS
## HAS_FETCH
setClass("SkeletonMissingDatasetPoissonBinomial",
         contains = c("SkeletonMissingDataset", "Prob"))


setClassUnion("DemographicOrSkeletonMissingData",
              members = c("DemographicArray", "SkeletonMissingData"))
