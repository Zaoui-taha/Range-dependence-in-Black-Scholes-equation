# Improvising time-dependent Black-Scholes equation for option values with fractional Brownian motion and numerical resolution

**Mathematical derivation and numerical approximation using fractional Brownian motion, PDEs, and Monte Carlo methods**

**Research internship | Mahindra University, Hyderabad, India | August 2025**  
**Report:** *Improvising Time-Independent Black-Scholes Equation for Option Values with Fractional Brownian Motion and Numerical Resolution*  
**Authors:** Taha Zaoui and Sanjukta Das  
**Status:** Internship research report (not peer-reviewed)

> **[Read the full research report]([Final_report/improvising_time_dependent_black_scholes_equation.pdf](https://github.com/Zaoui-taha/Range-dependence-in-Black-Scholes-equation/blob/41917996c30948e9bb6b3209c198d704d6c89795/Final%20report/improvising%20time%20dependent%20black%20scholes%20equation.pdf))** — includes the mathematical derivations, numerical experiments, references, and MATLAB code in the appendix.

## Overview

The classical Black–Scholes model assumes that the underlying asset follows a geometric Brownian motion. This research investigates a fractional Brownian motion (fBm) extension, in which the **Hurst exponent** \(H\) controls the temporal dependence of the stochastic process.

The project derives a generalized Black–Scholes-type equation for **European call and put options**, then studies two numerical approaches:

1. **PDE-based numerical solution** in MATLAB using `pdepe`, following a time-reversal and change-of-variables formulation.
2. **Stochastic numerical solution** based on a forward-backward SDE representation, Euler–Maruyama discretization, and **Least-Squares Monte Carlo (LSMC)** regression.

Numerical option values are compared against the analytical expressions presented in the report to examine approximation error and sensitivity to \(H\).

## Research objectives

- Model stock prices using geometric fractional Brownian motion.
- Derive a generalized option-pricing PDE using a fractional Itô-type formula and a portfolio-based argument.
- Simulate fBm paths with covariance-matrix construction and **Cholesky decomposition**.
- Numerically approximate European call and put prices using two approaches.
- Investigate how short- and long-range dependence changes the simulated option-price behavior.

## Mathematical formulation

The stock-price model considered in the report is

$$
S_t=S_0\exp\!\left(\mu t-\frac{\sigma^2}{2}t^{2H}+\sigma W_t^H\right),
$$

where \(W_t^H\) is fractional Brownian motion, \(\mu\) is the drift, \(\sigma\) is the volatility, and \(H\in(0,1)\) is the Hurst exponent. At \(H=1/2\), fBm reduces to standard Brownian motion; values below and above \(1/2\) correspond to negatively and positively correlated increments, respectively.

Using a transformed option-price function \(\widetilde V(t,x)\), the report derives the generalized pricing equation

$$
\frac{\partial\widetilde V}{\partial t}
+(r-\mu)\frac{\partial\widetilde V}{\partial x}
+H\sigma^2t^{2H-1}\frac{\partial^2\widetilde V}{\partial x^2}
-r\widetilde V=0,
$$

with terminal conditions corresponding to European call or put payoffs. See **Section 6 of the report** for the derivation and assumptions.

## Numerical methods

### 1. PDE solver

- Reformulates the terminal-value problem through time reversal and a spatial transformation.
- Uses MATLAB's `pdepe` to approximate the transformed PDE solution on a time-space grid.
- Recovers simulated option prices by interpolation along the fBm-driven stock-price path.
- Compares estimated prices with the analytical expression described in Section 7.1.

**Report:** Section 7; Figures 2–5; Tables 2–3.

### 2. Least-Squares Monte Carlo

- Uses the Feynman–Kac/FBSDE formulation developed in the report.
- Simulates forward paths with an Euler–Maruyama discretization.
- Estimates conditional expectations by least-squares regression on a polynomial basis.
- Works within the **\(H\geq 0.5\)** setting considered in Section 8 of the report.
- Compares the LSMC-based option valuations with the PDE-based solution.

**Report:** Section 8; Figures 7–10; Table 5.

## Selected reported results

The report presents numerical comparisons for both European calls and puts, including the following *reported relative errors*:

| Method | Option | Hurst exponent \(H\) | Reported relative error |
|---|---|---:|---:|
| PDE | Call | 0.8 | 0.0986% |
| PDE | Call | 0.3 | 28.0802% |
| PDE | Put | 0.5 | 0.0639% |
| PDE | Put | 0.3 | 12.7941% |
| LSMC | Put | 0.9 | 0.1220% |
| LSMC | Put | 0.5 | 0.5153% |

*These numbers are transcribed from Tables 2, 3, and 5 of the internship report; they are not independent reproductions.* Results depend on the method and on \(H\). The report notes increased numerical difficulties near \(t=0\), particularly when \(H<0.5\), because of the behavior of the time-dependent coefficients. The stronger errors in some regimes are important limitations rather than results to omit.

## MATLAB implementation

The appendix of the report documents routines for:

- `fbm_simulator` — fractional Brownian motion simulation via Cholesky factorization.
- `stock_price` — geometric-fBm stock-price paths.
- `option_price` — the report's analytical pricing expression.
- `fbm_solver_pde` — transformed PDE resolution with `pdepe`.
- `sde_solver` — LSMC / stochastic numerical approximation.

**Suggested repository structure** (adapt filenames to the code files you actually upload):

```text
.
├── README.md
├── report/
│   └── Research_Report.pdf
├── matlab/
│   ├── [PDE experiment script].m
│   ├── [PDE comparison script].m
│   ├── [LSMC experiment script].m
│   └── [supporting function files].m
└── figures/                 # Optional: selected output figures
```

### Running the code

1. Install MATLAB with the functionality needed by your scripts. The appendix uses `pdepe`, `normrnd`, and `normcdf`; the latter two are associated with Statistics and Machine Learning Toolbox.
2. Place the experiment scripts and their supporting functions on the MATLAB path.
3. Open an experiment script, configure `H`, the option type (`1` for call or `0` for put), grid settings, and simulation parameters.
4. Run the script to generate the relevant solution plots and numerical comparisons.

> **Reproducibility note:** The commands and filenames above are intentionally general until the original `.m` files are uploaded and checked. The scripts have **not** been executed or independently verified for this repository description. The report's appendix includes multiple experiments with differing parameter settings; refer to each script rather than assuming a single default configuration.

## Scope and limitations

- The report studies a **specific fractional Black–Scholes modeling framework** under its stated assumptions; its derivations and comparisons should not be interpreted as a general no-arbitrage validation of fBm-based financial markets.
- The LSMC formulation is investigated for \(H\geq 0.5\) in the report.
- Accuracy varies with the Hurst exponent and discretization choices, with numerical sensitivity near \(t=0\) noted in the report.
- The work is a **research internship report, not a peer-reviewed publication**.

## Research skills demonstrated

**Stochastic processes** · Fractional Brownian motion · **Stochastic calculus** · Partial differential equations · **Numerical analysis** · Feynman–Kac methods · **Monte Carlo simulation** · MATLAB · Quantitative finance

## Report and attribution

**Taha Zaoui and Sanjukta Das** (2025). *Improvising Time-Independent Black-Scholes Equation for Option Values with Fractional Brownian Motion and Numerical Resolution.* Internship research report, Department of Mathematics, Mahindra University, Hyderabad, India. **Not peer-reviewed.**

The full report contains the derivations, discussion, figures, bibliography, and original MATLAB-code appendix.

## License and reuse

No reuse license is asserted here. Before selecting a license or making the report and code public, confirm any applicable permissions and institutional or coauthor requirements.
