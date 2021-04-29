div(class = 'container',
   
    div(class = 'col-sm-8',
        h2("2. After participating in this study, how do you think Facebook comes up with the list of topics that it thinks you might be interested in?"),
        textAreaInput("postquestion2", "", "",rows=10,cols=50),
        actionButton("block_threepost", "Next",style="font-size:17pt;float;right;"),
        br()
    )
)