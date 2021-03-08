#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

source("data_figures.R")
#corrmat_GROUP1_Savg
#corrmat_GROUP2_Savg
######
#####
####
###
## SHINY UI
ui <- fluidPage(
  dashboardPage(skin="red", #tags$head(tags$link(rel="stylesheet", type="text/css", href="style.css")),
                    dashboardHeader(title= "Weis Dissertation"),
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem("Background", tabName= "intro"),
                        menuItem("Analysis Strategy", tabName = "analysis"),
                        menuItem("Network Identification", tabName = "gICA"),
                        menuItem("Static FC Results", tabName = "sFC"),
                        menuItem("Dynamic FC Results", tabName = "dFC"),
                        menuItem("Connectivity States", tabName = "CS"),
                        menuItem("Summary", tabName = "summary"),
                        menuItem("About Me/References", tabName = "bio")
                      )
                    ),
                    dashboardBody(
                      tags$head(tags$style(HTML(' p {font-family: "Optima"} main-title {font-family: "Optima"}
                                                h1 {font-family: "Optima"} h2 {font-family: "Optima"}
                                                h3 {font-family: "Optima"} h4 {font-family: "Optima"};'))),
                      tabItems(
                        tabItem(tabName="intro",
                                h1("Data driven approach to dynamic resting state functional connectivity in post-traumatic stress disorder"),
                                h3("The dissertation work of Carissa Weis, PhD from the University of Wisconsin-Milwaukee"),
                                fluidRow(
                                  box(width=6,
                                      h3("What is PTSD?"),
                                      p("Post-traumatic stress disorder (PTSD) is a heterogenous psychological disorder that may result from trauma.
                                        'Trauma' encompasses a wide-range of events that a person can experience (e.g. combat, assault, car accident, unexpected death of someone close).
                                        According to the DSM-5, a traumatic event is any event in which a person feels their life and/or safety is threatened. While trauma
                                        is exceedingly prevalent in the world (an estimated 70-90% of all individuals will experience one traumatic event in their lifetime),
                                        most are resilient after experiencing trauma. However, nearly 9% of trauma-exposed individuals will go on to develop PTSD."),
                                      br(),
                                      p("PTSD is quite a heterogenous disorder. While there are 4 defining symptom 'clusters' (flashbacks/intrusive memories, avoiding trauma reminders hyperarousal, 
                                        and negative thoughts/emotions) from which diagnosis is determined, the 
                                        presentations and combinations of symptoms vary greatly from person-to-person. For this reason, and the vast array of trauma in the world,
                                        it is very difficult to predict who may develop PTSD after experiencing a trauma."),
                                      br(),
                                      br(),
                                      p("For more information about PTSD, visit the National Center for PTSD at the",
                                        a(href="https://www.ptsd.va.gov/index.asp", "U.S. Department of Veterans Affairs website."))
                                  ),
                                  box(width=6,
                                      h3("PTSD and the Brain"),
                                      p("Neuroscience research indicates that PTSD is related to disruptions in the function of 3 brain regions: the amygdala, hippocampus, 
                                        and medial prefrontal cortex. Disruptions of the 'normal' function of these 3 regions can be seen in the 'resting' brain using 
                                        using neuroimaging techinques such as functional MRI (fMRI)."),
                                      br(),
                                      helpText("In the schematic below, the amygdala is purple, the hippocampus is yellow, and the medial prefrontal cortex is blue. Image from Godsil et al., (2012)."),
                                      img(src="amyg_hippo_PFC_Godsil.png", width="50%", height="50%"),
                                      br(),
                                      p("However, recent advances in neuroimaging analytic techniques have shown disruptions related to PTSD in larger and more widespread brain", em("networks"), "of which the most
                                        consistently reported is the Default Mode Network (below)."),
                                      br(),
                                      helpText("The Default Mode Network. Image from Norton et al., (2012)."),
                                      img(src="DMN_Norton12.png", width="75%", height="75%"),
                                      br()
                                  )
                                ),
                                fluidRow(
                                  box(width=6, 
                                      h3("Resting State Functional Connectivity"),
                                      p("fMRI allows researchers to infer brain activity approximated from the movement of blood throughout brain tissues.
                                        While researchers frequently utilize fMRI to understand how different regions of the brain respond to different 
                                        stimuli in a task presented to a participant, 
                                        fMRI can also be used to understand brain function when a person is just 'resting' or lying still (", em("but not sleeping"), 
                                        ") in an MRI scanner with no task to do for a period of 5-10 minutes.
                                        Resting state scans show brain activvity that can be conceptualized as the activity that occurs 'in the background' or as someone's 
                                        'baseline' brain function. "),
                                      p("During resting state scans, different brain regions can show synchronized activity levels through time. 
                                        A pair of regions exhibiting synchronized signals are called", strong("functionally connected (FC)."), 
                                        "Though there may not be a physical or structural connection between a pair of regions, a functional
                                        connection between 2 regions may indicate these regions are 'working together' in some capacity."),
                                      p("Thus, resting state functional connectivity analyses describe the functional relationships 
                                        across brain regions or networks while a person is resting.")
                                      ),
                                  box(width=6,
                                      h3("Static vs. Dynamic Functional Connectivity"),
                                      p("To date, the most common analysis method of resting state data uses a static FC approach.",
                                        strong("Static FC"), "examines the", em("average"), "signal of a brain region/network over 
                                        the course of the whole resting state scan (typically 5-10 min). This means all of the activity in a region/network 
                                        across the 5-10 min scan is reduced to 1 average number."),
                                      p("While this method has some utility, 
                                        it completely ignores the potential for", em("changes in activity across time"), "within or 
                                        between regions/networks. Evaluation of ", em("dynamics"), "within region(s)/networks utlizes 
                                        an analysis technique called dynamic FC.", strong("Dynamic FC"), "looks at the activity of region(s)/
                                        networks during small windows of time and how activity changes across these windows through the
                                        length of the scan. Thus, dynamic FC can account for changes in brain activity within the 5-10 min resting state scan.")
                                  )
                                ),
                                fluidRow(
                                  box(width=6,
                                      h4("Static and Dynamic FC and PTSD"),
                                      p("As mentioned in 'PTSD and the Brain' above, research has shown dysfunction in specific brain regions 
                                        [amygdala, hippocampus, frontal cortex], and specific brain networks [Default Mode]. While dysfunction 
                                        has been shown in these regions during tasks, it has also been demonstrated at rest. This means 
                                        there's dysfunction in baseline/background brain activity that may underlie PTSD and its symptoms."),
                                      p("The majority of the research that has examined resting state connectivity in PTSD has looked at specific 
                                        regions of interest (ROIs) and limited their investigations to only those regions. However, since PTSD 
                                        is such a heterogenous disorder, it's likely that the dysfunction that underlies PTSD symptoms would not 
                                        be contained to only a select few regions. There could be other broader networks or under investigated 
                                        regions that also exhibit dysfunction related to PTSD."),
                                      p("Furthermore, the majority of work in resting state connectivity and PTSD has utilized a static FC 
                                        analysis approach. However, dynamic FC may be a more sensitive technique to understand broader
                                        network dysfunction."),
                                      br(),
                                      p(strong("To better understand the dysfunction of resting state FC and patterns of brain activity that may underlie PTSD and the  
                                        heterogeneity of PTSD symptoms, it is critical to understand widespread brain network dynamics in those with PTSD.")
                                        )
                                  ),
                                  box(width=6,
                                      helpText("Conceptual diagram of dynamic FC. Image from Hutchison et al. (2013)"),
                                      img(src="dFC_Hutchison13.png", width="75%", height="75%")
                                      )
                                ),
                                fluidRow(
                                  box(width=12, background="red",
                                      h3("Current Study Aims"),
                                      h4("Examine resting state functional connectivity in a data-driven manner (independent
                                         of hypothesis-driven ROIs), to characterize brain network dynamics and connectivity
                                         states (recurrent brain patterns over time) in those with and without PTSD from a 
                                         very large sample of trauma exposed individuals from around the world (courtesy of 
                                         ENIGMA PGC-PTSD workgroup, ~3,000 trauma exposed)"),
                                      br(),
                                      h4("Aim 1: Use data-driven approach to network identification and to compare static and 
                                        dynamic functional connectivity properties between PTSD and Trauma Exposed Control groups."),
                                      br(),
                                      h4("Aim 2: Identify and compare dynamic functional connectivity states between PTSD and Control groups.")
                                      )
                                )
                        ),
                        tabItem(tabName="analysis",
                                fluidRow(
                                  box(width=5,
                                    h1("Analysis Overview"),
                                    p("The current study utilized resting state fMRI scans, demographic and clinical data collected by the",a(href="https://pgc-ptsd.com/", "ENIGMA consortium's PGC-PTSD workgroup.")),
                                    br(),
                                    p("Of the original 2,902 trauma-exposed participant's data released from 27 sites around the world, 1,049 from 11 sites were retained for final analysis."),
                                    p("447 met criteria for PTSD, 602 were trauma exposed controls"),
                                    br(),
                                    p("For characterstics of the final 1,049 individuals retained please see the manuscript (Tables 1 and 2) in References/Links. 
                                      Broadly speaking, the sample was approximately middle aged, balanced by gender, and experienced a mixture of trauma types including combat, 
                                      mixed civilian trauma (i.e. car accidents, falls), first responders, and interpersonal violence.")
                                  ),
                                  box(width=7, offset=0,
                                      helpText("See diagram below for data reduction process."),
                                      img(src= "ConsortDiagram.png", width="100%", height="100%"))
                                ),
                                fluidRow(
                                  box(width=12,
                                      column(7,
                                             img(src="Analysis_Plan_Overview.png", width="100%", height="100%")
                                      ),
                                      column(5,
                                             h4("3 Main Analysis Components:"),
                                             br(),
                                             h4("1. Identifying the brain network with data-driven approach (Group Independent Components Analysis)"),
                                             br(),
                                             h4("2. Evaluate static functional connectivity of network between PTSD - Control groups"),
                                             br(),
                                             h4("3. Evaluate dynamic functional connectivity of network between groups")
                                             )
                                      )
                                ),
                                fluidRow(
                                  box(width=12,
                                      h2("Covariates of Interest"),
                                      p("In trauma research, there are more trauma-related outcomes than just PTSD. For example, pain, depression, and anxiety may also develop/worsen as a result of trauma.
                                        In addition, there are a number of factors that may contribute to the risk of PTSD development after trauma, including but not limited to: age, sex, 
                                        prior trauma exposure, early life history, other previous psychiatric history, and substance use."),
                                      p("For this reason, it's important to consider how these factors (i.e. covariates) may contribute to PTSD diagnosis."),
                                      p("While there were many covariates of interest to account for in the current analysis, 
                                        only 4 variables were reliably reported within the dataset: age, sex, depression diagnosis, and childhood trauma severity.
                                        Of the 1,049 individuals included in the final analysis, only 442 had information reported for all 4 covariates.
                                        However, if childhood trauma severity was removed as a variable of interest, then 779 individuals had the remaining information reported."),
                                      br(),
                                      p("Therefore, in an effort to balance sample size and important covariates, and to demonstrate the potential effects of some covariates over others
                                        all 3 sample sizes were evaluated:"),
                                      p("1) 1,049 with no covariates"),
                                      p("2) 442 with all covariates [age, sex, depression, childhood trauma]"),
                                      p("3) 779 with some covariates [age, sex, depression]"),
                                      p(em("*all analyses report results from these 3 samples*"))
                                      )
                                )
                        ),
                        tabItem(tabName="gICA",
                                fluidRow(
                                  box(width=12,
                                      h1("Data-driven network identification via group ICA"),
                                      p("Group independent components analysis (ICA) is a data reduction technique that identifies 
                                        temporally coherent regions/networks filtered from the fMRI signal through the full course of
                                        the resting state scan. Through quite a bit of math, the ICA yields maximally independent 
                                        spatial components (or network nodes). In other words, this step takes all brain activity 
                                        signal from the whole brain for all participants and shakes out the most common and 
                                        active brain regions across everyone's brains."),
                                      p("For more information on this step please visit the", a(href="http://mialab.mrn.org/software/gift/", "GIFT website."), 
                                        "and the numerous publications from the Calhoun group. Or for a *slightly* less math-y 
                                        explanation, you can also read my dissertation.")
                                      ),
                                  fluidRow(
                                    box(width=12,
                                        h3("Results"),
                                        p("In the current study, the group ICA yielded 42 common brain regions (i.e. components). 
                                                 For ease of interpretation, these 42 brain regions were organized into broad cognitive domains.
                                                 See diagram below for a composite image of all 42 components color coded by domain."),
                                        p(strong(em("These 42 components make up the network from which we'll evaluate static and dynamic functional connectivity."))),
                                        
                                        img(src="alldomains_composite.png", width="100%", height="100%"),
                                        helpText("CB =cerebellar, COG =cognitive control, DMN = default mode, L/A = lanugage/audition,
                                                 SM = sensorimotor, SC = subcortical, VIS = visual"),
                                        p("Of note, the brain regions identified in this network are not all that surprising. Importantly, a wider variety of regions
                                          emerged than would've if we started with a hypothesis-driven ROI approach. Identifying the network using the group
                                          ICA 'evens the playing field' in a sense that any brain regions were fair game for analysis if they were
                                          consistently active at rest across the group")
                                        )
                                    ),
                                  fluidRow(
                                    box(width=3, background="red",
                                        p("Select a domain to examine it's components more closely:"),
                                        radioButtons("domains", "Domains", choices=list("Cerebellar",
                                                                                        "Cognitive Control",
                                                                                        "Default Mode",
                                                                                        "Language/Audition",
                                                                                        "Sensorimotor",
                                                                                        "Subcortical",
                                                                                        "Visual"))
                                        ),
                                    box(width=9,
                                        uiOutput("domain_selected"),
                                        tableOutput("domain_table"),
                                        helpText("X, Y, Z, peak component coordinates in standard
                                                 MNI space in RAI-orientation; k, number of voxels
                                                 per component; Iq, quality index from group ICA."))
                                  )
                                  )
                        ),
                        tabItem(tabName= "sFC",
                                h3("Static Functional Connectivity Results"),
                                fluidRow(
                                  box(width=7,
                                      p(strong("In the current analysis, static FC refers to the comparison of 
                                        average activity over the course of the resting state scan
                                        between a pair of components or across the whole network.")),
                                      br(),
                                      p("1. Average time series (activity over the course of resting state scan) is extracted from each network component
                                        identified from the group ICA"),
                                      p("2. The correlation (degree of similarity between component signals) between the full average time series
                                        for all pairs of components is calculated for each participant"),
                                      p("3. Correlations are collapsed across participant groups to compare PTSD and Control groups"),
                                      br(),
                                      p("Presented below are several heat maps depicting the results of the static FC
                                        analysis. Each cell represents a pair of components. For example, the cell in
                                        the uppermost left hand corner represents the component pair #33 and #11 
                                        (component numbers are listed along the x- and y- axes). Components are 
                                        grouped by cognitive domain as depicted with the horizontal and vertical
                                        black lines.")
                                  ),
                                  box(width=5,
                                      helpText("Schematic of static FC analysis with simulated data."),
                                      img(src="sFC_schematic.png", width="75%", height="75%")
                                      )
                                ),
                                fluidRow(
                                  tabBox(width=12,
                                         tabPanel("Side-by-Side Group Comparisons",
                                                  fluidRow(
                                                    box(width=6, background="red",
                                                        h3("What are we looking at?"),
                                                        p("Shown here are the average correlation of signal between all possible pairs
                                                          of components in the network identified in the group ICA (see 'Network Identification
                                                          tab on the left navigation bar for more information). The left depicts the average
                                                          static FC of all component pairs averaged across only the participants
                                                          who met criteria for PTSD (N=447), on the right depicts the same thing but only for
                                                          participants who did not meet criteria for PTSD (N=602).")
                                                        ),
                                                    box(width=6, background="yellow",
                                                        h3("What are we looking for?"),
                                                        p("The color of each tile in the heatmap depicts the degree of correlation
                                                          between a pair of components. Warm colors indicate higher correlation (i.e. 
                                                          greater static FC) for a pair of components."),
                                                        p("At this point in the analysis we're just looking", em("qualitatively"), "at
                                                          how static FC within domains (groups of components along the diagonal: 
                                                          all components within the VIS domain) and
                                                          between domains (off the diagonal: for example, sFC between VIS and COG
                                                          components) may differ between the PTSD and Control groups."),
                                                        p("Obviously from these 2 heatmaps there are not many stark differences, 
                                                          at least visually. Select the 'Group Differences' tab above to see where
                                                          differences between groups emerge.")
                                                        )
                                                    ),
                                                  helpText("Roll your cursor over the tiles in the heat map to show the exact
                                                                 correlation value represented by the color shown."),
                                                  fluidRow(
                                                    column(6, girafeOutput("sFC_PTSD", width= 400, height=400)),
                                                    column(6, offset=0, girafeOutput("sFC_TEC", width= 400, height=400))
                                                  ),
                                                  fluidRow(
                                                    column(12,
                                                        helpText("Note: cells depict correlations of full resting state time series
                                                                  between a given pair of nodes in the network.
                                                                 Black lines depict organization of nodes into broad cognitive domains.",
                                                                 "CB =cerebellar, COG =cognitive control, DMN = default mode, L/A = lanugage/audition,
                                                                 SM = sensorimotor, SC = subcortical, VIS = visual")
                                                        )
                                                  )
                                         ),
                                         tabPanel("Group Differences",
                                                  fluidRow(width=12,
                                                           box(width=6, background="red",
                                                               h3("What are we looking at?"),
                                                               p("Before, it was difficult to see where there were differences within or between
                                                                 component domains. Here we can see exactly where those differences exist.
                                                                 The heat map below is simply the difference between the two heat maps on 
                                                                 the previous tab. While the layout/organization is identical as before,
                                                                 the values of the cells are now different. Here, warm colors indicate pairs
                                                                 of components where those with PTSD had higher static FC than Controls. Cool
                                                                 colors therefore indicate pairs of components where those with PTSD had lower
                                                                 static FC than controls. The brightness of the warm/cool colors indicates
                                                                 how large of a difference there was between groups.")
                                                               ),
                                                           box(width=6, background="yellow",
                                                               h3("What are we looking for?"),
                                                               p("As you can see below, where differences between groups exist is rather subtle;
                                                                 although, as a whole, those with PTSD seem to exhibit lower static FC than controls (
                                                                 evidenced by more widespread blues across the whole network).")
                                                               )
                                                  ),
                                                  fluidRow(
                                                    column(12,
                                                           helpText("Roll your cursor over the tiles in the heat map to show the exact difference in
                                                               correlation value represented by the color shown."),
                                                           girafeOutput("sFC_DIFF", width= 500, height=500),
                                                           helpText("Note: cells now depict group differences in correlations of full resting state time series
                                                                    between a given pair of nodes in the network.
                                                                    Black lines depict organization of nodes into broad cognitive domains.",
                                                                    "CB =cerebellar, COG =cognitive control, DMN = default mode, L/A = lanugage/audition,
                                                                    SM = sensorimotor, SC = subcortical, VIS = visual")
                                                           )
                                                    )
                                         ),       
                                         tabPanel("Statistical Results",
                                                  fluidRow(
                                                    box(width=6, background="red",
                                                        h3("What are we looking at?"),
                                                        p("Up until now, the patterns of sFC and differences between groups were assessed",
                                                          em("qualitatively."), "Here you can see where", em("quantitative"), "differences
                                                          between groups exist (assesed via group statistics)."),
                                                        p("As mentioned in 'Analysis Strategy', there were 3 samples (sets of covariates) evaluated
                                                          for all analyses. Here you can see precisely where in the network static FC of component 
                                                          pairs within and between domains statistically differed between groups accounting for
                                                          the various covariates of interest where applicable."),
                                                        p("Here, the cell values have changed again. However, cool colors still indicate component pairs
                                                          where those with PTSD had lower static FC than Controls, and warm colors indicate where controls
                                                          had higher static FC than those with PTSD. The brightness of the color indicates how strong the 
                                                          difference was statistically.")
                                                    ),
                                                    box(width=6, background = "yellow",
                                                        h3("What are we looking for?"),
                                                        p("To see where differences between groups was", em("greatest"), "check the 'Apply FDR correction'
                                                          box below. Tiles with asterisks indicate statistical differences between groups that survive
                                                          statistical correction (i.e. these are really big group differnces)."),
                                                        p("Here our focus is on the tiles with asterisks, where group differences are greatest. In all 3 samples (with and without covariates),
                                                          you'll notice there are strong group differences", strong(em("within the VIS and SM domains")),
                                                          "and", strong(em("between the VIS and SM, VIS and L/A, VIS and COG, and SM and L/A domains.")), "In all
                                                          cases, those with PTSD exhibited lower static FC meaning these domains are less functionally connected in the
                                                          network compard to Controls."),
                                                        p("Remember, these specific differences in network function between groups are only differences in the
                                                          average signal from these components across a 5-10 minute scan. To know more about why these differences
                                                          may arise, we can look to the dynamic FC analysis and results.")
                                                        )
                                                  ),
                                                  fluidRow(
                                                    column(3,
                                                           radioButtons("sFC_sample", h4("Choose Sample"),
                                                                        choices=list("No covariates (N=1,049)"=1, 
                                                                                     "All covariates (N=442)"=2,
                                                                                     "Some covariates (N=779)"=3)),
                                                           h4("Apply FDR Correction?"),
                                                           checkboxInput("sFC_MCC", "Yes", value=FALSE),
                                                           helpText("Note: Cells with an asterisk indicate comparisons",
                                                                    "that survive FDR correction (p<0.05).")
                                                    ),
                                                    column(9,
                                                           girafeOutput("sFC_stats", width=500, height=500),
                                                           helpText("Note: cell values are plotted as sign(", em("t"),")*-log(", em("p"),
                                                                    "where", em("t"), "and", em("p"), 
                                                                    "were obtained from the group diagnosis term of the statistical test (t-test or ANCOVA) run.", 
                                                                    "Black lines depict organization of nodes into broad cognitive domains.",
                                                                    "CB =cerebellar, COG =cognitive control, DMN = default mode, L/A = lanugage/audition,
                                                                    SM = sensorimotor, SC = subcortical, VIS = visual")
                                                    )
                                                  )
                                         )
                                  )
                                )
                        ),
                        tabItem(tabName= "dFC",
                                h3("Dynamic Functional Connectivity Results"),
                                fluidRow(
                                  box(width=5,
                                      helpText("Schematic of dynamic FC analysis with simulated data"),
                                      img(src="dFC_schematic.png", width="75%", height="75%")
                                  ),
                                  box(width=7,
                                      p("In the static FC analysis, we saw how average group component/domain activity from the full resting
                                        state scan differed between PTSD and Control groups. However, that analysis did not allow us to see
                                        how component/domain activity changes throughout the resting state scan differed between groups. This
                                        is the intention behind dynamic FC.", strong("Instead of examining the average activity from the network over
                                        the course of the full scan, activity from smaller windows of time are extracted so that network changes
                                        can be examined over time.")),
                                      p("In this analysis, I used a sliding-window approach to segment the full resting state scan into smaller
                                        time windows. For example, the first time window encompasses the first 30 seconds of the resting state scan.
                                        Activity from network components is averaged within this first 30 seconds, and pairwise correlations between
                                        components are calculated which generates the same kind of functional connectivity 
                                        heat map we saw in the static FC analysis. Next, the time window is 'slid', activity from seconds 5-35 is extracted, 
                                        and pairwise correlations among components are calculated again. We repeat this sliding window process until we
                                        get to the end of the resting state scan. Now we'll have functional connectivity heat maps for overlapping 30 second
                                        increments for the duration of the scan. From here we can 'plot' what changes occur across the network 
                                        (or components/domains) across these time windows, and compare network dynamics between groups.")
                                  )
                                ),
                                fluidRow(
                                  box(width=12,
                                      h4("A note on graph theory"),
                                      p("Rather than report dynamics of *correlations* of brain activity through time,
                                        below you'll see various graph theory metrics instead. Graph theory is a branch of mathematics
                                        that studies graphs- sets of vertices (nodes) connected by lines (edges). Graph theory is 
                                        very easily implemented in neuroscience to understand the complex network connectivity 
                                        amongst brain regions. Brain regions (or components) can be considered nodes, and the 
                                        functional connections between them edges. Once a graph (brain network) is established
                                        a number of characteristics can be used to describe to network in terms of efficiency
                                        and connectivity. In the current analysis I evaluated the following 5 metrics:"),
                                      p("1. Global efficiency - a measure of how functionally integrated a network is and the direct
                                        interactions among all nodes in the network"),
                                      p("2. Local efficiency - the efficiency of an individual node (brain region) and its
                                        immediate neighbors"),
                                      p("3. Clustering coefficient - the degree to which a node's neighbors are neighbors
                                        of each other (connectedness of a neighborhood)"),
                                      p("4. Connectivity strength - the strength of connections amongst all network nodes"),
                                      p("5. Characteristic path length - the smallest distance between all node pairs"),
                                      br(),
                                      p("For all metrics 1-4, higher values describe a more efficient network, where as lower
                                        values for path length (#5) indicate a more efficient network. For brevity I will spare you
                                        the specifics of how these metrics are calculated and how they're related. Just know that
                                        all of these metrics help to indicate properties like efficiency about the network of interest.")
                                  )
                                ),
                                fluidRow(
                                  column(3,
                                         h4("Select Graph Metric"),
                                         radioButtons("dFC_graph_metrics_plots", "Graph Metrics", choices=list("Global Efficiency",
                                                                                         "Local Efficiency",
                                                                                         "Clustering Coefficient",
                                                                                         "Connectivity Strength",
                                                                                         "Path Length")),
                                         br(),
                                         h4("View Regression Line?"),
                                         checkboxInput("dFC_regline", "Yes", value=FALSE),
                                         helpText("Essentially an averaged and smoothed time series with error bars.")
                                         ),
                                  column(9, 
                                         plotOutput("GE_dFC")
                                  )
                                ),
                                fluidRow(
                                  box(width=6, background = "red",
                                      h3("What are we looking at?"),
                                      p("Above you can see the time series plots of various graph metrics that were computed
                                        across the network as a whole, across the 200 time windows (~30 seconds each) extracted
                                        from the length of the resting state scan."),
                                      p("Each group of interest is plotted as a different color. The time windows are plotted 
                                        along the x-axis, and the graph metric selected at left is plotted along the y-axis.")
                                  ),
                                  box(width=6, background = "yellow",
                                      h3("What are we looking for?"),
                                      p("Qualitatively, we're looking for any stark differences in the pattern of graph metrics
                                        through time. As you can see as you look through all of the calculated graph metrics,
                                        the 2 groups are indistinguishable for the first 100 time windows (~ first half of the 
                                        scan). However, in the second 100 time windows (second half of the scan), there is 
                                        some separation between groups and at the very least more variability in patterns through time."),
                                      p("To quantitatively compare patterns, I compared average graph metrics between the first and second
                                        halves of the scan. For statistical results see the tables below. In summary, results showed
                                        there was a significant main effect of scan halves (for all 3 sets of covariates) where
                                        all participants (regardless of group) showed significantly higher graph metrics for all metrics
                                        calculated. Results did not show any group differences in the second half of the scan though."),
                                      p("Even though there were no group differences in the dynamic FC analysis, there is an interesting
                                        trend of increased graph metrics in the second half of the scan. To understand this pattern better,
                                        we can look to the Connectivity States analysis.")
                                  )
                                ),
                                fluidRow(
                                  box(width=3, background = "black",
                                      radioButtons("dFC_sample", h4("Choose Sample"),
                                                          choices=list("No covariates (N=1,049)", 
                                                                       "All covariates (N=442)",
                                                                       "Some covariates (N=779)"))
                                  ),
                                  box(width=9,
                                      h4("Scan halves comparison of graph metrics across the whole network by group"),
                                      tableOutput("dFC_table"),
                                      helpText("CI, confidence interval; p-values presented are uncorrected, * indicates
                                               those that survive FDR correction (alpha=0.05)")
                                      )
                                )
                        ),
                        tabItem(tabName = "CS",
                                h3("Connectivity States Results"),
                                box(width=12,
                                    p(strong("Connectivity states can be described as functional connectivity patterns that reoccur
                                      over time within subjects."), "You can imagine during the course of a resting states can (5-10 min)
                                      of lying still in a scanner with nothing to do that the brain may flow in and out of different
                                      activity states depending on thought patterns/day-dreaming/baseline rhythms. The purpose of 
                                      the connectivity states analysis is to identify what these recurring patterns look like on an 
                                      individual and group level. This analysis is really just an extension of the dynamic FC analysis
                                      as a means to better characterize what the dynamic patterns look like in terms of the specific 
                                      components and domains and what collective components/domains may be active together
                                      during these states.")
                                ),
                                fluidRow(
                                  box(width=6,
                                      p("While this may seem conceptually straight-forward there's a LOT of math and statistics
                                        that need to happen in order to identify connectivity states. I'll spare you the details of 
                                        the process here; however, for a schematic of the whole process, refer to the fun graphic I made 
                                        (right). Essentially, we're looking at the functional connectivity patterns 
                                        calculated in each time window from the dynamic FC analysis and identifying what time 
                                        windows look alike. Any time windows that look alike can be grouped together
                                        and called a recurrent connectivity state."),
                                      p("At the individual-level, we can count the number of recurrent states a person may have
                                        had over the course of their scan. Then, for example, ", strong("we can assess if those with
                                        PTSD had more or less connectivity states than controls."), "However, since each individual
                                        likely had unique states we cannot actually compare these states across participants. For that, we 
                                        need to look for connectivity states that occurred across the entire group"),
                                      br(),
                                      p("At the group-level, we can again examine what time windows look most alike, but this time we'll 
                                        do this when looking at all time windows for all participants at the same time. We're now looking
                                        to see if there were time windows that look alike", em("between"),
                                        "individuals instead of within. Similar patterns of activity across subjects can be considered group-level
                                        connectivity states.", strong("With these group-level states we can assess how long each person spent in a given state (dwell time),
                                        and how many times they transitioned between identified states (transition counts).
                                        Dwell time and transition counts can then be compared between PTSD and control groups."))
                                  ),
                                  box(width=6,
                                      img(src="method_CSanalysis.png", width="100%", height="100%")
                                      )
                                ),
                                fluidRow(
                                  tabBox(width=12,
                                        tabPanel("Individual-level CS Results",
                                                 fluidRow(
                                                   box(width=3, background= "black",
                                                       radioButtons("indiv_CS_halves", "Count CS's by Scan Halves?", choices=list("Whole Scan",
                                                                                                                    "Scan Halves"))
                                                   ),
                                                   box(width=9,
                                                       plotOutput("indiv_CS_plot")
                                                   )
                                                 ),
                                                 fluidRow(
                                                   box(width=6, background = "red",
                                                       h3("What are we looking at?"),
                                                       p("Plotted above are the relative frequencies of the number of individual-level 
                                                          connectivity states by group. On the x-axis is the number of
                                                         different connectivity states indentified within an individual
                                                         participants resting state scan. On the y-axis is the proportion of 
                                                         participants within their respective groups."),
                                                       p("An example way to read this figure: 22% of control subjects experienced 3 different
                                                         connectivity states during the course of their resting state scan, while
                                                         only 18% of those with PTSD experienced 3 states. ")
                                                   ),
                                                   box(width=6, background = "yellow",
                                                       h3("What are we looking for?"),
                                                       p("In this figure, we're interested in seeing if
                                                         number of individual connectivity states differs according to group
                                                         membership. In other words, do those with PTSD experience more or less individual
                                                         connectivity states than controls?"),
                                                       p("As you might be able to infer from these figures, there is no real difference in number of connectivity
                                                         states between groups. Equal proportions of participants from each group experienced
                                                         2, 3, 4, 5, and 6 connectivity states."),
                                                       p("Even if we count individual connectivity states in just the first and just the second
                                                         halves of the resting state scan and compare groups again, there does not seem to 
                                                         be any particular group that has more or less states. Further, with the various
                                                         samples analyzed, there were no group differences across the whole
                                                         scan nor in each scan half.")
                                                   )
                                                 )
                                                 
                                        ),
                                        tabPanel("Group-level CS Results",
                                                 box(width=20, background = "red",
                                                     h4("What are we looking at?"),
                                                     p("Organized in an identical fashion to the static FC heat map results, 
                                                        the heat maps below depict the pattern of connectivity (shown via 
                                                        pairwise correlations between components organized by domain)
                                                        for the 2 group-level connectivity states identified. The heat maps
                                                       show the average activity patterns across network nodes that best
                                                       represent the recurrent activity state. Warm colors indicate greater
                                                       functional connectivity and cool colors indicate lesser."),
                                                     p("On the left is the first connectivity state identified, as you can
                                                       probably see, this state has a rather unique pattern of connectivity.",
                                                       em("Within"), "almost all domains (along the diagonal), there is fairly strong
                                                       functional connectivity. Between all domains (off the diagonal), there
                                                       is weaker functional connectivity."),
                                                     p("On the right is the second connectivity state. This state has a rather
                                                       different pattern of connectivity than the first state. Within all domains
                                                       there is again strong functional connectivity. However, between all domains
                                                       there is also strong functional connectivity.")
                                                 ),
                                                 fluidRow(
                                                   column(6, 
                                                          h4("High within domain FC"),
                                                          girafeOutput("group_CS_centroid_1")
                                                          ),
                                                   column(6, offset=0, 
                                                          h4("High within and between domain FC"),
                                                          girafeOutput("group_CS_centroid_2")
                                                          ),
                                                   column(12,
                                                          helpText("Roll your cursor over the tiles in the heat map to show the exact
                                                                 correlation value represented by the color shown."))
                                                 ),
                                                 br(),
                                                 br(),
                                                 fluidRow(
                                                   box(width=12, background= "yellow",
                                                       h4("What are we looking for?"),
                                                       p("Now that we've identified the group-level connectivity states, we
                                                         can compare how long participants from each group spent in each state 
                                                        and how many times they transitioned between states. Below are
                                                         the figures showing average dwell time for each CS and the number of 
                                                          transitions by group for each CS. As you can see, 
                                                         though more time was spent in general in CS #1 compared to CS #2,
                                                         there were no group differences in dwell time. Similarly, there
                                                         were no group differences in the number of CS transitions by group."),
                                                       p("Even if we examine dwell time and transition counts between first and
                                                         second halves, there were no group differences. Even in the various
                                                         samples analyzed, there were no group differences across the whole
                                                         scan nor in each scan half.")
                                                       )
                                                   
                                                 ),
                                                 fluidRow(
                                                   box(width=2, background= "black",
                                                       radioButtons("group_CS_halves", "Split by Scan Halves?", choices=list("Whole Scan",
                                                                                                                                  "Scan Halves"))
                                                   ),
                                                   box(width=10,
                                                       column(6, plotOutput("dwell_CS_whole")),
                                                       column(6, offset=0, plotOutput("trans_CS_whole"))
                                                   )
                                                 )
                                        )
                                  )
                                )
                        ),
                        tabItem(tabName = "summary",
                              h2("What have we learned?"),
                              fluidRow(
                                box(width=4,
                                  h4("Data-driven approach is useful."),
                                  p("The brain regions derived from the group ICA step closely resemble
                                    networks identified in other samples/studies that use this same method. 
                                    This means this method is pretty reliable even in a really large sample.
                                    And, this approach yielded more refined components than would have been
                                    possible if we used an ROI/hypothesis-driven approach.")
                                  ),
                                box(width=4,
                                    h4("Static FC showed those with PTSD have less efficient network on average."),
                                    p("Regardless of the sample used (with no, all, or some covariates), the
                                      static FC analysis yielded some clear group differences. Namely, those with 
                                      PTSD exhibited a less functionally connected network", em("on average"),
                                      "compared with controls. This pattern of resting state connectivity has 
                                      been shown before in other trauma-exposed samples. However, if you look back to the static FC
                                      results (and in my full dissertation), the magnitude of these group differences is actually quite 
                                      small. This means though there were group differences they were minor. Nonetheles, the current study adds to the
                                      literature by describing more nuanced differences in this weaker connectivity 
                                      in PTSD (i.e. deficiencies in specific domains- visual and sensorimotor networks).")
                                    ),
                                box(width=4,
                                    h4("Dynamic FC can tell you a lot about network properties."),
                                    p("While", em("on average"), "across the whole network, those with PTSD had
                                      less efficient/functionally connected networks, the results of the dynamic FC
                                      analysis tell a slightly different story. There were no group (PTSD vs. Controls)
                                      differences in the pattern of network functional connectivity through time, 
                                      nor in the patterns (time spent and transitions) of recurrent brain states as shown in 
                                      the connectivity states analysis."),
                                    p("Even though we didn't find any group differences in dynamic FC or connectivity states,
                                      dynamic FC as a method can tell you a lot more about network properties than static FC
                                      can. Just because we didn't see anything between groups in this study, 
                                      does not discredit this method.")
                                    )
                              ),
                              fluidRow(
                                box(width=12,
                                    h2("So, what does this all mean?"),
                                    h4("This is the first time this methodology has been applied to a dataset of this scale
                                      in the PTSD literature, cool! Second, in a general sense, the real overarching question of the current analysis was:"),
                                    br(),
                                    h4("Is there anything unique in the resting brain related to the diagnosis
                                                of PTSD (regardless of trauma type, timing of trauma, symptom 
                                                               severity/presentation, etc)?"),
                                    h4("In short, the answer is no."),
                                    br(),
                                    h4("As mentioned in the introduction, while trauma exposure is really common, PTSD 
                                      presentation is not. There are many (10s of thousands) of combinations of symptoms 
                                      that make PTSD very heterogenous. While we found large scale differences in a widespread brain network on average 
                                      in the static FC analysis, these differences were not that stark and we didn't see any other group differences in brain dynamics."),
                                    br(),
                                    h4("From what we found (or rather didn't find) using this very large trauma-exposed 
                                      sample, there aren't robust brain network characteristics unique to PTSD diagnosis in the resting brain.
                                      However, with more detailed information regarding the trauma experienced and the PTSD symptoms of the included
                                      participants, our conclusion could change. If PTSD is so heterogenous, then perhaps we 
                                      need to consider more detailed contexts of what a specific person is experiencing
                                      in order to see changes in the brain.")
                                    )
                              )
                        ),
                        tabItem(tabName = "bio",
                                fluidRow(
                                  box(width=12,
                                    h3("Want to know more?"),
                                    p("Read my full dissertation available through the University of Wisconsin-Milwaukee
                                      library or download a PDF version", downloadLink("diss_PDF", "here.")),
                                    p(strong("**Fair warning, she's a beast (i.e. 178 dense pages).**")),
                                    br(),
                                    p("This work was made possible by collaborations with the ENIGMA 
                                        Pediatric Genomics Consortium-PTSD workgroup (PGC-PTSD) and all contributing
                                      sites and participants. For more information on the ongoing work by the PGC-PTSD
                                      you can visit their website", a(href="https://pgc-ptsd.com/", "here.")),
                                    br(),
                                    p("For questions about the current study or for more information on my ongoing work 
                                      and recent publications", a(href="https://www.linkedin.com/in/carissa-weis/", "add me on LinkedIn!")),
                                    p("For the source code of this RShiny app see my github repository", a(href="https://github.com/carissaweis/DissertationRShinyApp", "here."))
                                  )
                                ),
                                fluidRow(
                                  box(width=8,
                                      h3("About me"),
                                      p("I graduated with my BS from Calvin College in 2016 with degrees in Psychology and 
                                        Mathematics. In 2019, I received my MS in neuroscience and in 2020 I completed my
                                        PhD in neuroscience at the University of Wisconsin-Milwaukee (UWM)
                                        under the supervision of Dr. Christine Larson in the ", 
                                        a(href="http://uwmlarsonlab.org/", "Affective Neuroscience Lab.")),
                                      p("I am currently a postdoctoral research fellow with 5 years of experience in 
                                        neuroscience research of brain network dynamics and trauma-related mental health outcomes.
                                        I have extensive experience analyzing large-scale and multidimensional
                                        data. I am proficient in a wide variety of statistical methods, coding, and scripting, and
                                        am actively pursuing a career as a data scientist."),
                                      p("Outside of my professional life I am an marathoner and Ironman triathlete who loves to spend time 
                                        outdoors whether that be running, gardening, or playing with my 2 crazy dogs.")
                                  ),
                                  box(width=4,
                                      img(src="MTOP_headshot2.jpg", width="100%", height="100%"))
                                ),
                                br(),
                                fluidRow(
                                  box(width=12,
                                      h4("(Some) References"),
                                      p("For a complete list of references, refer to my dissertation work at the link above."),
                                      p("1. Godsil, B. P., Kiss, J. P., Spedding, M., & Jay, T. M. (2012). The hippocampal–prefrontal pathway: The weak link in psychiatric disorders? European Neuropsychopharmacology, 23(10), 1165–1181. https://doi.org/10.1016/j.euroneuro.2012.10.018"),
                                      p("2. Norton L, Hutchison RM, Young GB, Lee DH, Sharpe MD, Mirsattari SM. Disruptions of functional connectivity in the default mode network of comatose patients. Neurology. 2012 Jan 17;78(3):175-81. doi: 10.1212/WNL.0b013e31823fcd61. Epub 2012 Jan 4. PMID: 22218274."),
                                      p("3. Hutchison, R. M., Womelsdorf, T., Allen, E. A., Bandettini, P. A., Calhoun, V. D., Corbetta, M., Penna, S. D., Duyn, J. H., Glover, G. H., Gonzalez-Castillo, J., Handwerker, D. A., Keilholz, S., Kiviniemi, V., Leopold, D. A., Pasquale, F. de, Sporns, O., Walter, M., & Chang, C. (2013). Dynamic functional connectivity: Promise, issues, and interpretations. NeuroImage, 80, 360–378. https://doi.org/10.1016/j.neuroimage.2013.05.079 [doi]"),
                                      p("4. Allen, E. A., Damaraju, E., Plis, S. M., Erhardt, E. B., Eichele, T., & Calhoun, V. D. (2014). Tracking Whole-Brain Connectivity Dynamics in the Resting State. Cerebral Cortex (New York, N.Y. : 1991), 24(3), 663–676. https://doi.org/10.1093/cercor/bhs352"),
                                      p("5. Damaraju, E., Allen, E. A., Belger, A., Ford, J. M., McEwen, S., Mathalon, D. H., Mueller, B. A., Pearlson, G. D., Potkin, S. G., Preda, A., Turner, J. A., Vaidya, J. G., Erp, T. G. van, & Calhoun, V. D. (2014). Dynamic functional connectivity analysis reveals transient states of dysconnectivity in schizophrenia. NeuroImage: Clinical, 5(C), 298–308. https://doi.org/10.1016/j.nicl.2014.07.003"),
                                      p("6. Yu, Q., Erhardt, E. B., Sui, J., Du, Y., He, H., Hjelm, D., Cetin, M. S., Rachakonda, S., Miller, R. L., Pearlson, G., & Calhoun, V. D. (2015). Assessing dynamic brain graphs of time-varying connectivity in fMRI data: Application to healthy controls and patients with schizophrenia. NeuroImage, 107, 345–355. https://doi.org/S1053-8119(14)01012-X [pii]"),
                                      p("7. Allen, E. A., Erhardt, E. B., Damaraju, E., Gruner, W., Segall, J. M., Silva, R. F., Havlicek, M., Rachakonda, S., Fries, J., Kalyanam, R., Michael, A. M., Caprihan, A., Turner, J. A., Eichele, T., Adelsheim, S., Bryan, A. D., Bustillo, J., Clark, V. P., Ewing, S. W. F., … Calhoun, V. D. (2011). A Baseline for the Multivariate Comparison of Resting-State Networks. Frontiers in Systems Neuroscience, 5, 2. https://doi.org/10.3389/fnsys.2011.00002")
                                      
                                      )
                                )
                        )
                      )
                    )
  )
)

                       




######
#####
####
###
##
# SHINY SERVER
server <- function(input, output) {
  
#  output$sFC_both<-renderPlot(grid.arrange(corrmat_GROUP1_Savg, corrmat_GROUP2_Savg, ncol=2, 
#                         top=textGrob("Static Functional Connectivity", gp=gpar(fontsize=20, face="bold"))))
  
  output$sFC_PTSD<-renderGirafe(ggiraph(ggobj=corrmat_GROUP1_Savg, hover_css = "fill:red;"))
  output$sFC_TEC<-renderGirafe(ggiraph(ggobj=corrmat_GROUP2_Savg, hover_css = "fill:red;"))

  #output$sFC_both<-renderPlotly(subplot(ggplotly(corrmat_GROUP1_Savg, tooltip="text"), 
  #                                      ggplotly(corrmat_GROUP2_Savg, tooltip="text")))
  
  output$sFC_DIFF<-renderGirafe(ggiraph(ggobj=sFC_DIFF, hover_css = "fill:red;"))
  
  output$sFC_stats<-renderGirafe({
    g<-sFC_stats_n1049
    if(input$sFC_sample==2) {
      g<-sFC_stats_n442
      if(input$sFC_MCC) {
        g <- g + geom_text(label=sFC_ttest_n442_ggplot_df$SigStar, size=5, color="black", vjust="0")
      }
    } else if (input$sFC_sample==3){
      g<-sFC_stats_n779
      if(input$sFC_MCC) {
        g <- g + geom_text(label=sFC_ttest_n779_ggplot_df$SigStar, size=5, color="black", vjust="0")
      }
    } else {
      if(input$sFC_MCC) {
        g <- g + geom_text(label=sFC_ttest_n1049_ggplot_df$SigStar, size=5, color="black", vjust="0")
      }
    }
      
    ggiraph(ggobj=g, hover_css = "fill:red;")
    })
  
  output$domain_selected<-renderUI({
      if(input$domains == "Cerebellar"){            
        img(src = "CB_comps.png", width="50%", height="50%")
      }                                        
      else if(input$domains == "Cognitive Control"){
        img(src = "COG_comps.png", width="100%", height="100%")
      }
      else if(input$domains == "Default Mode"){
        img(src = "DMN_comps.png", width="100%", height="100%")
      }
      else if(input$domains == "Language/Audition"){
        img(src = "LA_comps.png", width="100%", height="100%")
      }
      else if(input$domains == "Sensorimotor"){
        img(src = "SM_comps.png", width="100%", height="100%")
      }
      else if(input$domains == "Subcortical"){
        img(src = "SC_comps.png", width="50%", height="50%")
      }
      else if(input$domains == "Visual"){
        img(src = "VIS_comps.png", width="100%", height="100%")
      }
    })
  output$domain_table<-renderTable({
    if(input$domains == "Cerebellar"){            
      CB_tab
    }                                        
   else if(input$domains == "Cognitive Control"){
     COG_tab
   }
   else if(input$domains == "Default Mode"){
     DMN_tab
   }
   else if(input$domains == "Language/Audition"){
     LA_tab
   }
   else if(input$domains == "Sensorimotor"){
     SM_tab
   }
   else if(input$domains == "Subcortical"){
     SC_tab
   }
   else if(input$domains == "Visual"){
     VIS_tab
   }
  })
  
  output$GE_dFC<-renderPlot({
    if(input$dFC_graph_metrics_plots=="Global Efficiency"){
      g<-GE_plot_W
      if(input$dFC_regline==TRUE) {
        g<-g+geom_smooth(aes(group=X1, fill=X1, size=1.2), method="gam", size=0.5, se=T)
      }
      g
    }
    else if(input$dFC_graph_metrics_plots=="Local Efficiency"){
      g<-LE_plot_W
      if(input$dFC_regline==TRUE) {
        g<-g+geom_smooth(aes(group=X1, fill=X1, size=1.2), method="gam", size=0.5, se=T)
      }
      g
    }
    else if(input$dFC_graph_metrics_plots=="Clustering Coefficient"){
      g<-CC_plot_W
      if(input$dFC_regline==TRUE) {
        g<-g+geom_smooth(aes(group=X1, fill=X1, size=1.2), method="gam", size=0.5, se=T)
      }
      g
    }
    else if(input$dFC_graph_metrics_plots=="Connectivity Strength"){
      g<-CS_plot_W
      if(input$dFC_regline==TRUE) {
        g<-g+geom_smooth(aes(group=X1, fill=X1, size=1.2), method="gam", size=0.5, se=T)
      }
      g
    }
    else if(input$dFC_graph_metrics_plots=="Path Length"){
      g<-PL_plot_W
      if(input$dFC_regline==TRUE) {
        g<-g+geom_smooth(aes(group=X1, fill=X1, size=1.2), method="gam", size=0.5, se=T)
      }
      g
    }
    })

output$dFC_table <- renderTable({
  if(input$dFC_sample== "No covariates (N=1,049)"){
    dFC_table_fullsample
  }  
  else if(input$dFC_sample== "All covariates (N=442)"){
    dFC_table_allcovars
  }
  else if(input$dFC_sample== "Some covariates (N=779)"){
    dFC_table_somecovars
  }
  
})



output$indiv_CS_plot<-renderPlot({
  g<-CS_indiv_counts_props
  if(input$indiv_CS_halves=="Scan Halves"){
    g<-CS_indiv_counts_props_halves
  }
  g
  })

output$dwell_CS_whole <-renderPlot({
  CS_group_dwell_plot
})

output$trans_CS_whole <-renderPlot({
  CS_group_transition_counts_plot
})

output$group_CS_centroid_1 <-renderGirafe({
  ggiraph(ggobj=plot_CS_1, hover_css = "fill:red;")
})

output$group_CS_centroid_2 <-renderGirafe({
  ggiraph(ggobj=plot_CS_2, hover_css = "fill:red;")
})

output$dwell_CS_whole<-renderPlot({
  g<-CS_group_dwell_plot
  if(input$group_CS_halves=="Scan Halves"){
    g<-CS_group_dwell_halves_plot
  }
  g
})

output$trans_CS_whole<-renderPlot({
  g<-CS_group_transition_counts_plot
  if(input$group_CS_halves=="Scan Halves"){
    g<-CS_group_transition_counts_halves_plot
  }
  g
})

output$diss_PDF <- downloadHandler(
  filename="Weis_Defense_Final_12.1.20_postdefense.pdf",
  content=function(file){
    file.copy("www/Weis_Defense_Final_12.1.20_postdefense.pdf", file)
  }
)


}

# Run the application 
shinyApp(ui = ui, server = server)
#runApp("CW_Dissertation_ShinyApp")
