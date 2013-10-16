erlurl
======

Because I needed to stochastically test URL parsing.  And the name was pithy.

put it in `/foo/erlurl.erl`, then `c("/foo/erlurl.erl").`  then

```
133> erlurl:url().
{"ftp://:pass@www.ibm.com:9000/index.html;e=1,;c=1,2,3;b=1,;d=;a=1,2,3;f=?q&r=1#",
 [ftp,
  {nothing,"pass"},
  "www.ibm.com",9000,"index.html",
  [{"e",["1"]},
   {"c",["1","2","3"]},
   {"b",["1"]},
   "d",
   {"a",["1","2","3"]},
   "f"],
  [q,{r,1}],
  undefined]}
```

the notation is `{ Url, ParseResultList }`.  the parse result is the protocol, the user/pass, 
the location, port, request target, matrix parameters, query parameters, and fragment of the url.