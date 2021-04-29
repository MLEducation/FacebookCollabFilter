div(class = 'container',
    
    div(class = 'col-sm-8',
        h2("10. Do you consider yourself a part of a marginalized group? For example, this researcher is nonbinary. Your answer will NOT be shared or linked to your identity. Please describe below. We really appreciate your vulnerability. You may also choose to write 'Prefer not to say'"),
        textAreaInput("marginalized", "", "",rows=10,cols=50),
        actionButton("marginalized_block", "Next",style="font-size:17pt;float;right;"),
        br()
    )
)