#install.packages("ggplot2")
#install.packages("ggrepel")
#install.packages("readstata13")

library(ggplot2)
library(ggrepel)

# setwd("D:\\DATA")
# fnm = 'VOLCANOPLOT_DATASET.dta'

fnmCSV = '/zdsk/Manuscripts/Baydoun/UK-BioBank/2023-05-16--08--Dementia-Infection/2023-05-31-Volcano/raw/INFECTION_PROTEOME_VOLCANOPLOTDATA.csv'

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

Volcano = function(volDat) {
	ggObj =	ggplot(data=volDat, aes(x=estimate, y=mlog10p, label=lblOutcome)) +
		geom_point(shape=20, size=1) +
                geom_point(shape=20, size=3, col='red', data=subset(volDat, selected==1)) +
# 		geom_point(shape=20, size=1, col='red', data=subset(volDat, selected==1 & min95>=.25)) +
		geom_point(shape=20, size=3, col='orange', data=subset(volDat, selected==0 & signif==1 & estimate>0)) +
                geom_point(shape=20, size=3, col='blue', data=subset(volDat, selected==0 & signif==1 & estimate<0)) +
		xlim(-.35, .35) + ylim(0, 140) +
		geom_text_repel(size=3, col='red', data=subset(volDat, selected==1 & min95>=.25), aes(label=lblOutcome)) +
                labs(x='Effect size') +
		theme_minimal() +
		geom_vline(xintercept=-.25, col="gray", linetype=2) +
		geom_vline(xintercept=.25,  col="gray", linetype=2) +
		geom_hline(yintercept=-log10(0.05/1463), col="gray", linetype=2)

	ggObj
	}

(pltObj = Volcano(pltDat))

dirName = '/zdsk/Manuscripts/Baydoun/UK-BioBank/2023-05-16--08--Dementia-Infection/2023-05-31-Volcano/R/'
imgName = '2023-06-02-UKB08-Volcano'
pdfFile = paste0(dirName, imgName, '.pdf')
pngFile = paste0(dirName, imgName, '.png')

pdf(pdfFile)
pltObj
jnk = dev.off()

png(pngFile)
pltObj
jnk = dev.off()
