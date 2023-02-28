##
## 'Calculate the case fatality rate (CFR) for COVID-19 in South Africa
##' this code plots the epicurve based on the 

# Clear the global environment
rm(list=ls())

## import required packages
require(data.table)

# import data
cfr_date = fread('data/owid-rsa.csv')
#owid_rsa = d[iso_code=='ZAF',]

# some data wrangling
cfr_date$cfr <-  cfr_date$new_deaths_smoothed_per_million/cfr_date$new_cases_smoothed_per_million

# plot a graph containing the reported cases, reported deaths and CFR
png('data/Rplot.png', width=2400, height=1600, res=240)
par(mfrow=c(3,1), mar=c(2,4,1,1))
plot(cfr_date$date, cfr_date$new_cases_per_million, type='l', xlab='Date', ylab='Reported cases')
lines(cfr_date$date, cfr_date$new_cases_smoothed_per_million, type='l', col='red')
plot(cfr_date$date, cfr_date$new_deaths_per_million, type='l', xlab='Date', ylab='Reported deaths')
lines(cfr_date$date, cfr_date$new_deaths_smoothed_per_million, type='l', col='red')
#plot(d$date, d$new_deaths_smoothed_per_million/d$new_cases_smoothed_per_million, type='l', xlab='Date', ylab='CFR')
plot(cfr_date$date, cfr_date$cfr, type='l', xlab='Date', ylab='CFR')
dev.off()

# add a lag to the CFR
death_lag <- 15
cfr_date$cfr_lagged <- NA
cfr_date$cfr_lagged[-c(1:death_lag)] <- tail(cfr_date$new_deaths_smoothed_per_million, -death_lag)/
  head(cfr_date$new_cases_smoothed_per_million, -death_lag)

# plot the CFR with the added lag
png('output/Rplot1.png', width=2400, height=500, res=150)
plot(cfr_date$date, cfr_date$cfr_lagged, type='l', xlab='Date', ylab='CFR with lag')
dev.off()

# create a function that takes in the data, lag and maximum lag (max_lag)
# and prints the cfr with the maximum lag
plot_lagged_cfr <- function(data, lag, max_lag) {
    xaxt = ifelse(lag==max_lag,'s','n')
    xlim=c(data$date[max_lag+1], tail(data$date,1))
    cfr_lagged = tail(data$new_deaths_smoothed_per_million, -lag)/head(data$new_cases_smoothed_per_million, -lag)
    print(xlim)
    print(data$date[lag+1])
    plot(data$date[-c(1:lag)], cfr_lagged, type='l', xlab='Case report date', ylab=paste0('CFR (lag = ',lag,')'), ylim=c(0.0, 0.4), xaxt=xaxt, xlim=xlim, cex.axis=1.5, cex.lab=1.5)
}

# use the function created to plot the CFR with the maximum lag
lag_range <- seq(1,25,6)
max_lag <- max(lag_range)

png('output/Rplot2.png', width=2400, height=2400, res=240)
par(mfrow=c(length(lag_range),1), mar=c(0.1,4.5,1,1), oma=c(3,0,0,0),las=1)
for (lag in lag_range) {
    plot_lagged_cfr(cfr_date, lag, max_lag)
    print(lag)
}
dev.off()