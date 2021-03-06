% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SpecPrior-generators.R
\name{Covariates}
\alias{Covariates}
\title{Specify covariates in a prior for a main effect or interaction.}
\usage{
Covariates(formula, data, contrastsArg = list(), intercept = Norm(),
  coef = HalfT())
}
\arguments{
\item{formula}{A \code{\link[stats]{formula}} with response \code{mean}.}

\item{data}{A data.frame containing covariate data.}

\item{contrastsArg}{A named list, the elements which are matrices
or names of contrasts functions.}

\item{intercept}{An object of class \code{\linkS4class{Norm}}.}

\item{coef}{An object of class \code{\link{HalfT}}.}
}
\value{
An object of class \code{\linkS4class{Covariates}}
}
\description{
Most priors for main effects or interactions, such as age effects or
age-sex interactions, can include a covariate term.  The covariate
term is specified using function \code{Covariates}.
}
\details{
The \code{formula} argument is a standard R \code{\link[stats]{formula}},
though with the restriction that the response must be \code{mean}.
Interactions are specified in the usual way, so that, for instance,

\code{mean ~ age * sex + time}

\code{mean ~ age + sex + age:sex + time}

\code{mean ~ (age + sex)^2 + time}

are all equivalent.

The \code{data} argument must include labels for the main effect or
interaction being modelled, in addition to the covariate data itself.
For example, the \code{data} argument for region effect with a
\code{formula} argument of \code{mean ~ income} could be

\tabular{lrr}{
 \tab region \tab income \cr
1 \tab A \tab 15000 \cr
2 \tab B \tab 22000 \cr
3 \tab C \tab 18000
}

The \code{data} argument for region:time interaction with a
\code{formula} argument of \code{mean ~ income} could be

\tabular{lrrr}{
 \tab region \tab time \tab income \cr
1 \tab A \tab 2000 \tab 15000 \cr
2 \tab B \tab 2000 \tab 22000 \cr
3 \tab C \tab 2000 \tab 18000 \cr
4 \tab A \tab 2010 \tab 17000 \cr
5 \tab B \tab 2010 \tab 23000 \cr
6 \tab C \tab 2010 \tab 17000
}

Any columns in \code{data} that are not referred to by the \code{formula}
argument and that do do not serve as labels for the main effect or
interaction are ignored.  Similarly, redundant rows are ignored.

Internally, covariates are standardized to have mean 0 and standard
deviation 0.5, as described in Gelman et al (2014, Section 16.3).
Coefficients for the standardized covariates are assumed to be drawn
from \emph{t} distributions centered on 0.  These distributions contain
scale parameters that determine the degree to which coefficient estimates
are shrunk towards 0.  The rules for choosing default values for the scale
parameters are described in the' documentation for \code{\link{HalfT}}.
Shrinking coefficient' estimates towards 0 protects against over-fitting.

The intercept term is assumed to have a diffuse normal distribution centered
at 0.  The rules for choosing default values for the standard deviation are
described in the documentation for \code{\link{Norm}}.

The help for \code{\link[stats]{model.matrix}} contains a discussion of
contrasts.  With Bayesian models that have informative priors, such as the
t priors used by \code{Covariates}, all levels of a factor can be included
in the model. See below for an example.
}
\examples{
reg.data <- data.frame(region = LETTERS[1:10],
                       income = c(20, 31, 15, 7, 24, 8, 22, 14, 21, 17),
                       area = rep(c("Urban", "Rural"), each = 5))
Covariates(mean ~ income + area,
           data = reg.data)

## override the default settings for
## intercept and coefficients
Covariates(mean ~ income + area,
           data = reg.data,
           intercept = Norm(scale = 5),
           coef = HalfT(scale = 0.25))

## override the default 'treatment' contrast
contrasts.arg <- list(area = diag(2))
Covariates(mean ~ income + area,
           data = reg.data,
           contrastsArg = contrasts.arg)

## covariate data for an age:sex interaction
agesex.data <- data.frame(age = rep(c("0-14", "15-29", "30+"),
                                    times = 2),
                          sex = rep(c("Female", "Male"),
                                    each = 3),
                          weight = c(78, 94, 83, 84, 62, 75))
Covariates(mean ~ weight,
           data = agesex.data)
}
\references{
Gelman, A., Carlin, J.B., Stern, H.S. and Rubin, D.B., 2014.
\emph{Bayesian Data Analysis. Third Edition.} Boca Raton, FL, USA:
Chapman & Hall/CRC.
}
\seealso{
Priors constructed with \code{\link{Exch}} and
\code{\link{DLM}} both allow for covariates.
}

