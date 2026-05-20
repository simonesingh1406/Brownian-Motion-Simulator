simulate_OU_euler <- function(theta,
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

    dW <- rnorm(1,
                mean = 0,
                sd = sqrt(dt))

    X[i] <- X[i - 1] +
      theta * (mu - X[i - 1]) * dt +
      sigma * dW
  }

  data.frame(time = times,
             X = X)
}