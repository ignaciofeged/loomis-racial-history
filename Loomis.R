##Load and Data Wrangle#############
pacman::p_load(pacman, psych, rio, tidyverse) 
library(shiny)
library(shinythemes)
library(timevis)
library(ggpubr)
library(rpart)
library(caret)
library(data.table)
library(caTools)
library(reshape2)
library(dplyr)
library(rvest)

timeline_data1<-import("C:\\Users\\18602\\Downloads\\Timeline Data4-1.xlsx")
as.tibble(timeline_data1)
timeline_data1$month[is.na(timeline_data1$month)]<-1
timeline_data1$help<-timeline_data1$thing-1700
timeline_data1$help<-timeline_data1$help*365+timeline_data1$month*31
timeline_data1$start<-as.Date(timeline_data1$help,origin="1700-01-01")

timeline_data2<-import("C:\\Users\\18602\\Downloads\\Timeline Data4-2.xlsx")
as.tibble(timeline_data2)
timeline_data2$month[is.na(timeline_data2$month)]<-1
timeline_data2$help<-timeline_data2$thing-1700
timeline_data2$help<-timeline_data2$help*365+timeline_data2$month*31
timeline_data2$start<-as.Date(timeline_data2$help,origin="1700-01-10")

timeline_data<-rbind(timeline_data1,timeline_data2)
as.tibble(timeline_data)
as.factor(timeline_data$group)
timeline_data$id<-1:121
##Time Vis prep############
timevisDataGroups <- data.frame(
  id = c("CT", "SC", "USA"),
  content = c("Connecticut", "South Carolina", "United States"))
##Shiny UI#########
dday1<-as.Date("1698-01-01","%Y-%m-%d")
dday2<-as.Date("1710-01-01","%Y-%m-%d")


ui<- fluidPage(tags$style(HTML(
  ".js-irs-0 .irs-single, .js-irs-0 .irs-bar-edge, .js-irs-0 .irs-bar {background: #98252b}")),#color goes here
               theme = shinytheme("simplex"),
               titlePanel("Historical Context"),
               sidebarLayout(
                 sidebarPanel(
                   sliderInput(
                     inputId = "date_range",
                     label = "Year Range",
                     min = as.Date("1698-01-01","%Y-%m-%d"),
                     max = as.Date("1861-12-01","%Y-%m-%d"),
                     value = c(dday1,dday2),
                     timeFormat = "%Y-%m-%d",
                     step = 1095,
                     animate = 
                       animationOptions(
                         interval = 1000,
                         loop=F,)
                     
                   ),
                 ),
                 mainPanel(
                   timevisOutput("LCline"),
                   (conditionalPanel(condition = "output.show_notes", 
                                     h1("More Information:"),
                                     br())),
                   htmlOutput("printNotes")),
               )
)
##Shiny Server#####
server <- function(input, output) {
  
  start1<-reactive({input$date_range[1]})
  end1<-reactive({input$date_range[2]})
  
  output$LCline<-renderTimevis(timevis(data=timeline_data, groups=timevisDataGroups,
                                       fit = T,
                                       options = list(start=start1(), end=end1(), selectable=TRUE)))
  observe({
    values$tl_selected <- input$LCline_selected
  })
  note<-reactive({
    if (!is.null(values$tl_selected)){
      filter(timeline_data,id==values$tl_selected)%>%
        pull(Notes)
    }
  })
  #create server to UI variable for Notes conditional pannel#
  values <- reactiveValues(tl_selected = NULL )
  output$show_notes<-reactive({
    !is.null(values$tl_selected) 
  })
  outputOptions(output, "show_notes",suspendWhenHidden=F)
  
  output$printNotes<-renderUI({
    if(!is.null(values$tl_selected)){
      note()
    }
  })
  
}
# Create Shiny app ####
shinyApp(ui = ui, server = server)

# CLEAN UP #################################################
rm(list = ls()) 
detach("package:datasets", unload = TRUE)  # For base
dev.off()  # But only if there IS a plot
cat("\014")
