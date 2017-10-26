#!/bin/ksh
DOWN()
{
isql -b -U$user -P$password -S$server -o$output <<END
go
go
sql statement
go
END
}

user=megg
password=feb09mg
server=10.160.0.5
DOWN
