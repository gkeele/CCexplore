CCexplore
=========

This a simple package with a specific purpose of selecting an optimal set of a specified number of CC mice from some specified subset of the available 73, based on a number of criterion. For example, selection the best 5 lines from 11 that are readily available based while maximizing genetic diversity and cumulative wild-derived allele frequencies.

## Example code

Example data is included in the package - it is quite large - sorry. The following code services as a simple vignette for using the package for now.

```r
library(devtools)
install_github("gkeele/CCexplore")
library(CCexplore)
data(CC.probs)

# Large set
these.lines <- c("CC065.Unc", 
                 "CC011.Unc", 
                 "CC004.TauUnc", 
                 "CC003.Unc", 
                 "CC039.Unc", 
                 "CC053.Unc", 
                 "CC071.TauUnc", 
                 "CC017.Unc", 
                 "CC022.GeniUnc", 
                 "CC021.Unc", 
                 "CC058.Unc")

candidate.allele.freq <- get.allele.freq(allele.props.array=CC.probs, these.individuals=these.lines)
allele.freq.plot(allele.freq=candidate.allele.freq)

# Include lines
include.lines <- c("CC065.Unc", 
                   "CC011.Unc", 
                   "CC004.TauUnc",   
                   "CC058.Unc")


# Choice lines
choice.lines <- c("CC039.Unc", 
                  "CC053.Unc", 
                  "CC071.TauUnc", 
                  "CC017.Unc", 
                  "CC022.GeniUnc", 
                  "CC021.Unc")

all.eval <- eval.criteria(allele.props.array=CC.probs, fixed.set=include.lines, 
			  choice.set=choice.lines, choice.select=3)

# Remove extreme imbalance
extreme.sets <- all.eval$extreme.imbalance > 0

# Bottom 20% for imbalance
balanced.sets <- all.eval$imbalance < quantile(all.eval$imbalance, probs=0.2)

# Top 20% for wild-derived alleles
wild.sets <- all.eval$mean.wild > quantile(all.eval$mean.wild, probs=0.8)

# Top 20% for PWK & CAST alleles
pwk_cast.sets <- all.eval$mean.pwk_cast > quantile(all.eval$mean.pwk_cast, probs=0.8)

# Top 20% for mean L2norm
L2.sets <- all.eval$mean.L2norm > quantile(all.eval$mean.L2norm, probs=0.8)

# Accumulate criterion (Could weight based on importance, currently just equally weighting)
all.checks <- as.numeric(!extreme.sets) + as.numeric(balanced.sets) + as.numeric(wild.sets) + as.numeric(pwk_cast.sets) + as.numeric(L2.sets)
table(all.checks)

# Look at top sets
top.sets <- which(all.checks == 5)
all.eval$possible[top.sets,]
```
