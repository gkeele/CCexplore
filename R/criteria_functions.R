######### Criteria functions
## Produce list of loci that have allele with freq >= cut.off.freq for set
#' @export
flag_allele.imbalance <- function(allele.freq,
                                  cut.off.freq=0.5){
  flag.rows <- apply(allele.freq, 1, function(x) any(x >= cut.off.freq))
  flag.loci <- rownames(allele.freq)[flag.rows]
  return(flag.loci)
}

## Produce list of loci that have lost all wild-derived alleles for set
#' @export
flag_wild.allele.loss <- function(allele.freq){
  flag.rows <- apply(allele.freq, 1, function(x) any(x[c(6, 7, 8)] == 0))
  flag.loci <- rownames(allele.freq)[flag.rows]
  return(flag.loci)
}

## Calculate mean wild-derived frequency for set
#' @export
mean_wild.alleles <- function(allele.freq){
  wild.mean <- apply(allele.freq, 1, function(x) mean(x[c(6, 7, 8)]))
  return(wild.mean)
}

## Calculate mean PWK and CAST frequency for set
#' @export
mean_pwk_cast.alleles <- function(allele.freq){
  pwk_cast.mean <- apply(allele.freq, 1, function(x) mean(x[c(6, 7)]))
  return(pwk_cast.mean)
}

## Calculate mean PWK frequency for set
mean_pwk.alleles <- function(allele.freq){
  pwk.mean <- apply(allele.freq, 1, function(x) mean(x[7]))
  return(pwk.mean)
}

## Calculate mean L2norm across pairs and all loci for set
#' @export
mean_pairwise.L2norm <- function(allele.props.array, these.individuals="all"){
  ## Grabbing some subset of individuals
  if(these.individuals[1] == "all"){
    these.individuals <- dimnames(allele.props.array)[[1]]
  }
  allele.props.array <- allele.props.array[these.individuals,,, drop=FALSE]
  
  L2norm <- mean(apply(allele.props.array, 3, function(x) mean(as.vector(dist(x, method="euclidean")))))
  return(L2norm)
}

######### Run criteria for all choose(11, 5) = 462 possible sets
#' @export
eval.criteria <- function(allele.props.array, fixed.set, choice.set, choice.select){
  # Check to see if fixed and choice are in the data
  all.options <- unique(c(fixed.set, choice.set))
  if(!all(all.options %in% dimnames(allele.props.array)[[1]])){
    error.message <- paste(paste(all.options[!(all.options %in% dimnames(allele.props.array)[[1]])], collapse=", "),
                           "not in data")
    stop(error.message, call.=FALSE)
  }
  # Number to select cannot be greater than the number of options
  if(choice.select > length(choice.set)){
    error.message <- "Cannot select more lines than there are options"
    stop(error.message, call.=FALSE)
  }
  ## Evaluate all possible combinations of the lines that can vary
  fixed <- possible <- NULL
  if(!is.null(choice.set)){ possible <- t(combn(x=choice.set, m=choice.select)) }
  if(!is.null(fixed.set)){ fixed <- matrix(fixed.set, nrow=1)[rep(1, nrow(possible)),] }
  possible <- cbind(fixed, possible)
  
  number.imbalance <- number.extreme.imbalance <- number.wild.loss <- mean.wild <- mean.pwk_cast <- mean.pwk <- mean.L2norm <- rep(NA, nrow(possible))
  
  for(i in 1:nrow(possible)){
    # L2norm
    mean.L2norm[i] <- mean_pairwise.L2norm(allele.props.array=allele.props.array, these.individuals=possible[i,])
    
    this.allele.freq <- get.allele.freq(allele.props.array=allele.props.array, these.individuals=possible[i,])
    # Imbalance
    this.set.imbalance <- flag_allele.imbalance(allele.freq=this.allele.freq)
    number.imbalance[i] <- length(this.set.imbalance)
    # Extreme imbalance
    this.set.extreme.imbalance <- flag_allele.imbalance(allele.freq=this.allele.freq, cut.off.freq=1)
    number.extreme.imbalance[i] <- length(this.set.extreme.imbalance)
    # Wild-derived allele loss
    this.set.wild.loss <- flag_wild.allele.loss(allele.freq=this.allele.freq)
    number.wild.loss[i] <- length(this.set.wild.loss)
    # Wild-derived allele mean total
    this.set.wild.mean <- mean_wild.alleles(allele.freq=this.allele.freq)
    mean.wild[i] <- mean(this.set.wild.mean)
    # PWK & CAST allele mean total
    this.set.pwk_cast.mean <- mean_pwk_cast.alleles(allele.freq=this.allele.freq)
    mean.pwk_cast[i] <- mean(this.set.pwk_cast.mean)
    # PWK allele mean total
    this.set.pwk.mean <- mean_pwk.alleles(allele.freq=this.allele.freq)
    mean.pwk[i] <- mean(this.set.pwk.mean)
    
    cat(paste("Evaluating set", i, "out of", nrow(possible)), "possible sets", "\n")
  }
  return(list(possible=possible, 
              imbalance=number.imbalance,
              extreme.imbalance=number.extreme.imbalance,
              wild.loss=number.wild.loss,
              mean.wild=mean.wild,
              mean.pwk_cast=mean.pwk_cast,
              mean.pwk=mean.pwk,
              mean.L2norm=mean.L2norm))
}


