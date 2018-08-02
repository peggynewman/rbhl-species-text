###################################################
## Extract OCR output from BHL for a species
## Author: Peggy 
## Notes:
## See https://www.biodiversitylibrary.org/search?SearchTerm=Macropus+rufus for expected results
## OCR text in the output CSV has EOLs replaced by "||"
###################################################

library(rbhl)
library(dplyr)
library(httr)
library(jsonlite)
library(tictoc)

# global
options(bhl_key = my_bhl_key)

## try multiple species
# Eastern Grey Kangaroos (Macropus Giganteus) gives slightly over 1500 matches in BHL
# Western Grey Kangaroos (Macropus fuliginosus) gives a smaller number about 200
# Red Kangaroos (but let's use the search term Macropus rufus as you suggest) with a bit over 900 records.

inputsearchterms <- c('Macropus Giganteus','Macropus fuliginosus','Macropus rufus')

confirmednames <- list()

for (term in inputsearchterms) {
  namedf <- bhl_namesearch(term)
  confirmednames <- append(confirmednames,namedf$NameConfirmed)
}
print("confirmed names")
confirmednames

# final dataframe (unique id is page id)
df <- data.frame(ScientificName=character()
                 ,TitleID=integer()
                 ,ShortTitle=character()
                 ,ItemID=integer()
                 ,PageID=integer()
                 ,PageYear=character()
                 ,OcrText=character(),stringsAsFactors=FALSE
)

for (sciname in confirmednames) {
  tic(sciname)
  resp <- fromJSON(bhl_namegetdetail(name=sciname,as="json"), flatten = FALSE, simplifyVector = FALSE)
  titles <- resp$Result$Titles
  for (title in titles) {
    items <- title$Items   
    for (i in items) { 
      pages <- i$Pages
      for (p in pages) { # pages is a list
        df[nrow(df) + 1,] = list(sciname
                                ,title$TitleID
                                ,title$ShortTitle
                                ,i$ItemID
                                ,p$PageID
                                ,paste(p$Year,"",sep="")
                                ,gsub("\n","||",paste(bhl_getpageocrtext(p$PageID),"",sep="")))
      }
    }
  }
  toc()
}  

write.csv(df,file=paste("Macropus.csv",sep=""))

