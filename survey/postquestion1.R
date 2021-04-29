div(class = 'container',
    
    div(class = 'col-sm-8',
        h2("1. After participating in this study, would you be willing the share the data you just downloaded of what Facebook thinks you're interested in if it were anonymized? "),
        h3("Please check all options you would be comfortable sharing anonymized data with."),
        checkboxInput("checkbox1post", label = "University Researchers", value = FALSE),
        checkboxInput("checkbox2post", label = "Company Marketing Teams", value = FALSE),
        checkboxInput("checkbox3post", label = "Other Apps in Your Phone (send to those companies)", value = FALSE),
        checkboxInput("checkbox4post", label = "Political Campaigns", value = FALSE),
        checkboxInput("checkbox5post", label = "Government Organizations", value = FALSE),
        checkboxInput("checkbox6post", label = "I would not be willing to share it", value = FALSE),
        textInput("writeinpost",label="Other"),
        br(),
        actionButton("block_twopost", "Next",style="font-size:17pt;float;right;"),
        br()
    )
)