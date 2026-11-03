# Problem 6: IPCA and IGP-M, sample moments, autocorrelations and seasonality
# Run from solutions/PS2/:  Rscript code/p6_inflation.R

df <- read.csv("../../problem_sets/PS2/ipca_igpm.csv")
df$date <- as.Date(paste0(df$Date, "-01"))
df$month <- as.integer(format(df$date, "%m"))
cat(sprintf("Sample: %s to %s, T = %d\n", df$Date[1], df$Date[nrow(df)], nrow(df)))

# Sample moments as defined in the problem set (divide by T, not T - h)
autocov <- function(y, H = 24) {
  T <- length(y); d <- y - mean(y)
  sapply(0:H, function(h) sum(d[1:(T - h)] * d[(1 + h):T]) / T)
}

cols <- c(IPCA = "#0072BC", IGPM = "#EB811B")

# b) time-series plot
pdf("figures/p6_series.pdf", width = 8, height = 4)
par(mar = c(4, 4.2, 1, 1))
plot(df$date, df$IGPM, type = "l", col = cols["IGPM"], lwd = 1.2,
     ylim = range(df$IPCA, df$IGPM), xlab = "", ylab = "Monthly change (%)")
lines(df$date, df$IPCA, col = cols["IPCA"], lwd = 1.2)
abline(h = 0, col = "grey60")
legend("topright", bty = "n", lwd = 2, col = cols, legend = c("IPCA", "IGP-M"))
dev.off()

# c) mean, variance and autocovariances up to lag 24
g_ipca <- autocov(df$IPCA); g_igpm <- autocov(df$IGPM)
r_ipca <- g_ipca / g_ipca[1]; r_igpm <- g_igpm / g_igpm[1]
cat(sprintf("IPCA: mean %.4f, variance %.4f, sd %.4f\n", mean(df$IPCA), g_ipca[1], sqrt(g_ipca[1])))
cat(sprintf("IGPM: mean %.4f, variance %.4f, sd %.4f\n", mean(df$IGPM), g_igpm[1], sqrt(g_igpm[1])))

# d) sample ACFs; the dashed lines are +-1.96/sqrt(T), the 95% band under i.i.d. data
acf_plot <- function(r, main, col) {
  plot(1:24, r[-1], type = "h", lwd = 3, col = col, ylim = c(-0.3, 1),
       xlab = "Lag (months)", ylab = "Sample autocorrelation", main = main, xaxt = "n")
  axis(1, at = c(1, 6, 12, 18, 24))
  abline(h = 0, col = "grey40")
  abline(h = c(-1, 1) * 1.96 / sqrt(nrow(df)), lty = 2, col = "grey50")
}
pdf("figures/p6_acf.pdf", width = 8, height = 3.6)
par(mfrow = c(1, 2), mar = c(4, 4.2, 2, 1))
acf_plot(r_ipca, "IPCA", cols["IPCA"])
acf_plot(r_igpm, "IGP-M", cols["IGPM"])
dev.off()

# e)(i) average change by calendar month
s_ipca <- tapply(df$IPCA, df$month, mean)
s_igpm <- tapply(df$IGPM, df$month, mean)
pdf("figures/p6_months.pdf", width = 7, height = 3.8)
par(mar = c(4, 4.2, 1, 1))
plot(1:12, s_ipca, type = "b", pch = 16, col = cols["IPCA"], lwd = 2,
     ylim = range(0, s_ipca, s_igpm), xlab = "Calendar month", ylab = "Average monthly change (%)",
     xaxt = "n")
lines(1:12, s_igpm, type = "b", pch = 17, col = cols["IGPM"], lwd = 2)
axis(1, at = 1:12, labels = month.abb)
abline(h = c(mean(df$IPCA), mean(df$IGPM)), col = cols, lty = 3)
legend("topright", bty = "n", lwd = 2, pch = c(16, 17), col = cols, legend = c("IPCA", "IGP-M"))
dev.off()
cat("Calendar-month averages:\n")
print(round(rbind(IPCA = s_ipca, IGPM = s_igpm), 3))

# e)(iv) seasonally adjusted IPCA
z <- df$IPCA - s_ipca[df$month]
g_z <- autocov(z); r_z <- g_z / g_z[1]
cat(sprintf("z: mean %.4f, variance %.4f, sd %.4f\n", mean(z), g_z[1], sqrt(g_z[1])))
cat("Calendar-month averages of z (zero by construction):\n")
print(round(tapply(z, df$month, mean), 12))

pdf("figures/p6_acf_sa.pdf", width = 8, height = 3.6)
par(mfrow = c(1, 2), mar = c(4, 4.2, 2, 1))
acf_plot(r_ipca, "IPCA", cols["IPCA"])
acf_plot(r_z, "IPCA, seasonally adjusted", "#2D3E50")
dev.off()

# Table of autocovariances and autocorrelations, written for the solutions
tab <- data.frame(h = 0:24, g_ipca, r_ipca, g_igpm, r_igpm, g_z, r_z)
lines_tex <- sprintf("%d & $%.4f$ & $%.3f$ & $%.4f$ & $%.3f$ & $%.4f$ & $%.3f$ \\\\",
                     tab$h, tab$g_ipca, tab$r_ipca, tab$g_igpm, tab$r_igpm, tab$g_z, tab$r_z)
writeLines(lines_tex, "tables/p6_autocov.tex")
print(round(tab, 3))

# A few numbers for the discussion in f): subsample means and standard deviations
periods <- list(`1995-1999` = df$date < as.Date("2000-01-01"),
                `2000-2009` = df$date >= as.Date("2000-01-01") & df$date < as.Date("2010-01-01"),
                `2010-2019` = df$date >= as.Date("2010-01-01") & df$date < as.Date("2020-01-01"),
                `2020-2026` = df$date >= as.Date("2020-01-01"))
print(round(t(sapply(periods, function(p) c(ipca_mean = mean(df$IPCA[p]), ipca_sd = sd(df$IPCA[p]),
                                             igpm_mean = mean(df$IGPM[p]), igpm_sd = sd(df$IGPM[p])))), 3))
