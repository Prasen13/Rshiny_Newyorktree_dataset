#install.packages("tidyverse")
#install.packages("dplyr")
#install.packages("ggplot2")
#install.packages("maps")
#install.packages("RColorBrewer")
library(RColorBrewer)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(maps)
library(gridExtra)
library(grid)
library(DT)
library(data.table)


#Setting the working directory
setwd("~/Documents/Documents/Rshiny project/4rshiny")

#Reading the dataset
Tree_df <- read.csv("./Tree_Data .csv")

#Dropping the row names
rownames(Tree_df) <- NULL

server <- function(input,output,session){
    
 
    url <- a("2015 NYC Tree Census", href="https://www.nycgovparks.org/trees/street-tree-planting/species-list/")
    
    tx1 <- reactive(sprintf("The percentage distribution of Tree status in %s",paste(input$borough,collapse=",")))
    tx2 <- reactive(sprintf("Top %s species in %s",input$number,paste(input$borough,collapse=",")))
    tx3 <- reactive(sprintf("The health condition of %s in %s",input$spec,paste(input$borough,collapse=",")))
    tx4 <- reactive(sprintf("The  %s Species in %s",input$spec,paste(input$borough,collapse=",")))
    tx5 <- reactive(sprintf("The Distribution of Tree type in %s",paste(input$borough,collapse=",")))
    tx6 <- reactive(sprintf("Sidewalk Damage with respect to tree diameter in %s of %s",paste(input$borough,collapse=","),paste(input$Treetype,collapse=",")))
    
    #omitting null values for spc_common attribute
    data1 <- Tree_df[!Tree_df$spc_common=="",] 
    
    #Borough and common species count
    data2 <- data1 %>% group_by(borough,spc_common) %>% tally 
    
    #assigning the namings for columns
    names(data2) <- c("Borough","Species","Count") 
    
    #ordering the top count species[descending]``
    data3 <- data2[order(-data2$Count),]  
    
    
    #url output
    output$tab <- renderUI({
        tagList("For more information, visit:", url)
    })
    
    #StatusTab
    output$p1 <- renderPlot({
        data4 <- Tree_df[Tree_df$borough %in% input$borough,]
        data4$status <- factor(data4$status,levels=c("Alive","Dead","Stump"))
        pl1 <- ggplot(data4, aes(x=as.factor(borough), fill=status))+
            geom_bar(aes(y=..count../tapply(..count.., ..x.. ,sum)[..x..]), width=0.8,position=position_dodge(width = 0.89) ) +
            scale_y_continuous(breaks=seq(0,1,0.1),limits=c(0,1),labels = scales::percent)+
            scale_fill_manual(values=c("green","red","orange"))
        lb1<-labs(title=tx1(),x=element_blank(),y=element_blank())
        background_theme <- theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank(),panel.background = element_blank())
        
        pl1+lb1+background_theme+
            theme(legend.title=element_blank(),legend.position="top")+
            theme(plot.title=element_text(face="bold",color="black",hjust = 0.4,size = 14.5))
    })
    
    #SpeciesRankTab
    output$t1 <- renderPlot({
        #Tree_df1 <- passData
        data5 <- Tree_df[!Tree_df$spc_common=="",]
        data6 <- data5[data5$borough %in% input$borough,]
        data7 <- data6 %>% group_by(borough,spc_common) %>% tally
        data8 <- unite(data7,"name",borough,spc_common)
        data9 <- head(data8[order(-data8$n),],input$number)
        data9$name <- factor(data9$name,levels=rev(data9$name))
        mycolor <- brewer.pal(9,"RdPu")
        mycolor1 <- rev(mycolor)
        pl4 <- ggplot(data9, aes(x=as.factor(name),fill=name,y=n))+
            geom_bar(stat="identity",width=0.8,position=position_dodge(width = 0.89),show.legend = FALSE) +
            scale_fill_manual(values=mycolor1[nrow(data9):1])
        lb4<-labs(title=tx2(),x=element_blank(),y=element_blank()) 
        background_theme <- theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank(),panel.background = element_blank())
        
        pl4+lb4+background_theme+                #coord_flip()+
            theme(legend.title=element_blank(),legend.position="top")+
            theme(plot.title=element_text(face="bold",color="black",hjust = 0.4, size = 14.5))
    })
    
    #tree type
    output$p4 <- renderPlot({
        Tree_df0 <- Tree_df[Tree_df$borough %in% input$borough,]
        Tree_df1 <- Tree_df0[Tree_df0[,"guards"] %in% unlist(input$Treetype),]
        ggplot(data = Tree_df1 , aes(borough, ..count..)) +
            geom_bar(aes(fill=guards), position = "dodge") +
            theme_minimal() +
            labs(title = tx5(),
                 x = element_blank(),
                 y=element_blank())+
            theme(legend.title=element_blank(),legend.position="top")+
            theme(plot.title=element_text(face="bold",color="black",hjust = 0.4, size = 14.5))
        
    }) 
    
    #table
    output$caption2 <- renderText({"Below are the whole tables:"})
    
    output$t2 <- renderTable({data3[data3$Borough %in% (input$borough[1]),]})
    output$t3 <- renderTable({data3[data3$Borough %in% (input$borough[2]),]})
    output$t4 <- renderTable({data3[data3$Borough %in% (input$borough[3]),]})
    output$t5 <- renderTable({data3[data3$Borough %in% (input$borough[4]),]})
    output$t6 <- renderTable({data3[data3$Borough %in% (input$borough[5]),]})
    
    #Health Condition
    output$p2 <- renderPlot({
       #Tree_df1 <- passData()
        data10 <- Tree_df[!Tree_df$spc_common=="",]
        data11 <- data10[data10$spc_common %in% input$spec,]
        data12 <- data11[data11$borough %in% input$borough,]
        data12$health <- factor(data12$health,levels=c("Good","Fair","Poor"))
        
        pl2 <- ggplot(data12, aes(x=as.factor(borough), fill=health))+
            geom_bar(aes(y=..count../tapply(..count.., ..x.. ,sum)[..x..]), width=0.8,position=position_dodge(width = 0.89) ) +
            scale_y_continuous(breaks=seq(0,1,0.1),limits=c(0,1),labels = scales::percent)+
            scale_fill_manual(values=c("green","orange","red"))
        
        lb2<-labs(title=tx3(),x=element_blank(),y=element_blank())   #
        background_theme <- theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank(),panel.background = element_blank())
        
        pl2+lb2+background_theme+
            theme(legend.title=element_blank(),legend.position="top")+
            theme(plot.title=element_text(face="bold",color="black",hjust = 0.4, size = 14.5)) 
    })
    
    #Map distribution
    output$p3 <- renderPlot({
        #Tree_df1 <- passData()
        data13 <- Tree_df[!Tree_df$spc_common=="",]
        data14 <- data13[data13$spc_common %in% input$spec,]
        data15 <- data14[data14$borough %in% input$borough,]
        map1 <- borders('county','new york',colour = "gray55",fill="white")
        pl3<-ggplot()+
            map1+
            xlim(-74.3,-73.7)+ylim(40.45,40.95)+
            geom_point(aes(x=data15$longitude,y=data15$latitude),color="light green")
        lb3<-labs(title=tx4())
        background_theme <- theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank(),panel.background = element_blank())
        
        pl3+lb3+background_theme+
            theme(legend.title=element_blank(),legend.position="top")+
            labs( x ="Longtitude", y = "Latitude")+
            theme(plot.title=element_text(face="bold",color="black",hjust = 0.4, size = 14.5))
    })
    
    #Sidewalk
    output$p5 <- renderPlot({
        data19 <- Tree_df[Tree_df$borough %in% input$borough,]
        data20 <- data19[data19[,"guards"] %in% unlist(input$Treetype),]
        data20 <- data20[!data20$sidewalk == "",]
        
        ggplot(data20, aes(borough,tree_dbh,fill = sidewalk)) +
            geom_boxplot() +
            labs(title = tx6())+
            theme_minimal() +
            theme(legend.title=element_blank(),legend.position="top")+
            theme(plot.title=element_text(face="bold",color="black",hjust = 0.4, size = 14.5)) 
    
        
            
    })
    
    #Data
    output$table <- DT::renderDataTable({
        datatable(Tree_df, rownames=FALSE)
    })
}
