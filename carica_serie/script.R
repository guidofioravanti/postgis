#Converte i file delle serie giornaliere/mensili/annuali (dati raw/climatol/acmant) da formato wide a formato long. I file creati
#sono caricati nello schema "serie" del database scia sfruttando la funzione serie.carica() nel file 'serie_dati.sql'
#I file di input devono riportare le diciture "Giornaliere","Mensili","Annuali" altrimenti il programma fallisce.
rm(list=objects())
library("tidyverse")
options(error=recover,warn = 2)

list.files(pattern="^Tmin.+csv$")->ffile

incolla<-function(){
  
  browser()
  
}


purrr::walk(ffile,.f=function(nomeFile){
  
  read.csv(nomeFile,sep=";",header = TRUE,stringsAsFactors = FALSE,check.names = FALSE)->dati

  dati %>% gather(key="codice",value="temp",contains("_")) %>%
    mutate(temp=ifelse(is.na(temp),NA,round(temp,2))) %>%
    mutate(regione=stringr::str_extract(codice,"^[a-z]+"),siteid=stringr::str_extract(codice,"[0-9]+$"))->dati2 
  
    if(grepl("Annuali",nomeFile)){
    
      dati2 %>% mutate(yymmdd=paste0(yy,"-01-01"))->dati3
      
    }else if(grepl("Mensili",nomeFile)){
      
      dati2 %>% mutate(yymmdd=paste0(yy,"-",mm,"-01"))->dati3
      
    }else if(grepl("Giorna",nomeFile)){
      
      dati2 %>% mutate(yymmdd=paste0(yy,"-",mm,"-",dd))->dati3
      
    }
    
    dati3 %>% select(yymmdd,regione,siteid,temp) %>%
      write_delim(paste0("gather_",nomeFile),delim=";",col_names=TRUE)
  

}) 


