library(shiny)
library(shinythemes)
library(shinyjs)
library(DT)
library(ggplot2)
library(car)
library(nortest)
library(tseries)
library(RcmdrMisc)
library(lmtest)
library(jsonlite)
library(tidyverse)
library(lubridate)
library(mongolite)
library(data.table)
library(visNetwork)

jscode <- "
shinyjs.disableTab = function(name) {
  var tab = $('.nav li a[data-value=' + name + ']');
  tab.bind('click.tab', function(e) {
    e.preventDefault();
    return false;
  });
  tab.addClass('disabled');
}

shinyjs.enableTab = function(name) {
  var tab = $('.nav li a[data-value=' + name + ']');
  tab.unbind('click.tab');
  tab.removeClass('disabled');
}
"

css <- "
.nav li a.disabled {
  background-color: #aaa !important;
  color: #333 !important;
  cursor: not-allowed !important;
  border-color: #aaa !important;
}"


options(mongodb = list(
  "host" = "",
  "username" = "",
  "password" = ""
)
)

databaseName <- "shinydatabase"
collectionName <- "responses"

saveData <- function(data) {
  # Connect to the database
  db <- mongo(collection = collectionName,
              url = sprintf(
                "mongodb+srv://%s:%s@%s/%s",
                options()$mongodb$username,
                options()$mongodb$password,
                options()$mongodb$host,
                databaseName))
  # Insert the data into the mongo collection as a data.frame
  data <- as.data.frame(data)
  db$insert(data)
}

loadData <- function() {
  # Connect to the database
  db <- mongo(collection = collectionName,
              url = sprintf(
                "mongodb+srv://%s:%s@%s/%s",
                options()$mongodb$username,
                options()$mongodb$password,
                options()$mongodb$host,
                databaseName))
  # Read all the entries
  data <- db$find()
  data
  return(data)
}

OPTIONS = 7





cosine_similarity <- function(a,b){
  crossprod(a,b)/sqrt(crossprod(a) * crossprod(b))
}

##########################################################################################
shinyServer(function(input, output,session) {
  
  #HERE IS GENERATING THE CONDITION
  CONDITION = as.factor(sample(c("Treatment"),1))
  #for the intro
  output$variableintro <-  renderText({ 
    
    if(CONDITION=="Treatment"){ 
      "In this research study, we will walk you through an interactive data science lesson. It will introduce you to one of the algorithms that works behind the scenes to help companies like Facebook learn about you, its user, in order to show content and ads you are likely to be interested in."
    }
    else if(CONDITION=="Control"){
      "In this research study, you will explore what Facebook thinks you are interested in by looking through your personal Facebook data. Facebook uses this data to determine what ads and content you see on their platform."
    }
    
  })
  
 
values <- reactiveValues( response_data=NULL
  
)

images_and_names <- reactiveValues( imagesdf=NULL
                          
)

observeEvent(input$adsfile,{
  shinyjs::show("arrange")
  shinyjs::show("choose")
})
 makedata <- reactive({
    req(input$adsfile)
   
    
   
    tryCatch(
      {
        
        thedata <- fromJSON(input$adsfile$datapath)
        
        thedata <-as.data.frame(thedata)
        names(thedata)<-c("Interest")
        #set.seed(42)
        rows <- sample(nrow(thedata))
        shuffle <- as.data.frame(thedata[rows,])
        names(shuffle)<-c("Interest")
        
       return(shuffle)
        
        
        
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
      
      
    )
   
  })
 

 

    
grab_answer_from_matrx <- reactive({
  
   
   values$response_data$HowMatrix <-as.character(input$aftermatrix)
   
   
 })

observeEvent(input$whichradio,{
  
  values$response_data$SelectedSimilar <- as.character(input$whichradio)
  
  #we also need to record the correct answer, this should be the friend with the highest similarity
  d<- get_cosine_similarity()[1,]
  
  
  name <- str_extract(d$Name1,"(\\w+)") #friend
  othername <- str_extract(d$Name2,"(\\w+)") #me
  similarity <-round( d[3],2)
  values$response_data$CorrectSimilar <- as.character(name)
  
})

output$maketable <- DT::renderDataTable(
  
  {makedata()},server=TRUE,options=list(pageLength=15),
  
  
)

output$newfriendimage <- renderUI({
  div(tags$img(src = "newfriend.png",width="100px"),height="100px",class="cover")
  
})

output$renderuserimage <- output$renderuserimage2 <- output$renderuserimage3 <-renderUI({
  srcstring = img()
  
  if(!is.null(input$userphoto)){
    req(input$userphoto)
    #print(input$userphoto$datapath)
    srcstring = gsub("\\\\", "/", input$userphoto$datapath)
    #print(srcstring)
    
  }
  else{
    srcstring=img()
  }
  
  
  div(tags$img(src = srcstring,width="100px"),height="100px",class="cover")
  
})



regenerate_avatar <- function(){
  friend_imgs <- c("friend1.png","friend2.png","friend3.png","friend4.png","friend5.png","friend6.png","friend7.png","friend8.png","friend9.png","friend10.png",
                   "friend11.png","friend12.png","friend13.png","friend14.png","friend15.png","friend16.png","friend17.png","friend18.png","friend19.png","friend20.png",
                   "friend21.png","friend22.png","friend23.png","friend24.png","friend25.png","friend26.png","friend27.png")
  
  choices <- sample(friend_imgs,3)
  labels <- c("Friend1","Friend2","Friend3")
  
  images_and_names$imagesdf$Name = c(input$name1,input$name2,input$name3)
  images_and_names$imagesdf$Image = choices
  
  

  output$friend1_image <- output$friend1_image2 <-renderUI({
    srcstring = as.character(images_and_names$imagesdf$Image[images_and_names$imagesdf$Name==input$name1])
    
    tags$img(src = srcstring,width="100px")
  })
  output$friend2_image <- output$friend2_image2 <- renderUI({
    
    srcstring = as.character(images_and_names$imagesdf$Image[images_and_names$imagesdf$Name==input$name2])
    
    tags$img(src = srcstring,width="100px")
  })
  
  output$friend3_image <- output$friend3_image2 <- renderUI({
    
    srcstring = as.character(images_and_names$imagesdf$Image[images_and_names$imagesdf$Name==input$name3])
    
    tags$img(src = srcstring,width="100px")
  })
  
}




# print the selected indices
output$x4 = renderPrint({
  s = input$maketable_rows_selected
    
    cat('The interests you chose:\n\n')
    cat(as.character(makedata()$Interest[s]),sep="\n",fill=TRUE)
    
    
    shinyjs::disable("done")
    
    
    if(length(s)==OPTIONS){
      shinyjs::enable("done")
      
    }
  
})

observeEvent(input$done,
             {
               if(CONDITION=="Treatment"){
               updateTabsetPanel(session, "thenav",
                                 selected = "step2")
               }
               else if(CONDITION =="Control"){
                 updateTabsetPanel(session, "thenav",
                                   selected = "step8")
               }
               
               updateSelectInput(session, "selectedrecs",
                                 
                                 
                                 choices = sort(unique(c("Type to Select",collect(), othersample()))),
                                 selected = "Type to Select"
                                 )
               write.csv(values$response_data,'responses.csv')
               
             })


collect <- reactive({
  return(as.character(makedata()$Interest[input$maketable_rows_selected]))
  
})
output$collect <-output$collect2<- output$collect3 <- renderPrint({
                  cat("\n")
                  cat(
                    sort(collect()),sep="\n")
          })


observeEvent(input$name1,
             { 
               images_and_names$imagesdf$Name[1] = trimws(input$name1)
              
             })
observeEvent(input$name2,
             { 
               images_and_names$imagesdf$Name[2] = trimws(input$name2)
               
             })

observeEvent(input$name3,
             { 
               images_and_names$imagesdf$Name[3] = trimws(input$name3)
               
             })


RollDie <- reactive({
  #actually we could make this fixed and then just shuffle it so it's different friends (not always the first friend)
  thesample <- sample(c(OPTIONS-2, OPTIONS-4,OPTIONS-5))
   #return(sample(3:OPTIONS-2,3,replace=F))
  return(thesample)
  })

sample1 <- reactive({
  N = RollDie()[1]
  rest = OPTIONS - N
  
  restdata <- makedata()%>%
    filter(!(row_number() %in% input$maketable_rows_selected))
  
  
  sameasyou <- sample(as.character(makedata()$Interest[input$maketable_rows_selected]),N,replace=F)
  therest <- sample(as.character(restdata$Interest),rest,replace=F)
  sample <- c(sameasyou,therest)
  return(sort(sample))
})


sample2 <- reactive({
  N = RollDie()[2]
  rest = OPTIONS - N
  restdata <- makedata()%>%
    filter(!(row_number() %in% input$maketable_rows_selected))
  sameasyou <- sample(as.character(makedata()$Interest[input$maketable_rows_selected]),N,replace=F)
  therest <- sample(as.character(restdata$Interest),rest,replace=F)
  sample <- c(sameasyou,therest)
  return(sort(sample))
})

sample3 <- reactive({
  N = RollDie()[3]
  rest = OPTIONS - N
  restdata <- makedata()%>%
    filter(!(row_number() %in% input$maketable_rows_selected))
  sameasyou <- sample(as.character(makedata()$Interest[input$maketable_rows_selected]),N,replace=F)
  therest <- sample(as.character(restdata$Interest),rest,replace=F)
  sample <- c(sameasyou,therest)
  return(sort(sample))
  })

output$friend1 <- output$friend1_2 <- renderPrint({
  
  cat("\n")
  cat(sample1(),sep="\n")
})



output$friend2 <- output$friend2_2 <-renderPrint({
  
  cat("\n")
  cat(sample2(),sep="\n")
})


output$friend3 <- output$friend3_2 <-renderPrint({
  
  cat("\n")
  cat(sample3(),sep="\n")
})



#literally a github issue of duplicate bindings not my fault
output$name1value <- output$name1value_2 <- renderText({ input$name1 })
output$name2value <- output$name2value_2 <- renderText({ input$name2 })
output$name3value <- output$name3value_2 <- renderText({ input$name3 })
output$username <- output$username1 <-output$username_2 <-output$username_3 <-renderText({ input$user })

output$newfriend <- renderText("New Friend")


common <- reactive({
  common1_2 <- Reduce(intersect, list(sample1(),sample2()))
  common1_3 <- Reduce(intersect, list(sample1(),sample3()))
  common2_3 <- Reduce(intersect, list(sample2(),sample3()))
  common1_2_3 <- Reduce(intersect, list(sample1(),sample2(),sample3()))
  
  return(c(common1_2,common1_3,common2_3,common1_2_3))
  
  
})

common1_2_3 <- reactive({
  return(Reduce(intersect, list(sample1(),sample2(),sample3())))
})

output$incommon <- renderPrint({
  if(length(common1_2_3())){
 
  cat(common1_2_3(),sep="\n")
  }
  
  else{
    cat("Nothing")
  }
  
  
})

make_matrix <- reactive({
  
  friends<-c(rep(input$name1,length(sample1())),
             rep(input$name2,length(sample2())),
             rep(input$name3,length(sample3())),
             rep(input$user,length(collect()))
             
             )
  #print(friends)
  prefs <-c(sample1(),sample2(),sample3(),collect())

  
  data <- data.frame(friends,prefs)

 
  data<-as.data.frame(table(friends,prefs))
  data <- data %>% 
    rename(
      Ad_Preferences = prefs
    )
  
  d <- spread(data,friends,Freq)
  
  
  
  return (d)
})

flip_data <- reactive({
  friends<-c(rep(input$name1,length(sample1())),
             rep(input$name2,length(sample2())),
             rep(input$name3,length(sample3())),
             rep(input$user,length(collect()))
             
  )
  prefs <-c(sample1(),sample2(),sample3(),collect())
  data <- data.frame(friends,prefs)
  
  data<-as.data.frame(table(friends,prefs))
  data <- data %>% 
    rename(
      Ad_Preferences = prefs
    )
  
  d <- spread(data,Ad_Preferences,Freq)
  
  return(d)
  
})

get_cosine_similarity <- reactive({
  
  
  names <- levels(flip_data()$friends)
  
  combos<- as.data.frame(combn(names,2))
  
  #we have our combos and we need to get the cosine similarity between each of them
  newframe <- list()
  
  
  for (c in 1:length(combos)){
    
    
    #c[1],c[2]
    firstname <- as.character(combos[[c]][1])
    
    secondname <- as.character(combos[[c]][2])
    #print(paste(firstname,secondname))
    #we need to extract the vectors from the matrix
    first_data <- as.matrix(flip_data()[flip_data()$friend==firstname,])
    
    first_data <-first_data[-(1:2)]
    
    second_data <- as.matrix(flip_data()[flip_data()$friend==secondname,])
    second_data <-second_data[-(1:2)]
    cs <- cosine_similarity(as.numeric(first_data),as.numeric(second_data))
    #print(cs[1])
    temp <-data.frame(name1=firstname,name2=secondname,cossim=cs)
    newframe[[c]] <- temp
    
  }
  data = do.call(rbind, newframe)
  data <- as.data.frame(data)
  data <- data %>%
    arrange(desc(cossim))
  
  
  
  
  colnames(data) <- c("Name1", "Name2", "Similarity (0-1)")
  data$Name1 <- as.character(data$Name1)
  data$Name2 <- as.character(data$Name2)
  
  if(data$Name2[1] != input$user){
    
     tempfriendname <- str_extract(data$Name2[1],"(\\w+)") 
     data$Name1[1] = tempfriendname
     data$Name2[1] = input$user
    
     
  }
  
  #rank by cosine similarity
 
  
  return(data)
  
})

  


output$combos <-renderTable(
  #organize where the name is
  get_cosine_similarity()
)

output$mostsimilar <- renderPrint({
  d<- get_cosine_similarity()[1,]
  
  
  name <- str_extract(d$Name1,"(\\w+)") #we need to make sure name 1 is the friend and name2 is yourself
  othername <- str_extract(d$Name2,"(\\w+)") 
  similarity <-round( d[3],2)
  
  
  cat(
    paste("The friends with the most in common are " ,name, " and ", othername, " with a similarity of: ", similarity)
  )
})

output$explainsimilar <- renderPrint({
  d<- get_cosine_similarity()[1,]
  
 
  name <- str_extract(d$Name1,"(\\w+)") #friend
  othername <- str_extract(d$Name2,"(\\w+)") #me
  similarity <-round( d[3],2)
 
  
  cat(
    paste("Because <strong>" ,name, "</strong> and <strong>", othername, "</strong> are most similar, now we can recommend Ads to <strong>", othername, "</strong> based on <strong>", name,"</strong>'s Interests. That is a very simple explanation of the collaborative filtering algorithm.")
  )
})

output$recommend <- renderPrint({
  d<- get_cosine_similarity()[1,]
  
  
  name <- str_extract(d$Name1,"(\\w+)") 
  othername <- str_extract(d$Name2,"(\\w+)") #needs to be me
  similarity <-round( d[3],2)
  
  cat(
    paste("Recommend to <strong>" ,othername, "</strong><br> from <strong>", name, "'s</strong> Interests:<br>")
    
  )
  
})

makedataagain <- reactive({
  friends<-c(rep(input$name1,length(sample1())),
             rep(input$name2,length(sample2())),
             rep(input$name3,length(sample3())),
             rep(input$user,length(collect()))
             
  )
  prefs <-c(sample1(),sample2(),sample3(),collect())
  data <- data.frame(friends,prefs)
  
  data<-as.data.frame(table(friends,prefs))
  
  
  return(data)
  
})

similarity1<-reactive({data<-makedataagain()
d<- get_cosine_similarity()[1,]
name <- str_extract(d$Name1,"(\\w+)") 
othername <- str_extract(d$Name2,"(\\w+)") 
similarity <-round( d[3],2)


interests1 <-  data %>%
  filter(friends==name,Freq==1)

return(interests1)
  
})

output$displaysimilarity1 <- renderPrint({
  
  
  interests1<-similarity1()
  interests1<-as.character(interests1$prefs)
  
  cat(interests1,sep="\n")
  
})


output$similar1 <- renderPrint({
  d<- get_cosine_similarity()[1,]
  
  
  name <- str_extract(d$Name1,"(\\w+)") 
  cat(name)
})

output$similar2 <- renderPrint({
  d<- get_cosine_similarity()[1,]
  
  
  othername <- str_extract(d$Name2,"(\\w+)") 
  cat(othername)
})

makenetwork <- reactive({
  
  
})

highlight <- function(text, search) {
  x <- unlist(strsplit(text, split = " ", fixed = T))
  x[tolower(x) == tolower(search)] <- paste0("<mark>", x[tolower(x) == tolower(search)], "</mark>")
  paste(x, collapse = " ")
}

similarity2<-reactive({
  data<-makedataagain()
  
  d<- get_cosine_similarity()[1,]
  
  
  name <- str_extract(d$Name1,"(\\w+)") 
  othername <- str_extract(d$Name2,"(\\w+)") 
  similarity <-round( d[3],2)
  
  interests2 <-  data %>%
    filter(friends==othername,Freq==1)
  
  return(interests2)
  
})

output$displaysimilarity2 <- renderPrint({

  interests2<-similarity2()
  interests2<-as.character(interests2$prefs)
  cat(interests2,sep="\n")
  
  
})

#display the antijoin of the two friends

output$antijoin <- renderPrint({
  not_in_common <- anti_join(similarity1(),similarity2(),by="prefs")
  not_in_common <-as.character(not_in_common$prefs)
  cat(not_in_common,sep="\n")
  
  
})

#the visNetwork
output$network <-renderVisNetwork({


  
  incommon <- merge(similarity2(),similarity1(),by="prefs")
  # these should be mapped to both users, because they are both interested in them
 
  
  nodes <- data.frame(id = 1:length(incommon$prefs), label = incommon$prefs, 
                      group = "In Common",font.size=c(20),level=2) #me
  
 
  
  #poorly named, overlap is the suggests
  
  overlap <- anti_join(similarity1(),similarity2(),by="prefs")
  
  
  length <- (length(overlap$prefs)+length(incommon$prefs)) #total length of dataframe
  ids<- seq(length(incommon$prefs)+1,length)
  
  
 
  nodes2<-data.frame(id = ids, label = overlap$prefs, 
                     group = "Suggest",font.size=c(20),level=2) #friend
  
  
  nodes <- rbind(nodes,nodes2)

  nodes$label <- as.character(nodes$label)
  nodes$group <- as.character(nodes$group)
  
  #friend1 ID is length+1
  friend1 <- c(length+1,as.character(similarity1()$friends[1]),"firstfriend",font.size=c(20),level=1) #friend
  nodes <- rbind(nodes,friend1)
  
  #my ID is length+2
  friend2 <- c(length+2,as.character(similarity2()$friends[1]),"secondfriend",font.size=c(20),level=3) #me
  nodes <- rbind(nodes,friend2)
  
  
  
  
  #for all the incommon, they go to both friends
  edges <- data.frame(from = 1:length(incommon$prefs), to = length+2,label="",color="black",arrows="",dashes=c("FALSE"),font.size=c(20)) #me
  edges2 <- data.frame(from = 1:length(incommon$prefs), to = length+1,label="",color="black",arrows="",dashes=c("FALSE"),font.size=c(20)) #friend
  edges <- rbind(edges,edges2)
  
  #the suggestions belong to the friend, and will be suggested to me
  
  ids <- nodes$id[nodes$group=="Suggest"]
  #print(ids)
  
  edges3<-data.frame(from=ids,to=length+1,label="",color="black",arrows="",dashes=c("FALSE"),font.size=c(20))
  edges <-rbind(edges,edges3)
  
  edges4<-data.frame(from=ids,to=length+2,label="Suggest",color="#39D11A",arrows="to",dashes=c("TRUE"),font.size=c(20))
  edges <-rbind(edges,edges4)
  
 
  
  edges$dashes <- as.logical(edges$dashes)
  #bug, we need to ENSURE myname is secondfriend
  
  
  imageforfriend <- images_and_names$imagesdf$Image[images_and_names$imagesdf$Name == similarity1()$friends[1]]
  
  

  
 graph <- visNetwork(nodes,edges,width="100%",height="100%") %>%
    visEdges(dashes = TRUE)%>%
    visGroups(groupname = "In Common",font.size=c(20)) %>%
    visGroups(groupname = "Suggest",color="#39D11A",font.size=c(20)) %>%
    visGroups(groupname = "firstfriend", shape = "circularImage", image=imageforfriend,size=50) %>%
    visGroups(groupname = "secondfriend", shape = "circularImage", image=img(),size=50) %>%
    visNodes(shapeProperties = list(useBorderWithImage = TRUE))%>%
    visOptions(selectedBy = "group")%>%
    visInteraction(dragNodes = TRUE, dragView = TRUE, zoomView = F) %>%
    visOptions(highlightNearest = list(enabled =TRUE, degree = 2, hover = TRUE)) %>%
    visLayout(randomSeed = 4, improvedLayout = TRUE) %>%
    addFontAwesome()%>%
    visHierarchicalLayout(direction = "LR", levelSeparation = 500)
 
 visExport(
   graph,
   type = "png",
   name = "mynetwork",
   label = "Export as png",
   background = "#fff",
   float = "right",
   style = "font-size:17pt;background-color:black;color:white;margin-top:2%;margin-right:20%;align:center;",
   loadDependencies = TRUE
 )
  
  
})

othersample <- reactive({
  #take new sample
  N = 4
  rest = OPTIONS - N
  restdata <- makedata()%>%
    filter(!(row_number() %in% input$maketable_rows_selected))
  sameasyou <- sample(as.character(makedata()$Interest[input$maketable_rows_selected]),N,replace=F)
  therest <- sample(as.character(restdata$Interest),rest,replace=F)
  sample <- c(sameasyou,therest)
  sample <- sort(sample)
  
 
  return(sample)
})



output$renderother <- renderPrint({
 cat("\n")
  cat(othersample(),sep="\n")
})


    
 
  


output$select <- renderPrint(input$selectedrecs)
  


# the matrix of Friends and their interests
output$matrix <- DT::renderDataTable(
  DT::datatable({
    make_matrix()
  },options=list(pageLength=21,sDom  = '<"top">lrt<"bottom">ip'),class = 'cell-border stripe',rownames = FALSE))

#get the similar people's images


output$similarimage1 <- renderUI({
  srcstring = images_and_names$imagesdf$Image[images_and_names$imagesdf$Name == similarity1()$friends[1]]
  tags$img(src = srcstring,width="100px")
  
})


output$similarimage2 <- renderUI({
  srcstring = img()
  div(tags$img(src = srcstring,width="100px"),class="cover")
  
})
# the choosing which pair they think is the most similar, needs to be populated with the names and correct answer

demographics <- function(...) {
  renderUI({ source("demographics.R", local = TRUE)$value })
}

demopart2 <- function(...) {
  renderUI({ source("demopart2.R", local = TRUE)$value })
}

marginalized <- function(...) {
  renderUI({ source("marginalized.R", local = TRUE)$value })
}
question_one <- function(...) {
  renderUI({ source("question1.R", local = TRUE)$value })
}

question_two <- function(...) {
  renderUI({ source("question2.R", local = TRUE)$value })
}

question_three <- function(...) {
  renderUI({ source("question3.R", local = TRUE)$value })
}

thanks <- function(...) {
  renderUI({ source("thanks.R", local = TRUE)$value })
}




render_page <- function(...,f, title = "test_app") {
  page <- f(...)
  renderUI({
    fluidPage(page, title = title)
  })
}

presurvey <- function(...) {
  args <- list(...)
  div(class = 'container', id = "presurvey",
     
      div(class = 'col-sm-8',
          h1("Background Questions"),
          p("There are 12 questions in this short survey. These questions will help us establish your current familiarity with the study topic. "),
          br(),
          actionButton("presurveyback", "Back",style="margin-right:10%;font-size:17pt;"),
          actionButton("block_one", "Start",style="font-size:17pt;")
      ))
  
}
  
  ## render the presurvey
  output$pre <- render_page(f = presurvey)
  
  observeEvent(input$block_one, {
    output$pre <- render_page(f = demographics)
    
  })
  observeEvent(input$presurveyback, {
    updateTabsetPanel(session, "thenav",
                      selected = "home")
   
    
  })
  
  observeEvent(input$demo_block, {
    output$pre <- render_page(f = demopart2)
   
  })
  
  observeEvent(input$demo_part2, {
    output$pre <- render_page(f = marginalized)
    
  })
  
  observeEvent(input$marginalized_block, {
    output$pre <- render_page(f = question_one)
    
  })
  
  observeEvent(input$block_two, {
    
    output$pre <- render_page(f = question_two)
    
  })
  
  observeEvent(input$block_three, {
    
    output$pre <- render_page(f = thanks)
    
    
  })
  
  
 
  create_unique_ids <- function( char_len = 7){
   
    pool <- c(letters, LETTERS, 0:9)
    
     # pre-allocating vector is much faster than growing it
    
    this_res <- paste0(sample(pool, char_len, replace = TRUE), collapse = "")
      
      
    
    return(this_res)
  }
  
  
  img <- reactive({
    f <- input$myFile
    if (is.null(f)){
      return("youarehere.png") }
    else{
    b64 <- base64enc::dataURI(file = f$datapath, mime = "image/png")
    return(b64)}
  })
  
  output$uploadedimage <-output$uploadedimage2 <-output$uploadedimage3<-renderUI({
    req(img())
    div(tags$img(src = img(),width="100px"),class="cover")
  })
  

  
  
  observeEvent(input$completed, {
    id <- create_unique_ids()
    
    values$response_data <- data.frame(matrix(ncol = 20, nrow = 0))
    
    
    names <- c('Subject','Condition','Age','FacebookOften','UnderstandingRating','DSExperience','DownloadedBefore','DownloadExplain','FunctionTrust','EffectiveRecommend','FBCare','Marginalized','Researchers', 'Marketing', 'OtherApps', 'Political', 'Government', 'NotWilling','Other','PreHowReccomend')
   
    colnames(values$response_data) <- names
    
    
    row <- c(id,as.character(CONDITION), input$age,input$fboften,input$regularly,input$understandrating,input$experience,input$download,input$downloadexplain,input$trust1,input$trust2,input$trust3,input$marginalized,input$checkbox1, input$checkbox2, input$checkbox3, input$checkbox4, input$checkbox5, input$checkbox6, input$writein,  input$question2)
    
    values$response_data[1, ] <-row
    
    
    updateTabsetPanel(session, "thenav",
                      selected = "intro")
 
    
    
    
  })
  
postquestion_one <- function(...) {
    renderUI({ source("postquestion1.R", local = TRUE)$value })
}

postquestion_two <- function(...) {
  renderUI({ source("postquestion2.R", local = TRUE)$value })
}

postquestion_three <- function(...) {
  renderUI({ source("postquestion3.R", local = TRUE)$value })
}

postquestion_four <- function(...) {
  renderUI({ source("postquestion4.R", local = TRUE)$value })
}

postquestion_five <- function(...) {
  renderUI({ source("postquestion5.R", local = TRUE)$value }) #thanks and goodbye
}


  postsurvey <- function(...) {
    args <- list(...)
    div(class = 'container', id = "postsurvey",
        div(class = 'col-sm-8',
            h1("Please complete this post survey."),
            p("Thank you for participating in this study. Please fill out 4 questions to complete the study. Make sure to hit Submit at the end."),
            br(),
            actionButton("postsurveyback", "Back",style="font-size:17pt;float:left;"),
            actionButton("postblock_one", "Start",style="font-size:17pt;float:right;")
        ))
    
  }
  
  ## render the postsurvey
  output$post <- render_page(f = postsurvey)
  
  observeEvent(input$postblock_one, {
    output$post <- render_page(f = postquestion_one)
    
    
  })
  
  # Who would you share your data with?
  
  observeEvent(input$block_twopost, {
    output$post <- render_page(f = postquestion_two)
    
    #collect from previous
    values$response_data$ResearchersPost <- input$checkbox1post
    
    values$response_data$MarketingPost <- input$checkbox2post
    
    values$response_data$OtherAppsPost <- input$checkbox3post
    
    values$response_data$PoliticalPost <- input$checkbox4post
    
    values$response_data$GovernmentPost <- input$checkbox5post
    
    values$response_data$NotWillingPost <- input$checkbox6post
    
    values$response_data$OtherPost <- input$writeinpost
    
  })
  
  # How does FB gather what you're interested in?
  observeEvent(input$block_threepost, {
    output$post <- render_page(f = postquestion_three)
    
    #collect from previous
    values$response_data$PostHowRecommend <- as.character(input$postquestion2)
   
    
  })
  
  # Was anything surprising in your data?
  observeEvent(input$block_fourpost, {
    output$post <- render_page(f = postquestion_four)
    
    #collect from previous
    values$response_data$Surprising <- as.character(input$postquestion3)
   
    
  })
  
  # Imagine harmful. What you gonna do?
  observeEvent(input$block_fivepost, {
    output$post <- render_page(f = postquestion_five)
    
    #collect from previous
    values$response_data$HarmfulScenario <- as.character(input$postquestion4)
    
    
    #saveData(values$response_data)
    
    
  })
  
  
  observeEvent(input$firstnext, {
    regenerate_avatar()
    updateTabsetPanel(session, "thenav",
                      selected = "home")
    
    
    
  })
  
  observeEvent(input$homeback, {
    regenerate_avatar()
    updateTabsetPanel(session, "thenav",
                      selected = "first")
    
    
    
  })
  observeEvent(input$homenext, {
    regenerate_avatar()
    updateTabsetPanel(session, "thenav",
                      selected = "presurvey")
    
    
    
  })
  observeEvent(input$intronext, {
    
    updateTabsetPanel(session, "thenav",
                      selected = "intro2")
    
    
    
  })
  observeEvent(input$intro2next, {
    
    updateTabsetPanel(session, "thenav",
                      selected = "step1")
    
    
    
  })
  
  observeEvent(input$intro2back, {
    
    updateTabsetPanel(session, "thenav",
                      selected = "intro")
    
    
    
  })
  
  observeEvent(input$step1back, {
    
    updateTabsetPanel(session, "thenav",
                      selected = "intro2")
    
    
    
  })
  observeEvent(input$introback, {
    
    updateTabsetPanel(session, "thenav",
                      selected = "home")
    
    
    
  })
  
 
  #only in treatment
  observeEvent(input$step2next, {
    updateRadioButtons(session,"whichradio",
    choices = c(input$name1,input$name2,input$name3, "I'm not sure", "They're all the same","None selected"),
    selected=c("None selected")
  )
    
   
    
   
    updateTabsetPanel(session, "thenav",
                      selected = "step3")
    
    
    
  })
  
  
  #only in treatment
  observeEvent(input$step2back, {
    
    updateTabsetPanel(session, "thenav",
                      selected = "step1")
    
    
    
  })
  
  #only in treatment
  observeEvent(input$step3next, {
    
    updateTabsetPanel(session, "thenav",
                      selected = "step4")
    
    
    
  })
  
  #only in treatment
  observeEvent(input$step3back, {
    
    updateTabsetPanel(session, "thenav",
                      selected = "step2")
    
    
    
  })
  
  #only in treatment
  observeEvent(input$step4next, {
    updateTabsetPanel(session, "thenav",
                      selected = "step5")
    
    
    
  })
  
  #only in treatment
  observeEvent(input$step4back, {
    
    updateTabsetPanel(session, "thenav",
                      selected = "step3")
    
    
    
  })
  
  #only in treatment
  observeEvent(input$step5next, {
    updateTabsetPanel(session, "thenav",
                      selected = "step6")
    
    
    
  })
  
  #only in treatment
  observeEvent(input$step5back, {
    
    updateTabsetPanel(session, "thenav",
                      selected = "step4")
    
    
    
  })
  

  #only in treatment
  observeEvent(input$step6next, {
    updateTabsetPanel(session, "thenav",
                      selected = "step7")
    
    
    
  })
  
  #only in treatment
  observeEvent(input$step6back, {
    
    updateTabsetPanel(session, "thenav",
                      selected = "step5")
    
    
    
  })
  
  
  #only in treatment
  observeEvent(input$step7next, {
    updateTabsetPanel(session, "thenav",
                      selected = "step8")
    
    
    
  })
  
  #only in treatment
  observeEvent(input$step7back, {
    
    updateTabsetPanel(session, "thenav",
                      selected = "step6")
    
    
    
  })
  
  #FROM NEW FRIEND TO POST SURVEY
  observeEvent(input$step8next, {
    updateTabsetPanel(session, "thenav",
                      selected = "postsurvey")
    
    #need to store the response for the new friend to me selected recommendations
    responses <- as.data.frame(input$selectedrecs,stringsAsFactors=FALSE) # the interest set the user chose
    colnames(responses) <- c("Item")
   
    
    othersample <- as.data.frame(othersample(),stringsAsFactors=FALSE)
    colnames(othersample) <- c("Item")
    
    
    collect <-as.data.frame(collect(),stringsAsFactors=FALSE)
    colnames(collect) <-c("Item")
   
    correct <-  anti_join(othersample,collect)   #the correct interest set 
   
 
    
    values$response_data$NewFriendSelected <- toString(
      responses$Item)
    values$response_data$NewFriendCorrect <- toString(correct$Item)
    
    
  })
  
  observeEvent(input$step8back, {
    
    if(CONDITION=="Treatment"){
      updateTabsetPanel(session, "thenav",
                        selected = "step7")
    }
    else if(CONDITION =="Control"){
      updateTabsetPanel(session, "thenav",
                        selected = "step1")
    }
    
   
    
    
    
  })
  
  #FROM POSTSURVEY TO NEW FRIEND PAGE
  observeEvent(input$postsurveyback, {
    
    updateTabsetPanel(session, "thenav",
                      selected = "step8")
    
    
    
  })
  
  
  #GO TO NETWORK GRAPH (STEP 5)
  observeEvent(input$step4next,{
    grab_answer_from_matrx()
  })


  observeEvent(input$generate_avatar,{
    regenerate_avatar()
    
    
  })
  
  

    
  })
