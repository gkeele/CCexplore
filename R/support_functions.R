#' @export
get.allele.freq <- function(allele.props.array,
                            these.individuals="all",
                            these.positions="all",
                            thin=NULL){
  # Grabbing some subset of individuals
  if(these.individuals[1] == "all"){
    these.individuals <- dimnames(allele.props.array)[[1]]
  }
  allele.props.array <- allele.props.array[these.individuals,,]
  ## Grabbing some subset of loci
  if(these.positions[1] == "all"){
    these.positions <- dimnames(allele.props.array)[[3]]
  }
  allele.props.array <- allele.props.array[,,these.positions]
  ## Thinning -- attempt to make plots that don't kill my computer
  if(!is.null(thin)){
    seq.loci <- 1:dim(allele.props.array)[3]
    keep <- seq.loci[seq(1, length(seq.loci), thin)]
    allele.props.array <- allele.props.array[,,keep]
  }
  
  # Taking allele frequencies at each locus
  allele.freq <- t(apply(allele.props.array, 3, function(x) colMeans(x)))
  return(allele.freq)
}