#open ended, baseline
div(class = 'container',
    
    div(class = 'col-sm-8',
        h2("How do you think Facebook decides what to recommend to you for new ads?"),
        textAreaInput("question3","" ,"",rows=10,cols=50),
        actionButton("block_four", "Next",style="font-size:17pt;"),
        br()
    )
)