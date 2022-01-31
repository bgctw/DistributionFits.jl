# determine the steepest part of the most spread flat logitnorm

using Optim
using StatsFuns
using DistributionFits
using StatsPlots

dln = fit_mode_flat(LogitNormal, 0.5)

# Sympy
# x = symbols('x', nonnegative=True, real=True)
# lx = ln(x/(1-x))
# lnormx = 1/(2*sqrt(2*pi)) * 1/(x*(1-x)) * exp(-1/4*lx*lx)
# dlnormx = simplify(diff(lnormx,x))
# ddlnormx = simplify(diff(dlnormx,x))
# ccode(dlnormx)

# second derivative via sympy
pow(b,e) = b^e
ddlogit(x) = −1.0/16.0*sqrt(2)*(24*pow(x,2)−12*x*log(−x/(x−1))−24*x+pow(log(−x/(x−1)),2)+6*log(−x/(x−1))+6)*exp(−1.0/4.0*pow(log(−x/(x−1)),2))/(sqrt(pi)*pow(x,3)*(pow(x,3)−3*pow(x,2)+3*x−1))

# first derivative via numpy
dlogit(x) = (1.0/8.0)*sqrt(2)*(4*x−log(−x/(x−1))−2)*exp(−1.0/4.0*pow(log(−x/(x−1)),2))/(sqrt(pi)*pow(x,2)*pow(x−1,2))


ansopt2 = optimize(dlogit, 0.9, 1)
ansopt2
xms = ansopt2.minimizer

x = 0.7:0.002:1.0
x = x[1:(end-1)]
plot(x, dlogit.(x))
vline!([xms])

plot(x, pdf.(dln,x))
vline!([xms])



