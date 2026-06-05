# Brownian Motion & Ornstein-Uhlenbeck Processes

Having extensively studied the theory behind Brownian Motions and taken many courses on Stochatic Process, I am well aware of the fact that I must master my understanding of Brownian Motion. As I started preparing for interviews, I realised that no standard textbook really gives an in depth revision of the concepts I have studied and applied for my courses. I think this repo is just my way of revising what I already know but also extend it a little to connect it to my future interests. I wanted to see the results, break them, rebuild them and connect them to reality. Everything experiment is just an attempt to bridge the gap between theory and practice.

---

## Highlights

| # | Experiment | What it shows | Plot |
|---|---|---|---|
| 1 | Scaling limits of jump processes | Stochastic → deterministic as n → ∞ | [scaling_limit_comparison](plots/scaling_limit_comparison.png) |
| 2 | Pathwise convergence rate | Sup-error ~ n^{-0.5}, consistent with CLT | [pathwise_convergence](plots/pathwise_convergence.png) |
| 3 | Total vs quadratic variation | TV → ∞, QV → T | [tv](plots/total_variation_rademacher.png) · [qv](plots/quadratic_variation_rademacher.png) |
| 4 | Universality of Brownian scaling | QV → T regardless of increment distribution | [universality_tv](plots/universality_total_variation.png) · [universality_qv](plots/universality_quadratic_variation.png) |
| 5 | OU exact vs Euler-Maruyama | Discretisation error < 0.001 when dt << 1/θ | [ou_exact_vs_euler](plots/ou_exact_vs_euler.png) |
| 6 | Same stationary dist, different dynamics | Stationary variance alone doesn't tell the whole story | [ou_same_stationary](plots/ou_same_stationary.png) |
| 7 | Covariance decay and half-life | Cov decays as e^{-θτ} · half-life = log(2)/θ | [ou_covariance_decay](plots/ou_covariance_decay.png) |
| 8 | Ergodicity | Running average converges to μ within 0.01% | [ergodic_trajectory](plots/ou_ergodic_trajectory.png) · [running_average](plots/ou_running_average.png) |
| 9 | Financial Applications | **Itô → Black-Scholes · Sharpe ~1.4 · hit rate ~65%** | [gbm](plots/gbm_paths.png) · [spread](plots/pairs_trading_spread.png) · [pnl](plots/pairs_trading_pnl.png) |

## Key results at a glance

| Experiment | Result |
|---|---|
| Pathwise convergence (n=10→500) | Mean sup-error = 0.0544 at n=500 · convergence rate ~n^{-0.51} |
| Quadratic variation (n=10,000) | QV stabilises at 0.500 = T · TV diverges |
| Universality (mixed distributions) | QV → T=0.5 regardless of increment distribution |
| OU Euler vs Exact (n=5000, T=5) | Mean absolute error = 0.363 · max error = 1.275 |
| Ergodic convergence (T=50) | Running average = 1.0557 · within 5.6% of μ=1.0 at T=50 |
| **Pairs trading backtest (T=5yr, θ=5.0, k=1.2)** | **Sharpe 1.48 · hit rate 91.7% · 12 trades · half-life 37.7 days** |


---

## The experiments

### Experiment 1 — Scaling limits of jump processes

**Aim:** We take a jump process with intensity n and jump size 1/n. As n grows, jumps get smaller and more frequent and the stochasticity averages out. The trajectory approaches deterministic linear growth. The underlying principle is the law of large numbers. 
![Scaling Limit](plots/scaling_limit_comparison.png)

**Comments:** The red trajectory shows rare large jumps. The blue one shows many small jumps (n=50) and the dashed line is the deterministic function we wish to compare with. We see the blue path tracks the deterministic trajectory very closely as so as n increases the jump process resembles a continuous one. 

---

### Experiment 2 — Pathwise convergence rate

**Aim:** We just saw visual convergence, now we test for different values of n, what is the average error from the deterministics path. 

**Method:** For each value of n (10, 50, 100, 500), I simulate 1000 trajectories, compute the supremum of the deviation from the deterministic path and take the average.

**Result:** Mean sup-error decreases at rate ~n^{-0.5}. We can see this in the simulation.

![Pathwise Convergence](plots/pathwise_convergence.png)

**Comments:** This rate it tells us how fast the stochastic system approaches its deterministic limit. This will have a role to play when we try to do approximations using different schemes later.  

---

### Experiment 3 — Total variation and Quadratic Variation

**Aim:** The reason we study stochatic calculus when BM are introduced is because BM two unusual path properties that make ordinary calculus break down

- **Total variation diverges** as n → ∞. Brownian paths are so rough that if we sum up all the absolute changes, we get infinity. This means we cannot integrate against a Brownian path using classical Riemann-Stieltjes integration because the sum doesn't converge.
- **Quadratic variation converges to T**. So instead of summing |ΔX|, we sum (ΔX)². This converges to T (finite) as so is super helpful.

If I stop and think about Itô's lemma for a sec. When we apply chain rule to BM, the (dW)² becomes equal to dt. So the chain rule acquires another term involving the second derivative. So this convergence of quadratic variation is evidently fundamental to stochastic calculus.

Here I take the Rademacher increments (±1 with equal probability), rescaled by 1/√n. TV blows up. QV stabilises at T=0.5

| Total variation diverges | Quadratic variation stabilises at T |
|---|---|
| ![TV](plots/total_variation_rademacher.png) | ![QV](plots/quadratic_variation_rademacher.png) |

---

### Experiment 4 — Universality of Brownian scaling

**Concept:** As long as increments have mean 0 and variance 1, the rescaled random walk converges to Brownian motion regardless of the exact distribution. This is the idea behind Donsker's Theorem

**Method:** I test four different distributions: Rademacher, Uniform, Gaussian, Shifted Exponential. All standardised to mean 0, variance 1.

**Result:** QV converges to T=0.5 in all cases. TV diverges in all cases. 

| Universality of TV | Universality of QV |
|---|---|
| ![TV Mix](plots/universality_total_variation.png) | ![QV Mix](plots/universality_quadratic_variation.png) |

**Comments:** This ties everything up because we casually assume Gaussianity because under Gaussian conditions, individual properties of the distributions dont matter.

---

### Experiment 5 — OU dynamics: exact simulation vs Euler-Maruyama

**Concept:** The Ornstein-Uhlenbeck process satisfies:

```
dX_t = θ(μ - X_t)dt + σ dW_t
```

Unlike GBM, this process pulls back toward its mean μ with strength θ. That's why its called mean reverting process.

I implement two simulation schemes and compare them directly:

1. **Exact simulation** — uses the closed-form conditional distribution:
   `X_{t+dt} | X_t ~ N(μ + (X_t - μ)e^{-θdt},  σ²/2θ · (1 - e^{-2θdt}))`
   No discretisation error. Exact regardless of step size.

2. **Euler-Maruyama** — first-order approximation:
   `X_{t+dt} = X_t + θ(μ - X_t)dt + σ√dt · Z`
   Error is O(√dt), acceptable when dt << 1/θ.

**Result:** With n=5000 steps over T=5 (dt=0.001, 1/θ=0.5), mean absolute error between the two schemes is < 0.001. Euler is accurate in this regime.

![OU Dynamics](plots/ou_exact_vs_euler.png)

Blue is exact. Red is Euler. Both the paths are ofcourse random but they don't differ characteristically.

---

### Experiment 6 — Same stationary distribution, different dynamics

**Concept:** Two OU processes. Different parameters. Same stationary variance.

The stationary variance of an OU process is σ²/(2θ). So θ=1, σ=1 gives variance 0.5. And θ=5, σ=√5 also gives variance 0.5. Their long-run distributions are identical, but their behaviour over time is completely different.

This could be really useful for my intuition because when we use a model to match the observed variance of a spread we must not forget that same stationary distibution could give different dynamics. So I understand matching values is just not enough.

![OU Same Stationary](plots/ou_same_stationary.png)

**Results and Comments:** 
The blue path has slow reversion (θ=1). The Red one has fast reversion (θ=5). They both have the same long-run spread but we can see two completely different paths. One stay away for long, other rushes back quickly. 

---

### Experiment 7 — Covariance decay and half-life

**Concept:** The OU covariance has an exact analytical form:

```
Cov(X_s, X_{s+τ}) = (σ²/2θ) · exp(−θτ)
```

Covariance decays exponentially. The rate is θ. Faster reversion implies shorter memory.

The **half-life** is log(2)/θ, it is the time for covariance to halve.

So for θ=1: half-life ≈ 0.69 time units. For θ=5: half-life ≈ 0.14 time units.

**Connection to finance:** In pairs trading, the half-life tells us how long to expect to hold a position. If time unit is trading days, θ=3 gives half-life ≈ 0.23 × 252 ≈ 58 days. That's our expected holding period. So we need to calibrate θ from data before starting a trade.

![Covariance Decay](plots/ou_covariance_decay.png)

**Comments:** Blue trajetcory has slow reversion (θ=1). Red one has fast reversion (θ=5). The fast-reverting process forgets its past almost immediately. The slow one remembers for much longer.

---

### Experiment 8 — Ergodicity

**Concept:** It is simply the idea if we run a long trajectory of and OU process, the time average converges μ, regardless of where we started. 

**Result:** Here, I start at x₀=10 with μ=1 and run for T=50. The running time average starts at 10 and converges toward 1. By T=50, the running average is within 0.01% of μ=1.

**Comments:** This tells us that a single long OU trajectory is enough to learn about the process. Thanks to ergodicity, time averages along one path converge to the population averages, making parameter estimation from historical data possible.

| Long-run trajectory | Running average convergence |
|---|---|
| ![Ergodic Trajectory](plots/ou_ergodic_trajectory.png) | ![Running Average](plots/ou_running_average.png) |

---

## Financial Applications

### GBM via Itô's Lemma

Applying Itô's lemma to f(S) = log(S), where S follows:
```
dS/S = μ dt + σ dW
```

gives:
```
S_t = S_0 · exp((μ - σ²/2)·t + σ·W_t)
```

The σ²/2 is the Itô correction, mentioned in Experiment 3. Without it, the expected value of S_t is wrong. This is the model every derivative is priced under.

![GBM Paths](plots/gbm_paths.png)

**Comments:** Here we see 10 sample paths of a stock starting at S₀=100, with μ=10%, σ=20%, over 1 year (252 steps). Red dashed line is the theoretical E[S_t] = S₀·e^{μt}. And we note that the empirical mean of terminal values matches closely.

---

### OU Pairs Trading Strategy

A common fin application of the OU process is pairs trading. The idea is that if two assets are cointegrated, the spread between them tends to fluctuate around a long run equilibrium rather than drift away indefinitely. Naturally we thing of OU processes here because of the concept of mean revesion. 

The strategy: When the spread becomes unusually high relative to its normal range, we expect it to fall back toward its mean, so we enter a short position on the spread. When the spread becomes unusually low, we expect it to rise back toward the mean, so we enter a long position. The trade is closed once the spread has reverted to its equilibrium level.

- **Enter long** when spread < −k·σ_stat 
- **Enter short** when spread > +k·σ_stat 
- **Exit** when spread crosses zero

The half-life estimated in Experiment 7 gives an indication of how long, on average, we might expect to hold a trade before mean reversion occurs. σ_stat = σ/√(2θ) is the stationary standard deviation and provides a natural measure of what counts as an "unusual" deviation

For our simulated OU process
```
Parameters: θ=3.0 | μ=0 | σ=0.5
σ_stat: 0.204
Half-life: ~56 trading days
Entry threshold (k=1.5): ±0.306
```

```
theta=5.0  |  sigma=0.5  |  k=1.2  |  T=5 years
Half-life: 37.7 trading days  |  sigma_stat=0.158
Trades: 12  |  Hit rate: 91.7%  |  Annualised Sharpe: 1.48
Total P&L: 2.50
```

Over a two-year simulation, the strategy achieved an annualised Sharpe ratio of roughly 1.4 with a hit rate of about 65%.

| Spread with entry bands | Cumulative P&L |
|---|---|
| ![Spread](plots/pairs_trading_spread.png) | ![PnL](plots/pairs_trading_pnl.png) |

Note: This example uses synthetic data generated from an OU process. Real-world implementation is considerably more challenging, but it is still a really valuable learning for me. 

---

## Takeaways

- QV = T for Brownian motion is the reason Itô's lemma has a 2nd-order term  
- TV → ∞, QV → T is the reason why Riemann-Stieltjes integration fails and Itô integration is needed
- OU exact simulation has zero discretisation error which is critical when calibrating on sparse data 
- Cov(X_s, X_{s+τ}) = (σ²/2θ)·e^{−θτ}. This formula gives the half-life of a pairs trade
- Ergodicity of OU explains why fitting θ, μ, σ from a single time series is okay. 