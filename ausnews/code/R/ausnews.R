# fairfax_to_headlines

fairfax_to_headlines <- function(base_url) {
  require(rvest)
  require(stringr)
  
  headlines <- read_html(base_url) %>% html_nodes("div.story__wof") %>% html_text()
  headlines <- str_match(headlines, "^\\n\\s+\\n\\s+(.*?)\\n")[, 2]
  headlines <- gsub("\\.$", "",headlines)
  headlines <- gsub(",", "",headlines)
  headlines <- gsub("\\?", "",headlines)
  headlines <- gsub("\\:", "",headlines)
  headlines <- gsub("'\\s+", " ",headlines)
  headlines <- gsub("\\s+'", " ",headlines)
  headlines <- gsub("^'", "",headlines)
  headlines <- gsub("'$", "",headlines)
  headlines <- gsub("^\"", "",headlines)
  headlines <- gsub("$\"", "",headlines)
  headlines <- tolower(headlines)
  # headlines <- headlines[which(!headlines %in% stopwords())]
  return(headlines)
}

headlines_to_words <- function(headlines) {
  require(tm)
  words <- unlist(strsplit(headlines, "\\s+"))
  words <- words[!words %in% stopwords()]
  return(words)
}

count_words <- function(words) {
  freq <- as.data.frame(table(words), stringsAsFactors = FALSE)
  colnames(freq) <- c("word", "count")
  freq <- freq[order(freq$count, decreasing = TRUE), ]
  return(freq)
}

# library(wordcloud)
# pal2 <- brewer.pal(8, "Dark2")
# wordcloud(wordcount$word, wordcount$count, scale = c(8, .2), min.freq = 3, max.words = 200, random.order = FALSE, rot.per = .15, colors = pal2)
