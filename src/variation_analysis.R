variations <- function(Y, T) {

  n <- length(Y)

  S <- c(0, cumsum(Y))

  Y_hat <- S * sqrt(T) / sqrt(n)

  increments <- diff(Y_hat)

  total_variation <- sum(abs(increments))

  quad_variation <- sum(increments^2)

  c(total_variation = total_variation,
    quad_variation = quad_variation)
}