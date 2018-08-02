# rbhl-species-text
Retrieve OCR text about multiple species from the [Biodiversity Heritage Library](https://www.biodiversitylibrary.org) (BHL) using the [RBHL](https://github.com/ropensci/rbhl) R package.

The rbhl-extract.R script looks at 3 species of big kangaroos, finds all of the scientific names that match in BHL, then looks up pages in journals where those names have occurred and harvests the OCR text. EOL characters in the OCR text are replaced with || (double pipe) to avoid confusion. 

The final dataset contains:
* scientific name
* title id
* short title 
* item id (ie. https://www.biodiversitylibrary.org/item/224562)
* page id (ie. https://www.biodiversitylibrary.org/page/53282212, also /pagethumb/id, /pageimage/id, /pageocr/id
* page year
* ocr text

Took 25 mins to run. Probably could have used apply() more often.
