source("src/jump_scaling.R")
source("src/pathwise_error.R")
source("src/variation_analysis.R")
source("src/universality_experiments.R")
source("src/simulate_ou_exact.R")
source("src/simulate_ou_euler.R")
source("src/covariance_analysis.R")
source("src/ergodicity_analysis.R")


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

# ------------------------------------------------
# Experiment 5
# OU process dynamics
# ------------------------------------------------

set.seed(123)

theta <- 2
mu <- 0
sigma <- 1
x0 <- 2

T <- 5
n <- 5000

ou_exact <- simulate_OU_exact(theta,
                               mu,
                               sigma,
                               x0,
                               T,
                               n)

ou_euler <- simulate_OU_euler(theta,
                               mu,
                               sigma,
                               x0,
                               T,
                               n)

# ------------------------------------------------
# Plot trajectories
# ------------------------------------------------

png("plots/ou_exact_vs_euler.png",
    width = 900,
    height = 600)

plot(ou_exact$time,
     ou_exact$X,
     type = "l",
     lwd = 2,
     col = "blue",
     xlab = "Time",
     ylab = expression(X[t]),
     main = "Ornstein–Uhlenbeck Dynamics")

lines(ou_euler$time,
      ou_euler$X,
      col = "red",
      lwd = 1)

abline(h = mu,
       lty = 2)

legend("topright",
       legend = c("Exact simulation",
                  "Euler simulation",
                  "Mean level"),
       col = c("blue",
               "red",
               "black"),
       lty = c(1, 1, 2),
       lwd = 2)

dev.off()


# ------------------------------------------------
# Experiment 6
# Same stationary distribution
# Different dynamics
# ------------------------------------------------

set.seed(123)

T <- 5
n <- 5000

# ------------------------------------------------
# Parameter sets
# ------------------------------------------------

theta_1 <- 1
sigma_1 <- 1

theta_2 <- 5
sigma_2 <- sqrt(5)

mu <- 0
x0 <- 2

ou_1 <- simulate_OU_exact(theta_1,
                          mu,
                          sigma_1,
                          x0,
                          T,
                          n)

ou_2 <- simulate_OU_exact(theta_2,
                          mu,
                          sigma_2,
                          x0,
                          T,
                          n)

# ------------------------------------------------
# Plot trajectories
# ------------------------------------------------

png("plots/ou_same_stationary.png",
    width = 900,
    height = 600)

plot(ou_1$time,
     ou_1$X,
     type = "l",
     col = "blue",
     lwd = 2,
     xlab = "Time",
     ylab = expression(X[t]),
     main = "Same Stationary Distribution, Different Dynamics")

lines(ou_2$time,
      ou_2$X,
      col = "red",
      lwd = 2)

abline(h = 0,
       lty = 2)

legend("topright",
       legend = c("Slow reversion",
                  "Fast reversion"),
       col = c("blue",
               "red"),
       lty = 1,
       lwd = 2)

dev.off()

# ------------------------------------------------
# Experiment 7
# Covariance decay
# ------------------------------------------------

tau_grid <- seq(0,
                5,
                length.out = 1000)

cov_slow <- ou_covariance(theta = 1,
                          sigma = 1,
                          tau = tau_grid)

cov_fast <- ou_covariance(theta = 5,
                          sigma = sqrt(5),
                          tau = tau_grid)

png("plots/ou_covariance_decay.png",
    width = 900,
    height = 600)

plot(tau_grid,
     cov_slow,
     type = "l",
     lwd = 2,
     col = "blue",
     ylim = c(0, max(cov_slow)),
     xlab = expression(tau),
     ylab = "Covariance",
     main = "Covariance Decay in OU Processes")

lines(tau_grid,
      cov_fast,
      col = "red",
      lwd = 2)

legend("topright",
       legend = c("Slow reversion",
                  "Fast reversion"),
       col = c("blue",
               "red"),
       lty = 1,
       lwd = 2)

dev.off()

# ------------------------------------------------
# Experiment 8
# Ergodicity and stationary behaviour
# ------------------------------------------------

set.seed(123)

theta <- 2
mu <- 1
sigma <- 1

x0 <- 10

T <- 50
n <- 50000

ou_long <- simulate_OU_exact(theta,
                             mu,
                             sigma,
                             x0,
                             T,
                             n)

# ------------------------------------------------
# Running time average
# ------------------------------------------------

time_average <- running_average(ou_long$X)

# ------------------------------------------------
# Plot trajectory
# ------------------------------------------------

png("plots/ou_ergodic_trajectory.png",
    width = 900,
    height = 600)

plot(ou_long$time,
     ou_long$X,
     type = "l",
     lwd = 1,
     col = "steelblue",
     xlab = "Time",
     ylab = expression(X[t]),
     main = "Long-Run OU Trajectory")

abline(h = mu,
       col = "red",
       lwd = 2,
       lty = 2)

legend("topright",
       legend = c("OU trajectory",
                  "Stationary mean"),
       col = c("steelblue",
               "red"),
       lty = c(1, 2),
       lwd = 2)

dev.off()

# ------------------------------------------------
# Running average convergence
# ------------------------------------------------

png("plots/ou_running_average.png",
    width = 900,
    height = 600)

plot(ou_long$time,
     time_average,
     type = "l",
     lwd = 2,
     col = "darkgreen",
     xlab = "Time",
     ylab = "Running average",
     main = "Ergodic Convergence of Time Average")

abline(h = mu,
       col = "red",
       lwd = 2,
       lty = 2)

legend("topright",
       legend = c("Time average",
                  "Stationary mean"),
       col = c("darkgreen",
               "red"),
       lty = c(1, 2),
       lwd = 2)

dev.off()