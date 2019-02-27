library(xlsx)
library(data.table)
library(zoo)

#######################################################################################################################################################
dataDictionary = as.data.table(read.xlsx("~/Downloads/CAGED/CAGEDEST_layout_Atualizado.xls",sheetName = "CAGESTID - layout",startRow = 2))
dataDictionary[,NA.:=NULL]

names(dataDictionary) = stri_replace_all_fixed(tolower(stri_trans_general(names(dataDictionary),"latin-ascii")),".","_")

dataDictionary = dataDictionary[,lapply(.SD, na.locf)]
dataDictionary = dataDictionary[categorias != "(ver planilha correspondente contida neste arquivo)"]

#######################################################################################################################################################
codMun = as.data.table(read.xlsx("~/Downloads/CAGED/CAGEDEST_layout_Atualizado.xls",sheetName = "municipio",startRow = 1))

names(codMun) = "codigo"

codMun[, codigo := stri_replace_first_fixed(codigo,"-","|")]
codMun[, c("id", "aux") := tstrsplit(codigo, ":", fixed=TRUE)]
codMun[, c("uf", "label") := tstrsplit(aux, "|", fixed=TRUE)]
codMun[, uf := toupper(uf)]
codMun[,`:=`(aux=NULL, codigo=NULL)]
codMun[,id:=as.integer(id)]

#######################################################################################################################################################
codCBO94 = as.data.table(read.xlsx("~/Downloads/CAGED/CAGEDEST_layout_Atualizado.xls",sheetName = "CBO 94",startRow = 1))
names(codCBO94) = "codigo"

codCBO94[, c("id", "label") := tstrsplit(codigo, ":", fixed=TRUE)]
codCBO94[, codigo:=NULL]
codCBO94[,id:=as.integer(id)]

#######################################################################################################################################################
codCBO2002 = as.data.table(read.xlsx("~/Downloads/CAGED/CAGEDEST_layout_Atualizado.xls",sheetName = "cbo2002",startRow = 1))
names(codCBO2002) = "codigo"

codCBO2002[, c("id", "label") := tstrsplit(codigo, ":", fixed=TRUE)]
codCBO2002[, codigo:=NULL]
codCBO2002[,id:=as.integer(id)]

#######################################################################################################################################################
cnaeSubclass = as.data.table(read.xlsx("~/Downloads/CAGED/CAGEDEST_layout_Atualizado.xls",sheetName = "subclasse",startRow = 1))
names(cnaeSubclass) = "codigo"

cnaeSubclass[, c("id", "label") := tstrsplit(codigo, ":", fixed=TRUE)]
cnaeSubclass[, codigo:=NULL]
cnaeSubclass[,id:=as.integer(id)]

#######################################################################################################################################################
cnaeClass2 = as.data.table(read.xlsx("~/Downloads/CAGED/CAGEDEST_layout_Atualizado.xls",sheetName = "classe 20",startRow = 1))
names(cnaeClass2) = "codigo"

cnaeClass2[, c("id", "label") := tstrsplit(codigo, ":", fixed=TRUE)]
cnaeClass2[, codigo:=NULL]
cnaeClass2[,id:=as.integer(id)]

#######################################################################################################################################################
cnaeClass1 = as.data.table(read.xlsx("~/Downloads/CAGED/CAGEDEST_layout_Atualizado.xls",sheetName = "classe 10",startRow = 1))
names(cnaeClass1) = "codigo"

cnaeClass1[, codigo := stri_replace_first_fixed(codigo,":","|")]
cnaeClass1[, c("id", "label") := tstrsplit(codigo, "|", fixed=TRUE)]
cnaeClass1[, codigo:=NULL]
cnaeClass1[,id:=as.integer(id)]

#######################################################################################################################################################
outros = as.data.table(read.xlsx("~/Downloads/CAGED/CAGEDEST_layout_Atualizado.xls",sheetName = "outros",startRow = 1))
names(outros) = stri_replace_all_fixed(tolower(stri_trans_general(names(outros),"latin-ascii")),".","_")
outros[,`:=`(na_ = NULL, na__1 = NULL)]

tables = lapply(names(outros), function(column){
  df = outros[, eval(parse(text = paste0(".(codigo = ",column,")")))][, c("id", "label") := tstrsplit(codigo, ":", fixed=TRUE)][!is.na(id)]
  df[, codigo:=NULL]
  df[, id:=as.integer(id)]
})

names(tables) = names(outros)

#######################################################################################################################################################
bairroSP = as.data.table(read.xlsx("~/Downloads/CAGED/CAGEDEST_layout_Atualizado.xls",sheetName = "BAIRRO_SP",startRow = 2))
names(bairroSP) = stri_replace_all_fixed(tolower(stri_trans_general(names(bairroSP),"latin-ascii")),".","_")

#######################################################################################################################################################
bairroFort = as.data.table(read.xlsx("~/Downloads/CAGED/CAGEDEST_layout_Atualizado.xls",sheetName = "BAIRRO FORT",startRow = 2))
names(bairroFort) = stri_replace_all_fixed(tolower(stri_trans_general(names(bairroFort),"latin-ascii")),".","_")

#######################################################################################################################################################
bairroRJ = as.data.table(read.xlsx("~/Downloads/CAGED/CAGEDEST_layout_Atualizado.xls",sheetName = "BAIRRO_RJ",startRow = 2))
names(bairroRJ) = stri_replace_all_fixed(tolower(stri_trans_general(names(bairroRJ),"latin-ascii")),".","_")

#######################################################################################################################################################
distritoSP = as.data.table(read.xlsx("~/Downloads/CAGED/CAGEDEST_layout_Atualizado.xls",sheetName = "Distrito SP",startRow = 1,header = F))
names(distritoSP) = c("id","label")
distritoSP[,id:=as.integer(id)]

#######################################################################################################################################################
reg_adm_df = as.data.table(read.xlsx("~/Downloads/CAGED/CAGEDEST_layout_Atualizado.xls",sheetName = "REG ADM DF",startRow = 1))
names(reg_adm_df) = c("id","label")
reg_adm_df[,id:=as.integer(id)]
reg_adm_df[grepl("ñ",label), label := ""]
