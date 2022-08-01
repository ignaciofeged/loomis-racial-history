#server.R

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
