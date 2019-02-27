library(data.table)
library(stringi)

caged = fread("~/Downloads/CAGED/Extracted/CAGED_teste.txt", sep=';', fill = T,quote='', encoding = "Latin-1")
names(caged) = stri_replace_all_fixed(tolower(stri_trans_general(names(caged),"latin-ascii"))," ","_")

caged[, salario_mensal := as.numeric(stri_replace_all_fixed(salario_mensal,",","."))]

subclassOcupation = rbind(cbo2002[tipo == "Sinônimo" ,.(cbo_2002,titulos,base,digit)], cbo2002[cbo_2002%in%cbo2002[,.N, by = .(cbo_2002,tipo)][,.N,by=cbo_2002][N == 1]$cbo_2002][tipo == "Ocupação", .(cbo_2002,titulos,base,digit)])

ocupationDT = merge(subclassOcupation, cbo2002[tipo == "Ocupação",.(cbo_2002,ocupacao = titulos)], all.x = T, by="cbo_2002")
wideCBO2002 = merge(ocupationDT, cbo2002[tipo == "Família",.(base, familia = titulos)], all.x = T, by="base")
wideCBO2002[,cbo_2002 := as.integer(cbo_2002)]

aggCaged = caged[,.(media_salario = mean(salario_mensal,na.rm = T)), by = cbo_2002_ocupacao]
labedCaged = merge(aggCaged, unique(wideCBO2002, by = "ocupacao"), all.x = T, by.x = "cbo_2002_ocupacao", by.y = "cbo_2002")

labedCaged[is.na(titulos), titulos := codCBO2002$label[match(labedCaged[is.na(titulos)]$cbo_2002_ocupacao,codCBO2002$id)]]