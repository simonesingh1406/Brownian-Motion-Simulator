running_average <- function(X) {

  cumsum(X) / seq_along(X)
}