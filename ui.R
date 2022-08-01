#ui.R

#find a way to reference the data in a way that works, check yt vids work and throw on github
library(readxl)
library(tidyverse)
library(shiny)
library(shinythemes)
library(timevis)

timeline_data1<-import("https://raw.github.com/ignaciofeged/loomis-racial-history/blob/heroku/Timeline%20Data4-1.xlsx")
as.tibble(timeline_data1)
timeline_data1$month[is.na(timeline_data1$month)]<-1
timeline_data1$help<-timeline_data1$thing-1700
timeline_data1$help<-timeline_data1$help*365+timeline_data1$month*31
timeline_data1$start<-as.Date(timeline_data1$help,origin="1700-01-01")

timeline_data2<-import("https://raw.github.com/ignaciofeged/loomis-racial-history/blob/heroku/Timeline%20Data4-2.xlsx")
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

##Shiny UI#########
ui<- fluidPage(tags$style(HTML(
  ".js-irs-0 .irs-single, .js-irs-0 .irs-bar-edge, .js-irs-0 .irs-bar {background: #98252b}")),#color goes here
  theme = shinytheme("simplex"),
  titlePanel("",windowTitle = "Historical Context: Timeline"),
  titlePanel(
    h1("Loomis' History of Slavery: In Context", align = "center")),
  titlePanel(
    h5("Click on the timeline events to get a description and adjust the years shown by using the slider, the play button, zooming in/out, or draging the timeline",align="center")),
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "date_range",
        label = "Hit the Play Button or Drag the Slider to Change the Range of Years",
        min = as.Date("1698-01-01","%Y-%m-%d"),
        max = as.Date("1861-12-01","%Y-%m-%d"),
        value = c(dday1,dday2),
        timeFormat = "%Y-%m-%d",
        step = 1095,
        animate = 
          animationOptions(
            interval = 1500,
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
