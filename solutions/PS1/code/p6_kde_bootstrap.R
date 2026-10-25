# Problem 6: bootstrap confidence intervals for a kernel density estimate
# Run from solutions/PS1/:  Rscript code/p6_kde_bootstrap.R

set.seed(2026)
B <- 1000; m <- 1000

# a) Bootstrap CI for f(x) from the root R_n = f_hat(x) - f(x).
# h is computed once, on the original sample, and reused in every bootstrap sample.
# hfac scales Silverman's h (hfac = 1/3 for item f).
kde_ci <- function(X, x, B = 1000, hfac = 1, level = 0.95) {
  n <- length(X)
  h <- hfac * 1.06 * sd(X) * n^(-1/5)
  k <- dnorm((X - x) / h) / h          # f_hat(x) is the mean of these n numbers
  f_hat <- mean(k)
  # Resampling X_i with replacement resamples k_i, so f*_hat(x) is the mean of the
  # resampled k's. Column b of idx holds the n draws of bootstrap sample b.
  idx <- matrix(sample.int(n, n * B, replace = TRUE), n, B)
  roots <- colMeans(matrix(k[idx], n, B)) - f_hat
  q <- quantile(roots, c((1 + level) / 2, (1 - level) / 2), names = FALSE)
  c(lo = f_hat - q[1], hi = f_hat - q[2], f_hat = f_hat, h = h)
}

coverage <- function(n, x, hfac = 1) {
  out <- t(replicate(m, kde_ci(rnorm(n), x, B, hfac)))
  f0 <- dnorm(x)
  c(n = n, x = x, hfac = hfac,
    coverage = mean(out[, "lo"] <= f0 & f0 <= out[, "hi"]),
    avg_width = mean(out[, "hi"] - out[, "lo"]),
    bias = mean(out[, "f_hat"]) - f0,
    sd = sd(out[, "f_hat"]),
    avg_h = mean(out[, "h"]))
}

res <- rbind(
  coverage(500, 0),            # b)
  coverage(500, 1),            # b)
  coverage(2000, 0),           # e)
  coverage(500, 0, hfac = 1/3) # f)
)
print(round(res, 4))

# Theory check, treating h as fixed at its population value (sigma = 1).
# With K = phi and X ~ N(0,1), E f_hat(x) is the N(0, 1 + h^2) density at x.
# sd_lead is the leading term sqrt(f R(K) / (nh)); sd_exact also keeps the -E[f_hat]^2/n term.
th <- function(n, x, hfac = 1) {
  h <- hfac * 1.06 * n^(-1/5)
  mean_f <- dnorm(x, 0, sqrt(1 + h^2))
  m2 <- integrate(function(u) dnorm(u)^2 * dnorm(x + h * u), -Inf, Inf)$value / h
  sd_exact <- sqrt((m2 - mean_f^2) / n)
  sd_lead <- sqrt(dnorm(x) / (2 * sqrt(pi)) / (n * h))
  bias <- mean_f - dnorm(x)
  c(h = h, bias = bias, bias_lead = h^2 / 2 * (x^2 - 1) * dnorm(x),
    sd_exact = sd_exact, sd_lead = sd_lead, ratio = bias / sd_exact,
    cov_normal = pnorm(1.96 - bias / sd_exact) - pnorm(-1.96 - bias / sd_exact))
}
print(round(rbind(th(500, 0), th(500, 1), th(2000, 0), th(500, 0, 1/3), th(1e8, 0)), 4))
