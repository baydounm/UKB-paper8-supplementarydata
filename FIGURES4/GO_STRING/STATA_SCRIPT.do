 cd "E:\16GBBACKUPUSB\BACKUP_USB_SEPTEMBER2014\May Baydoun_folder\UK_BIOBANK_PROJECT\UKB_PAPER8A_INFECTIONBURDEN_OLINK_DEM\MANUSCRIPT\GITHUB\FIGURES4\GO_STRING"
 use GOenrichment.Process_GDF15cluster,clear
 capture drop mlog10FDR
 gen mlog10FDR=-log10(FDR)
 graph bar (mean) mlog10FDR if mlog10FDR>=6, over(termdescription)
 
 
 **Graph Editor**
 **Change each label to tiny and vertical. 
 **Change color to maroon. 
 
 