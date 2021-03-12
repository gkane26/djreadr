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

# if datajoint is installed in a conda environment or virtualenvironment, set the correct envirnoment:
set_python(conda="dj") # the name of the conda environment
set_python(venv="dj") # the name of the virtual environment

# set the datajoint configuration (if necessary, you should only need to do this once in either python or R)
host = '127.0.0.1:3306'
user = 'root'
password = 'simple'
set_config(host, user, password)

# connect to datajoint
dj_connect()

# fetch all experimental sessions for for mouse_name=my_mouse in one of two ways
# 1. by specifying a schema, table, and restrictions
sch = 'exp'
tbl = 'Session'
restrictions = list(mouse_name='mymouse')
my_data = get_table(sch=sch, tbl=tbl, restrictions=restrictions)

# 2. by providing a full query as a string
query = "exp.Session() * (mice.Mouse() & 'mouse_name=\"mymouse\"')"
my_data = get_table(sch=c("exp", "mice"), query=query)

# if you want to return data as a data frame or data table, you can use a callback function
sch = 'exp'
tbl = 'Session'
restrictions = list(mouse_name='mymouse')
callback = funtion(x) data.frame(mouse = x[[1]]$mouse_name, date = x[[1]]$date, task = x[[1]]$task)
my_data_frame = get_table(sch=sch, tbl=tbl, restrictions=restrictions, callback=callback)

# lastly, you can define restrictions within a data frame, and fetch all matching entries
# e.g. to get all entries for mymouse from May 01-05
log = data.frame(mouse_name = "mymouse", date = c("2020-05-01", "2020-05-02", "2020-05-03"))
my_data = get_table_from_log(sch='exp', tbl='Session', log=log)
```

