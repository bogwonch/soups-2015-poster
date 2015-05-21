library('ggplot2')
library('reshape2')

advanced     <- read.csv('advanced.csv')
conservative <- read.csv('conservative.csv')
fencesitter  <- read.csv('fencesitter.csv')
malware      <- read.csv('malware.csv')
pus          <- read.csv('pus.csv')
unconcerned  <- read.csv('unconcerned.csv')
pup <- read.csv('pup.csv')

installs <- read.csv('user-installs.csv')

setEPS()
postscript("lin.eps", width=6, height=3)

lin <- merge(merge(merge(conservative, advanced), fencesitter), unconcerned)
lin_ <- merge(lin, installs)
lin__ <- lin_[lin_$installs > 20,]
lin___ <- lin__[,1:5]

d_lin <- melt(lin___, id.vars=c(1))
p_lin <- ggplot(d_lin, aes(x=value, fill=variable)) + geom_histogram(binwidth=0.05)
update_labels(p_lin, list(x="Percentage of users apps meeting policy", y="Stacked user count", color="Policy"))
dev.off()

setEPS()
postscript("malware.eps", width=6, height=3)
bad <- merge(pup,malware)

bad_ <- merge(bad, installs)
bad__ <- bad_[bad_$installs > 20,]
bad___ <- bad__[,1:3]

d_bad <- melt(bad___, id.vars=c(1))
p_bad <- ggplot(d_bad, aes(x=value, fill=variable)) + geom_histogram(binwidth=0.02) + ylim(0,175) + xlim(0.7, 0.9999) # + scale_y_sqrt()
update_labels(p_bad, list(x="Percentage of users apps meeting policy", y="Stacked user count", color="Policy"))
dev.off()

