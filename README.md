# Working with Stocks

This project is a basic look into using R Programming to work on stocks.<br>
Topics include: Visualizing Stocks, Daily Returns, Moving Averages, Trade Signals, Value at Risk, Portfolio, and Prediction.

Libraries used: psych, tseries, quantmod, dygraphs, reshape2, and PerformanceAnalytics

R file - [WorkingWithStocks.R](https://github.com/itsDV7/WorkingWithStocks_Project/blob/master/WorkingWithStocks.R)

```
> head(TSLA.stock)
           TSLA.Open TSLA.High TSLA.Low TSLA.Close TSLA.Volume TSLA.Adjusted
2010-06-29     3.800     5.000    3.508      4.778    93831500         4.778
2010-06-30     5.158     6.084    4.660      4.766    85935500         4.766
2010-07-01     5.000     5.184    4.054      4.392    41094000         4.392
2010-07-02     4.600     4.620    3.742      3.840    25699000         3.840
2010-07-06     4.000     4.000    3.166      3.222    34334500         3.222
2010-07-07     3.280     3.326    2.996      3.160    34608500         3.160
```
![InteractivePlot.png](https://github.com/itsDV7/WorkingWithStocks_Project/blob/master/Figures/InteractivePlot.png)

![DailyReturnPlot.png](https://github.com/itsDV7/WorkingWithStocks_Project/blob/master/Figures/DailyReturnPlot.png)

![CandleChart.png](https://github.com/itsDV7/WorkingWithStocks_Project/blob/master/Figures/CandleChart.png)

![CandleChartSMA.png](https://github.com/itsDV7/WorkingWithStocks_Project/blob/master/Figures/CandleChartSMA.png)

![CandleChartEMA.png](https://github.com/itsDV7/WorkingWithStocks_Project/blob/master/Figures/CandleChartEMA.png)

![SignalBollingerBand.png](https://github.com/itsDV7/WorkingWithStocks_Project/blob/master/Figures/SignalBollingerBand.png)

```
> head(TSLA.adj)
           TSLA.Adjusted
2010-06-29         4.778
2010-06-30         4.766
2010-07-01         4.392
2010-07-02         3.840
2010-07-06         3.222
2010-07-07         3.160
```

```
> head(TSLA.returns)
           daily.returns
2010-06-29   0.000000000
2010-06-30  -0.002511511
2010-07-01  -0.078472514
2010-07-02  -0.125683060
2010-07-06  -0.160937500
2010-07-07  -0.019242706
```

```
> skew(TSLA.returns)
[1] 0.3801534
> kurtosi(TSLA.returns)
daily.returns 
     5.904894 
```

```
> VaR(TSLA.returns, p=0.95, method = "modified")
    daily.returns
VaR   -0.04764192
> VaR(TSLA.returns, p=0.99, method = "modified")
    daily.returns
VaR    -0.1171893
> VaR(TSLA.returns, p=0.999, method = "modified")
    daily.returns
VaR    -0.2585947
```

```
> CVaR(TSLA.returns, p=0.95, method = "modified")
   daily.returns
ES   -0.05581006
> CVaR(TSLA.returns, p=0.99, method = "modified")
   daily.returns
ES    -0.1189824
> CVaR(TSLA.returns, p=0.999, method = "modified")
   daily.returns
ES    -0.2585947
```

```
"TSLA" "NIO"
> head(Portfolio.adj)
           TSLA.Adjusted NIO.Adjusted
2018-11-01        68.856         6.62
2018-11-02        69.282         6.49
2018-11-05        68.280         6.68
2018-11-06        68.212         6.40
2018-11-07        69.632         6.74
2018-11-08        70.280         6.69
```

```
> head(Portfolio.returns)
                    TSLA          NIO
2018-11-02  0.0061867518 -0.019637462
2018-11-05 -0.0144626170  0.029275809
2018-11-06 -0.0009959139 -0.041916168
2018-11-07  0.0208175400  0.053125000
2018-11-08  0.0093059938 -0.007418398
2018-11-09 -0.0025327547  0.011958146
```

```
> CVaR(Portfolio.returns, p=0.999, weights = Wts, portfolio_method = "component", method = "modified")
$MES
[1] 0.1912087

$contribution
     TSLA       NIO 
0.0537959 0.1374128 

$pct_contrib_MES
     TSLA       NIO 
0.2813465 0.7186535 
```

```
> All.VAR
           TSLA        NIO  Portfolio Type
Hist 0.05953687 0.07424276 0.05256300 Hist
Gaus 0.09817813 0.14081366 0.09535704 Gaus
Mod  0.28151073 0.41860248 0.19120867  Mod
```

![PortfolioVaR.png](https://github.com/itsDV7/WorkingWithStocks_Project/blob/master/Figures/PortfolioVaR.png)

![ContributionVaR.png](https://github.com/itsDV7/WorkingWithStocks_Project/blob/master/Figures/ContributionVaR.png)

```
> tail(TSLA.close)
           TSLA.Close
2019-12-23     83.844
2019-12-24     85.050
2019-12-26     86.188
2019-12-27     86.076
2019-12-30     82.940
2019-12-31     83.666
```

```
> head(TSLA.logDiff)
             TSLA.Close
2018-01-03 -0.010285800
2018-01-04 -0.008324561
2018-01-05  0.006210444
2018-01-08  0.060754619
2018-01-09 -0.008118221
2018-01-10  0.003320920
```

![logReturnPlot.png](https://github.com/itsDV7/WorkingWithStocks_Project/blob/master/Figures/logReturnPlot.png)

```
> adf.test(TSLA.logDiff)

	Augmented Dickey-Fuller Test

data:  TSLA.logDiff
Dickey-Fuller = -7.7407, Lag order = 7, p-value = 0.01
alternative hypothesis: stationary
```

![autocorrPlot.png](https://github.com/itsDV7/WorkingWithStocks_Project/blob/master/Figures/autocorrPlot.png)

![partialautocorrPlot.png](https://github.com/itsDV7/WorkingWithStocks_Project/blob/master/Figures/partialautocorrPlot.png)

![ArimaForecast.png](https://github.com/itsDV7/WorkingWithStocks_Project/blob/master/Figures/ArimaForecast.png)

```
> summary(fit)

Call:
arima(x = stock_train, order = c(2, 0, 2), include.mean = FALSE)

Coefficients:
          ar1      ar2     ma1   ma2
      -0.3612  -0.9866  0.3435  1.00
s.e.   0.0107   0.0101  0.0095  0.01

sigma^2 estimated as 0.00112:  log likelihood = 989.26,  aic = -1968.52

Training set error measures:
                       ME       RMSE        MAE      MPE     MAPE     MASE
Training set 0.0005143513 0.03346495 0.02356299 101.2978 118.9419 0.673982
                    ACF1
Training set -0.02431075
```

```
> summary(arima.forecast)

Forecast method: ARIMA(2,0,2) with zero mean

Model Information:

Call:
arima(x = stock_train, order = c(2, 0, 2), include.mean = FALSE)

Coefficients:
          ar1      ar2     ma1   ma2
      -0.3612  -0.9866  0.3435  1.00
s.e.   0.0107   0.0101  0.0095  0.01

sigma^2 estimated as 0.00112:  log likelihood = 989.26,  aic = -1968.52

Error measures:
                       ME       RMSE        MAE      MPE     MAPE     MASE
Training set 0.0005143513 0.03346495 0.02356299 101.2978 118.9419 0.673982
                    ACF1
Training set -0.02431075

Forecasts:
    Point Forecast       Lo 99      Hi 99
502   9.109431e-05 -0.08625447 0.08643666
```

![ActualvsForecast.png](https://github.com/itsDV7/WorkingWithStocks_Project/blob/master/Figures/ActualvsForecast.png)

```
> print(comparsion)
           Actual_series    Forecasted Accuracy
2019-12-06   0.016570547  8.402938e-04        1
2019-12-09   0.010778539 -1.047080e-03        0
2019-12-10   0.027051057 -1.481987e-03        0
2019-12-11   0.011004516  6.652523e-04        1
2019-12-12   0.019596854  2.690323e-04        1
2019-12-13  -0.003592913 -1.995074e-03        1
2019-12-16   0.062489097  3.182951e-04        1
2019-12-17  -0.006601110 -2.439017e-04        1
2019-12-18   0.036681400  4.308264e-04        1
2019-12-19   0.027322690 -5.120081e-04        0
2019-12-20   0.003828877 -5.051159e-04        0
2019-12-23   0.033053118  7.187943e-04        1
2019-12-24   0.014281401 -4.252729e-04        0
2019-12-26   0.013291649 -1.992423e-04        0
2019-12-27  -0.001300423  3.886106e-04        0
2019-12-30  -0.037113102  5.718788e-04        0
2019-12-31   0.008715203  9.109431e-05        1
```

```
> print(Accuracy_percentage)
[1] 52.94118
```
