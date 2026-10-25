# Problem 3: Nadaraya-Watson estimate of P(applied = 1 | offer4 = x)
# Run from solutions/PS1/:  Rscript code/p3_karlan.R

df <- read.csv("../../problem_sets/PS1/karlan.csv")
Y <- df$applied
X <- df$offer4
n <- length(X)

# Bandwidths: Silverman's rule, a much smaller one and a much larger one
hS <- 1.06 * sd(X) * n^(-1/5)
H  <- c(small = hS / 5, silverman = hS, large = 5 * hS)
cat(sprintf("n = %d, sd(offer4) = %.3f, h_S = %.3f\n", n, sd(X), hS))

# Both kernels have unit variance (as in lecture 1), so a given h means the same
# amount of smoothing for both
k_gauss <- function(u) dnorm(u)
k_epan  <- function(u) ifelse(abs(u) < sqrt(5), 3 / (4 * sqrt(5)) * (1 - u^2 / 5), 0)

nw <- function(grid, X, Y, h, K) {
  sapply(grid, function(x) {
    w <- K((X - x) / h)
    if (sum(w) == 0) return(NA_real_)
    sum(w * Y) / sum(w)
  })
}

grid <- seq(min(X), max(X), length.out = 300)

# Raw frequencies at each distinct offered rate, to put on the plots
cells <- aggregate(applied ~ offer4, data = df, FUN = mean)
cells$n <- as.vector(table(df$offer4))

cols <- c("#2E7D32", "#0072BC", "#EB811B")
plot_kernel <- function(K, main, file) {
  est <- sapply(H, function(h) nw(grid, X, Y, h, K))
  pdf(file, width = 7, height = 4.5)
  par(mar = c(4.2, 4.2, 2, 1))
  plot(cells$offer4, cells$applied, pch = 16, col = "grey70",
       cex = 0.4 + 1.6 * sqrt(cells$n / max(cells$n)),
       ylim = c(0, 0.2), xlab = "offer4 (offered interest rate, %)",
       ylab = "P(applied = 1 | offer4 = x)", main = main)
  matlines(grid, est, lty = 1, lwd = 2, col = cols)
  legend("bottomleft", bty = "n", lwd = 2, col = c(cols, NA), pch = c(NA, NA, NA, 16),
         legend = c(sprintf("h = h_S / 5 = %.2f", H[1]), sprintf("h = h_S = %.2f", H[2]),
                    sprintf("h = 5 h_S = %.2f", H[3]), "raw share at each rate"))
  dev.off()
  est
}

est_g <- plot_kernel(k_gauss, "Gaussian kernel", "figures/p3_gaussian.pdf")
est_e <- plot_kernel(k_epan, "Epanechnikov kernel", "figures/p3_epanechnikov.pdf")

# A few numbers quoted in the solutions
at <- c(4, 8, 12)
idx <- sapply(at, function(a) which.min(abs(grid - a)))
tab <- rbind(gauss = round(est_g[idx, 2], 3), epan = round(est_e[idx, 2], 3))
colnames(tab) <- paste0("x=", at)
print(tab)
cat(sprintf("max |gauss - epan| at h_S: %.4f\n", max(abs(est_g[, 2] - est_e[, 2]), na.rm = TRUE)))
cat(sprintf("max |gauss - epan| at h_S/5: %.4f\n", max(abs(est_g[, 1] - est_e[, 1]), na.rm = TRUE)))
cat(sprintf("NA count Epanechnikov small h: %d\n", sum(is.na(est_e[, 1]))))
