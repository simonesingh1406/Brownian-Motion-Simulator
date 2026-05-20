source("src/jump_scaling.R")
source("src/pathwise_error.R")
source("src/variation_analysis.R")
source("src/universality_experiments.R")


set.seed(123)

# ------------------------------------------------
# Experiment 1
# Scaling limits of jump processes
# ------------------------------------------------

T <- 1
n <- 50

# Few jumps
traj_few <- simulate_jump(rate = 1,
                          jump_size = 1 / n,
                          T)

# Many small jumps
traj_many <- simulate_jump(rate = n,
                           jump_size = 1 / n,
                           T)

# ------------------------------------------------
# Plot comparison
# ------------------------------------------------

png("plots/scaling_limit_comparison.png",
    width = 900,
    height = 600)

plot(traj_few$times,
     traj_few$values,
     type = "s",
     col = "red",
     lwd = 2,
     ylim = c(0, T),
     xlab = "t",
     ylab = expression(X[t]),
     main = "Few Jumps vs Many Small Jumps")

lines(traj_many$times,
      traj_many$values,
      type = "s",
      col = "blue",
      lwd = 2)

abline(a = 0,
       b = 1,
       lty = 2)

legend("topleft",
       legend = c("Few jumps",
                  "Many small jumps",
                  "Deterministic"),
       col = c("red",
               "blue",
               "black"),
       lty = c(1, 1, 2),
       lwd = 2)

dev.off()


# ------------------------------------------------
# Experiment 2
# Pathwise convergence
# ------------------------------------------------

simulate_X_hat_trajectory <- function(n, T) {

  time <- 0
  X <- 0

  times <- c(0)
  values <- c(0)

  while (time < T) {

    wait <- rexp(1, rate = n)

    time <- time + wait

    if (time <= T) {

      X <- X + 1 / n

      times <- c(times, time)
      values <- c(values, X)
    }
  }

  list(times = times,
       values = values)
}

n_values <- c(10, 50, 100, 500)

n_trials <- 1000

mean_sup_error <- numeric(length(n_values))

for (i in seq_along(n_values)) {

  n <- n_values[i]

  sup_errors <- replicate(n_trials, {

    traj <- simulate_X_hat_trajectory(n, T)

    trajectory_error(traj, T)
  })

  mean_sup_error[i] <- mean(sup_errors)
}

png("plots/pathwise_convergence.png",
    width = 900,
    height = 600)

plot(n_values,
     mean_sup_error,
     type = "b",
     pch = 19,
     lwd = 2,
     xlab = "n",
     ylab = expression(sup[t <= T] *
                       "|" *
                       hat(X)[t] *
                       " - X(t)|"),
     main = "Pathwise Approximation Error")

dev.off()

# ------------------------------------------------
# Experiment 3
# Total vs Quadratic Variation
# ------------------------------------------------

set.seed(123)

T <- 0.5

n_values <- c(10,
              50,
              100,
              500,
              1000,
              5000,
              10000)

# ------------------------------------------------
# Rademacher increments
# ------------------------------------------------

tv_rad <- numeric(length(n_values))
qv_rad <- numeric(length(n_values))

for (i in seq_along(n_values)) {

  n <- n_values[i]

  Y <- sample(c(-1, 1),
              size = n,
              replace = TRUE)

  vars <- variations(Y, T)

  tv_rad[i] <- vars["total_variation"]

  qv_rad[i] <- vars["quad_variation"]
}

# ------------------------------------------------
# Plot total variation
# ------------------------------------------------

png("plots/total_variation_rademacher.png",
    width = 900,
    height = 600)

plot(n_values,
     tv_rad,
     type = "b",
     pch = 19,
     lwd = 2,
     xlab = "n",
     ylab = "Total variation",
     main = "Total Variation Growth")

dev.off()

# ------------------------------------------------
# Plot quadratic variation
# ------------------------------------------------

png("plots/quadratic_variation_rademacher.png",
    width = 900,
    height = 600)

plot(n_values,
     qv_rad,
     type = "b",
     pch = 19,
     lwd = 2,
     xlab = "n",
     ylab = "Quadratic variation",
     main = "Quadratic Variation Stabilisation")

abline(h = T,
       col = "red",
       lty = 2)

dev.off()


# ------------------------------------------------
# Experiment 4
# Universality of Brownian scaling
# ------------------------------------------------

tv_mix <- numeric(length(n_values))
qv_mix <- numeric(length(n_values))

for (i in seq_along(n_values)) {

  n <- n_values[i]

  Y <- generate_increments(n)

  vars <- variations(Y, T)

  tv_mix[i] <- vars["total_variation"]

  qv_mix[i] <- vars["quad_variation"]
}

# ------------------------------------------------
# Total variation
# ------------------------------------------------

png("plots/universality_total_variation.png",
    width = 900,
    height = 600)

plot(n_values,
     tv_mix,
     type = "b",
     pch = 19,
     lwd = 2,
     xlab = "n",
     ylab = "Total variation",
     main = "Universality of Total Variation")

dev.off()

# ------------------------------------------------
# Quadratic variation
# ------------------------------------------------

png("plots/universality_quadratic_variation.png",
    width = 900,
    height = 600)

plot(n_values,
     qv_mix,
     type = "b",
     pch = 19,
     lwd = 2,
     xlab = "n",
     ylab = "Quadratic variation",
     main = "Universality of Quadratic Variation")

abline(h = T,
       col = "red",
       lty = 2)

dev.off()