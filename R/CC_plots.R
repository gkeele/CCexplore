## Plot out set allele frequencies across the genome in pretty CC colors!
#' @export
allele.freq.plot <- function(allele.freq,
                             colors=c(rgb(240, 240, 0, maxColorValue=255), # yellow
                                      rgb(128, 128, 128, maxColorValue=255), # gray
                                      rgb(240, 128, 128, maxColorValue=255), # pink/salmon
                                      rgb(16, 16, 240, maxColorValue=255), # dark blue
                                      rgb(0, 160, 240, maxColorValue=255), # light blue
                                      rgb(0, 160, 0, maxColorValue=255), # green
                                      rgb(240, 0, 0, maxColorValue=255), # red
                                      rgb(144, 0, 224, maxColorValue=255)), # purple
                             title=""){
  positions <- 1:nrow(allele.freq)
  max.x <- max(positions) + 0.2*max(positions)
  
  ## Arranging to be plotted
  plot.props <- matrix(0, nrow=nrow(allele.freq), ncol=ncol(allele.freq))
  plot.props[,1] <- allele.freq[,1]
  for(i in 2:ncol(allele.freq)) {
    plot.props[,i] <- rowSums(allele.freq[,c(1:i)])
  }
  plot(0, bty="n", pch="",
       xlim=c(min(positions), max(positions)), ylim=c(0, 1), main=title, xlab="Position", xaxt="n", ylab="Set allele frequency", las=1)
  # plot(x=positions, y=plot.props[,1], col='black', type='l', bty="n", 
  #      ylim=c(0, 1), main=title, xlab="Position", xaxt="n", ylab="Set allele frequency", las=1)
  #points(x=positions, y=plot.props[,2], col='black', type='l', ylim=c(0,1))
  #points(x=positions, y=plot.props[,3], col='black', type='l', ylim=c(0,1))
  #points(x=positions, y=plot.props[,4], col='black', type='l', ylim=c(0,1))
  #points(x=positions, y=plot.props[,5], col='black', type='l', ylim=c(0,1))
  #points(x=positions, y=plot.props[,6], col='black', type='l', ylim=c(0,1))
  #points(x=positions, y=plot.props[,7], col='black', type='l', ylim=c(0,1))
  
  polygon(c(positions, rev(positions)), c(plot.props[,1], rep(0, length(positions))), col=colors[1], border=NA)
  for(i in 2:ncol(allele.freq)) {
    polygon(c(positions, rev(positions)), c(plot.props[,i], rev(plot.props[,i-1])), col=colors[i], border=NA)
  }
  # legend("topright", legend=c("A/J", "B6", "129S", "NOD", "NZO", "CAST", "PWK", "WSB"),
  #        col=colors, fill=colors, border=colors)
}