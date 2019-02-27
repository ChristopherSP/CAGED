library(dplyr)
library(RCurl)
library(doParallel)
library(parallel)

outputPath = "/home/christopher/Downloads/CAGED/"

years = 2007:2017
baseURL = "ftp://ftp.mtps.gov.br/pdet/microdados/CAGED/"

ncores = detectCores() - 1

lapply(years, function(year){
  url = paste0(baseURL, year, "/")
  alldir = getURL(url, ftp.use.epsv = FALSE, ftplistonly = TRUE, crlf = TRUE)
  alldir = paste(url, strsplit(alldir, "\r*\n")[[1]], sep = "")
  
  mclapply(alldir, function(file) {
    fileName = unlist(
      strsplit(file,"/"))[
        length(
          unlist(
            strsplit(file,"/")
          )
        )
        ]
    
    download.file(file,
                  paste0(outputPath, fileName)
    ) 
  }, mc.cores = ncores)
  
})

