
## HAS_TESTS
setClass("Mapping",
         slots = c(isOneToOne = "logical",
                        nSharedVec = "integer",
                        stepSharedCurrentVec = "integer",
                        stepSharedTargetVec = "integer"),
         prototype = prototype(isOneToOne = FALSE),
         contains = "VIRTUAL",
         validity = function(object) {
             isOneToOne <- object@isOneToOne
             nSharedVec <- object@nSharedVec
             stepSharedCurrentVec <- object@stepSharedCurrentVec
             stepSharedTargetVec <- object@stepSharedTargetVec
             ## 'isOneToOne' has length 1
             if (!identical(length(isOneToOne), 1L))
                 stop(gettextf("'%s' does not have length %d",
                               "isOneToOne", 1L))
             ## 'isOneToOne' is not missing
             if (is.na(isOneToOne))
                 stop(gettextf("'%s' is missing",
                               "isOneToOne"))
             ## nSharedVec, stepSharedCurrentVec, stepSharedTargetVec,
             ## have no missing values
             for (name in c("nSharedVec", "stepSharedCurrentVec", "stepSharedTargetVec")) {
                 value <- methods::slot(object, name)
                 if (any(is.na(value)))
                     return(gettextf("'%s' has missing values",
                                     name))
             }
             ## nSharedVec, stepSharedCurrentVec, stepSharedTargetVec,
             ## all positive values
             for (name in c("nSharedVec", "stepSharedCurrentVec", "stepSharedTargetVec")) {
                 value <- methods::slot(object, name)
                 if (any(value < 1L))
                     return(gettextf("'%s' has non-positive values",
                                     name))
             }
             ## nSharedVec, stepSharedCurrentVec have same length
             if (!identical(length(nSharedVec), length(stepSharedCurrentVec)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "nSharedVec", "stepSharedCurrentVec"))
             ## nSharedVec, stepSharedTargetVec have same length
             if (!identical(length(nSharedVec), length(stepSharedTargetVec)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "nSharedVec", "stepSharedTargetVec"))
             TRUE
         })

## HAS_TESTS
setClass("MappingMixinAge",
         slots = c(hasAge = "logical",
                        nAge = "integer",
                        stepAgeCurrent = "integer",
                        stepAgeTarget = "integer",
                        stepTriangleCurrent = "integer"),
         contains = "VIRTUAL",
         validity = function(object) {
             hasAge <- object@hasAge
             ## hasAge, nAge, stepAgeCurrent, stepAgeTarget, stepTriangleCurrent have length 1
             for (name in c("hasAge", "nAge", "stepAgeCurrent",
                            "stepAgeTarget", "stepTriangleCurrent")) {
                 value <- methods::slot(object, name)
                 if (!identical(length(value), 1L))
                     return(gettextf("'%s' does not have length %d",
                                     name, 1L))
             }
             ## hasAge is not missing
             if (is.na(hasAge))
                 return(gettextf("'%s' is missing",
                                 "hasAge"))
             if (hasAge) {
                 ## if hasAge: nAge, stepAgeCurrent, stepAgeTarget, stepTriangleCurrent not missing
                 for (name in c("nAge", "stepAgeCurrent", "stepAgeTarget", "stepTriangleCurrent")) {
                     value <- methods::slot(object, name)
                     if (is.na(value))
                         return(gettextf("'%s' is missing",
                                         name))
                 }
                 ## if hasAge: nAge, stepAgeCurrent, stepAgeTarget, stepTriangleCurrent positive
                 for (name in c("nAge", "stepAgeCurrent", "stepAgeTarget", "stepTriangleCurrent")) {
                     value <- methods::slot(object, name)
                     if (value < 1L)
                         return(gettextf("'%s' is non-positive",
                                         name))
                 }
                 ## if hasAge: stepAge not in stepShared
                 for (type in c("Current", "Target")) {
                     name.age <- sprintf("stepAge%s", type)
                     name.shared.vec <- sprintf("stepShared%sVec", type)
                     step.age <- methods::slot(object, name.age)
                     step.shared.vec <- methods::slot(object, name.shared.vec)
                     if (step.age %in% step.shared.vec)
                         stop(gettextf("overlap between '%s' and '%s'",
                                       name.age, name.shared.vec))
                 }
             }
             else {
                 ## if not hasAge: nAge, stepAgeCurrent, stepAgeTarget, stepTriangleCurrent missing
                 for (name in c("nAge", "stepAgeCurrent", "stepAgeTarget", "stepTriangleCurrent")) {
                     value <- methods::slot(object, name)
                     if (!is.na(value))
                         return(gettextf("'%s' is %s but '%s' is not missing",
                                         "hasAge", FALSE, name))
                 }
             }
             TRUE
         })

## HAS_TESTS
setClass("MappingMixinAgeStrict",
         contains = c("VIRTUAL", "MappingMixinAge"),
         validity = function(object) {
             hasAge <- object@hasAge
             if (!isTRUE(hasAge))
                 return(gettextf("'%s' is %s",
                                 "hasAge", "FALSE"))
             TRUE
         })

## HAS_TESTS
setClass("MappingMixinOrigDest",
         slots = c(nOrigDestVec = "integer",
                        stepOrigCurrentVec = "integer",
                        stepDestCurrentVec = "integer",
                        stepOrigDestTargetVec = "integer"),
         contains = "VIRTUAL",
         validity = function(object) {
             nOrigDestVec <- object@nOrigDestVec
             stepOrigCurrentVec <- object@stepOrigCurrentVec
             stepDestCurrentVec <- object@stepDestCurrentVec
             stepOrigDestTargetVec <- object@stepOrigDestTargetVec
             ## nOrigDestVec, stepOrigCurrentVec, stepDestCurrentVec, stepOrigDestTargetVec
             ## have no missing values
             for (name in c("nOrigDestVec", "stepOrigCurrentVec", "stepDestCurrentVec",
                            "stepOrigDestTargetVec")) {
                 value <- methods::slot(object, name)
                 if (any(is.na(value)))
                     return(gettextf("'%s' has missing values",
                                     name))
             }
             ## nOrigDestVec, stepOrigCurrentVec, stepDestCurrentVec, stepOrigDestTargetVec
             ## all positive values
             for (name in c("nOrigDestVec", "stepOrigCurrentVec", "stepDestCurrentVec",
                            "stepOrigDestTargetVec")) {
                 value <- methods::slot(object, name)
                 if (any(value < 1L))
                     return(gettextf("'%s' has non-positive values",
                                     name))
             }
             ## nOrigDestVec, stepOrigCurrentVec have same length
             if (!identical(length(nOrigDestVec), length(stepOrigCurrentVec)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "nOrigDestVec", "stepOrigCurrentVec"))
             ## nOrigDestVec, stepDestCurrentVec have same length
             if (!identical(length(nOrigDestVec), length(stepDestCurrentVec)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "nOrigDestVec", "stepDestCurrentVec"))
             ## nOrigDestVec, stepOrigDestTargetVec have same length
             if (!identical(length(nOrigDestVec), length(stepOrigDestTargetVec)))
                 return(gettextf("'%s' and '%s' have different lengths",
                                 "nOrigDestVec", "stepOrigDestTargetVec"))
             TRUE
         })

## HAS_TESTS
setClass("MappingMixinTime",
         slots = c(nTimeCurrent = "integer",
                        stepTimeCurrent = "integer",
                        stepTimeTarget = "integer"),
         contains = "VIRTUAL",
         validity = function(object) {
             for (name in c("nTimeCurrent", "stepTimeCurrent", "stepTimeTarget")) {
                 value <- methods::slot(object, name)
                 ## nTimeCurrent, stepTimeCurrent, stepTimeTarget have length 1
                 if (!identical(length(value), 1L))
                     return(gettextf("'%s' does not have length %d",
                                     name, 1L))
                 ## nTimeCurrent, stepTimeCurrent, stepTimeTarget not missing
                 if (is.na(value))
                     return(gettextf("'%s' is missing",
                                     name))
                 ## nTimeCurrent, stepTimeCurrent, stepTimeTarget positive
                 for (name in c("nTimeCurrent", "stepTimeCurrent", "stepTimeTarget")) {
                     value <- methods::slot(object, name)
                     if (value < 1L)
                         return(gettextf("'%s' is non-positive",
                                         name))
                 }
             }
         })

## HAS_TESTS
setClass("MappingMixinIMinAge",
         slots = c(iMinAge = "integer"),
         contains = "VIRTUAL",
         validity = function(object) {
             iMinAge <- object@iMinAge
             ## 'iMinAge' has length 1
             if (!identical(length(iMinAge), 1L))
                 return(gettextf("'%s' does not have length %d",
                                 "iMinAge", 1L))
             ## iMinAge positive if not missing
             if (!is.na(iMinAge) && iMinAge <= 1L)
                 return(gettextf("'%s' is non-positive",
                                 "iMinAge"))
             TRUE
         })

## Mappings to population

## HAS_TESTS
setClass("MappingCompToPopn",
         contains = c("Mapping", "MappingMixinAge", "MappingMixinTime"))

## HAS_TESTS
setClass("MappingOrigDestToPopn",
         contains = c("Mapping", "MappingMixinOrigDest", "MappingMixinAge", "MappingMixinTime"))


## Mappings to accession

## HAS_TESTS
setClass("MappingCompToAcc",
         contains = c("Mapping", "MappingMixinAgeStrict", "MappingMixinTime"))

## HAS_TESTS
setClass("MappingOrigDestToAcc",
         contains = c("Mapping", "MappingMixinOrigDest", "MappingMixinAgeStrict",
                      "MappingMixinTime"))



## Mappings from Exposure

## HAS_TESTS
setClass("MappingExpToComp",
         contains = "Mapping")

## HAS_TESTS
setClass("MappingExpToBirths",
         contains = c("Mapping", "MappingMixinTime", "MappingMixinIMinAge"))

