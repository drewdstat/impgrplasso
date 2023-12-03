
<!-- README.md is generated from README.Rmd. Please edit that file -->

# LASSO Regression for Multiply Imputed Data with a Group Penalty

<!-- badges: start -->
<!-- badges: end -->

There are currently several proposed methods for performing LASSO
regression on multiply imputed data, and a comparison between these
proposed methods is summarized nicely in [Gunn et
al. 2023](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10117422/). One
of these most promising of these methods is the MI-LASSO method proposed
by [Chen and Wang
2013](https://onlinelibrary.wiley.com/doi/10.1002/sim.5783), which
stacks imputed data sets and uses a group LASSO penalty for each
variable across imputed data sets. This method was updated by Gunn et
al. 2023 to change the metric by which an optimal lambda value is chosen
from the Bayes Information Criterion (BIC) to the out-of-sample mean
squared prediction error (MSE). Of the approaches evaluated by Gunn et
al. 2023, this one best combined a low out-of-sample MSE and readily
interpretable coefficients.

This package includes functions that implement the MI-LASSO method with
the additional additions of incorporating the validated group LASSO
method of the [‘grplasso’](https://CRAN.R-project.org/package=grplasso)
package ([Meier et
al. 2008](https://rss.onlinelibrary.wiley.com/doi/10.1111/j.1467-9868.2007.00627.x)),
using a diagonal stacking approach that allows for intercepts specific
to each imputed data set, using k-fold cross-validation rather than
single training/test splits to obtain out-of-sample prediction error
statistics for optimizing lambda, providing methods for both LASSO
linear regressions and logistic regression, and providing the option to
not penalize certain independent variables in the model.

## Installation

You can install the development version of impgrplasso from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("drewdstat/impgrplasso")
```

## Usage

Here is a [brief tutorial
vignette](http://htmlpreview.github.io/?https://github.com/drewdstat/impgrplasso/blob/working/vignettes/introduction.html)
on how to use the impgrplasso package.
