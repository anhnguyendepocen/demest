% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AllClasses-10-Prior-generators.R
\docType{class}
\name{HalfT-class}
\alias{HalfT-class}
\title{An S4 class to specify a truncated half-\emph{t} distribution.}
\description{
Truncated half-\emph{t} distributions are used as priors
for standard deviations or scale parameters.
}
\section{Slots}{

\describe{
\item{\code{nu}}{Degrees of freedom.}

\item{\code{A}}{Scale.}

\item{\code{scaleMax}}{Maximum value.}

\item{\code{mult}}{Multiplier applied to default value for \code{A}.}
}}
\seealso{
Objects of class \code{HalfT} are created
by calls to function \code{\link{HalfT}}.
}

