simulate_OU_exact <- function(theta,
                              mu,
                              sigma,
                              x0,
                              T,
                              n) {

  dt <- T / n

  times <- seq(0, T, by = dt)

  X <- numeric(length(times))

  X[1] <- x0

  for (i in 2:length(times)) {

    mean_term <- mu +
      (X[i - 1] - mu) * exp(-theta * dt)

    variance_term <- sigma^2 *
      (1 - exp(-2 * theta * dt)) /
      (2 * theta)

    X[i] <- rnorm(1,
                  mean = mean_term,
                  sd = sqrt(variance_term))
  }

  data.frame(time = times,
             X = X)
}