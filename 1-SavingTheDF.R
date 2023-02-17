library(httr)
library(jsonlite)

# API Key (del correo)
api_key <- "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJyb2RyaXNhYmF0ZHNAZ21haWwuY29tIiwianRpIjoiOWJiMTAxNjMtN2NlZi00NmRkLTkxOGItYzRhNzVhZjc3NTZmIiwiaXNzIjoiQUVNRVQiLCJpYXQiOjE2NzYzMTQ2OTEsInVzZXJJZCI6IjliYjEwMTYzLTdjZWYtNDZkZC05MThiLWM0YTc1YWY3NzU2ZiIsInJvbGUiOiIifQ.IFE7mC_Sf2Y9IfiG8564KkrKYIrvs-pnHqzdZpHdnOk"

# 20 years study
# Start 2002, End 2022

# Estación meteorologica
EMA = "1208H" #GIJON, PUERTO #de https://datosclima.es/Aemethistorico/Estaciones.php

# 20 years study
# Start 2002, End 2022
init=2002
fin=2022

# Creating the dataframe and saving the daily data year per year
gijon_weather_df = data.frame()

for (year in seq(init,fin,1)){
  fechaIniStr = paste0(year,"-01-01T00:00:00UTC")
  fechaFinStr = paste0(year,"-12-31T23:59:59UTC")
  endpoint = paste0("https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/",fechaIniStr,"/fechafin/",fechaFinStr,"/estacion/",EMA,"/?api_key=")
  
  response = GET(paste0(endpoint, api_key))
  if (status_code(response) != 200) {
    stop("API request failed")
  }
  
  weather_data = fromJSON(content(response, as = "text"))
  gijon_weather_df = rbind(gijon_weather_df,as.data.frame(fromJSON(content(GET(weather_data$datos), as = "text"))))
  
  
}

# Parsing the data to dates and floats
gijon_weather_df$fecha <- as.Date(gijon_weather_df$fecha)
variables = c("altitud","tmed","prec","tmin","tmax","sol","presMax","presMin")
for (i in variables){
  gijon_weather_df[[i]] = as.numeric(gsub(",",".",gijon_weather_df[[i]]))
}

#Saving the data as a csv file
write.csv(gijon_weather_df, file = paste0("GijonWeather_",init,"_",fin,".csv"))
print(paste0("GijonWeather_",init,"_",fin,".csv"," Saved"))

