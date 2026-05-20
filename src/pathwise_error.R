trajectory_error <- function(traj,
                             T,
                             grid_size = 1000) {

  t_grid <- seq(0,
                T,
                length.out = grid_size)

  X_hat <- approx(traj$times,
                   traj$values,
                   xout = t_grid,
                   method = "constant",
                   rule = 2)$y

  X_det <- t_grid

  max(abs(X_hat - X_det))
}
