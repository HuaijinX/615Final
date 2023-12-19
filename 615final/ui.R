#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
fluidPage(titlePanel("Barbados"),
          
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
