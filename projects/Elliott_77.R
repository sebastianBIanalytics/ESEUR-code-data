#
# Elliott_77.R, 17 Oct 19
# Data from:
# Life Cycle Planning for a Large Mix of Commercial Systems
# I. R. Elliott
#
# Example from:
# Evidence-based Software Engineering: based on the publicly available data
# Derek M. Jones
#
# TAG system_lifetime staffing system_rewrite


source("ESEUR_config.r")


# The igraph package (which might be loaded when building the book)
# contains functions found in gnm.  The treemap package might also have
# been loaded (as might phangorn), and its 'load' of igraph cannot be
# undone without first unloading treemap!
unloadNamespace("FrF2")
unloadNamespace("treemap")
unloadNamespace("phangorn")
unloadNamespace("igraph")

library("gnm")


pal_col=rainbow(3)

staff=read.csv(paste0(ESEUR_dir, "projects/Elliott_77.csv.xz"), as.is=TRUE)

peak=subset(staff, P_A == "Peak")
average=subset(staff, P_A == "Average")

plot(average$Years, average$Staff, log="y", col=pal_col[2],
	ylim=c(50, 210),
	xlab="Lifetime (years)", ylab="Staff\n")

aver_mod=gnm(Staff ~ instances(Mult(1, Exp(Years)), 2)-1,
                data=average, verbose=FALSE, trace=FALSE,
                start=c(300, -1, 100, -0.1))
summary(aver_mod)

exp_coef=as.numeric(coef(aver_mod))

t=predict(aver_mod)
lines(average$Years, t, col=pal_col[2])

lines(average$Years, exp_coef[1]*exp(exp_coef[2]*average$Years), col=pal_col[1])
lines(average$Years, exp_coef[3]*exp(exp_coef[4]*average$Years), col=pal_col[3])


# # The models constant offset has a big impact
# me_mod=mexpfit(average$Years, average$Staff, p0=c(-0.9, -0.1))
# print(me_mod)

# peak_mod=gnm(Staff ~ instances(Mult(1, Exp(Years)), 2)-1,
#                 data=peak, verbose=TRUE, trace=TRUE,
#                 start=c(300, -1, 100, -0.1))
# summary(peak_mod)

