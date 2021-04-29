#open ended, baseline
div(class = 'container',
    
    div(class = 'col-sm-8',
        h2("12. How do you think Facebook comes up with the list of topics that it thinks you might be interested in? Brainstorm as many ideas as you can."),
        h3("e.g. they gather data from what you click on"),
        textAreaInput("question2", "","",rows=10,cols=50),
        actionButton("block_three", "Next",style="font-size:17pt;float;right;"),
        br()
    )
)