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
#' @format string; format to fetch data. either "dict" for dictionary or "df" for data.frame
#' @param callback a callback function to process data returned from the query
#' @param add_vars a list of additional variables to add to the data, optional
#' @param ... additional arguments passed to callback
#'
#' @return if callback is specified, data is returned in the form of the callback's return. otherwise, returns data fetched from datajoint table as a list.
#'
#' @export
dj_fetch = function(sch=NULL, tbl=NULL, restrictions=NULL, query=NULL, format="dict", callback=NULL, add_vars=list(), ...){

  # create query
  if (!is.null(sch) & !is.null(tbl)) {
    query = paste0(sch, '.', tbl, '()')
    for(i in names(restrictions)){
      if(class(restrictions[[i]]) %in% c("character", "factor"))
        rval = paste0('"', restrictions[[i]], '"')
      else
        rval = restrictions[[i]]
      query = paste0(query, ' & \'', i, "=", rval, '\'')
    }
  } else if(is.null(query)){
    stop("Parameters misspecified! Must provide either sch & tbl combination, or vector of sch with full query")
  }

  # run query in python space
  reticulate::py_run_string(paste0("qry = ", query))

  # fetch data from python space
  if (format == "dict") {
    dat = reticulate::py$qry$fetch(as_dict=T)
    if (length(dat) > 0) {
      for (i in 1:length(dat)) dat[[i]] = c(dat[[i]], add_vars)
    }
  } else if (format == "df") {
    reticulate::py_run_string("dat = qry.fetch(format='frame')")
    reticulate::py_run_string("dat = dat.reset_index()")
    dat = data.table::setDT(reticulate::py$dat)
    if (length(add_vars > 0))
      for (i in 1:length(add_vars)) dat[[names(add_vars[i])]] = add_vars[[i]]
  } else {
    stop("format not supported!")
  }

  # call the callback function
  if(length(dat) > 0){
    if(!is.null(callback))
      return(callback(dat, ...))
    else
      return(dat)
  }else{
    warning(paste0("Query = '", query, "' produced no results!"))
    return(NULL)
  }

}
