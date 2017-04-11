#' @export
haplotypes.maxprob <- function(probs.3D, set){
  probs.3D <- probs.3D[set,,]
  maxprob.haplotypes.3D <- probs.3D
  for(i in 1:dim(probs.3D)[3]){
    for(s in 1:dim(probs.3D)[1]){
      maxprob.haplotypes.3D[s, , i] <- ifelse(1:dim(probs.3D)[2] == which.max(probs.3D[s, , i]), 1, 0)
    }
  }
  allele.freq.maxprob <- get.allele.freq(allele.props.array=maxprob.haplotypes.3D, these.individuals=set)
  return(allele.freq.maxprob)
}


#' @export
haplotypes.sample <- function(probs.3D, set, seed){
  set.seed(seed)
  probs.3D <- probs.3D[set,,]
  sample.from.probs <- apply(probs.3D, c(1,3), function(x) rmultinom(n=1, size=1, prob=x))
  sample.from.probs <- aperm(a=sample.from.probs, perm=c(2, 1, 3))
  allele.freq.sample <- get.allele.freq(allele.props.array=sample.from.probs, these.individuals=set)
  return(allele.freq.sample)
}
