## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----installationRemotes, eval = FALSE----------------------------------------
#  # If you do not have remotes installed:
#  install.packages("remotes")
#  
#  # Install DependencyReviewer with remotes:
#  remotes::install_github("darwin-eu/DependencyReviewer")

## ----installationBase, eval=FALSE---------------------------------------------
#  install.packages("DependencyReviewer")

## ----loadPackages, setup, message=FALSE---------------------------------------
library(DependencyReviewer)

# Other packages that are used in the examples
library(DT)
library(ggplot2)
library(dplyr)
library(igraph)
library(GGally)

## ---- echo=FALSE--------------------------------------------------------------
library(withr)
local_envvar(
  R_USER_CACHE_DIR = tempfile()
)

## ----getDefaultPermittedPackages----------------------------------------------
datatable(getDefaultPermittedPackages())

## ---- eval=FALSE--------------------------------------------------------------
#  # Assumes the current environment is a package-project
#  # Defaults are: packageName = NULL, packageTypes = c("Imports", "Depends")
#  checkDependencies()
#  
#  # Check dependencies for installed package "dplyr"
#  checkDependencies(
#    packageName = "dplyr"
#  )

## -----------------------------------------------------------------------------
# Check Imports and Suggests
checkDependencies(
  packageName = "dplyr",
  dependencyType = c("Imports", "Suggests")
)

## -----------------------------------------------------------------------------
# Only check directly imported dependencies of installed package "dplyr"
checkDependencies(
  packageName = "dplyr",
  dependencyType = c("Imports")
)

## ---- echo=FALSE, out.width="100%", fig.cap="Request template button"---------
knitr::include_graphics("figures/Schermafbeelding_20221209_100800.png")

## ---- echo=FALSE, out.width="100%", fig.cap="Request template"----------------
knitr::include_graphics("figures/Schermafbeelding_20221209_101030.png")

## ---- echo=FALSE, out.width="100%", fig.cap="Request filled out"--------------
knitr::include_graphics("figures/Schermafbeelding_20221209_101612.png")

## ---- echo=FALSE, out.width="100%", fig.cap="Request preview"-----------------
knitr::include_graphics("figures/Schermafbeelding_20221209_101939.png")

## -----------------------------------------------------------------------------
# Assumes the function is run inside a package-project.
datatable(
  summariseFunctionUse(list.files(here::here("R"), full.names = TRUE)
))

## -----------------------------------------------------------------------------
if (interactive()) {
  # Any other R-file, with verbose messages
  foundFuns <- summariseFunctionUse(
    r_files = "../inst/testScript.R",
    verbose = TRUE
  )

  datatable(foundFuns)
}

## ----dpi=250, fig.height=10, out.width="100%"---------------------------------
if (interactive()) {
  funCounts <- foundFuns %>%
    group_by(fun, pkg, name = "n") %>%
    tally() %>%
    dplyr::filter(pkg %in% c("checkmate", "DBI", "dplyr"))

  ggplot(
    data = funCounts,
    mapping = aes(x = fun, y = n, fill = pkg)
  ) +
    geom_col() +
    facet_wrap(
      vars(pkg),
      scales = "free_x",
      ncol = 1
    ) +
    theme_bw() +
    theme(
      legend.position = "none",
      axis.text.x = (element_text(angle = 45, hjust = 1, vjust = 1))
    )
}

## ----eval=FALSE---------------------------------------------------------------
#  graphData <- getGraphData()

## ---- echo=FALSE--------------------------------------------------------------
invisible(capture.output(graphData <- DependencyReviewer::getGraphData()))

## -----------------------------------------------------------------------------
# Get graphData with only imports
graphData <- getGraphData()

## ---- out.width="100%", dpi=500, messages=FALSE-------------------------------
if (!is.null(graphData)) {
  # Calculate colour of nodes based on distances from root package
cols <- factor(as.character(apply(
  X = distances(graphData, V(graphData)[1]),
  MARGIN = 2,
  FUN = max
)))

# Plot graph
ggnet2(
  net = graphData,
  arrow.size = 1,
  arrow.gap = 0.025,
  label = TRUE,
  palette = "Set2",
  color.legend = "distance",
  color = cols,
  legend.position = "bottom",
  edge.alpha = 0.25,
  node.size = 2.5,
  label.size = 1,
  legend.size = 2
)
}

## ----eval=FALSE---------------------------------------------------------------
#  runShiny()

## ---- echo=FALSE, out.width="100%", fig.cap="Function review"-----------------
knitr::include_graphics("figures/function_review.png")

## ---- echo=FALSE, out.width="100%", fig.cap="Package review"------------------
knitr::include_graphics("figures/Schermafbeelding_20221209_132449.png")

## ---- echo=FALSE, out.width="100%", fig.cap="Function review plot"------------
knitr::include_graphics("figures/function_review_plot.png")

## ---- echo=FALSE, out.width="100%", fig.cap="Package review"------------------
knitr::include_graphics("figures/Schermafbeelding_20221209_133831.png")

## ---- echo=FALSE, out.width="100%", fig.cap="Package review"------------------
knitr::include_graphics("figures/Schermafbeelding_20221209_134126.png")

## ---- echo=FALSE, out.width="100%", fig.cap="Package review"------------------
knitr::include_graphics("figures/Schermafbeelding_20221209_134345.png")

## ---- echo=FALSE, out.width="100%", fig.cap="Package review"------------------
knitr::include_graphics("figures/Schermafbeelding_20221209_134754.png")

## ----warning=FALSE, error=FALSE, message=FALSE--------------------------------
if (interactive()) {
  lintOut <- data.frame(
    darwinLintFile(
      fileName = "../inst/testScript.R"
    )
  )
}

## -----------------------------------------------------------------------------
if (interactive()) {
  lintOut %>%
    group_by(type, message) %>%
    tally(sort = TRUE) %>%
    datatable()
}

## ----eval=FALSE---------------------------------------------------------------
#  if (interactive()) {
#    darwinLintScore(darwinLintPackage)
#  }

