
div(class = 'container',
    
    div(class = 'col-sm-8',
        h2("11. Would you be willing to share data of what Facebook thinks you're interested in if it were anonymized? (e.g. the file you downloaded at the beginning of this study)"),
        h3("Please check which groups you would be willing to share with."), checkboxInput("checkbox1", label = "University Researchers", value = FALSE),
        checkboxInput("checkbox2", label = "Company Marketing Teams", value = FALSE),
        checkboxInput("checkbox3", label = "Other Apps in Your Phone (send to those companies)", value = FALSE),
        checkboxInput("checkbox4", label = "Political Campaigns", value = FALSE),
        checkboxInput("checkbox5", label = "Government Organizations", value = FALSE),
        checkboxInput("checkbox6", label = "I would not be willing to share it", value = FALSE),
        textInput("writein",label="Other"),
        br(),
        actionButton("block_two", "Next",style="font-size:17pt;float;right;"),
        br()
    )
)