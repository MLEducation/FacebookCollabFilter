div(class = 'container',
    
    div(class = 'col-sm-8',
        h2("5. Have you ever downloaded data about yourself from a social platform before?"),
        radioButtons("download","", choices = c("None Selected","Yes","No")),
        br(),
        h2("6. If yes, what did you download and what did you do with it?"),
        textInput("downloadexplain",""),
        br(),
        h2("7. Do you trust Facebook to work as you expect it to, functioning to allow you to complete the tasks you want to do?"),
        radioButtons("trust1","", choices = c("None Selected","Yes","No","Maybe")),
        br(),
        h2("8. Do you trust that Facebook's algorithms have the ability to recommend things to you that you actually like?"),
        radioButtons("trust2","", choices = c("None Selected","Yes","No","Maybe")),
        br(),
        h2("9. Do you trust that Facebook cares about its users and acts with their interests in mind?"),
        radioButtons("trust3","", choices = c("None Selected","Yes","No","Maybe")),
        br(),
        
       
        actionButton("demo_part2", "Next",style="font-size:17pt;float;right;"),
        br()
    )
)