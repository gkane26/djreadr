#' Get datajoint table
#'
#' Fetches data from a datajoint table, using restrictions from a log (a data frame)
#'
#' @param sch the names of the schema used to fetch; string
#' @param tbl the table to fetch; string
#' @param log a data frame with column names as key and rows as value for restrictions
#' @param module the name of the python module containing your schemas
#' @param callback a callback function to process data returned from the query
#' @param add_vars a list of addititional variables to add to the data, optional
#' @param ... additional arguments passed to callback
#'
#' @return Returns a list. if callback is specified, contents of the list are in the form of the callback's return. otherwise, returns a list of lists.
#'
#'@export
get_table_from_log = function(sch, tbl, log, module="schema", callback=NULL, add_vars=list(), ...){

  dat = list()

  for(i in 1:nrow(log)){

    restrictions = list()
    for(j in 1:ncol(log)){
      restrictions[[names(log[j])]] = log[[j]][i]
    }

    dat[[i]] = get_table(sch, tbl, restrictions, module=module, callback=callback, add_vars=add_vars, ...)

  }

  return(dat)
}
