# https://gist.github.com/goldingn/80c82f2886debeb927a5
fuzzyMatch <- function (a, b) {
  
  # no-frills fuzzy matching of strings between character vectors
  # `a` and `b` (essentially a wrapper around a stringdist function)
  # The function returns a two column matrix giving the matching index
  # (as `match` would return) and a matrix giving the distances, so you
  # can check how well it did on the hardest words.
  # Warning - this uses all of your cores.
  
  # load the stringdist package
  require (stringdist)
  
  # calculate a jaccard dissimilarity matrix
  distance <- stringdistmatrix(a, b, method = 'jaccard')
  
  # find the closest match for each
  match <- apply(distance, 1, which.min)
  
  # find how far away these were
  dists <- apply(distance, 1, min)
  
  # return these as a two-column matrix
  return (cbind(match = match, distance = dists))
  
}
