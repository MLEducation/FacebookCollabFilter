# Facebook Collaborative Filtering

## What is UB-CF?
Algorithmic recommendations are all around you. From what to watch, what to buy, who to be friends with, and the ads you see. One common algorithm used to generate these recommendations is "User-Based Collaborative Filtering" or "UB-CF". UB-CF gathers up users who are similar, and mines recommendations from those users with interests in common. Let's look at an example!

This is Basil. They like gardening, reading fantasy books, playing Dungeons and Dragons, and soccer.

<center>
<img src="https://raw.githubusercontent.com/MLEducation/FacebookCollabFilter/main/www/friend10.png" alt="drawing" width="200"/></img>
<center>


This is Hazel. They like reading fantasy books too! And they like Dungeons and Dragons! They even like soccer too! They also like bicycling and baking.

<center>
<img src="https://raw.githubusercontent.com/MLEducation/FacebookCollabFilter/main/www/friend24.png" alt="drawing" width="200"/></img>
<center>

UB-CF would say that because Basil and Hazel have similar interests (fantasy books, D&D, soccer), maybe Basil would like some of Hazel's other interests too! So UB-CF would recommend bicycling and baking *from* Hazel *to* Basil.

On a large scale, platforms like Facebook take data from millions of users to recommend content. In many ways this is helpful and beneficial. In other ways, it can lead to echo chambers, downweighting of minority voices, and other harms. In a study, we explored how this teaching tool helped Data Science non-experts learn about UB-CF and express potential harms from the algorithm!

## What is this git repo for?
This is the [R shiny app](https://shiny.rstudio.com/) used in the paper: **Developing Self-Advocacy Skills Through Machine Learning Education: The Case of Ad Recommendation on Facebook**

## How to Run This App
1. Clone or Download this repository.
2. Open it in [RStudio](https://www.rstudio.com/)
3.  If you haven't used R shiny in the past, you will likely need to install several libraries and [make an account](https://www.shinyapps.io/admin/#/dashboard). Here is a list of libraries used in the app currently.
`library(visNetwork)
library(shiny)
library(shinythemes)
library(DT)
library(ggplot2)
library(car)
library(nortest)
library(tseries)
library(RcmdrMisc)
library(lmtest)
library(jsonlite)
library(giphyr)
library(shinyWidgets)
library(shinyBS)
library(shinyjs)
library(shinyMatrix)
library(data.table)
library(tidyverse)
library(lubridate)
library(mongolite)`
4. [OPTIONAL] Currently, this shiny app is not collecting any data. You can connect it to a [MongoDB Cloud Atlas](https://www.mongodb.com/cloud/atlas) if you desire, by inputting your host link, username, password, database name, and collection name in this block located in server.R :
`options(mongodb = list(
      "host" = "",
      "username" = "",
      "password" = ""
    )
    )`
    
    `databaseName <- "shinydatabase"`
  
	  `collectionName <- "responses"`
  Find out more [here](https://shiny.rstudio.com/articles/persistent-data-storage.html#mongodb)
5.   You can click "Run App" to run the shiny app locally, or Publish Application (right next to Run App, in the dropdown beneath the blue arrows in a circle) if you'd like to host it yourself.

## Learn More

*this will eventually link to the PDF if the paper is accepted*



