# Brownian-Motion-And-Ornstein-Uhlenbeck-Processes

## Overview

This repository explores computational stochastic dynamics through simulation, asymptotic analysis, and empirical validation of stochastic processes.

The experiments investigate:
- scaling limits of jump processes,
- Brownian motion approximations,
- total and quadratic variation,
- universality of Donsker scaling,
- Ornstein–Uhlenbeck dynamics,
- covariance decay,
- ergodicity,
- stationary behaviour of stochastic systems.

The project combines mathematical modelling, Monte Carlo simulation, and stochastic analysis using R.

Applications to:
- quantitative finance,
- stochastic volatility,
- statistical arbitrage,
- diffusion modelling,
- market microstructure,
- time-series systems

are discussed throughout.

---

# Experiment 1 — Scaling Limits and Jump Process Approximation

## Motivation

A central idea in stochastic analysis is that deterministic dynamical systems can emerge as scaling limits of stochastic jump processes.

This experiment investigates:
- jump processes with rare large jumps,
- jump processes with frequent small jumps,
- convergence toward deterministic dynamics,
- pathwise approximation behaviour.

The objective is to study how increasing jump frequency and decreasing jump size produces trajectories increasingly close to deterministic motion.

---

## Theory

Consider a jump process with jump size:

- 1/n

and jump intensity:

- n

As n increases:
- jumps become smaller,
- jumps occur more frequently,
- stochastic fluctuations average out.

The process approaches deterministic linear growth.

This illustrates a law-of-large-numbers-type scaling limit for stochastic jump systems.

---

## Simulation Methodology

Two jump systems are compared:

### Process A
- rare jumps,
- larger effective time scale,
- slow growth.

### Process B
- jump intensity increases with n,
- jump size decreases as 1/n,
- trajectories increasingly resemble deterministic motion.

The simulations are constructed directly from exponential waiting times.

---

## Scaling Limit Comparison

![Scaling Limit](plots/scaling_limit_comparison.png)

---

## Observations

The process with many small jumps approaches the deterministic trajectory more closely as jump frequency increases.

This illustrates:
- stochastic averaging,
- scaling limits,
- emergence of deterministic behaviour from random dynamics.

---

# Experiment 2 — Pathwise Convergence of Rescaled Jump Processes

## Motivation

Beyond visual comparison, it is important to quantify convergence of stochastic trajectories toward deterministic dynamics.

This experiment studies:
- pathwise approximation error,
- convergence speed,
- stochastic trajectory fluctuations,
- scaling behaviour as n increases.

---

## Error Metric

For each trajectory, the maximum deviation from the deterministic solution is computed over the interval [0,T].

Monte Carlo simulations are used to estimate the average pathwise error.

---

## Pathwise Convergence

![Pathwise Error](plots/pathwise_convergence.png)

---

## Observations

The mean pathwise approximation error decreases as n increases.

This demonstrates:
- convergence of stochastic trajectories,
- reduction of fluctuations,
- emergence of deterministic behaviour under scaling.

---

# Experiment 3 — Total Variation and Quadratic Variation in Brownian Scaling Limits

## Motivation

Brownian motion exhibits highly irregular path behaviour.

This experiment investigates two fundamental pathwise quantities:
- total variation,
- quadratic variation.

The objective is to study how these quantities behave under Donsker scaling as the number of increments increases.

These concepts are foundational in:
- stochastic calculus,
- diffusion modelling,
- volatility theory,
- stochastic integration.

---

## Theory

For rescaled random walks approximating Brownian motion:

- total variation diverges,
- quadratic variation converges.

This reflects the roughness of Brownian trajectories:
- paths are nowhere differentiable,
- fluctuations persist at arbitrarily small scales.

Quadratic variation remains finite despite infinite total variation.

---

## Simulation Methodology

For increasing values of n:
1. Generate i.i.d. increments.
2. Construct the rescaled partial-sum process.
3. Compute:
   - total variation,
   - quadratic variation.

The experiment investigates asymptotic behaviour as n becomes large.

---

## Total Variation Growth

![TV](plots/total_variation_rademacher.png)

---

## Quadratic Variation Stabilisation

![QV](plots/quadratic_variation_rademacher.png)

---

## Observations

The simulations verify:
- divergence of total variation,
- stabilisation of quadratic variation near T.

This illustrates the irregular geometry of Brownian paths and the emergence of quadratic variation as the correct notion of accumulated stochastic fluctuation.

---

# Experiment 4 — Universality of Brownian Scaling Across Increment Distributions

## Motivation

A remarkable property of Brownian scaling limits is universality.

The limiting Brownian behaviour depends primarily on:
- mean,
- variance,

rather than the exact increment distribution.

This experiment investigates scaling behaviour across multiple standardized increment distributions.

---

## Increment Distributions

At each step, increments are sampled randomly from:
- Rademacher distribution,
- Uniform distribution,
- Gaussian distribution,
- Shifted exponential distribution.

All distributions are standardized to have:
- mean 0,
- variance 1.

---

## Universality of Total Variation

![TV Mix](plots/universality_total_variation.png)

---

## Universality of Quadratic Variation

![QV Mix](plots/universality_quadratic_variation.png)

---

## Observations

Despite the increment distributions being fundamentally different:
- total variation still diverges,
- quadratic variation still stabilises near T.

This illustrates the universality of Brownian scaling limits and demonstrates that large-scale stochastic behaviour depends primarily on low-order moments rather than precise microscopic distributions.

---

# Experiment 5 — Mean-Reverting Dynamics in Ornstein–Uhlenbeck Processes

## Motivation

The Ornstein–Uhlenbeck (OU) process is one of the most important mean-reverting stochastic systems.

Applications include:
- statistical arbitrage,
- interest-rate modelling,
- stochastic volatility,
- physical diffusion systems,
- time-series dynamics.

This experiment investigates:
- mean reversion,
- stochastic fluctuations,
- exact simulation,
- Euler discretization.

---

## OU Dynamics

The OU process satisfies:

- drift toward long-run mean μ,
- stochastic diffusion,
- stationary long-run behaviour.

The process evolves according to:
- reversion speed θ,
- volatility σ,
- equilibrium level μ.

---

## Simulation Methodology

Two simulation schemes are compared:
1. Exact discretization.
2. Euler–Maruyama approximation.

This allows comparison between:
- exact stochastic dynamics,
- numerical approximation error.

---

## OU Trajectories

![OU Dynamics](plots/ou_exact_vs_euler.png)

---

## Observations

The trajectories fluctuate randomly while repeatedly reverting toward the equilibrium level μ.

Increasing θ strengthens mean reversion, while increasing σ amplifies stochastic variability.

The exact and Euler schemes remain close for sufficiently small time steps.

---

# Experiment 6 — Distinct Dynamical Regimes with Identical Stationary Distributions

## Motivation

Stochastic systems can possess identical stationary distributions while exhibiting fundamentally different temporal dynamics.

This experiment investigates:
- slow mean reversion,
- rapid mean reversion,
- dependence structure,
- dynamical memory effects.

---

## Theory

For an OU process, the stationary variance is:

- σ² / (2θ)

Different parameter combinations may therefore produce:
- identical stationary distributions,
- different pathwise behaviour.

---

## Dynamical Comparison

![OU Stationary](plots/ou_same_stationary.png)

---

## Observations

Although both processes share the same stationary variance:
- one process reverts slowly,
- the other reverts rapidly.

This illustrates that stationary distributions alone do not fully characterise stochastic dynamics.

Temporal dependence structure remains critically important.

---

# Experiment 7 — Covariance Decay and Temporal Dependence in OU Processes

## Motivation

Temporal dependence plays a central role in stochastic systems and time-series modelling.

This experiment investigates:
- covariance decay,
- memory structure,
- dependence persistence,
- effects of mean-reversion speed.

---

## Covariance Structure

The covariance of an OU process decays exponentially:

- faster decay → weaker memory,
- slower decay → stronger persistence.

The reversion parameter θ controls dependence decay.

---

## Covariance Decay

![Covariance Decay](plots/ou_covariance_decay.png)

---

## Observations

Processes with stronger mean reversion exhibit more rapid covariance decay.

This demonstrates how reversion speed controls:
- memory persistence,
- temporal dependence,
- stochastic correlation structure.

---

# Experiment 8 — Ergodicity and Long-Run Stationary Behaviour

## Motivation

Ergodicity is a fundamental concept in stochastic dynamics.

An ergodic process allows:
- long-run time averages,
- statistical ensemble averages

to coincide asymptotically.

This experiment investigates:
- long-run OU trajectories,
- convergence of running averages,
- stationary equilibrium behaviour,
- ergodic convergence.

---

## Theory

The Ornstein–Uhlenbeck process is ergodic under standard conditions.

As time increases:
- transient initial conditions disappear,
- trajectories repeatedly revisit the equilibrium region,
- long-run averages converge toward the stationary expectation.

This property is fundamental for:
- statistical estimation,
- Monte Carlo simulation,
- stochastic equilibrium systems.

---

## Long-Run Trajectory

![Ergodic Trajectory](plots/ou_ergodic_trajectory.png)

---

## Running Average Convergence

![Running Average](plots/ou_running_average.png)

---

## Observations

The running average converges progressively toward the stationary mean μ.

This demonstrates:
- disappearance of initial-condition effects,
- long-run equilibrium behaviour,
- ergodic convergence of stochastic trajectories.

The experiment illustrates how long-run statistical structure emerges from stochastic dynamics.