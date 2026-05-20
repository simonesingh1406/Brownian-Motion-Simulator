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