% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/query-functions.R
\name{finiteY}
\alias{finiteY}
\title{Estimate or predict finite-population quantity 'y'.}
\usage{
finiteY(filename, total, sampled = NULL, iterations = NULL)
}
\arguments{
\item{filename}{The filename used by the estimate function.}

\item{total}{An object of class \code{\linkS4class{Counts}}
giving the size of the population for which the finite-population
estimates are to be generated.}

\item{sampled}{An object of class \code{\linkS4class{Counts}}
giving the same of the sample from which the rates, means, or
probabilities were estimated.  If no \code{sampled} argument
is supplied, and if the model includes an \code{exposure}
term, then \code{sampled} is assumed to equal \code{exposure}.}

\item{iterations}{A vector of positive integers giving the iterations to be
extracted if an item has multiple iterations.}
}
\description{
Estimate or predict finite-population quantities for
the toal population, from estimated rates, probabilities,
or means for the sampled population, plus information
on the sizes of the sampled and total population.
}
\details{
Consider a model in which

\deqn{y_i \sim G(\gamma_i, n_i)}

for some distribution \eqn{G}, such as a Poisson, binomial, or
normal distribution.  \eqn{y_i} is a count or other value
for cell \eqn{i} within a classification defined by
dimensions such as age and sex.  \eqn{\gamma_i} is an
unobserved cell-level parameter such as a rate, probability,
or mean.  \eqn{n_i} is a cell-level exposure or sample size, which
is included in some models, such as Poisson or binomial models,
but not all.

We assume that \eqn{y_i} is observed for only part of
the population (the sampled population), and would like to
know \eqn{Y_i}, the corresponding value for the total population.
This requires estimating values for the unobserved' part
of the population (the nonsampled population).  We assume that
the unobserved part of the population is subject to the same
\eqn{\gamma_i} as the observed part.

Quantities \eqn{y_i} and \eqn{Y_i} are finite-population
quantities, that is, they are values that are, or
could theoretically be, observed in real populations.
Value \eqn{\gamma_i}, in contrast, is a super-population
quantity. It describes the hypothetical super-population
from which values such as \eqn{y_i} and \eqn{Y_i} are
drawn.
}
\examples{
## generate sampled, non-sampled, and total population
popn.sampled <- Counts(array(rpois(n = 20, lambda = 100),
                             dim = c(10, 2),
                             dimnames = list(region = LETTERS[1:10],
                                 sex = c("Female", "Male"))))
popn.nonsampled <- Counts(array(rpois(n = 20, lambda = 900),
                             dim = c(10, 2),
                             dimnames = list(region = LETTERS[1:10],
                                 sex = c("Female", "Male"))))
popn.total <- popn.sampled + popn.nonsampled

## binomial model
y.sampled.binom <- Counts(array(rbinom(n = 20, size = popn.sampled, prob = 0.5),
                          dim = c(10, 2),
                          dimnames = list(region = LETTERS[1:10],
                              sex = c("Female", "Male"))))
filename.binom <- tempfile()
estimateModel(Model(y ~ Binomial(mean ~ region + sex)),
              y = y.sampled.binom,
              exposure = popn.sampled,
              filename = filename.binom,
              nBurnin = 10,
              nSim = 10,
              nChain = 2)
fy.binom <- finiteY(filename = filename.binom, # sample population assumed
                    total = popn.total)        # to equal exposure

## normal model
y.sampled.norm <- Counts(array(rnorm(n = 20),
                               dim = c(10, 2),
                               dimnames = list(region = LETTERS[1:10],
                                   sex = c("Female", "Male"))))
filename.norm <- tempfile()
estimateModel(Model(y ~ Normal(mean ~ region + sex)),
              y = y.sampled.norm,
              filename = filename.norm,
              nBurnin = 10,
              nSim = 10,
              nChain = 2)
fy.norm <- finiteY(filename = filename.norm,
                   sampled = popn.sampled, # specify sample population
                   total = popn.total)
}
\references{
Gelman, A., Carlin, J.B., Stern, H.S. and Rubin, D.B., 2014.
\emph{Bayesian Ddata Analysis. Third Edition.} Boca Raton, FL, USA:
Chapman & Hall/CRC. Section 8.3.
}
\seealso{
\code{finiteY} can be used with the results from
a call to \code{estimate} or \code{predict} functions such
as \code{\link{estimateModel}} and \code{\link{predictModel}}.
}

