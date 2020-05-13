#' Set python version
#'
#' @param conda name of conda environment, one of conda or venv must be specified
#' @param venv name of virtual environment, one of conda or venv must be specified
#'
#' @return None
#'
#' @examples
#' set_python(conda="dj")
#'
#' @export
set_python <- function(conda=NULL, venv=NULL){

  if(!is.null(conda)){
    if(!is.null(venv)){
      stop("Both conda environment and virtualenv are specified. Please specify only one version of python to use. If neither is specified, will use the stored default python.")
    }else{
      tryCatch(reticulate::use_condaenv(conda, required=T),
               error = function(e){
                                    cur_py = reticulate::py_config()$python
                                    warning(paste0("python = ", cur_py, " is already loaded. You must restart the R session to switch to conda environment = ", conda))
                                  }
               )
    }
  }else if(!is.null(venv)){
    tryCatch(reticulate::use_virtualenv(venv, required=T),
             error = function(e){
                                  cur_py = reticulate::py_config()$python
                                  warning(paste0("python = ", cur_py, " is already loaded. You must restart the R session to switch to virtualenv = ", venv))
                                }
             )
  }

}
