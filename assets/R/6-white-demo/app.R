library(shiny)
library(shinyMobile)

shinyApp(
  ui = f7Page(
    title = "Tab layout",
    options = list(
      theme = "md", 
      dark = FALSE, 
      filled = FALSE,
      color = "#007aff", 
      touch = list(
        tapHold = TRUE, 
        tapHoldDelay = 750, 
        iosTouchRipple = FALSE
      ), 
      iosTranslucentBars = FALSE, 
      navbar = list(iosCenterTitle = TRUE, hideOnPageScroll = TRUE), 
      toolbar = list(hideOnPageScroll = FALSE), 
      pullToRefresh = FALSE
    ),
    f7TabLayout(
      tags$head(
        tags$script(
          "$(function(){
               $('#tapHold').on('taphold', function () {
                 app.dialog.alert('Tap hold fired!');
               });
             });
             "
        )
      ),
      panels = tagList(
        f7Panel(title = "Left Panel", side = "left", theme = "light", "Blabla", effect = "cover"),
        f7Panel(title = "Right Panel", side = "right", theme = "dark", "Blabla", effect = "cover")
      ),
      navbar = f7Navbar(
        title = "Tabs",
        hairline = FALSE,
        shadow = TRUE,
        leftPanel = TRUE,
        rightPanel = TRUE
      ),
      f7Tabs(
        animated = FALSE,
        swipeable = TRUE,
        f7Tab(
          tabName = "Tab 1",
          icon = f7Icon("envelope"),
          active = TRUE,
          f7Shadow(
            intensity = 10,
            hover = TRUE,
            f7Card(
              title = "Card header",
              f7Stepper(
                "obs1",
                "Number of observations",
                min = 0,
                max = 1000,
                value = 500,
                step = 100
              ),
              plotOutput("distPlot1"),
              footer = tagList(
                f7Button(inputId = "tapHold", label = "My button"),
                f7Badge("Badge", color = "green")
              )
            )
          )
        ),
        f7Tab(
          tabName = "Tab 2",
          icon = f7Icon("today"),
          active = FALSE,
          f7Shadow(
            intensity = 10,
            hover = TRUE,
            f7Card(
              title = "Card header",
              f7Select(
                inputId = "obs2",
                label = "Distribution type:",
                choices = c(
                  "Normal" = "norm",
                  "Uniform" = "unif",
                  "Log-normal" = "lnorm",
                  "Exponential" = "exp"
                )
              ),
              plotOutput("distPlot2"),
              footer = tagList(
                f7Button(label = "My button", href = "https://www.google.com"),
                f7Badge("Badge", color = "orange")
              )
            )
          )
        ),
        f7Tab(
          tabName = "Tab 3",
          icon = f7Icon("cloud_upload"),
          active = FALSE,
          f7Shadow(
            intensity = 10,
            hover = TRUE,
            f7Card(
              title = "Card header",
              f7SmartSelect(
                inputId = "variable",
                label = "Variables to show:",
                c("Cylinders" = "cyl",
                  "Transmission" = "am",
                  "Gears" = "gear"),
                multiple = TRUE,
                selected = "cyl"
              ),
              tableOutput("data"),
              footer = tagList(
                f7Button(label = "My button", href = "https://www.google.com"),
                f7Badge("Badge", color = "green")
              )
            )
          )
        )
      )
    )
  ),
  server = function(input, output) {
    output$distPlot1 <- renderPlot({
      dist <- rnorm(input$obs1)
      hist(dist)
    })
    
    output$distPlot2 <- renderPlot({
      dist <- switch(
        input$obs2,
        norm = rnorm,
        unif = runif,
        lnorm = rlnorm,
        exp = rexp,
        rnorm
      )
      
      hist(dist(500))
    })
    
    output$data <- renderTable({
      mtcars[, c("mpg", input$variable), drop = FALSE]
    }, rownames = TRUE)
  }
)