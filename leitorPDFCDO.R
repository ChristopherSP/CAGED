library(pdftools)
library(stringi)
file <- '~/Downloads/CBO2002_LISTA.PDF'

pages <- pdf_text(file)

pages_non_blank = stri_trim_both(stri_replace_all_regex(pages,"  +","\t"))
pages_non_blank = paste(pages_non_blank, collapse = "\t \n")

sink(file = stri_replace_all_fixed(file,".PDF",".txt"))
cat(pages_non_blank)
sink()
