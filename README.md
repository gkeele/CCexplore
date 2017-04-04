CCexplore
=========

This a simple package with a specific purpose of selecting an optimal set of a specified number of CC mice from some specified subset of the available 73, based on a number of criterion. For example, selection the best 5 lines from 11 that are readily available based while maximizing genetic diversity and cumulative wild-derived allele frequencies.

## Example code

Example data is included in the package. The following code services as a simple vignette for using the package for now.

```r
library(devtools)
install_github(“gkeele/CCexplore”)
library(CCexplore)
data(CC.probs)

## Let's look at all the CC lines
all.allele.freq <- get.allele.freq(allele.props.array= CC.probs)
allele.freq.plot(allele.freq=all.allele.freq)
```
