#server.R

library(readxl)
library(tidyverse)
library(shiny)
library(shinythemes)
library(timevis)
library(RCurl)

x<-getURL("https://raw.githubusercontent.com/ignaciofeged/loomis-racial-history/heroku2/Timeline-Data-(edited).csv")
timeline_data1<-read_csv(x)
as.tibble(timeline_data)
timeline_data$month[is.na(timeline_data$month)]<-1
timeline_data$help<-timeline_data$thing-1700
timeline_data$help<-timeline_data$help*365+timeline_data$month*31
timeline_data$start<-as.Date(timeline_data$help,origin="1700-01-01")
as.factor(timeline_data$group)
timeline_data$id<-1:38

##Time Vis prep############
timevisDataGroups <- data.frame(
  id = c("CT", "SC", "USA"),
  content = c("Connecticut", "South Carolina", "United States"))
dday1<-as.Date("1698-01-01","%Y-%m-%d")
dday2<-as.Date("1710-01-01","%Y-%m-%d")

library(timevis)

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
