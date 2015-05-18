library('ggplot2')
library('reshape2')

advanced     <- read.csv('advanced.csv')
conservative <- read.csv('conservative.csv')
fencesitter  <- read.csv('fencesitter.csv')
malware      <- read.csv('malware.csv')
pus          <- read.csv('pus.csv')
unconcerned  <- read.csv('unconcerned.csv')

# png('advanced.png')
# qplot(percentage_following, data=advanced) +
#   scale_y_continuous("User frequency")
# dev.off()
#
# png('conservative.png')
# qplot(percentage_following, data=conservative) +
#   scale_y_continuous("User frequency") 
# dev.off()
#
# png('fencesitter.png')
# qplot(percentage_following, data=fencesitter) +
#   scale_y_continuous("User frequency")
# dev.off()
#
# png('unconcerned.png')
# qplot(percentage_following, data=unconcerned) +
#   scale_y_continuous("User frequency")
# dev.off()
#
# png('pus.png')
# qplot(percentage_following, data=pus) +
#   scale_y_continuous("User frequency")
# dev.off()
#
# png('malware.png')
# qplot(percentage_following, data=malware) +
#   scale_y_continuous("User frequency")
# dev.off()

lin <- merge(merge(merge(conservative, advanced), fencesitter), unconcerned)
d_lin <- melt(lin, id.vars=c(1))
p_lin <- ggplot(d_lin, aes(x=value, fill=variable)) + geom_histogram(binwidth=0.03) + scale_y_sqrt() 
update_labels(p_lin, list(x="Percentage of users apps meeting policy", y="User count", color="Policy"))

bad <- merge(pus,malware)
d_bad <- melt(bad, id.vars=c(1))
p_bad <- ggplot(d_bad, aes(x=value, fill=variable)) + geom_histogram(binwidth=0.03) + scale_y_sqrt()
update_labels(p_bad, list(x="Percentage of users apps meeting policy", y="User count", color="Policy"))
