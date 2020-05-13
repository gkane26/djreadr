#' Connect to datajoint database
#'
#' @param conda conda environment to use. May only specify one of conda or venv
#' @param venv virtual environment to use. May only specify one of conda or venv
#'
#' @examples
#' dj_connect()
#'
#' @export
dj_connect <- function(conda=NULL, venv=NULL){

  set_python(conda, venv)
  dj = reticulate::import("datajoint")
  dj$conn()

}
