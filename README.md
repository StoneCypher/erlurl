erlurl
======

Because I needed to stochastically test URL parsing.  And the name was pithy.



Status
------

This is a new library and is considered to be usable.  However, it is esoteric, and most people are not expected to want it.



Hau 2
-----

Put it in `/foo/erlurl.erl`, then `c("/foo/erlurl.erl").`  then

```
1> erlurl:url().
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

The notation is `{ Url, ParseResultList }`.  The parse result is the protocol, the user/pass, 
the location, port, request target, matrix parameters, query parameters, and fragment of the url.





Polemic :neckbeard:
-------------------

`erlurl` is MIT licensed, because viral licenses and newspeak language modification are evil.  Free is ***only*** free when it's free for everyone.
