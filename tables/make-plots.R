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
colnames(lin___)[2] <- "C"
colnames(lin___)[3] <- "A"
colnames(lin___)[4] <- "F"
colnames(lin___)[5] <- "U"

d_lin <- melt(lin___, id.vars=c(1))
p_lin <- ggplot(d_lin, aes(x=value, fill=variable)) +
         geom_histogram(binwidth=0.10, position="dodge") +
         xlim(0,1.0) +
         theme(axis.text=element_text(size=14)) +
         theme_bw()
update_labels(p_lin, list(x="%age of user's apps meeting policy", y="User count", color="Policy"))
dev.off()

setEPS()
postscript("malware.eps", width=6, height=3)
bad <- merge(pup,malware)

bad_ <- merge(bad, installs)
bad__ <- bad_[bad_$installs > 20,]
bad___ <- bad__[,1:3]

colnames(bad___)[2] <- "not PUP"
colnames(bad___)[3] <- "not Malware"
d_bad <- melt(bad___, id.vars=c(1))
p_bad <- ggplot(d_bad, aes(x=value, fill=variable)) +
         geom_histogram(binwidth=0.02, position="dodge") +
         ylim(0,150) + 
         xlim(0.7, 0.9999) +
         theme(axis.text=element_text(size=14)) +
         theme_bw()
update_labels(p_bad, list(x="%age of user's apps meeting policy", y="User count", color="Policy"))
dev.off()

