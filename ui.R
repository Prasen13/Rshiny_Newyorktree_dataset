#install.packages("shiny")
library(shiny)


ui <- fluidPage(    
    
    #header
    headerPanel("NEWYORK CITY TREE DISTRIBUTION DASHBOARD"),
    
    #Sidepanel layout
    sidebarPanel(
        h5("The details about the status, species rank, health conditions, and tree distribution in NYC is provided in this page"),
        hr(),
        
        
        #Selecting the borough [checkbox]
        checkboxGroupInput(inputId = "borough",
                           label = "Borough",
                           choices=c("Brooklyn","Staten Island","Queens","Manhattan","Bronx"),
                           selected = "Brooklyn"),
    
        
        hr(),
        
        #Selecting the  top species to compare [Slider input]
        sliderInput(inputId = "number", 
                    label =  "Select the number of top species",
                    min=1,
                    max=9,
                    value=4),
        hr(),
        
        #Select tree type using  button [check box]
        checkboxGroupInput(inputId = "Treetype",                                #"outputType" ["guard"],
                           label = "Select type of Tree",
                           choices = list("Harmful" = "Harmful",
                                          "Helpful" = "Helpful",
                                          "Unsure" = "Unsure")),
        hr(),
        
        
        #Selecting the species type [Dropdown]
        selectInput(inputId = "spec", 
                    label =  "Select the tree species for which you want health status results?",
                    choices = list(
                        "",
                        "'Schubert' chokecherry",
                        "London planetree",
                        "American elm",
                        "American hophornbeam",
                        "American hornbeam",
                        "American larch",
                        "American linden",
                        "Amur cork tree",
                        "Amur maackia",
                        "Amur maple",
                        "arborvitae",
                        "ash",
                        "Atlantic white cedar",
                        "Atlas cedar",
                        "bald cypress",
                        "bigtooth aspen",
                        "black cherry",
                        "black locust",
                        "black maple",
                        "black oak",
                        "black pine",
                        "black walnut",
                        "blackgum",
                        "blue spruce",
                        "boxelder",
                        "bur oak",
                        "Callery pear",
                        "catalpa",
                        "cherry",
                        "Chinese chestnut",
                        "Chinese elm",
                        "Chinese fringetree",
                        "Chinese tree lilac",
                        "cockspur hawthorn",
                        "common hackberry",
                        "Cornelian cherry",
                        "crab apple",
                        "crepe myrtle",
                        "crimson king maple",
                        "cucumber magnolia",
                        "dawn redwood",
                        "Douglas-fir",
                        "eastern cottonwood",
                        "eastern hemlock",
                        "eastern redbud",
                        "eastern redcedar",
                        "empress tree",
                        "English oak",
                        "European alder",
                        "European beech",
                        "European hornbeam",
                        "false cypress",
                        "flowering dogwood",
                        "ginkgo",
                        "golden raintree",
                        "green ash",
                        "hardy rubber tree",
                        "hawthorn",
                        "hedge maple",
                        "Himalayan cedar",
                        "holly",
                        "honeylocust",
                        "horse chestnut",
                        "Japanese hornbeam",
                        "Japanese maple",
                        "Japanese snowbell",
                        "Japanese tree lilac",
                        "Japanese zelkova",
                        "katsura tree",
                        "Kentucky coffeetree",
                        "Kentucky yellowwood",
                        "kousa dogwood",
                        "littleleaf linden",
                        "London planetree",
                        "magnolia",
                        "maple",
                        "mimosa",
                        "mulberry",
                        "northern red oak",
                        "Norway maple",
                        "Norway spruce",
                        "Ohio buckeye",
                        "Oklahoma redbud",
                        "Osage-orange",
                        "pagoda dogwood",
                        "paper birch",
                        "paperbark maple",
                        "Persian ironwood",
                        "pignut hickory",
                        "pin oak",
                        "pine",
                        "pitch pine",
                        "pond cypress",
                        "purple-leaf plum",
                        "quaking aspen",
                        "red horse chestnut",
                        "red maple",
                        "red pine",
                        "river birch",
                        "sassafras",
                        "sawtooth oak",
                        "scarlet oak",
                        "Schumard's oak",
                        "Scots pine",
                        "serviceberry",
                        "Shantung maple",
                        "shingle oak",
                        "Siberian elm",
                        "silver birch",
                        "silver linden",
                        "silver maple",
                        "smoketree",
                        "Sophora",
                        "southern magnolia",
                        "southern red oak",
                        "spruce",
                        "sugar maple",
                        "swamp white oak",
                        "sweetgum",
                        "sycamore maple",
                        "tartar maple",
                        "tree of heaven",
                        "trident maple",
                        "tulip-poplar",
                        "Turkish hazelnut",
                        "two-winged silverbell",
                        "Virginia pine",
                        "weeping willow",
                        "white ash",
                        "white oak",
                        "white pine",
                        "willow oak"
                    ),
                    selected="American beech"),   
        hr(),
        
    ),
    
    
    mainPanel(
        tabsetPanel(
            
            #Data information panel
            tabPanel("Dataset Information",
                     h3("About this dataset"),
                     p("The dataset contains the specific information of street trees (like status, health, species, etc.) 
                     in the 5 boroughs of New York city. 
                      The data is been collected by volunteers of NYC parks & Recreation and partner organizations."),
                     br(), 
                     h3("How can we make NYC an urban forest?"),
                     p("Our group is concerned about making NYC an urban forest by planting trees and improving green ecosystems.
                       As a result, we'll concentrate on identifying the areas where tree care is most needed, 
                       the top species with the most trees in each borough, the health of those species, and the distribution of trees 
                       in each borough."),
                     br(),
                     uiOutput("tab")),
            
            
            #Tree status panel
            tabPanel("Tree Status", plotOutput("p1")), 
            
            
            #Order of species panel
            tabPanel("Order Of Species", 
                     plotOutput("t1"), 
                     h4(textOutput("caption2")),
                     fluidRow(
                         column(6,tableOutput("t2")),
                         column(6,tableOutput("t3")),
                         column(6,tableOutput("t4")),
                         column(6,tableOutput("t5")),
                         column(6,tableOutput("t6"))),
            ), 
            
            #tree type
            tabPanel("Tree type", plotOutput("p4")),
            
            
            #health status
            tabPanel("Health Status", plotOutput("p2")),
            

            #Boxplot
            tabPanel("Sidewalk", plotOutput("p5")),
            
            #Map
            tabPanel("Map", plotOutput("p3")),
            
           
            
            #Conclusion
            tabPanel("Conclusion",
                     br(), 
                     p("Since more than 90% of the trees in the five boroughs are still alive, that means trees are taken good care of.
                       To make New York a green city, we propose setting a target of getting at least 95 percent live trees 
                       in each borough over the next three years. "),
                     br(),
                     p("Within the five boroughs, there are a variety of species, but the London planetree, Pin oak, Callery pear, and 
                     Honeylocust are the most common. To increase the variety of tree species, 
                     we recommend that NYC increase the numbers of other tree species such as 
                     Red maple, American linden, Cherry, Norway maple, and others."),
                     br(),
                     p("All five boroughs have less than 90% healthy trees, with Manhattan having the lowest percentage
                       of healthy trees compared to the other boroughs, particularly when it comes to Callery pear and London planetree. 
                       Over the next five years, we encourage each borough, especially Manhattan, to strive for at least 90% healthy trees.")
            ),
            
            
            #Data 
            tabPanel("Data", fluidPage(dataTableOutput('table')
                                           
            ))
        )
    )
)