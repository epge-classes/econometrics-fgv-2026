# Problem 7: the i.i.d. and the circular block bootstrap for the mean of an AR(1)
# Run from solutions/PS2/:  Rscript code/p7_block_bootstrap.R

set.seed(2026)

# b)(iv)-(v): limiting coverage of the i.i.d. bootstrap interval
phis <- c(-0.5, 0, 0.5, 0.9)
cov_formula <- 2 * pnorm(1.96 * sqrt((1 - phis) / (1 + phis))) - 1
names(cov_formula) <- phis
cat("Limiting coverage of the i.i.d. bootstrap interval:\n"); print(round(cov_formula, 4))

# Stationary AR(1): y_1 from the stationary distribution, the rest recursively
sim_ar1 <- function(T, phi, mu = 0, sigma = 1) {
  nu <- mu / (1 - phi)
  y <- numeric(T)
  y[1] <- rnorm(1, nu, sigma / sqrt(1 - phi^2))
  e <- rnorm(T, 0, sigma)
  for (t in 2:T) y[t] <- mu + phi * y[t - 1] + e[t]
  y
}

# Circular block bootstrap draws of the sample mean (b = 1 is the i.i.d. bootstrap).
# Each column of idx is one bootstrap sample: k blocks of length b, first T kept.
cbb_means <- function(y, b, B) {
  T <- length(y); k <- ceiling(T / b)
  starts <- sample.int(T, k * B, replace = TRUE)
  idx <- rep(starts, each = b) + rep(0:(b - 1), times = k * B)   # block j: I_j, ..., I_j + b - 1
  idx <- (idx - 1) %% T + 1                                        # circular extension
  idx <- matrix(idx, nrow = k * b, ncol = B)[1:T, , drop = FALSE]
  colMeans(matrix(y[idx], nrow = T, ncol = B))
}

# Interval from the root R* = ybar* - ybar, with quantiles from the empirical cdf L_T
cbb_ci <- function(y, b, B, level = 0.95) {
  ybar <- mean(y)
  roots <- cbb_means(y, b, B) - ybar
  q <- quantile(roots, c((1 + level) / 2, (1 - level) / 2), type = 1, names = FALSE)
  c(lo = ybar - q[1], hi = ybar - q[2])
}

# c) and e)(iv): the same M samples for every block length
T <- 200; M <- 500; B <- 499
bs <- c(1, 2, 3, 5, 10, 20, 30, 50, 75, 100)
res <- expand.grid(b = bs, phi = phis)
res$coverage <- NA; res$width <- NA
for (phi in phis) {
  Y <- replicate(M, sim_ar1(T, phi))                 # T x M, nu = 0
  for (b in bs) {
    ci <- apply(Y, 2, cbb_ci, b = b, B = B)
    i <- res$phi == phi & res$b == b
    res$coverage[i] <- mean(ci["lo", ] <= 0 & 0 <= ci["hi", ])
    res$width[i] <- mean(ci["hi", ] - ci["lo", ])
  }
}
saveRDS(res, "tables/p7_sim.rds")

cat("\nc) i.i.d. bootstrap (b = 1):\n")
c_tab <- res[res$b == 1, c("phi", "coverage", "width")]
c_tab$formula <- cov_formula[as.character(c_tab$phi)]
c_tab$true_width <- 2 * 1.96 * sqrt(1 / (1 - c_tab$phi)^2 / T)   # width with the right variance
print(round(c_tab, 3))

cat("\ne)(iv) coverage by block length:\n")
cov_tab <- reshape(res[, c("phi", "b", "coverage")], idvar = "phi", timevar = "b", direction = "wide")
print(cov_tab, row.names = FALSE)
cat("\nAverage width by block length:\n")
wid_tab <- reshape(res[, c("phi", "b", "width")], idvar = "phi", timevar = "b", direction = "wide")
print(round(wid_tab, 3), row.names = FALSE)

# Bootstrap-world variance of sqrt(T) ybar* relative to omega^2, using population
# autocovariances: sum_{|h|<b} (1 - |h|/b) phi^|h| over (1 + phi)/(1 - phi)
ratio <- function(b, phi) {
  h <- -(b - 1):(b - 1)
  sum((1 - abs(h) / b) * phi^abs(h)) / ((1 + phi) / (1 - phi))
}
cat("\nVariance ratio sum_{|h|<b}(1-|h|/b)gamma_h / omega^2:\n")
print(round(sapply(bs, function(b) sapply(c(-0.5, 0.5, 0.9), ratio, b = b)), 3))

# Table for the solutions (phi = -0.5, 0.5, 0.9)
lines_tex <- sapply(c(-0.5, 0.5, 0.9), function(phi) {
  r <- res[res$phi == phi, ]
  paste0("$", phi, "$ & ", paste(sprintf("%.3f", r$coverage), collapse = " & "), " \\\\")
})
writeLines(lines_tex, "tables/p7_coverage.tex")

cols <- c("-0.5" = "#2E7D32", "0.5" = "#0072BC", "0.9" = "#EB811B")
pdf("figures/p7_coverage_width.pdf", width = 9, height = 3.8)
par(mfrow = c(1, 2), mar = c(4, 4.2, 1, 1))
plot(NA, xlim = range(bs), ylim = c(0.3, 1), log = "x", xlab = "Block length b (log scale)",
     ylab = "Coverage", xaxt = "n")
axis(1, at = bs)
abline(h = 0.95, lty = 2, col = "#C62828")
for (phi in c(-0.5, 0.5, 0.9)) {
  r <- res[res$phi == phi, ]
  lines(r$b, r$coverage, type = "b", pch = 16, lwd = 2, col = cols[as.character(phi)])
}
legend("bottomright", bty = "n", lwd = 2, pch = 16, col = cols,
       legend = paste("phi =", names(cols)))
# Dotted lines: width of an interval with the correct long-run variance, 2 * 1.96 * omega / sqrt(T)
plot(NA, xlim = range(bs), ylim = c(0, 1.1 * 2 * 1.96 * 10 / sqrt(T)), log = "x",
     xlab = "Block length b (log scale)", ylab = "Average width", xaxt = "n")
axis(1, at = bs)
for (phi in c(-0.5, 0.5, 0.9)) {
  r <- res[res$phi == phi, ]
  lines(r$b, r$width, type = "b", pch = 16, lwd = 2, col = cols[as.character(phi)])
  abline(h = 2 * 1.96 / (1 - phi) / sqrt(T), lty = 3, col = cols[as.character(phi)])
}
dev.off()

# d) IPCA: the i.i.d. bootstrap erases time
df <- read.csv("../../problem_sets/PS2/ipca_igpm.csv")
df$date <- as.Date(paste0(df$Date, "-01"))
y <- df$IPCA; Tn <- length(y)
rho1 <- function(x) { d <- x - mean(x); sum(d[-1] * d[-length(d)]) / sum(d^2) }

y_star <- sample(y, Tn, replace = TRUE)
pdf("figures/p7_iid_sample.pdf", width = 8, height = 5)
par(mfrow = c(2, 1), mar = c(2.5, 4.2, 1.5, 1))
plot(df$date, y, type = "l", col = "#0072BC", lwd = 1.2, ylim = range(y, y_star),
     xlab = "", ylab = "Monthly IPCA (%)", main = "Data")
plot(df$date, y_star, type = "l", col = "#EB811B", lwd = 1.2, ylim = range(y, y_star),
     xlab = "", ylab = "Monthly IPCA (%)", main = "One i.i.d. bootstrap sample")
dev.off()

rho_star <- replicate(999, rho1(sample(y, Tn, replace = TRUE)))
cat(sprintf("\nd) IPCA rho_1 = %.3f; bootstrap rho*_1: mean %.4f, sd %.4f, max %.3f\n",
            rho1(y), mean(rho_star), sd(rho_star), max(rho_star)))
pdf("figures/p7_rho_star.pdf", width = 7, height = 3.6)
par(mar = c(4, 4.2, 1, 1))
hist(rho_star, breaks = 40, col = "grey80", border = "white", xlim = c(-0.25, 0.75),
     xlab = expression(hat(rho)[1]^"*"), main = "")
abline(v = rho1(y), col = "#C62828", lwd = 2)
legend("topright", bty = "n", lwd = 2, col = "#C62828", legend = "data")
dev.off()

# f) Circular block bootstrap intervals for the mean of monthly IPCA
bs_ipca <- c(1, 3, 6, 12, 24, 48, 96)
ci_ipca <- t(sapply(bs_ipca, function(b) cbb_ci(y, b, 999)))
ci_ipca <- data.frame(b = bs_ipca, ci_ipca, width = ci_ipca[, "hi"] - ci_ipca[, "lo"])
ci_ipca$rel_width <- ci_ipca$width / ci_ipca$width[1]
cat(sprintf("\nf) IPCA mean = %.4f, T = %d\n", mean(y), Tn))
print(round(ci_ipca, 4))
writeLines(sprintf("%d & [%.3f,\\ %.3f] & %.3f & %.2f \\\\", ci_ipca$b, ci_ipca$lo, ci_ipca$hi,
                   ci_ipca$width, ci_ipca$rel_width), "tables/p7_ipca.tex")
