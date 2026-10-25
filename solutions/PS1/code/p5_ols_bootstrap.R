# Problem 5: OLS under heteroskedasticity, three confidence intervals for beta
# Run from solutions/PS1/:  Rscript code/p5_ols_bootstrap.R

set.seed(2026)
alpha <- 2; beta <- 5; n <- 100; B <- 1000; m <- 500

# x ~ N(0, 3) with 3 the variance; eps | x ~ N(0, 2 + x^2)
simulate <- function(n) {
  x <- rnorm(n, 0, sqrt(3))
  y <- alpha + beta * x + rnorm(n, 0, sqrt(2 + x^2))
  data.frame(x = x, y = y)
}

ols <- function(x, y) {
  Xm <- cbind(1, x)
  XtXi <- solve(crossprod(Xm))
  b <- XtXi %*% crossprod(Xm, y)
  list(b = drop(b), e = drop(y - Xm %*% b), Xm = Xm, XtXi = XtXi)
}

# Receives a sample and returns the estimates and the three 95% intervals for beta
three_cis <- function(d, B = 1000) {
  fit <- ols(d$x, d$y)
  n <- nrow(d); k <- 2
  se_ols <- sqrt(sum(fit$e^2) / (n - k) * fit$XtXi[2, 2])
  meat <- crossprod(fit$Xm * fit$e)                 # sum of e_i^2 x_i x_i'
  se_hc <- sqrt((fit$XtXi %*% meat %*% fit$XtXi)[2, 2] * n / (n - k))   # HC1
  b_star <- replicate(B, {                          # pairs (nonparametric) bootstrap
    i <- sample.int(n, n, replace = TRUE)
    ols(d$x[i], d$y[i])$b[2]
  })
  se_bs <- sd(b_star)
  z <- qnorm(0.975)
  se <- c(ols = se_ols, robust = se_hc, bootstrap = se_bs)
  list(b = fit$b, se = se,
       lo = fit$b[2] - z * se, hi = fit$b[2] + z * se, b_star = b_star)
}

# b)-d) one sample
d <- simulate(n)
res <- three_cis(d, B)

pdf("figures/p5_scatter.pdf", width = 6, height = 4.2)
par(mar = c(4.2, 4.2, 1, 1))
plot(d$x, d$y, pch = 16, col = "#2D3E50AA", xlab = "x", ylab = "y")
abline(alpha, beta, col = "#C62828", lwd = 2, lty = 2)
abline(res$b[1], res$b[2], col = "#0072BC", lwd = 2)
legend("topleft", bty = "n", lwd = 2, lty = c(2, 1), col = c("#C62828", "#0072BC"),
       legend = c("true line: 2 + 5x", "OLS fit"))
dev.off()

pdf("figures/p5_bootstrap_hist.pdf", width = 6, height = 4.2)
par(mar = c(4.2, 4.2, 1, 1))
hist(res$b_star, breaks = 40, col = "grey80", border = "white", freq = FALSE,
     xlab = expression(hat(beta)^"*"), main = "")
abline(v = res$b[2], col = "#0072BC", lwd = 2)
abline(v = beta, col = "#C62828", lwd = 2, lty = 2)
legend("topright", bty = "n", lwd = 2, lty = c(1, 2), col = c("#0072BC", "#C62828"),
       legend = c("OLS estimate", "true beta"))
dev.off()

cat(sprintf("alpha_hat = %.3f, beta_hat = %.3f\n", res$b[1], res$b[2]))
print(round(cbind(se = res$se, lo = res$lo, hi = res$hi), 3))

# e) coverage over m = 500 samples
cover <- t(replicate(m, {
  r <- three_cis(simulate(n), B)
  c(cov = (r$lo <= beta & beta <= r$hi), len = r$hi - r$lo)
}))
cat("Coverage and average length over", m, "samples:\n")
print(round(colMeans(cover), 3))
