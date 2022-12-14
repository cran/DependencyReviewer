% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/checkDependencies.R
\name{checkDependencies}
\alias{checkDependencies}
\title{checkDependencies}
\usage{
checkDependencies(packageName = NULL, dependencyType = c("Imports", "Depends"))
}
\arguments{
\item{packageName}{Name of package to profile. If NULL current package}

\item{dependencyType}{Imports, depends, and/ or suggests}
}
\value{
Returns value NULL
}
\description{
Check package dependencies
}
\examples{
# Run only in interactive session
if (interactive()) {
  checkDependencies(packageName = "DependencyReviewer")

  checkDependencies(packageName = "DependencyReviewer", c("Suggests"))
}
}
