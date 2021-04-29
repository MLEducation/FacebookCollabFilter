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
         tags$head(tags$style(HTML(" #thenav li a[data-value = 'first'],
                                   #thenav li a[data-value = 'home'],
                                   #thenav li a[data-value = 'intro'], 
                                   #thenav li a[data-value = 'intro2'],
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
                   
                   
    
       ###############################################################################################
        tabPanel(title="First",value="first",
                            fluidRow(column(tags$img(src="lookingdata.png",width="150px",height="150px",style="float:right;"),width=2,offset=1),
                                     column(
                             
                              
                            
                              h1("How does Facebook learn what you are interested in?",style="color:black;"),
                              
                              textOutput("variableintro"),
                              tags$head(tags$style("#variableintro{color: black;
                                        font-size: 20px;
                                        }"
                              )
                              ),
                              br(),
                              p("You will download your own Facebook data, with instructions on the next screen. While you are waiting, you can proceed to fill out a short questionnaire. Then you will follow through the study, and finish with just 4 more questions."),
                              br(),
                              p("This research study is completely voluntary, and you can stop at any time. We do NOT save any of your personal data."),
                              br(),
                                
                               p("As of 2021, this web app is no longer collecting responses, but you can still participate. The survey sections will eventually be removed, leaving only the tutorial.",style="font-weight:normal;color:red;"),
                              actionButton("firstnext", "Next",style="margin-bottom:4%;font-size:17pt;float:right;"),
                              br(),
                              width=8,offset=2))
                   ),
                   
        #####################################################################################################################################################################
        tabPanel(title="Download Data",value="home",
                 
                 
                 fluidRow(column(tags$img(src="lookingdata.png",width="150px",height="150px",style="float:right;"),width=2,offset=1),
                          column(
                                  
                  
                                  
                                  h3("Before we get started, we need you to download some of your personal data from Facebook (follow the steps below). We do not save any of your personal Facebook data for this research study. It is for you to look at only. "),
                                  
                                  width=6),
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
                        p("Your data may take a few minutes to download from Facebook. Meanwhile, please click Next to answer some short questions for us.  Remember this is your personal data and we will not save it as part of this research study."),
                        br(),
                        actionButton("homeback", "Back",style="margin-bottom:4%;font-size:17pt;float:left;"),
                        actionButton("homenext", "Next",style="margin-bottom:4%;font-size:17pt;float:right;"),
                        br(),
                         width=8),
                         
                          
                      
                 
                        
                                     
                             ),
                 ),
  
        
        ###############################################################################################
        tabPanel(title="Background Questions",value="presurvey",
                 htmlOutput("pre")
        ),
        
        
        ###############################################################################################
        tabPanel(title="Intro",value="intro",
                 column(
                         h2("Facebook collects a lot of data about you. They use this data to organize your news feed, recommend advertisements, suggest new friends, and more.",align="left"),
                         tags$ul(
                                 tags$li("Coming up, you will see your own data, but it is for you to look at only. We will not see it.",style="font-size:16pt;"), 
                                 tags$li("Please look through as many pages of your data as you like, but ultimately you will choose 7 interests to work with in the lesson.",style="font-size:16pt;"), 
                                 
                         ),
                         
                         br(),
                         actionButton("introback", "Back",style="margin-bottom:4%;font-size:17pt;float:left;"),
                         actionButton("intronext", "Next",style="margin-bottom:4%;font-size:17pt;float:right;"),
                         br(),
                         
                         width=8,offset=2)
        ),
        
        #####################################################################################################################################################################
        ###############################################################################################
        tabPanel(title="Intro",value="intro2",
                 column(
                        
                 
                         h3("To get started, upload an image you'd like to use for yourself and fill in your name. This will allow you to personalize your experience and remember who is who in the tutorial. We will not save this image or your name. "),
                         p("You may opt not to add an image, and we will use the default image instead. Just click Next to continue."),
                         textInput("user", "What is your name?", "MyName"),
                         fileInput("myFile", "Choose a file", accept = c('image/png', 'image/jpeg')),
                         uiOutput(outputId="uploadedimage"),
                         br(),br(),
                         actionButton("intro2back", "Back",style="margin-bottom:4%;font-size:17pt;float:left;"),
                         actionButton("intro2next", "Next",style="margin-bottom:4%;font-size:17pt;float:right;"),
                         br(),
                         
                         width=8,offset=2)
        ),
        
        #####################################################################################################################################################################
                             tabPanel(title="Step 1",value="step1",
                                      
                                     
                                      
                                    
                                      column(
                                               
                                               h1("What Facebook Thinks You're Interested In",style="color:black;text-align:center;"),
                                               br(),
                                        div(
                                               uiOutput(outputId = "uploadedimage3",align="center"),
                                               textOutput("username1")
                                           ,style="text-align:center;"),
                                               
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
                                      actionButton("step1back", "Back",style="margin-bottom:4%;font-size:17pt;float:left;"),
                                      disabled(actionButton("done", "Next",style="margin-bottom:4%;font-size:17pt;float:right;")),
                                      
                                                
                                              
                                                
                                               
                                                
                                        
                             ),
        
                                      
                             
        
        
        ############################################
        ########################################################################################
                        
        ###################################################################################################################################################
                             
                             tabPanel(title="Step 2",value="step2",
                                      
                                      fluidRow(column(width=2),
                                               column(
                                                       h1("Let's Make Friends",style="color:black;text-align:center"),
                                                       width=8),
                                      ),
                                      br(),
                                      fluidRow(column(width=2,align="center"),
                                               column(width=8,
                                                      div( uiOutput(outputId = "uploadedimage2",align="center") ,br(),
                                                          
                                                          p("My Selected Interests:"),style="text-align:center;"),
                                                      
                                                      verbatimTextOutput("collect"),br(),
                                                      p("Imagine the people below are some of your friends on Facbeook. We will use these friends and their interests to learn how Facebook's algorithms guess at your likely interests.  ",style="color:black;text-align:center"),
                                                      br(),
                                                      p(strong("Write in the names of your 'friends' below."),style="text-align:center;"),
                                                      p("(it helps you to remember who is who)",style="text-align:center;"),
                                                      div(actionButton("generate_avatar","Regenerate Avatars",style="margin-bottom:2%;margin-top:1%;font-size:12pt;"),style="text-align:center"),
                                                      div(
                                                              div(column(3,
                                                                         div(br(),
                                                                             textOutput("username"),
                                                                             uiOutput(outputId = "renderuserimage",align="center"),
                                                                             br(),
                                                                             #div(verbatimTextOutput("friend1"),style="margin-top:10px;text-align:left;"),
                                                                             style="text-align:center;"),
                                                                         style="text-align:center;")),
                                                              div(column(3,
                                                                         div(textInput("name1", "", "Friend1"),
                                                                         textOutput("name1value"),
                                                                         uiOutput(outputId = "friend1_image"),
                                                                         br(),
                                                                         #div(verbatimTextOutput("friend1"),style="margin-top:10px;text-align:left;"),
                                                                         style="text-align:center;"),
                                                                         style="text-align:center;")),
                                                              div(column(3,
                                                                         div(textInput("name2", "", "Friend2"),
                                                                             textOutput("name2value"),
                                                                             uiOutput(outputId = "friend2_image"),
                                                                             br(),
                                                                             #div(verbatimTextOutput("friend2"),style="margin-top:10px;text-align:left;"),
                                                                             style="text-align:center;"),
                                                                         style="text-align:center;")),
                                                              div(column(3,
                                                                         div(textInput("name3", "", "Friend3"),
                                                                             textOutput("name3value"),
                                                                             uiOutput(outputId = "friend3_image"),
                                                                             br(),
                                                                             #div(verbatimTextOutput("friend3"),style="margin-top:10px;text-align:left;"),
                                                                             style="text-align:center;"),
                                                                         style="text-align:center;")),
                                                              
                                                              br(),
                                                              br(),
                                                              
                                                              
                                                             
                                                             
                                                              
                                                              style="text-align: center;"),
                                                      br(),
                                                      br(),
                                                      actionButton("step2back", "Back",style="margin-bottom:4%;font-size:17pt;float:left;"),
                                                      actionButton("step2next", "Next",style="margin-bottom:4%;font-size:17pt;float:right;"),
                                                      br(),
                                                      style="text-align: center;" ),
                                               
                                      ),
                                      
                                      
                                      
                                ),
        ####################################################################################################################
        
        tabPanel(title="Step 3",value="step3",
                 
                 fluidRow(column(width=2),
                          column(
                                  h1("Your Friends' Generated Interests",style="color:black;text-align:center"),
                                  p("These friends each have some interests which may be similar to yours. Some interests might be identical, others might be close or related in some way. For this lesson, they are not true friends from Facebook, but imagined friends we created for this study. On Facebook, the algorithm would have access to the real information about your friends and their friends, but we are not using that information in this study.",style="color:black;text-align:justify"),
                                  br(),
                                  width=8),
                 ),
                 br(),
                 
                          column(width=12,
                                 div(
                                         div(column(3,
                                                    
                                                    div(textOutput("username_2"),style="text-align:center;",
                                                        uiOutput("renderuserimage2",align="center"),),
                                                    br(),
                                                    div(verbatimTextOutput("collect2"),style="margin-top:10px;text-align:left;"),
                                                    style="text-align:left;")),
                                         div(column(3,
                                                   
                                                    div(textOutput("name1value_2"),style="text-align:center;",
                                                    uiOutput("friend1_image2"),),
                                                    br(),
                                                    div(verbatimTextOutput("friend1_2"),style="margin-top:10px;text-align:left;"),
                                                    style="text-align:left;")),
                                         div(column(3,
                                                    
                                                    div(textOutput("name2value_2"),style="text-align:center;",
                                                    uiOutput(outputId = "friend2_image2"),),
                                                    br(),
                                                    div(verbatimTextOutput("friend2_2"),style="margin-top:10px;text-align:left;"),
                                                    style="text-align:left;")),
                                         div(column(3,
                                                   
                                                    div(textOutput("name3value_2"),style="text-align:center;",
                                                    uiOutput(outputId = "friend3_image2"),),
                                                    br(),
                                                    div(verbatimTextOutput("friend3_2"),style="margin-top:10px;text-align:left;"),
                                                    br(),br(),
                                                    style="text-align:left;")),
                                         
                                         
                                         
                                         
                                         
                                         style="text-align: center;"),
                                 br(),
                                 
                                 
                                 br(),
                                 
                                 
                                
                                 style="text-align: center;"  ),
                 actionButton("step3back", "Back",style="margin-bottom:4%;font-size:17pt;float:left;"),
                 actionButton("step3next", "Next",style="margin-bottom:4%;font-size:17pt;float:right;")
                 
                          
                        
                 
                 
                 
        ),
        ###########################################################
        
        tabPanel(title="Step 4",value="step4",
                 
                 
                 column(width = 8,offset=2, 
                          column(
                                  h1("Where Do Interests Overlap?",style="color:black;text-align:center"),
                                  br(),
                                  p("This is how data often gets represented so that algorithms can make sense of it. This is a chart with the Friends across the top and the Interests along the side. A ",strong("0")," means that the friend in that column has", strong("NOT"),"shown interest in that thing. A ",strong("1")," means the friend ",strong("IS"), "interested in that thing."),
                                 br(),br()
                                  ,width=12),
                 
                 br(),
                 br(),
                 
                 
                      
                h3("Chart representation"),   
                br(),
                
                DT::dataTableOutput("matrix"),
                br(),
                h3("How would you determine which of these friends are the most similar to you?"),
                column(textAreaInput("aftermatrix","","",height="200px"),
                br(),
                radioButtons('whichradio', "Which friend is most similar to you?", c("1","2","3","I'm not sure", "They're all the same","None selected"),selected=c("None selected")),
                br(),
                align="center",width=12),
                br(),
                actionButton("step4back", "Back",style="margin-bottom:4%;font-size:17pt;float:left;"),
                actionButton("step4next", "Next",style="margin-bottom:4%;font-size:17pt;float:right;"),
                br(),align="center",style="text-align:center;")
                 
                 
                 
        ),
        
        
        ####################################################
        
   
        
        tabPanel(title="Step 5",value="step5",
                 
                 
                 column(width = 12, 
                       
                                h1("Network Vizualization",style="color:black;text-align:center"),
                                br(),
                                p("This network visualization demonstrates which interests would be recommended to you."),align="center"),
                        
                       div(visNetworkOutput("network",height=700),
                        br(),
                        actionButton("step5back", "Back",style="margin-bottom:4%;font-size:17pt;float:left;"),
                        actionButton("step5next", "Next",style="margin-bottom:4%;font-size:17pt;float:right;"),
                        br(),align="center",style="text-align:center;")
                 
                 
                 
        ),
        ####################################################
        
        
        tabPanel(title="Step 6",value="step6",
                 
                 fluidRow(column(width=12,align="center"),
                          column(
                                  h1("Who is Most Similar to You?",style="color:black;text-align:center"),
                                  br(),
                                  p("We can actually count up the number of shared interests between friends. This is a measure of similarity. If you want to know more about that metric, it's called Cosine Similarity. But basically, friends who have more things in common with each other will get rated as more similar.",style="margin-left:20%;margin-right:20%;"),
                                  br(),
                                  br(),
                                  width=12),
                          column(
                                   width=12, align="center",tableOutput("combos"),
                                   br(),
                                   br(),
                                   tags$head(tags$style("#mostsimilar{color: #4287f5;
                                        font-size: 17px;
                                        }"
                                   )
                                   ),
                                   textOutput("mostsimilar"),
                                   br(),
                                   br()
                                   
                          ),
                          
                          br(),
                          actionButton("step6back", "Back",style="margin-bottom:4%;font-size:17pt;float:left;"),
                          actionButton("step6next", "Next",style="margin-bottom:4%;font-size:17pt;float:right;"),
                          br(),
                align="center" ),
               
                 
                 
                 
                 
                 
        ),
        
        #####################################################
        
        
        tabPanel(title="Step 7",value="step7",
                 
                 fluidRow(column(width=12,align="center"),
                          column(
                                  h1("New Recommendations for You",style="color:black;text-align:center"),
                                  br(),
                                  div(htmlOutput("explainsimilar"),style="font-size:14pt;"),
                                  br(),
                                  br(),
                                  width=12),
                          column(
                                  width=5, align="center",
                                  textOutput("similar1"),
                                  br(),
                                  uiOutput(outputId = "similarimage1"),
                                  br(),
                                  verbatimTextOutput("displaysimilarity1"),
                                  br()
                                  
                          ),
                          column(width=2,align="center",
                                 br(),br(),
                                 img(src="rightarrow.png",width="150px")
                                 ),
                          column(
                                  width=5, align="center",
                                  textOutput("similar2"),
                                  br(),
                                  uiOutput(outputId = "similarimage2",align="center"),
                                  br(),
                                  verbatimTextOutput("displaysimilarity2"),
                                  br()
                                  
                          ),
                          column(
                                  width=12, align="center",
                                  div(htmlOutput("recommend"),style="font-size:14pt;"),
                                  br(),
                                  tags$style(type='text/css', '#antijoin {background-color: rgba(144,238,144,0.40); color: black;}'),
                                 verbatimTextOutput("antijoin"),
                                  br()
                                  
                          ),
                          
                          br(),
                          actionButton("step7back", "Back",style="margin-bottom:4%;font-size:17pt;float:left;"),
                          actionButton("step7next", "Next",style="margin-bottom:4%;font-size:17pt;float:right;"),
                          br(),
                          br(),
                          
                          width=12,align="center")
                    
                 
                 
                 
                 
                 
        ),
        #####################################################
       
        
        tabPanel(title="Step 8",value="step8",
                 
                 
                 column(width = 12, 
                        
                        h1("What Would the Algorithm Recommend?",style="color:black;text-align:center"),
                        br(),
                        p("What do you think a collaborative filtering algorithm would recommend to you based on New Friend's interests?  Select the interests most likely to be recommended."),align="center"),
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
                        p("Recommended Interests (choose):"),
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