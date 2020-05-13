#' Set datajoint configuration
#'
#' Sets the datajoint.config with desired hostname, username, and password
#' and saves the edited datajoint.config either locally or globally.
#'
#' @param host ip address of host database
#' @param user user name
#' @param pw password
#' @param save_global boolean; if TRUE, save configuration globally. If FALSE, save configuration locally
#'
#' @return None
#'
#' @export
set_config <- function(host=NULL, user=NULL, pw=NULL, save_global=T){

  reticulate::py_run_string("import datajoint as dj")
  if(!is.null(host)) reticulate::py_run_string(paste0("dj.config['database.host'] = ", host))
  if(!is.null(user)) reticulate::py_run_string(paste0("dj.config['database.user'] = ", user))
  if(!is.null(pw)) reticulate::py_run_string(paste0("dj.config['database.password'] = ", pw))

  if(save_global)
    reticulate::py_run_string("dj.config.save_global()")
  else
    reticulate::py_run_string("dj.config.save_local()")

}

#' Get datajoint configuration

#' @return Datajoint config
#'
#' @export
get_config <- function(){

  dj = reticulate::import("datajoint")
  return(dj$config)

}
