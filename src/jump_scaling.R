simulate_jump <- function(rate, jump_size, T) {

  time <- 0
  X <- 0

  times <- c(0)
  values <- c(0)

  while (time < T) {

    time <- time + rexp(1, rate = rate)

    if (time <= T) {

      X <- X + jump_size

      times <- c(times, time)
      values <- c(values, X)
    }
  }

  list(times = times,
       values = values)
}