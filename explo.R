library(ggplot2)
library(dplyr)
library(plotly)
library(htmlwidgets)


liste_pays = c("AU", "CA", "DE", "FR", "GB", "JP", "US")
  
for (code_pays in liste_pays){
  
  print(code_pays)

  # par métiers
  don = read.csv2(paste0("GitHub/job_postings_tracker/",
                         code_pays,
                         "/job_postings_by_sector_",
                         code_pays, ".csv"),
                  sep = ",")

  don$date = as.Date(don$date)
  don$indeed_job_postings_index = as.numeric(don$indeed_job_postings_index)

  plot = plot_ly(don, x = ~date, y = ~indeed_job_postings_index,
                 color = ~display_name) %>%
    add_lines() %>%
    layout(showlegend = FALSE)

  plot

  saveWidget(plot, paste0("GitHub/job_postings_tracker/", code_pays, "/plot.html"))
  
}

i = 0
for (code_pays in liste_pays){
  
  i = i + 1
  
  print(code_pays)
  
  # total par pays
  tmp = read.csv2(paste0("GitHub/job_postings_tracker/",
                         code_pays,
                         "/aggregate_job_postings_",
                         code_pays, ".csv"),
                  sep = ",")
  
  tmp$date = as.Date(tmp$date)
  tmp$indeed_job_postings_index_SA = as.numeric(tmp$indeed_job_postings_index_SA)

  if(i==1){don=tmp}
  else{don = rbind(don, tmp)}

  if(i==length(liste_pays)){
    
    plot = plot_ly(don[don$variable=="total postings",],
                   x = ~date, y = ~indeed_job_postings_index_SA, 
                   color = ~jobcountry) %>%
      add_lines()
    
    plot
    
    saveWidget(plot, paste0("GitHub/job_postings_tracker/plot_aggregate_all_countries.html"))
    
  }
  
}

