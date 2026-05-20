source("src/jump_scaling.R")

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