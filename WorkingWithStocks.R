suppressPackageStartupMessages(library(psych))
suppressPackageStartupMessages(library(tseries))
suppressPackageStartupMessages(library(quantmod))
suppressPackageStartupMessages(library(dygraphs))
suppressPackageStartupMessages(library(reshape2))
suppressPackageStartupMessages(library(PerformanceAnalytics))

# Data
TSLA.stock <- getSymbols("TSLA", auto.assign = FALSE)
head(TSLA.stock)

# Visualizing Variation in Stock Volume with Time
TSLA.variationGraph <- dygraph(TSLA.stock,main = "Tesla Stock Variation") %>%
    dyOptions(labelsUTC = TRUE, fillGraph = TRUE, fillAlpha = 0.5, drawGrid = FALSE, colors = "#E82127") %>%
    dyRangeSelector(strokeColor = "#E82127", fillColor = "") %>%
    dyCrosshair(direction = "vertical") %>%
    dyHighlight(highlightCircleSize = 3, highlightSeriesBackgroundAlpha = 0.2, hideOnMouseOut = TRUE) %>%
    dyRoller(rollPeriod = 100)
TSLA.variationGraph

# Daily Return of last 30 days of a Stock
TSLA.stock$dailyReturns <- dailyReturn(TSLA.stock, type = "arithmetic")
plot(tail(TSLA.stock[,"dailyReturns"],30), main = "Daily Returns")

# Technical Analysis - The studying of trends in the Share Price
TSLA.candleChart <- candleChart(TSLA.stock, theme="white",up.col="blue",dn.col="red", subset = "2020-07-01/")

# Moving Average - A technical indicator that smooths out price trends by filtering "noise" from random short term price fluctuations.
# Time frame for MA is called "look back period" the shorter the time span used to create the average, the more sensitive it will be to price changes.
# An MA with short time frame reacts much quicker to price changes than long time frame

# SMA - Simple Moving Average
# arithmetic mean of given set of prices over a specified number of days in the past
addSMA(n=10, col="navy")
addSMA(n=50, col="cyan")
addSMA(n=100,col="maroon")

# EMA - Exponential Moving Average
# weighted average which puts more emphasis to new information
TSLA.candleChart <- candleChart(TSLA.stock, theme="white",up.col="blue",dn.col="red", subset = "2020-07-01/")
addEMA(n=10, col="navy")
addEMA(n=50, col="cyan")
addEMA(n=100,col="maroon")

# Trade Signals
# When the short term moving average crosses above the long term moving average, this indicates a buy signal.
# When the short term moving average crosses below the long term moving average, it may be a good moment to sell.

# Bollinger Bands
# Bollinger bands help determine whether prices are high or low on a relative basis.
# Buy when price above the band and sell when price below the band.
TSLA.chartSeries <- chartSeries(TSLA.stock, subset='2020-07-01/', theme='white')
addBBands(n=50, sd=2)

# Value at Risk
TSLA.adj <- Ad(TSLA.stock)
head(TSLA.adj)
TSLA.returns <- dailyReturn(TSLA.adj)
head(TSLA.returns)
#  If your return series is skewed and/or has excess kurtosis, Cornish-Fisher estimates of VaR can be more appropriate.
skew(TSLA.returns)
kurtosi(TSLA.returns)

# The VaR at a probability level p is the p-quantile of the negative returns, or equivalently,
# is the negative value of the c=1-p quantile of the returns.

VaR(TSLA.returns, p=0.95, method = "modified")
VaR(TSLA.returns, p=0.99, method = "modified")
VaR(TSLA.returns, p=0.999, method = "modified")

#Conditional Value at Risk
# Calculates Expected Shortfall(ES) (also known as) Conditional Value at Risk(CVaR) or Expected Tail Loss (ETL) for univariate,
# component, and marginal cases using a variety of analytical methods.

CVaR(TSLA.returns, p=0.95, method = "modified")
CVaR(TSLA.returns, p=0.99, method = "modified")
CVaR(TSLA.returns, p=0.999, method = "modified")

#Portfolio
Tickers <- c("TSLA","NIO")
Wts <- c(0.5,0.5)
getSymbols(Tickers, from="2018-11-01")
Portfolio.adj <- merge(Ad(TSLA),Ad(NIO))
head(Portfolio.adj)
Portfolio.returns <- ROC(Portfolio.adj, type = "discrete")[-1,]
colnames(Portfolio.returns) <- c("TSLA","NIO")
head(Portfolio.returns)
CVaR(Portfolio.returns, p=0.999, weights = Wts, portfolio_method = "component", method = "modified")

# Visualizing Portfolio
PortHist <- VaR(Portfolio.returns, p=0.95, weights = NULL, portfolio_method = "single", method = "historical")
PortGaus <- VaR(Portfolio.returns, p=0.99, weights = NULL, portfolio_method = "single", method = "gaussian")
PortMod <- VaR(Portfolio.returns, p=0.999, weights = NULL, portfolio_method = "single", method = "modified")
PortHist.all <- VaR(Portfolio.returns, p=0.95, weights = Wts, portfolio_method = "component", method = "historical")
PortGaus.all <- VaR(Portfolio.returns, p=0.99, weights = Wts, portfolio_method = "component", method = "gaussian")
PortMod.all <- VaR(Portfolio.returns, p=0.999, weights = Wts, portfolio_method = "component", method = "modified")

All.VAR <- data.frame(rbind(PortHist,PortGaus,PortMod))
All.VAR$Portfolio <- 0
All.VAR$Portfolio <- c(PortHist.all$hVaR,PortGaus.all$VaR,PortMod.all$MVaR)
All.VAR <- abs(All.VAR)
All.VAR$Type <- c("Hist","Gaus","Mod")
rownames(All.VAR) <- c("Hist","Gaus","Mod")
All.VAR

# VaR of Each stock and complete portfolio with respect to different types of calculations.
Plot.VAR <- melt(All.VAR, id.vars = "Type", variable.name = "Ticker", value.name = "VaR")

ggplot(Plot.VAR, aes(x = Type, y = VaR, fill = Ticker))+
  geom_bar(stat = "identity", position = "dodge")

# Percent contribution of each stock in VaR of portfolio.
All.pct_contrib <- data.frame(rbind(PortHist.all$pct_contrib_hVaR,
                                    PortGaus.all$pct_contrib_VaR,
                                    PortMod.all$pct_contrib_MVaR))
rownames(All.pct_contrib) <- c("Hist","Gaus","Mod")
All.pct_contrib$Type <- c("Hist","Gaus","Mod")

Plot.pct_contrib <- melt(All.pct_contrib, variable.name = "Ticker", 
                         value.name = "%Contibution")
Plot.VAR$VaR <- as.factor(Plot.VAR$VaR)
Plot.VAR <- Plot.VAR[c(-7,-8,-9),]
ggplot(Plot.VAR, aes(x = Type, y = Plot.pct_contrib$`%Contibution`, 
                     colour = Ticker, size = 3))+
  geom_bar(stat = "identity", aes(fill = VaR))+
  scale_fill_grey()+
  scale_y_continuous(labels = scales::percent)+
  xlab("Type of VaR Used")+ylab("% Contribution in Portfolio")+
  ggtitle("VaR vs %Contribution to Portfolio")

# Predict future stock behavior
TSLA.stock <- getSymbols("TSLA",from = "2018-01-01", to = "2020-01-01", auto.assign = FALSE)
TSLA.close <- Cl(TSLA.stock)
tail(TSLA.close)
TSLA.logDiff <- diff(log(TSLA.close), lag=1)[-1,]
head(TSLA.logDiff)

# Visualize log returns
plot(TSLA.logDiff, type = 'l', main = 'log returns plot')

# Augmented Dickey-Fuller Test
adf.test(TSLA.logDiff)

# Breakpoint
TSLA.breakpoint <- floor(nrow(TSLA.logDiff)*(2.9/3))

# The function acf computes (and by default plots) estimates of the autocovariance or autocorrelation function.
# Function pacf is the function used for the partial autocorrelations.
TSLA.logDiff.acf <- acf(TSLA.logDiff[c(1:TSLA.breakpoint),], main='ACF Plot', lag.max=100)
TSLA.logDiff.pacf <- pacf(TSLA.logDiff[c(1:TSLA.breakpoint),], main='PACF Plot', lag.max=100)

# Initialzing an xts object for Actual log returns
Actual_series = xts(0,as.Date("2014-11-25","%Y-%m-%d"))

# Initialzing a dataframe for the forecasted return series
forecasted_series = data.frame(Forecasted = numeric())

# Prediction using ARIMA model
for (b in TSLA.breakpoint:(nrow(TSLA.logDiff)-1)) {
  stock_train <- TSLA.logDiff[1:b, ]
  stock_test <- TSLA.logDiff[(b+1):nrow(TSLA.logDiff), ]
  fit <- arima(stock_train, order = c(2, 0, 2),include.mean=FALSE)
  acf(fit$residuals,main="Residuals plot")
  arima.forecast <- forecast(fit, h = 1,level=99)
  par(mfrow=c(1,1))
  plot(arima.forecast, main = "ARIMA Forecast")
  forecasted_series <- rbind(forecasted_series,arima.forecast$mean[1])
  colnames(forecasted_series) <- c("Forecasted")
  Actual_return <- TSLA.logDiff[(b+1),]
  Actual_series <- c(Actual_series,xts(Actual_return))
  rm(Actual_return)
}
summary(fit)
summary(arima.forecast)

# Visualizing the difference between Actual and forecasted returns of Tesla
Actual_series = Actual_series[-1]
forecasted_series = xts(forecasted_series,index(Actual_series))
plot(Actual_series,type='l',main='Actual Returns Vs Forecasted Returns')
lines(forecasted_series,lwd=1.5,col='red')
legend("bottomleft", legend = c("Actual","Forecasted"), lty= 1:2,col=c('blue','red'), cex = 0.8)

# Table for the accuracy of the forecast
comparsion = merge(Actual_series,forecasted_series)
comparsion$Accuracy = sign(comparsion$Actual_series)==sign(comparsion$Forecasted)
print(comparsion)

# Accuracy percentage metric
Accuracy_percentage = sum(comparsion$Accuracy == 1)*100/length(comparsion$Accuracy)
print(Accuracy_percentage)
