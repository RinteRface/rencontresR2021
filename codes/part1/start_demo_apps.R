# To start local demo apps for the presentation.
# Requires processx and purrr

# Baseline function to start app
start_app <- function(path, port) {
  temp_app <- processx::process$new(
    "Rscript",
    c(
      "-e",
      sprintf("thematic::thematic_shiny();
      shiny::runApp('%s', port = %s)",
      path, port)
    )
  )
  Sys.sleep(2)
  message(sprintf("%s app started: http://localhost:%s", path, port))
  temp_app
}

# Start all apps
start_apps <- function() {
  
  paths <- list.dirs("./assets/R", recursive = FALSE)
  ports <- rep(3510, length(paths)) + 1:length(paths)
  purrr::map2(paths, ports, start_app)
}

# Kill all apps
kill_apps <- function(apps) {
  for(app in apps) app$kill()
}

apps <- start_apps()
# kill_apps(apps)
