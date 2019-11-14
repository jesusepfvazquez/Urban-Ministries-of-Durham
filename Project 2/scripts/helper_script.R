library(tidyverse)

# Helper function to load the data and filter
loaddata <- function(){
    
    mydf_original <- read_tsv("UMD_Services_Provided_20190719.tsv")

    
    # Removing observations that have NAs in type of bill paid and financial support
    mydf <- mydf_original[-which(is.na(mydf_original$`Financial Support`)),]
    mydf <- mydf[-which(is.na(mydf$`Type of Bill Paid`)),]
    
    # Excluding those who were not given financial support 
    mydf <- mydf[-which(mydf$`Financial Support` == 0),]
    
    #changing all characters to lower case and grouping them by category
    mydf$`Type of Bill Paid` <- (tolower(mydf$`Type of Bill Paid`))
    
    # Categorize each type of bill by the type key words used to describe the event, e.g. energy -> Electricity Bill
    # Column 14 is the type of bill
    
    for (i in 1:dim(mydf)[1]) {
        
        # Those paying their electricity bill
        if(str_detect(mydf[i,14], c("duke")) || str_detect(mydf[i,14], c("power")) || str_detect(mydf[i,14], "electricity") || str_detect(mydf[i,14], "energy")){
            mydf[i,14] <- paste("Electricity Bill") 
            next
        }
        
        # those paying their water bill
        if(str_detect(mydf[i,14], "water")){
            mydf[i,14] <- paste("Water Bill") 
            next
        }
        
        # those that needed money to get home in different state or transportation related expenses
        if(str_detect(mydf[i,14], "bus") || str_detect(mydf[i,14], "greyhound") || str_detect(mydf[i,14], "ticket") || str_detect(mydf[i,14], "car")){
            mydf[i,14] <- paste("Transportation") 
            next
        }
        
        # Those needing to pay rent or other housing relating bills
        if(str_detect(mydf[i,14], "rent") || str_detect(mydf[i,14], "mortgage") || str_detect(mydf[i,14], "deposit")){
            mydf[i,14] <- paste("Housing") 
            next
        }
        
        # Those needing to pay their Natural Gas Bill
        if(str_detect(mydf[i,14], "gas") || str_detect(mydf[i,14], "heating")){
            mydf[i,14] <- paste("Gas Bill") 
            next
        }
        
        # Medical related expenses
        if(str_detect(mydf[i,14], "prescription") || str_detect(mydf[i,14], "med") || str_detect(mydf[i,14], "hospital") || str_detect(mydf[i,14], "eyeglasses") || str_detect(mydf[i,14], "pharmacy")){
            mydf[i,14] <- paste("Medical Expenses") 
            next
        }
        
        # If the bill did not make it into any of the other categories is was lumped with other
        mydf[i,14] <- paste("Other")
    }
    
    mydf <- subset(mydf, select = c(`Type of Bill Paid`, `Financial Support`, `Date`))
    return(mydf)
}

mydata <- loaddata()

# Helper function to create plot by 
f <- function(typeofbill){
    mydata_plot = mydata %>% subset(mydata$`Type of Bill Paid` == typeofbill)
    ggplot(mydata_plot, aes(x=mydata_plot$`Type of Bill Paid`, y=mydata_plot$`Financial Support`)) + geom_boxplot() +
        labs(title="Amount Awarded from Financial Support", caption="Data Source: Urban Ministries of Durham", y = 'Amount Awarded', x = '') +
        theme(axis.text.y = element_text(size=12), axis.title=element_text(size=14,face="bold")) + theme_minimal() +
        coord_flip()
    
}

f1 <- function(typeofbill){
    mydata_average = mydata %>% subset(mydata$`Type of Bill Paid` == typeofbill)
    return(mean(mydata_average$`Financial Support`))
}

f2 <- function(typeofbill){
    mydata_max = mydata %>% subset(mydata$`Type of Bill Paid` == typeofbill)
    return(max(mydata_max$`Financial Support`))
}

f2_1 <- function(typeofbill){
    mydata_max_date = mydata %>% subset(mydata$`Type of Bill Paid` == typeofbill)
    return(mydata_max_date[which(mydata_max_date$`Financial Support` == max(mydata_max_date$`Financial Support`)),3])
}

f3 <- function(typeofbill){
    mydata_min = mydata %>% subset(mydata$`Type of Bill Paid` == typeofbill)
    return(min(mydata_min$`Financial Support`))
}

f3_1 <- function(typeofbill){
    mydata_min_date = mydata %>% subset(mydata$`Type of Bill Paid` == typeofbill)
    return(mydata_min_date[which(mydata_min_date$`Financial Support` == min(mydata_min_date$`Financial Support`)),3])
}

f4 <- function(typeofbill){
    mydata_size = mydata %>% subset(mydata$`Type of Bill Paid` == typeofbill)
    return(dim(mydata_size)[1])
}