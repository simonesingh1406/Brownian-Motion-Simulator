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