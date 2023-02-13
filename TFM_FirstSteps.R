library(httr)
library(jsonlite)

# API Key from mail
api_key <- # Here you enter the api key provided by the API 

# Parameterss for the endpoint for Gijon, Puerto
fechaIniStr = "2015-01-01T00:00:00UTC" #AAAA-MM-DDTHH:MM:SSUTC # Start date
fechaFinStr = "2019-12-31T23:59:59UTC" #AAAA-MM-DDTHH:MM:SSUTC # End date
EMA = "1208H" #GIJON, PUERTO # More can be look for here: https://datosclima.es/Aemethistorico/Estaciones.php

#Endpoint 
endpoint <- paste0("https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/",fechaIniStr,"/fechafin/",fechaFinStr,"/estacion/",EMA,"/?api_key=")

# API request
response <- GET(paste0(endpoint, api_key))

# Status code
if (status_code(response) != 200) {
  stop("API request failed")
}
response

# Parsing the JSON of the response
weather_data <- fromJSON(content(response, as = "text"))

# Checking the interesting parts of the response
print(weather_data$datos) # endpoint for the weather data itself
print(weather_data$metadatos)
fields = fromJSON(content(GET(weather_data$metadatos), as = "text"))$campos 
print(fields) # Values of the fields from the weather data

# Saving the data in dataframe
#as.data.frame(fromJSON(content(GET(weather_data$datos), as = "text"))) 
gijon_weather_df = as.data.frame(fromJSON(content(GET(weather_data$datos), as = "text")))

