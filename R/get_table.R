#' Get datajoint table
#'
#' Fetches data from a datajoint table, returns as a list or whatever format is returned from the callback.
#'
#' @param sch the names of the schema(s) used to fetch. Must be used in combination with tbl or query.
#'   If providing tbl, sch should be a string.
#'   If providing query, sch should consist of all schemas used in the query. Can be a string or a vector if multiple schemas are used.
#' @param tbl the table to fetch. Must specify either (sch and tbl) or query
#' @param restrictions a vector of strings containing restrictions. See details. Only used with sch and tbl
#' @param query a python datajoint query as a string. Must specify either (sch and tbl) or sch and query
#' @param module the name of the python module containing your schemas
#' @param callback a callback function to process data returned from the query
#' @param add_vars a list of addititional variables to add to the data, optional
#' @param ... additional arguments passed to callback
#'
#' @return if callback is specified, data is returned in the form of the callback's return. otherwise, returns data fetched from datajoint table as a list.
#'
#'@export
get_table = function(sch=NULL, tbl=NULL, restrictions=NULL, query=NULL, module="schema", callback=NULL, add_vars=list(), ...){

  # initialize schema
  mod = reticulate::import(module)
  for(i in sch) mod[[i]]

  # import module in python space
  reticulate::py_run_string(paste('from', module, 'import *'))

  # create query
  if((length(sch) == 1) & !is.null(tbl)){
    query = paste0(sch, '.', tbl, '()')
    for(i in 1:length(restrictions)){
      rname = names(restrictions)[i]
      if(class(restrictions[[i]]) %in% c("character", "factor"))
        rval = paste0('"', restrictions[[i]], '"')
      else
        rval = restrictions[[i]]
      query = paste0(query, ' & \'', rname, "=", rval, '\'')
    }
  }else if(is.null(query)){
    stop("Parameters misspecified! Must provide either sch & tbl combination, or vector of sch with full query")
  }

  reticulate::py_run_string(paste0("qry = ", query))
  dat = reticulate::py$qry$fetch(as_dict=T)

  if(length(dat) > 0){
    for(i in 1:length(dat)) dat[[i]] = c(dat[[i]], add_vars)
    if(!is.null(callback))
      return(callback(dat, ...))
    else
      return(dat)
  }else{
    warning(paste0("Query = '", query, "' produced no results!"))
    return(NULL)
  }
}
