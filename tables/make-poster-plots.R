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


lin <- merge(merge(merge(conservative, advanced), fencesitter), unconcerned)
lin_ <- merge(lin, installs)
lin__ <- lin_[lin_$installs > 20,]
lin___ <- lin__[,1:5]
colnames(lin___)[2] <- "C"
colnames(lin___)[3] <- "A"
colnames(lin___)[4] <- "F"
colnames(lin___)[5] <- "U"
lin_no_u <- lin__[,1:4]

d_lin <- melt(lin___, id.vars=c(1))
d_lin_no_u <- melt(lin_no_u, id.vars=c(1))

setEPS()
postscript("lin-poster.eps", width=6, height=4)
p_lin <- ggplot(d_lin, aes(x=value, fill=variable)) +
         geom_histogram(binwidth=0.10, position="dodge") +
         xlim(0,1.0) +
         theme_bw()

update_labels(p_lin, list(x="%age of user's apps meeting policy", y="User count", color="Policy"))
dev.off()

setEPS()
postscript("lin-poster-focused.eps", width=6, height=4)
p_lin <- ggplot(d_lin, aes(x=value, fill=variable)) +
         geom_histogram(binwidth=0.05, position="dodge") +
         xlim(0.70,1.06) +
         theme_bw()

update_labels(p_lin, list(x="%age of user's apps meeting policy", y="User count", color="Policy"))
dev.off()

bad <- merge(pup,malware)

bad_ <- merge(bad, installs)
bad__ <- bad_[bad_$installs > 20,]
bad___ <- bad__[,1:3]

colnames(bad___)[2] <- "not PUP"
colnames(bad___)[3] <- "not Malware"
d_bad <- melt(bad___, id.vars=c(1))

setEPS()
postscript("malware-poster.eps", width=6, height=4)
p_bad <- ggplot(d_bad, aes(x=value, fill=variable)) +
         geom_histogram(binwidth=0.02, position="dodge") +
         ylim(0,150) +
         xlim(0.7, 0.9999) +
         theme_bw()

update_labels(p_bad, list(x="%age of user's apps meeting policy", y="User count", color="Policy"))
dev.off()

setEPS()
postscript("c_v_pup-poster.eps", width=6, height=4)
colnames(bad___)[2] <- "PUP"
data <- merge(lin___, bad___)
d_data <- melt(data, id.vars=c(1))
p_data <- ggplot(data, aes(x=C, y=PUP)) + geom_point() + theme_bw()
update_labels(p_data, list(x="%age of apps meeting `Advanced' policy",
                           y="%age of apps meeting `Not-PUP' policy"))
dev.off()


# Generate the conformance table
# conformance <- function(data, field, amount) { return(100 * nrow(data[field >= amount,]) / nrow(data[field >= 0.0,])) }
conformance <- function(data, field, amount) { return( nrow(data[field >= amount,])) }
cs = NULL
as = NULL
fs = NULL
us = NULL
is = NULL
for(i in 1:101)
{
         is[i] = (i-1)/100
         cs[i] = conformance(lin___, lin___$C, (i-1)/100)
         as[i] = conformance(lin___, lin___$A, (i-1)/100)
         fs[i] = conformance(lin___, lin___$F, (i-1)/100)
         us[i] = conformance(lin___, lin___$U, (i-1)/100)
}
df = data.frame(is, cs, as, fs, us)
df.conforming <- df[df$is >= 0.5,]
summary(df)
d_df <- melt(df.conforming, id.vars=is)
ggplot(d_df, aes(x=is, y=value, colour=variable)) + geom_line()

df[df$is == 0.50,]
df[df$is == 0.60,]
df[df$is == 0.70,]
df[df$is == 0.80,]
df[df$is == 0.90,]
df[df$is == 1.00,]
