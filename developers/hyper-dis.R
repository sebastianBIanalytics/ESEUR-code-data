#
# hyper-dis.R, 21 Apr 20
# Data from:
# Example
#
# Example from:
# Evidence-based Software Engineering: based on the publicly available data
# Derek M. Jones
#
# TAG example time_discounting

source("ESEUR_config.r")


pal_col=rainbow(2)


plot_hype=function(V, delay, amount_str, col_str)
{
lines(V/(1+k*(max(delay)-1:delay)), col=col_str)
lines(c(delay, delay), c(0, V), col=col_str)
text(delay, V, amount_str, pos=2, cex=1.2)
# text(delay, 2, "reward", pos=2)
}


k=0.02

plot(0, type="n",
	xaxs="i",
	xaxt="n", yaxt="n",
	xlim=c(1, 100), ylim=c(2, 10),
	xlab="Time", ylab="Perceived present value")
axis(1, at=c(1, 55, 100), label=c("Start", expression(reward[1]), expression(reward[2])), cex.axis=1.2)

plot_hype(10, 100, expression(amount[2]), pal_col[1])
plot_hype(6, 55, expression(amount[1]), pal_col[2])


