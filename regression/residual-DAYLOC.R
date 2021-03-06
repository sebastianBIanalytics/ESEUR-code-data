#
# residual-DAYLOC.R, 24 Mar 20
# Data from:
# The {Linux} Kernel as a Case Study in Software Evolution
# Ayelet Israeli and Dror G. Feitelson
#
# Example from:
# Evidence-based Software Engineering: based on the publicly available data
# Derek M. Jones
#
# TAG Linux_evolution regression_residual


source("ESEUR_config.r")


# Need to get this plot to fit in the margin, along with the plot before it
# plot_layout(2, 1, max_height=12)
# par(mar=MAR_default-c(0.8, 0, 0.0, 0))

pal_col=rainbow(2)

# Lines of code in each release
ll=read.csv(paste0(ESEUR_dir, "regression/Linux-LOC.csv.xz"), as.is=TRUE)
# Data of each release
ld=read.csv(paste0(ESEUR_dir, "regression/Linux-days.csv.xz"), as.is=TRUE)

loc_date=merge(ll, ld)

# Add column giving number of days since first release
loc_date$Release_date=as.Date(loc_date$Release_date, format="%d-%b-%Y")
start.date=loc_date$Release_date[1]
loc_date$Number_days=as.integer(difftime(loc_date$Release_date,
                                         start.date,
                                         units="days"))
# Order by days since first release
ld_ordered=loc_date[order(loc_date$Number_days), ]

# What is the latest version
n_Version=numeric_version(ld_ordered$Version)

# cummax does not work for numeric_version, so we
# have to track the latest version
greatest_version <<- n_Version[1]

keep_version=sapply(2:nrow(ld_ordered),
		function(X)
		{
		if (n_Version[X] > greatest_version)
		   {	
		   greatest_version <<- n_Version[X]
		   return(TRUE)
		   }
		return(FALSE)
		})

latest_version=ld_ordered[c(TRUE, keep_version), ]


latest_version$MLOC=latest_version$LOC/1e6

m1=glm(MLOC ~ Number_days, data=latest_version)

# m2=glm(MLOC ~ Number_days+I(Number_days^2), data=latest_version)

plot(m1, which=1, caption="", sub.caption="", col=pal_col[2])

# plot(latest_version$Number_days, latest_version$MLOC, col=pal_col[2],
# 	cex.axis=1.4, cex.lab=1.4,
# 	xaxs="i", yaxs="i",
# 	xlab="Days", ylab="Total lines of code (MLOC)\n")
# 
# pred=predict(m1, type="response", se.fit=TRUE)
# lines(latest_version$Number_days, pred$fit, col=pal_col[1])
# lines(loess.smooth(latest_version$Number_days, latest_version$MLOC, span=0.3),
# 		col=pal_col[3])
# 
