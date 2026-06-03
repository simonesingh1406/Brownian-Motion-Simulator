# =============================================================================
# financial_application.R
#
# Two direct financial applications of this repo's mathematical content.
#
# Application 1: GBM stock price simulation via Ito's lemma
#   Connects: Brownian motion + quadratic variation -> Black-Scholes world
#
# Application 2: OU pairs trading strategy
#   Connects: OU mean reversion + covariance decay -> real trading signal
#   Reports: entry/exit count, hit rate, Sharpe ratio
# =============================================================================

source("src/simulate_ou_exact.R")

# =============================================================================
# Application 1: Geometric Brownian Motion via Ito's Lemma
# =============================================================================
#
# If S_t is a stock price, assume:
#   dS_t = mu*S_t*dt + sigma*S_t*dW_t
#
# By Ito's lemma applied to f(S) = log(S):
#   d(log S_t) = (mu - sigma^2/2)*dt + sigma*dW_t
#
# Therefore: S_t = S_0 * exp((mu - sigma^2/2)*t + sigma*W_t)
#
# The sigma^2/2 correction (Ito correction) is the direct consequence of
# quadratic variation: [W]_t = t, which means (dW)^2 = dt in Ito calculus.
# Without it, you get the WRONG expected value.

simulate_GBM <- function(S0, mu, sigma, T, n, n_paths = 1) {
  dt <- T / n
  t  <- seq(0, T, by = dt)
  paths <- matrix(NA, nrow = n + 1, ncol = n_paths)
  
  for (j in 1:n_paths) {
    W  <- c(0, cumsum(rnorm(n, mean = 0, sd = sqrt(dt))))
    # Ito correction: (mu - sigma^2/2) not mu
    paths[, j] <- S0 * exp((mu - 0.5 * sigma^2) * t + sigma * W)
  }
  list(t = t, paths = paths)
}

set.seed(42)
S0    <- 100
mu    <- 0.10    # 10% annual drift
sigma <- 0.20    # 20% annual vol
T     <- 1
n     <- 252

gbm <- simulate_GBM(S0, mu, sigma, T, n, n_paths = 10)

# Theoretical vs empirical check
theoretical_mean <- S0 * exp(mu * T)
empirical_mean   <- mean(gbm$paths[n + 1, ])

cat("=== Application 1: GBM ===\n")
cat(sprintf("Theoretical E[S_T]: %.2f\n", theoretical_mean))
cat(sprintf("Empirical mean S_T (10 paths): %.2f\n", empirical_mean))

# Plot
png("plots/gbm_paths.png", width = 900, height = 500)
plot(gbm$t, gbm$paths[, 1], type = "l", col = adjustcolor("steelblue", 0.8),
     ylim = range(gbm$paths), lwd = 1.2,
     xlab = "Time (years)", ylab = "Stock Price",
     main = "Geometric Brownian Motion — 10 Sample Paths")
for (j in 2:10) lines(gbm$t, gbm$paths[, j], 
                       col = adjustcolor("steelblue", 0.5), lwd = 1)
abline(h = S0, lty = 2, col = "gray")
lines(gbm$t, S0 * exp(mu * gbm$t), col = "red", lwd = 2, lty = 2)
legend("topleft", legend = c("GBM paths", "E[S_t] = S_0*exp(mu*t)"),
       col = c("steelblue", "red"), lty = c(1, 2), lwd = 2)
dev.off()


# =============================================================================
# Application 2: OU Pairs Trading Strategy
# =============================================================================
#
# Setup: two cointegrated assets. Their spread X_t follows an OU process.
# Strategy: 
#   - Enter LONG spread when X_t < -k * sigma_stat (spread too low, expect reversion up)
#   - Enter SHORT spread when X_t > +k * sigma_stat (spread too high, expect reversion down)  
#   - Exit when spread crosses zero
#
# This is the core of statistical arbitrage at every major quant fund.
#
# Key parameter: half-life = log(2)/theta
#   This tells you how long to expect to hold the position.

set.seed(42)

# Simulate a spread as OU process
theta_spread <- 3.0    # mean reversion speed
mu_spread    <- 0.0    # long-run mean of spread
sigma_spread <- 0.5    # spread volatility
T_backtest   <- 2      # 2 years of daily data
n_days       <- 504    # ~2 trading years

spread_sim <- simulate_OU_exact(theta_spread, mu_spread, sigma_spread,
                                 x0 = 0, T = T_backtest, n = n_days)
spread     <- spread_sim$X
time_axis  <- spread_sim$time

# Stationary std dev: sigma / sqrt(2*theta)
sigma_stat  <- sigma_spread / sqrt(2 * theta_spread)
half_life   <- log(2) / theta_spread

cat("\n=== Application 2: OU Pairs Trading ===\n")
cat(sprintf("OU params: theta=%.1f, mu=%.1f, sigma=%.1f\n", 
            theta_spread, mu_spread, sigma_spread))
cat(sprintf("Stationary std dev: %.4f\n", sigma_stat))
cat(sprintf("Half-life: %.2f time units (%.1f trading days)\n", 
            half_life, half_life * 252 / T_backtest))

# Trading signal: k = 1.5 standard deviations
k <- 1.5
entry_long  <- -k * sigma_stat
entry_short <-  k * sigma_stat

# Simulate P&L
position  <- 0      # 1 = long, -1 = short, 0 = flat
pnl       <- numeric(n_days)
trades    <- 0
wins      <- 0

for (i in 2:n_days) {
  prev <- spread[i - 1]
  curr <- spread[i]
  
  # Entry signals
  if (position == 0) {
    if (prev > entry_short) { position <- -1; trades <- trades + 1 }
    if (prev < entry_long)  { position <-  1; trades <- trades + 1 }
  }
  
  # Exit: spread crosses zero
  if (position == 1  && curr >= 0) {
    wins     <- wins + (curr > prev)
    position <- 0
  }
  if (position == -1 && curr <= 0) {
    wins     <- wins + (curr < prev)
    position <- 0
  }
  
  # Daily P&L = position * change in spread
  pnl[i] <- position * (curr - prev)
}

cum_pnl    <- cumsum(pnl)
total_pnl  <- sum(pnl)
hit_rate   <- ifelse(trades > 0, wins / trades, NA)
sharpe     <- mean(pnl) / sd(pnl) * sqrt(252 / T_backtest)

cat(sprintf("\nBacktest results (k=%.1f, T=%g years):\n", k, T_backtest))
cat(sprintf("  Trades executed:  %d\n", trades))
cat(sprintf("  Hit rate:         %.1f%%\n", 100 * hit_rate))
cat(sprintf("  Total P&L:        %.4f\n", total_pnl))
cat(sprintf("  Annualised Sharpe: %.2f\n", sharpe))

# Plot spread with signals
png("plots/pairs_trading_spread.png", width = 900, height = 500)
plot(time_axis, spread, type = "l", col = "steelblue", lwd = 1.5,
     xlab = "Time (years)", ylab = "Spread X_t",
     main = sprintf("OU Pairs Trading — Spread & Entry Bands (k=%.1f)", k))
abline(h = c(entry_long, entry_short), col = "red",    lty = 2, lwd = 1.5)
abline(h = 0,                          col = "darkgray", lty = 3)
legend("topright", 
       legend = c("Spread", sprintf("Entry bands (±%.1f*sigma_stat)", k)),
       col = c("steelblue", "red"), lty = c(1, 2), lwd = 2)
dev.off()

# Plot cumulative P&L
png("plots/pairs_trading_pnl.png", width = 900, height = 400)
plot(time_axis, cum_pnl, type = "l", col = "darkgreen", lwd = 2,
     xlab = "Time (years)", ylab = "Cumulative P&L",
     main = sprintf("Pairs Trading P&L — Sharpe %.2f | Hit Rate %.0f%%",
                    sharpe, 100 * hit_rate))
abline(h = 0, lty = 2, col = "gray")
dev.off()