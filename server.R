#server.R

library(readxl)
library(tidyverse)
library(shiny)
library(shinythemes)
library(timevis)
library(RCurl)

x<-getURL("https://raw.githubusercontent.com/ignaciofeged/loomis-racial-history/heroku/TimelineData4-1.csv")
timeline_data1<-read_csv(x)
as.tibble(timeline_data1)
timeline_data1$month[is.na(timeline_data1$month)]<-1
timeline_data1$help<-timeline_data1$thing-1700
timeline_data1$help<-timeline_data1$help*365+timeline_data1$month*31
timeline_data1$start<-as.Date(timeline_data1$help,origin="1700-01-01")

y<-getURL("https://raw.githubusercontent.com/ignaciofeged/loomis-racial-history/heroku/TimelineData4-2.csv")
timeline_data2<-read_csv(y)
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
dday1<-as.Date("1698-01-01","%Y-%m-%d")
dday2<-as.Date("1710-01-01","%Y-%m-%d")

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
