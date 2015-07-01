library('ggplot2')
library('reshape2')

advanced     <- read.csv('advanced.csv')
conservative <- read.csv('conservative.csv')
fencesitter  <- read.csv('fencesitter.csv')
malware      <- read.csv('malware.csv')
pus          <- read.csv('pus.csv')
unconcerned  <- read.csv('unconcerned.csv')
pup          <- read.csv('pup.csv')

installs <- read.csv('user-installs.csv')

lin <- merge(merge(merge(conservative, advanced), fencesitter), unconcerned)
lin_ <- merge(lin, installs)
lin__ <- lin_[lin_$installs > 20,]
lin___ <- lin__[,1:5]

bad <- merge(pup,malware)
bad_ <- merge(bad, installs)
bad__ <- bad_[bad_$installs > 20,]
bad___ <- bad__[,1:2]

colnames(bad___)[2] <- "PUP"

data <- merge(lin___, bad___)
d_data <- melt(data, id.vars=c(1))

# ggplot(data, aes(x=Fencesitter, y=PUP)) + geom_point()

# What what is the p(malware)?
pPUP = mean(data$PUP)

# Check significance
t.test(data[data$Conservative>0.5, ]$PUP, data$PUP, alternative="greater")
t.test(data[data$Advanced>0.5,     ]$PUP, data$PUP, alternative="greater")
t.test(data[data$Fencesitter>0.5,  ]$PUP, data$PUP, alternative="greater")
t.test(data[data$Unconcerned>0.5,  ]$PUP, data$PUP, alternative="greater")

