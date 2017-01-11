#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(wordcloud)
library(RColorBrewer)
library(rvest)
library(stringr)
library(tm)

fairfax_to_headlines <- function(base_url) {
  headlines <- read_html(base_url) %>% html_nodes("div.story__wof") %>% html_text()
  headlines <- str_match(headlines, "^\\n\\s+\\n\\s+(.*?)\\n")[, 2]
  # now lots of ugly munging to get to bare words
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
  return(headlines)
}

headlines_to_words <- function(headlines) {
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


# Define UI
ui <- fluidPage(
   
   # Application title
   titlePanel("Australian News Word Clouds"),
   
   # Sidebar with a slider input for min words
   sidebarLayout(
      sidebarPanel(
        selectInput("publication",
                    "News Source:",
                    c("Brisbane Times" = "http://www.brisbanetimes.com.au",
                      "Canberra Times" = "http://www.canberratimes.com.au/",
                      "Sydney Morning Herald" = "http://www.smh.com.au",
                      "The Age" = "http://www.theage.com.au",
                      "WA Today" = "http://www.watoday.com.au/"), selected = "http://www.smh.com.au"
                     ),
         sliderInput("minfreq",
                     "Minimum word frequency:",
                     min = 2,
                     max = 6,
                     value = 3)
      ),
      
      # Show a plot
      mainPanel(
         plotOutput("wordCloud")
      )
   )
)

# Define server logic
server <- function(input, output) {
  
  observe({
    headlines <- fairfax_to_headlines(input$publication)
    headlines.words <- headlines_to_words(unique(headlines))
    words.wc <- count_words(headlines.words)
    pal2 <- brewer.pal(8, "Dark2")
  
    output$wordCloud <- renderPlot({
      # generate wordcloud
     wordcloud(words.wc$word, words.wc$count, scale = c(8, .2), min.freq = input$minfreq, max.words = 200, random.order = FALSE, rot.per = .15, colors = pal2)
   }, width = 1024, height = 1024)
  }
)
}
# Run the application 

  shinyApp(ui = ui, server = server)

