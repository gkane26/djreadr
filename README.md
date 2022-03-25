### djreadr

djreadr is an R package to facilitate reading data from a datajoint-python database into R for further analysis. This package uses the [reticulate package](https://rstudio.github.io/reticulate/) to fetch tables directly from python. 

#### Requirements

You must have datajoint installed in a python environment, and you must be able to import your python-datajoint schema (just as you would in python). The working directory of your R session can be set to your datajoint schema directory (to import in python using `from . import my_schema`). Preferably, you can install your python-datajoint schema as a python module, which can be imported from any location. To do so:
 - add an `__init__.py` file to the schema directory (can be empty)
 - create a `setup.py` file in the parent directory

#### Installation

You can install this package directly from github. If necessary, install the devtools package, first, then install djreadr:

```
install.packages("devtools") # if devtools is not already installed
devtools::install_github("gkane26/djreadr")
```

### Example Usage

To read in data from datajoint, use the following workflow:

```
# load the djreadr package
library(djreadr)

# set the datajoint configuration, if necessary
# (skip this step if you've already saved your credentials, e.g., using dj.config.save_global())
host = '127.0.0.1:3306'
user = 'root'
password = 'simple'
set_config(host, user, password)

# connect to datajoint
dj_connect() # or
dj_connect(conda = "my_env") # if using datajoint in a conda environment

# fetch all experimental sessions for mouse_name=my_mouse in one of two ways. both methods return a list
# 1. by specifying a schema, table, and restrictions
sch = 'exp'
tbl = 'Session'
restrictions = list(mouse_name='mymouse')
my_data = dj_fetch(sch=sch, tbl=tbl, restrictions=restrictions)

# 2a. by providing a full query as a string
query = "exp.Session() * (mice.Mouse() & 'mouse_name=\"mymouse\"')"
my_data = dj_fetch(query=query)

# 2b. same as 2a, but returns results as a data.table -- equivalent to using MyTable.fetch(format="frame") in datajoint-python
query = "exp.Session() * (mice.Mouse() & 'mouse_name=\"mymouse\"')"
my_data = dj_fetch(query=query, format="df")

# you can also pass the result of dj_fetch to a callback function, and return the result of the callback
sch = 'exp'
tbl = 'Session'
restrictions = list(mouse_name='mymouse')
callback = funtion(x) data.frame(mouse = x[[1]]$mouse_name, date = x[[1]]$date, task = x[[1]]$task)
my_data_frame = dj_fetch(sch=sch, tbl=tbl, restrictions=restrictions, callback=callback)

# lastly, you can define restrictions within a data frame, and fetch all matching entries
# e.g. to get all entries for mymouse from May 01-05
log = data.frame(mouse_name = "mymouse", date = c("2020-05-01", "2020-05-02", "2020-05-03"))
my_data = dj_fetch_from_log(sch='exp', tbl='Session', log=log)
```

