library(data.table)
library(stringi)

cbo2002 = fread("~/Downloads/CBO2002_LISTA.txt", fill = T, sep="\t", skip = 3, na.strings = "")

names(cbo2002) = stri_replace_all_fixed(tolower(stri_trans_general(names(cbo2002),"latin-ascii"))," ","_")

cbo2002 = cbo2002[!grepl("CBO2002",cbo_2002)]
cbo2002 = cbo2002[!is.na(cbo_2002)]
cbo2002[is.na(tipo) & grepl("Sinônimo",titulos), tipo := "Sinônimo"]
cbo2002[is.na(tipo) & grepl("Ocupação",titulos), tipo := "Ocupação"]
cbo2002[is.na(tipo) & grepl("Família",titulos), tipo := "Família"]
cbo2002[nchar(cbo_2002) <=4, tipo := "Família"]

cbo2002[,cbo_2002:=stri_trim_both(cbo_2002)]
cbo2002[,tipo:=stri_trim_both(tipo)]

cbo2002[, c("base", "digit") := tstrsplit(cbo_2002, "-", fixed=TRUE)]
cbo2002[,cbo_2002:=stri_replace_first_fixed(cbo_2002,"-",'')]

# write.table(cbo2002[tipo == "Família", .(cbo_2002, titulos)],"~/Downloads/familia.csv",sep="\t",quote = F,row.names = F)
