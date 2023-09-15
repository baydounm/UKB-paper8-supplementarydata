#install.packages("ggplot2")
#install.packages("ggrepel")
#install.packages("readstata13")

library(ggplot2)
library(ggrepel)

# setwd("D:\\DATA")
# fnm = 'VOLCANOPLOT_DATASET.dta'

fnmCSV = '/Users/mainovieytesca/Library/CloudStorage/OneDrive-NationalInstitutesofHealth/nih/uk-biobank/ukb-paper-#8/INFECTION_PROTEOME_VOLCANOPLOTDATA.csv'

datObj = read.csv(fnmCSV, as.is=T)
nrow(datObj)
summary(datObj)
head(datObj)
# tail(datObj)

pltDat = within(datObj, {
	lblOutcome	= sub('^ z', '', Outcome, perl=T)
# 	p		= pmax(p, p, 10^-140)
	})

summary(pltDat)

options(ggrepel.max.overlaps = Inf)	# avoids error message about colliding labels

pltDat$nudge.x <- c( rep( 0,17), -0.2, rep(0, 4) )

( pltObj <- ggplot(data=pltDat, aes(x=estimate, y=mlog10p, label=lblOutcome)) +
		geom_point(shape=20, size=1) +
                geom_point(shape=20, size=3, col='red', data=subset(pltDat, selected==1)) +
# 		geom_point(shape=20, size=1, col='red', data=subset(volDat, selected==1 & min95>=.25)) +
		geom_point(shape=20, size=3, col='orange', data=subset(pltDat, selected==0 & signif==1 & estimate>0)) +
                geom_point(shape=20, size=3, col='blue', data=subset(pltDat, selected==0 & signif==1 & estimate<0)) +
		xlim(-.35, .35) + ylim(0, 140) +
		geom_label_repel(size=5, col='red', 
		                 data=subset(pltDat, selected==1 & estimate> .25), 
		                 aes(label=lblOutcome),
		                 min.segment.length = 0.1) +
                labs(x='Effect size') +
		theme_minimal() +
		geom_vline(xintercept=-.25, col="gray", linetype=2) +
		geom_vline(xintercept=.25,  col="gray", linetype=2) +
		geom_hline(yintercept=-log10(0.05/1463), col="gray", linetype=2) +
  theme( axis.text.x = element_text( size = 12),
         axis.text.y = element_text( size = 12),
         axis.title.x = element_text( size = 14),
         axis.title.y = element_text( size = 14)) +
    coord_cartesian( xlim = c( -0.3, 0.7 ),
                     ylim = c( 0, 170))
)



# increase font of labels and other text (done by Christian Maino Vieytes; 9/11/2023)
dirName = '/Users/mainovieytesca/Library/CloudStorage/OneDrive-NationalInstitutesofHealth/nih/uk-biobank/ukb-paper-#8/'
imgName = '2023-09-11-UKB08-Volcano.png'

ggsave( paste0( dirName, imgName),
        plot = pltObj,
        width = 7, height = 7)
