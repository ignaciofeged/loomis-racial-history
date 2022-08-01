#ui.R

#find a way to reference the data in a way that works, check yt vids work and throw on github
library(readxl)
library(tidyverse)
library(shiny)
library(shinythemes)
library(timevis)
library(RCurl)

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
