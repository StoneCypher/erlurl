
%%%%%%%%%
%%
%%  @doc ErlUrl
%%
%%  That's right, someone actually wrote a stochastic tester for URLs.
%%
%%  Yes, it was StoneCypher / John Haugeland.  Who else would waste the time?
%%
%%  http://fullof.bs/ and http://scutil.com/ are your friends.





-module(erlurl).





-export([

    url/0

]).





protocol() ->

    sc:random_from([
        { "",             nothing   },
        { "http://",      http      },
        { "https://",     https     },
        { "ftp://",       ftp       },
        { "whargarbl://", whargarbl },
        { "mailto:",      mailto    }
    ]).





userpass() ->

    sc:random_from([
        { "",           {nothing, nothing} },
        { "john@",      {"john",  nothing} },
        { "john:@",     {"john",  nothing} },
        { "john:pass@", {"john",  "pass"}  },
        { ":pass@",     {nothing, "pass"}  }
    ]).





host() ->

    sc:random_from([
        { "localhost",     "localhost"    },
        { "127.0.0.1",     "127.0.0.1"    },
        { "www.ibm.com",   "www.ibm.com"  },
        { "2001:db8:0:1",  "2001:db8:0:1" },
        { "[2001:db8:0:1]","2001:db8:0:1" }
    ]).





port() ->

    % the slash is me cheating to get the / between the host and path; deal with it <glasses/>

    sc:random_from([
        { "/",      80   },
        { ":80/",   80   },
        { ":443/",  443  },
        { ":9000/", 9000 }
    ]).





path() ->

    sc:random_from([
        { "",                   ""               },
        { "index",              "index"          },
        { "index.htm",          "index.htm"      },
        { "index.html",         "index.html"     },
        { "foo",                "foo/index.html" },
        { "foo/",               "foo/index.html" },
        { "foo/index.html",     "foo/index.html" },
        { "foo/bar/index.html", "bar/index.html" }
    ]).





matrix_params() ->
% ;p=1,2,3;q=1;r;saa;taa=1,2,;u

    case sc:random_from([nothing, empty, params]) of

        nothing -> {"",  []};
        empty   -> {";", []};

        params  ->

            Count = sc:rand(6) + 1,
            Tags  = sc:random_from(Count, ["a","b","c","d","e","f"]),
            
            Conts = fun(Tag) ->
                case sc:random_from([nothing, empty, scalar, scalar_list, list, list_hung]) of
                    nothing      -> { Tag,              Tag                 };
                    empty        -> { Tag ++ "=",       Tag                 };
                    scalar       -> { Tag ++ "=1",      {Tag,["1"]}         };
                    scalar_list  -> { Tag ++ "=1,",     {Tag,["1"]}         };
                    list         -> { Tag ++ "=1,2,3",  {Tag,["1","2","3"]} };
                    list_hung    -> { Tag ++ "=1,2,3,", {Tag,["1","2","3"]} }
                end
            end,
            
            { QS, Proofs } = lists:unzip([ Conts(Tag) || Tag <- Tags ]),
            { ";" ++ sc:implode(";", QS), Proofs }

%           ";" ++ sc:implode(";", [ Conts(Tag) || Tag <- Tags ])

    end.





query_params() ->

    sc:random_from([
        { "",         []            },
        { "?",        []            },
        { "?q",       [q]           },
        { "?q=1",     [{q,1}]       },
        { "?q&r",     [q,r]         },
        { "?q=1&r",   [{q,1},r]     },
        { "?q=1&r=1", [{q,1},{r,1}] },
        { "?q&r=1",   [q,{r,1}]     },
        { "?q&r&s&t", [q,r,s,t]     }
% what should q&q&q be? [q] or [q,q,q]? todo
    ]).





fragment() ->

    sc:random_from([
        { "",      undefined },
        { "#",     undefined },  % are index.html and index.html# the same url?  this test says yes.  verify.  todo
        { "#frag", "frag"    }
    ]).





url() -> 

    {Result, MustParseAs} = lists:unzip([
        protocol(),
        userpass(),
        host(),
        port(),
        path(),
        matrix_params(),
        query_params(),
        fragment()
    ]),

    { lists:flatten(Result), MustParseAs }.





% todo implement evil variation that literally throws out random everything according to legality
% and totally just wipes its butt all over convention like "here that's what's up"

% downside: the protocol comes back as an atom, so every time you run this you'll waste an atom.
% over a long timescale with large automated tests, this could cause a problem, given erlang's
% finite atom table and lack of atom disposal.

evil_url() ->

    todo.
