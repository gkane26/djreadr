#' Import datajoint-python module
#'
#' Imports module (and schema) from which to fetch data
#'
#' @param module the name of the python module containing your schemas. Default = ".", the local working directory
#' @param schema the names of the schema(s) to import. Default = "*" (imports all modules)
#'
#' @export
dj_import <- function(module=".", schema="*"){
  reticulate::py_run_string(paste('from', module, 'import', schema))
}
