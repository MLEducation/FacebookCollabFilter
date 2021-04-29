library(visNetwork)
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




shinyUI(fluidPage(useShinyjs(),theme = shinytheme("cosmo"),
                  includeCSS("style.css"),
                  tags$head(
                          tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
                  ),
                  
         #hide tabs to start
         tags$head(tags$style(HTML("#thenav li a[data-value = 'home'],
                                   #thenav li a[data-value = 'intro'], 
                                   #thenav li a[data-value = 'presurvey'],
                                   #thenav li a[data-value = 'step1'],
                                   #thenav li a[data-value = 'step2'],
                                   #thenav li a[data-value = 'step3'],
                                   #thenav li a[data-value = 'step4'],
                                   #thenav li a[data-value = 'step5'],
                                   #thenav li a[data-value = 'step6'],
                                   #thenav li a[data-value = 'step7'],
                                   #thenav li a[data-value = 'step8'],
                                   #thenav li a[data-value = 'postsurvey']
                                   {display: none;}"))),
        navbarPage("",id="thenav",
        tabPanel(title="Download Data",value="home",
                 
                 
                 fluidRow(column(tags$img(src="lookingdata.png",width="150px",height="150px",style="float:right;"),width=2),
                          column(
                                  
                                  
                                  br(),
                                  h1("What does Facebook think you are interested in?",style="color:black;background-color:white;padding:15px;border-radius:10px"),
                                  
                                  
                                   
                                  width=8),
                          ),
                 hr(),
                 
                 fluidRow(column(br(),width=2),
                          column(
                         br(),
                         
                         p("Download a zip file of your data by following these instructions:",
                           br(),
                           a(href="https://www.facebook.com/help/212802592074644", "How to Download Your Facebook Data",target="_blank",style="color:#4287f5"),style="color:black"),
                           br(),
                         p("Download your data in 'JSON' format:"),
                        img(src="download.png",width="70%"),
                        br(),
                        br(),
                        p("There are lots of things available for download, but today we will use the Ads and Businesses data. "),
                        img(src="ads_and_bus.png",width="70%"),
                        
                        br(),
                        br(),
                        p("You might also see the following, but we don't need these today."),
                        img(src="all.png",width="70%"),
                        br(),br(),
                        p("Extract, or 'unzip' the file that downloads, and our should see a folder called 'ads_and_businesses'. You will upload a file from here at a later step. Please don't look inside yet!"),
                        img(src="ads_interests.png",width="50%"),
                        br(),br(),
                        p("Remember this is your personal data and we will not save it as part of this research study."),
                        br(),
                        
                        actionButton("homenext", "Next",style="margin-bottom:4%;font-size:17pt;float:right;"),
                        br(),
                         width=8),
                         
                          
                      
                 
                        
                                     
                             ),
                 ),
        ###############################################################################################
        tabPanel(title="Intro",value="intro",
         column(
                h2("Facebook collects a lot of data about you. They use this data to organize your news feed, recommend advertisements, suggest new friends, and more.",align="left"),
                p("In the following step, you will see your own data, but it is for you to look at only. We will not see it. "),
                
                br(),
                
                h3("To get started, upload an image you'd like to use for yourself. This will allow you to personalize your experience and remember who is who in the tutorial. We will not save this image. "),
                h4("You may opt not to do this, and will use the default image instead. Just click Next to continue."),
                fileInput("myFile", "Choose a file", accept = c('image/png', 'image/jpeg')),
                uiOutput(outputId="uploadedimage"),
                br(),br(),
                actionButton("introback", "Back",style="margin-bottom:4%;font-size:17pt;float:left;"),
                actionButton("intronext", "Next",style="margin-bottom:4%;font-size:17pt;float:right;"),
                br(),
                
                width=8,offset=2)
        ),
        
        ###############################################################################################
        tabPanel(title="Background Questions",value="presurvey",
                 htmlOutput("pre")
        ),
        
        
        
        
        #####################################################################################################################################################################
                             tabPanel(title="Step 1",value="step1",
                                      
                                     
                                      
                                    
                                      column(
                                               
                                               h1("What Facebook Thinks You're Interested In",style="color:black;text-align:center;"),
                                               br(),
        
                                               uiOutput(outputId = "uploadedimage3",align="center"),
                                               br(),
                                               width=12
                                               
                                      ),
                                                
                                      
                                      column(
                                              
                                              br(),br(),
                                              h3("Upload the file titled ", strong('ads_and_businesses/ads_interests.json') ,br()," from the Facebook Download folder:",
                                              align="left"),
                                              br(),
                                              img(src="adsinterest2.png",width="50%"),
                                              br(),
                                              fileInput("adsfile", "Choose File",
                                                        multiple = FALSE,
                                                        accept = c(".json"))
                                              ,
                                              width=8,offset=2),
        
                                        
                                              fluidRow(
                                                      column(5,offset=2, 
                                                             hidden(div(id="arrange",p("These have been arranged in random order.",style="color:#4287f5;"), p("You can Search, Sort, and click on Interests to select them. To deselect, just click it again."))),br(),
                                                             DT::dataTableOutput('maketable')),
                                                             br(),br(),
                                                      hidden(div(id="choose",column(5,
                                                                                column(1,img(src="zooming-arrow.gif",height="100px",width="140px")),
                                                                                column(10,offset=1,
                                                                                                                                                                 
                                                                                h3("Choose the interests that actually apply to you by clicking on them in the table. We will use this data for the rest of the tutorial. Look through as many as you like, but ultimately Choose 7.",style="font-weight: bold;color:#4287f5"),verbatimTextOutput('x4'),
                                                                                #hidden(actionButton("done","Next",style="font-size:17pt;float:right;"))
                                                                                )))),
                                                      
                                              ),br(),br(),
                                      actionButton("introback", "Back",style="margin-bottom:4%;font-size:17pt;float:left;"),
                                      disabled(actionButton("done", "Next",style="margin-bottom:4%;font-size:17pt;float:right;")),
                                      
                                                
                                              
                                                
                                               
                                                
                                        
                             ),
        
                                      
                             
                        
 
       
        
        tabPanel(title="Step 2",value="step2",
                 
                 
                 column(width = 12, 
                        
                        h1("What Would the Algorithm Recommend?",style="color:black;text-align:center"),
                        br(),
                        p("Imagine that you have a new friend on Facebook. What do you think the algorithm would recommend to you from this new friend, based on the interests below?"),align="center"),
                 br(),
                 
                 div(column(4,
                            div(textOutput("newfriend"),style="text-align:center;",
                                br(),
                                uiOutput("newfriendimage",align="center")),
                            br(),
                            div(verbatimTextOutput("renderother"),style="margin-top:10px;text-align:left;"),
                            style="text-align:left;")),
                 div(column(4,
                            
                            div(textOutput("username_3"),style="text-align:center;",
                                br(),
                                uiOutput("renderuserimage3",align="center")),
                            br(),
                            div(verbatimTextOutput("collect3"),style="margin-top:10px;text-align:left;"),
                            style="text-align:left;")),
                
                 
                 div(column(4,
                        hr(),
                        p("Select the interests that would be recommended to you from your new friend:"),
                        selectInput('selectedrecs', 'Options', choices=NULL, multiple=TRUE, selectize=TRUE)
                 ),
                 
               br()),
        
                 column(width=12,
                
                         br(),
                        actionButton("step8back", "Back",style="margin-bottom:4%;font-size:17pt;float:left;"),
                        actionButton("step8next", "Next",style="margin-bottom:4%;font-size:17pt;float:right;"),
                        br(),align="center",style="text-align:center;"
                 
                 ))
                 
                 
                 
        ,
        
        tabPanel(title="Post-Survey",value="postsurvey",
                 htmlOutput("post")
        )
              
                  
)))