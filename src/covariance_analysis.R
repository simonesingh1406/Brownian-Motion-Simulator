stationary_variance <- function(sigma,
                                theta) {

  sigma^2 / (2 * theta)
}

ou_covariance <- function(theta,
                          sigma,
                          tau) {

  sigma^2 *
    exp(-theta * tau) /
    (2 * theta)
}