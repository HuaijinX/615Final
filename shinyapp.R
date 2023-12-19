library(ggplot2)
library(maps)

##Get map data for Barbados
library(leaflet)
barbados_map <- leaflet() %>% 
  addTiles() %>%  # Add default OpenStreetMap tiles
  setView(lng = -59.5432, lat = 13.1939, zoom = 10)  # Set view to Barbados


## Map of location in the world map
world_map <- map_data("world")

barbados_coords <- data.frame(long = -59.5432, lat = 13.1939)

world_map_plot<-ggplot() +
  borders("world", colour="gray50", fill="gray50") + # Draw world map
  geom_point(data = barbados_coords, aes(x = long, y = lat), 
             color = "red", size = 4) + # Add a red circle for Barbados
  ggtitle("Location of Barbados in the World") +
  theme_minimal()

##GDP
data <- read.csv("UNdata_Export_20231218_065119700.csv")

data <- data[data$Item == "Gross Domestic Product (GDP)", ]

data$Value <- data$Value / 1000000

gdp_plot <- ggplot(data, aes(x = Year, y = Value)) +
  geom_line() +  # Draw the line
  labs(x = "Year", y = "GDP (in millions)", title = "GDP Over Time") +
  theme_minimal()+
  theme(
    plot.title = element_text(size = 20, face = "bold"),    # Increase title text size and make it bold
    axis.title.x = element_text(size = 15),                # Increase x-axis title text size
    axis.title.y = element_text(size = 15),                # Increase y-axis title text size
    axis.text.x = element_text(size = 12),                 # Increase x-axis text size
    axis.text.y = element_text(size = 12)                  # Increase y-axis text size
  )
gdp_plot


## Demographics

total_pop <-  read.csv("UNdata_Export_20231218_193405627.csv")
male_pop <- read.csv("UNdata_Export_20231218_200505097.csv")
library(dplyr)
male_pop <- rename(male_pop, Male_Population = Value)
male_pop <- male_pop %>% 
  filter(Year.s. <= 2021)
total_pop <- rename(total_pop, Total_Population = Value)
total_pop <- total_pop %>% 
  filter(Year.s. <= 2021)

# Combine the two datasets by their common key using a join operation
# This assumes that there is a one-to-one correspondence between the rows of male_pop and total_pop
combined_data <- left_join(total_pop, male_pop, by = "Year.s.")  # Replace "Year" with the actual common key

combined_data <- combined_data %>%
  select(-Variant.x, - Variant.y, -Country.or.Area.y)

combined_data <- combined_data %>%
  mutate(Female_Population = Total_Population - Male_Population)

library(tidyr)
long_data <- combined_data %>%
  pivot_longer(
    cols = c(Total_Population, Male_Population, Female_Population), 
    names_to = "Population_Type", 
    values_to = "Population"
  )

#population plot with total, male and female from 1950-2021
population_plot<-ggplot(long_data, aes(x = Year.s., y = Population, color = Population_Type)) +
  geom_line() +
  labs(
    x = "Year",
    y = "Population",
    color = "Population Type",
    title = "Population Over Time by Gender"
  ) +
  
  theme_minimal() +
  scale_color_manual(values = c("Total_Population" = "blue", "Male_Population" = "green", "Female_Population" = "red"))+
  theme(

    plot.title = element_text(size = 20, face = "bold"),    # Increase title text size and make it bold
    axis.title.x = element_text(size = 15),                # Increase x-axis title text size
    axis.title.y = element_text(size = 15),                # Increase y-axis title text size
    axis.text.x = element_text(size = 12),                 # Increase x-axis text size
    axis.text.y = element_text(size = 12),                 # Increase y-axis text size
    legend.text = element_text(size = 12)                  # Increase legend text size
  )

population_plot

# religion
religion <- read.csv("UNdata_Export_20231218_204317290.csv")
religion_2010 <- religion %>%
  filter(Year == 2010, Religion != "Total", Sex == "Both Sexes" )

religion_plot<- ggplot(religion_2010, aes(x = "", y = Value, fill = Religion)) +
  geom_bar(width = 1.5, stat = "identity") +  # Use 'identity' to use the actual values in 'Count'
  coord_polar(theta = "y") +  # Convert the bar plot to a pie chart
  theme_minimal() +
  theme(axis.text.x = element_blank(),  # Remove x-axis labels
        axis.ticks = element_blank(),    # Remove axis ticks
        axis.title.x = element_blank(),  # Remove x-axis title
        panel.grid = element_blank(),
        plot.title = element_text(size = 15, face = "bold"),  # Increase title text size and make it bold
        legend.title = element_text(size = 12),              # Increase legend title text size
        legend.text = element_text(size = 10) )+  
 
  labs(fill = "Religion",
       title = "Religious Distribution in 2010")
religion_plot

# fertility rate

fertility <- read.csv("UNdata_Export_20231218_213152958.csv")

fertility <- fertility %>%
  filter(Year.s.<2022)

fertility$Decade <- (fertility$Year.s. %/% 10) * 10

# Calculate the average fertility rate for each decade
decade_fertility <- fertility %>%
  group_by(Decade) %>%
  summarize(AverageFertility = mean(Value, na.rm = TRUE))

# View the table
print(decade_fertility)


## Comparison with other Islands
# Population
population_comparison <- read.csv("UNdata_Export_20231218_233137164.csv")
population_comparison <- population_comparison %>%
  filter(Year.s. <= 2021)

population_comparison_plot <- ggplot(population_comparison, aes(x = Year.s., y = Value, group = Country.or.Area)) +
  geom_line(aes(color = Country.or.Area),linewidth = 0.2) +
  geom_line(data = subset(population_comparison, Country.or.Area == "Barbados"), 
            aes(x = Year.s., y = Value, color = Country.or.Area), linewidth = 1) +# Line plot for each country
  theme_minimal() +
  labs(x = "Year", y = "Population (in Thousands)", 
       title = "Population Comparison Over Years") +
  theme(
    legend.position = "bottom",
    plot.title = element_text(size = 20, face = "bold"),    
    axis.title.x = element_text(size = 15),              
    axis.title.y = element_text(size = 15),                
    axis.text.x = element_text(size = 12),               
    axis.text.y = element_text(size = 12),                 
    legend.text = element_text(size = 12)              
  )

population_comparison_plot

#gdp comparison

gdp_comparison <- read.csv("UNdata_Export_20231218_232907758.csv")
gdp_comparison <- gdp_comparison %>%
  mutate(Value = Value / 1000000) %>%  # Convert Value to thousands
  arrange(desc(Value))  # Arrange in descending order

# Creating the plot
gdp_comparison_plot <- ggplot(gdp_comparison, aes(x = reorder(Country.or.Area, -Value), y = Value)) +
  geom_bar(stat = "identity") +
  coord_flip() +  
  theme_minimal() +
  labs(x = "Country or Area", y = "GDP (in millions)", 
       title = "GDP Comparison") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
        plot.title = element_text(size = 20, face = "bold"),    
        axis.title.x = element_text(size = 15),                
        axis.title.y = element_text(size = 15),               
        axis.text.y = element_text(size = 12), ) 

gdp_comparison_plot

# fertility comparison

fertility_comparison <- read.csv("UNdata_Export_20231219_000506107.csv")
fertility_comparison <- fertility_comparison %>%
  filter(Year.s.<2022)
fertility_comparison_plot <- ggplot(fertility_comparison, aes(x = Year.s., y = Value, group = Country.or.Area)) +
  geom_line(aes(color = Country.or.Area),linewidth = 0.2) +
  geom_line(data = subset(fertility_comparison, Country.or.Area == "Barbados"), 
            aes(x = Year.s., y = Value, color = Country.or.Area), linewidth = 1) +# Line plot for each country
  theme_minimal() +
  labs(x = "Year", y = "Fertility rate", 
       title = "Fertility Rate Over Years") +
  theme(
    legend.position = "bottom",
    plot.title = element_text(size = 20, face = "bold"),    
    axis.title.x = element_text(size = 15),              
    axis.title.y = element_text(size = 15),                
    axis.text.x = element_text(size = 12),               
    axis.text.y = element_text(size = 12),                 
    legend.text = element_text(size = 12)              
  )

fertility_comparison_plot

# area comparison
area <- read.csv("API_AG.LND.TOTL.K2_DS2_en_csv_v2_6225186.csv", fill = TRUE)
selected_countries <- c("Antigua and Barbuda", "Barbados", "Dominica", 
                        "Grenada", "St. Kitts and Nevis", "St. Lucia", 
                        "St. Vincent and the Grenadines")
area <- area %>%
  select(X2021,Country.Name) %>%
  filter(Country.Name %in% selected_countries)

area_plot<- ggplot(area, aes(x = Country.Name, y = X2021)) + 
  geom_bar(stat = "identity") +
  labs(x = "Country Names", y = "Area (sq. km)", title = "Area of Caribbean islands Countries")+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12),
        plot.title = element_text(size = 20, face = "bold"),    
        axis.title.x = element_text(size = 15),              
        axis.title.y = element_text(size = 15),              
        axis.text.y = element_text(size = 12))

area_plot

##Shinny App Deliver
library(shiny)
library(DT)

# Define UI for application
ui <- fluidPage(
  titlePanel("Barbados"),
  
  # Main tabset panel
  tabsetPanel(
    
    tabPanel("General Description",
             tabsetPanel(
               tabPanel("Narrative Description",
                        # Adding the provided narrative description using HTML tags
                        HTML("<h2>Barbados</h2>
            <p>Barbados is an island country in the Lesser Antilles of the West Indies, in the Caribbean region of North America, and is the most easterly of the Caribbean islands. It lies on the boundary of the South American and the Caribbean Plates. Its capital and largest city is Bridgetown.</p>
                             <h3>Key Facts</h3>
                             <p>Size : Barbados is relatively small, with a total land area of approximately 430 square kilometers. This makes it one of the more compact island nations in the Caribbean.<p>
                             <p>Population: The population of Barbados is estimated to be around 281,200 people (as of 2021)<p>
                             <p>GDP: As of the latest data, Barbados has a Gross Domestic Product (GDP) of about USD 4.84 billion (as of 2021)<p>
                             <p>Religion: Christianity is the predominant religion in Barbados. The largest denomination is Anglican, followed by other Christian denominations including Pentecostal, Methodist, and Roman Catholic.<p>
                             <p>Fertality: The fertility rate in Barbados has been declining, in line with global trends. As of the latest data, the fertility rate in Barbados is approximately 1.6 children per woman.<p>
                             <p>Neighbors:  Martinique, and Saint Lucia to the northwest, Saint Vincent and the Grenadines to the west, Trinidad and Tobago and Venezuela to the southwest, and Guyana to the southeast.<p>"
                             )
               ),
             
               tabPanel("Barbados Map", 
                        leafletOutput("barbadosMap")),
               tabPanel("World Map",
                        plotOutput("ggplotWorldMap"),
                        HTML("<h3>Red Point is where Barbados Located<h3>"))
               # Add more map-related tabs if necessary
             )      
    ),
    
    # Second major panel: Demographics
    tabPanel("Demographics",
             tabsetPanel(
               tabPanel("GDP Plot",
                        plotOutput("ggplotGdp")),
               tabPanel("Population Plot",
                        plotOutput("populationPlot")),
               tabPanel("Religion Chart",
                        plotOutput("piechartReligion")),
               tabPanel("Fertility Rate by Decade",
                        dataTableOutput("fertilityTable")) 
               # Add more demographic-related tabs if necessary
             )
    ),
    
    tabPanel("Comparison to other Caribbean islands",
             tabsetPanel(
               tabPanel("Population",
                        plotOutput("populationComparison")),
               tabPanel("GDP",
                        plotOutput("gdpComparison")),
               tabPanel("Fertility",
                        plotOutput("fertilityComparison")),
               tabPanel("Area",
                        plotOutput("areaPlot"))
             )
             
    ),
    tabPanel("SWOT",
               tabsetPanel(
                 tabPanel("Strengths",
                            HTML("<h2>Strengths</h2>
    <ul>
        <li><strong>Geographic Location</strong>: Advantageous for tourism, situated in a region known for global attractions.</li>
        <li><strong>Steady GDP Growth</strong>: General upward economic trend indicating resilience.</li>
        <li><strong>Stable Population Growth</strong>: Balanced growth in both male and female populations.</li>
        <li><strong>Religious Diversity</strong>: A variety of faiths fostering a tolerant and diverse culture.</li>
    </ul>")),
                 tabPanel("Weakness",
                            HTML("<h2>Weaknesses</h2>
    <ul>
        <li><strong>Economic Fluctuations</strong>: Periods of instability reflected in GDP fluctuations.</li>
        <li><strong>Limited Area</strong>: Relatively small land area limiting resource development potential.</li>
        <li><strong>Fertility Rate Decline</strong>: Decreasing fertility rate may pose future labor market challenges.</li>
    </ul>")),
                 tabPanel("Opportunities",
                            HTML("<h2>Opportunities</h2>
    <ul>
        <li><strong>Tourism Development</strong>: Potential for further development and diversification in tourism.</li>
        <li><strong>Regional Comparison Advantage</strong>: Relative advancement over neighboring countries in population and GDP.</li>
        <li><strong>Religious Harmony</strong>: Opportunity for cultural enrichment and religious tourism development.</li>
    </ul>")),
                 tabPanel("Threats",
                            HTML("<h2>Threats</h2>
    <ul>
        <li><strong>Regional Competition</strong>: Growing competition for tourism and investment in the region.</li>
        <li><strong>Vulnerability to Global Trends</strong>: Economic dependence on global trends poses risks.</li>
        <li><strong>Demographic Shifts</strong>: An aging population could increase pressure on healthcare and social services.</li>
    </ul>"))
               )),
    tabPanel("Reference List",
             HTML("<li><strong>Title of the Dataset</strong>: 'GDP by Type of Expenditure at current prices - US dollars'</li>
                  <li><strong>URL</strong>: https://data.un.org/Data.aspx?q=Barbados+gdp&d=SNAAMA&f=grID%3a101%3bcurrID%3aUSD%3bpcFlag%3a0%3bcrID%3a52</li>
                  <li><strong>Publisher</strong>: United Nations Statistics Division</li>
                  
                  <li><strong>Title of the Dataset</strong>: 'Male Population (thousands)'</li>
                  <li><strong>URL</strong>: https://data.un.org/Data.aspx?q=Barbados+population&d=PopDiv&f=variableID%3a10%3bcrID%3a52 </li>
                  <li><strong>Publisher</strong>: United Nations Statistics Division
                  
                  <li><strong>Title of the Dataset</strong>: 'Total Population, both sexes bombined (thousands)'</li>
                  <li><strong>URL</strong>: https://data.un.org/Data.aspx?q=population&d=PopDiv&f=variableID%3a12 </li>
                  <li><strong>Publisher</strong>: United Nations Statistics Division</li>
                 
                  <li><strong>Title of the Dataset</strong>: 'Total fertility rate (live births per woman)'</li>
                  <li><strong>URL</strong>: https://data.un.org/Data.aspx?q=Barbados+fertility&d=PopDiv&f=variableID%3a54%3bcrID%3a52 </li>
                  <li><strong>Publisher</strong>: United Nations Statistics Division</li>
                  
                  <li><strong>Title of the Dataset</strong>: 'Population by religion, sex and urban/rural residence'</li>
                  <li><strong>URL</strong>: https://data.un.org/Data.aspx?q=Barbados+population&d=POP&f=tableCode%3a28%3bcountryCode%3a52 </li>
                  <li><strong>Publisher</strong>: United Nations Statistics Division</li>
                  
                  <li><strong>Title of the Dataset</strong>: 'Land area (sq. km)'</li>
                  <li><strong>URL</strong>: https://data.worldbank.org/indicator/AG.LND.TOTL.K2 </li>
                  <li><strong>Publisher</strong>: World Development Indicators</li>
                  
                  <li><strong>Wekipedia</strong></li>
                  <li><strong>URL</strong>:https://en.wikipedia.org/wiki/Barbados </li>
                  
                  <li><strong>ChatGPT</strong></li>
                  <li><strong>URL</strong>:http://chat.openai.com </li>
                  "
                  )
            )
  )
)

  


# Define server logic
server <- function(input, output) {
  
  # Render the pre-defined leaflet Barbados map
  output$barbadosMap <- renderLeaflet({
    barbados_map
  })
  
  # Render the pre-defined ggplot world map
  output$ggplotWorldMap <- renderPlot({
    world_map_plot
  })
  output$ggplotGdp <- renderPlot({
    gdp_plot
  })
  output$populationPlot <- renderPlot({
    population_plot
  })
  output$piechartReligion <- renderPlot({  
    religion_plot
  })
  output$fertilityTable <- renderDataTable({
    decade_fertility
  })
  output$populationComparison <- renderPlot({
    population_comparison_plot
  })
  output$gdpComparison <- renderPlot({
    gdp_comparison_plot
  })
  output$fertilityComparison <-renderPlot({
    fertility_comparison_plot
  })
  output$areaPlot <- renderPlot({
    area_plot
  })
}


# Run the application 
shinyApp(ui = ui, server = server)







#Title of the Dataset: GDP by Type of Expenditure at current prices - US dollars
#URL: https://data.un.org/Data.aspx?q=Barbados+gdp&d=SNAAMA&f=grID%3a101%3bcurrID%3aUSD%3bpcFlag%3a0%3bcrID%3a52
#Date Accessed: [Insert the date you accessed the dataset]
#Publisher: United Nations Statistics Division

# Male population: https://data.un.org/Data.aspx?q=Barbados+population&d=PopDiv&f=variableID%3a10%3bcrID%3a52
# Total polulation: https://data.un.org/Data.aspx?q=Barbados+population&d=PopDiv&f=variableID%3a12%3bcrID%3a52
# Religion: https://data.un.org/Data.aspx?q=Barbados+population&d=POP&f=tableCode%3a28%3bcountryCode%3a52
# Fertility: https://data.un.org/Data.aspx?q=Barbados+fertility&d=PopDiv&f=variableID%3a54%3bcrID%3a52
# Population Comparison:https://data.un.org/Data.aspx?q=Island+State&d=PopDiv&f=variableID%3a12%3bcrID%3a1637%2c275%2c68
# GDP comparison: https://data.un.org/Data.aspx?q=Saint+Lucia+GDP&d=SNAAMA&f=grID%3a101%3bcurrID%3aUSD%3bpcFlag%3a0%3bcrID%3a662
# Fertility comparison: https://data.un.org/Data.aspx?q=fertility&d=PopDiv&f=variableID%3a54
# Land Area: https://data.worldbank.org/indicator/AG.LND.TOTL.K2
# World Development Indicators