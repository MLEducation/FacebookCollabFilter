div(class = 'container',
    
    div(class = 'col-sm-8',
        h2("1. How old are you?"),
        radioButtons("age","", choices = c("None Selected","Under 20","21-36","37-45","Over 45")),
        br(),
        h2("2. How often do you use Facebook?"),
        radioButtons("fboften","", choices = c("None Selected",
                                               "I hardly use Facebook",
                                               "A couple times a month",
                                               "About once a week",
                                               "Every day"
                                               )),
        br(),
        
       
        h2("3. How true does this statement feel to you?"),
        h2("''I understand how ads get recommended to me on Facebook''"),
        radioButtons("understandrating","", choices = c(
                                                "None Selected",
                                                "Strongly Disagree",
                                               "Disagree",
                                               "Neither Agree nor Disagree",
                                               "Agree",
                                               "Strongly Agree"),
                    ),
        br(),
        h2("4. Which of the following best describes your experience with Data Science, Computer Science, and/or Machine Learning?"),
        radioButtons("experience","", choices = c("None Selected","I don't know anything about any of those topics.",
                                                        "I have a vague idea of how some of those things work, but with no formal instruction.",
                                                        "I have taken classes in any of those subjects.",
                                                        "I know a fair amount about those topics.",
                                                        "My job is in Data Science, Computer Science, and/or Machine Learning (e.g. I have the title of Data Scientist, or do Machine Learning work regularly)")),
        br(),
        actionButton("demo_block", "Next",style="font-size:17pt;float;right;"),
        br()
    )
)
