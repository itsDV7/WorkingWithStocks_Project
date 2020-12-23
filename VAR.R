#Library
library(quantmod)
library(PerformanceAnalytics)
library(ggplot2)
library(psych)
library(reshape2)

#Data
TSLA.adj <- Ad(getSymbols("TSLA", auto.assign = F))
head(TSLA.adj)
TSLA.returns <- dailyReturn(TSLA.adj)
head(TSLA.returns)
skew(TSLA.returns)
kurtosi(TSLA.returns)

#Value at Risk
VaR(TSLA.returns, p=0.95, method = "modified")
VaR(TSLA.returns, p=0.99, method = "modified")
VaR(TSLA.returns, p=0.999, method = "modified")
#Cornish-Fisher VaR

#Conditional Value at Risk
CVaR(TSLA.returns, p=0.95, method = "modified")
CVaR(TSLA.returns, p=0.99, method = "modified")
CVaR(TSLA.returns, p=0.999, method = "modified")
#ES -> Estimated Shortfall

#Portfolio
Tickers <- c("TSLA","NIO")
Wts <- c(0.5,0.5)
getSymbols(Tickers, from="2018-11-01")
Portfolio.adj <- merge(Ad(TSLA),Ad(NIO))
head(Portfolio.adj)
Portfolio.returns <- ROC(Portfolio.adj, type = "discrete")[-1,]
colnames(Portfolio.returns) <- c("TSLA","NIO")
head(Portfolio.returns)

PortHist <- VaR(Portfolio.returns, p=0.95, weights = NULL, portfolio_method = "single", method = "historical")
PortGaus <- VaR(Portfolio.returns, p=0.99, weights = NULL, portfolio_method = "single", method = "gaussian")
PortMod <- VaR(Portfolio.returns, p=0.999, weights = NULL, portfolio_method = "single", method = "modified")
PortHist.all <- VaR(Portfolio.returns, p=0.95, weights = Wts, portfolio_method = "component", method = "historical")
PortGaus.all <- VaR(Portfolio.returns, p=0.99, weights = Wts, portfolio_method = "component", method = "gaussian")
PortMod.all <- VaR(Portfolio.returns, p=0.999, weights = Wts, portfolio_method = "component", method = "modified")

CVaR(Portfolio.returns, p=0.95, weights = Wts, portfolio_method = "component", method = "modified")
CVaR(Portfolio.returns, p=0.99, weights = Wts, portfolio_method = "component", method = "modified")
CVaR(Portfolio.returns, p=0.999, weights = Wts, portfolio_method = "component", method = "modified")
VaR(Portfolio.returns, p=0.999, weights = Wts, portfolio_method = "component", method = "modified")

#Plot
ggplot(data = TSLA.returns,aes(x = index(TSLA.returns),y = TSLA.returns))+
  geom_line(colour = "deepskyblue")+
  ggtitle("TSLA Daily Returns")+
  xlab("Date")+ylab("TSLA Returns")+
  scale_x_date(date_labels = "%b %Y", date_breaks = "12 months")

TSLA.returns2020 <- subset(TSLA.returns,index(TSLA.returns) > "2020-01-01")
ggplot(data = TSLA.returns2020,aes(x = index(TSLA.returns2020),y = TSLA.returns2020))+
  geom_line(colour = "red")+
  ggtitle("TSLA Daily Returns 2020")+
  xlab("Month")+ylab("TSLA Returns 2020")+
  scale_x_date(date_labels = "%b", date_breaks = "1 months")

All.VAR <- data.frame(rbind(PortHist,PortGaus,PortMod))
All.VAR$Portfolio <- 0
All.VAR$Portfolio <- c(PortHist.all$hVaR,PortGaus.all$VaR,PortMod.all$MVaR)
All.VAR <- abs(All.VAR)
All.VAR$Type <- c("Hist","Gaus","Mod")
rownames(All.VAR) <- c("Hist","Gaus","Mod")

Plot.VAR <- melt(All.VAR, id.vars = "Type", variable.name = "Ticker", value.name = "VaR")
ggplot(Plot.VAR, aes(x = Type, y = VaR, fill = Ticker))+
  geom_bar(stat = "identity", position = "dodge")

All.pct_contrib <- data.frame(rbind(PortHist.all$pct_contrib_hVaR,PortGaus.all$pct_contrib_VaR,PortMod.all$pct_contrib_MVaR))
rownames(All.pct_contrib) <- c("Hist","Gaus","Mod")
All.pct_contrib$Type <- c("Hist","Gaus","Mod")

Plot.pct_contrib <- melt(All.pct_contrib, variable.name = "Ticker", value.name = "%Contibution")
Plot.VAR$VaR <- as.factor(Plot.VAR$VaR)
Plot.VAR <- Plot.VAR[c(-7,-8,-9),]
ggplot(Plot.VAR, aes(x = Type, y = Plot.pct_contrib$`%Contibution`, colour = Ticker, size = 3))+
  geom_bar(stat = "identity", aes(fill = VaR))+
  scale_fill_grey()+
  scale_y_continuous(labels = scales::percent)+
  xlab("Type of VaR Used")+ylab("% Contribution in Portfolio")+
  ggtitle("VaR vs %Contribution to Portfolio")
