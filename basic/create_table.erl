-module(create_table).
-export([init_table/0, insert_project/2, insert_user/3]).
-record(user, {id, name}).
-record(project, {title, description}).
-record(contributor, {user_id, title}).

init_table() ->
  mnesia:create_table(user, [{attributes, record_info(fields, user)}]),
  mnesia:create_table(project, [{attributes, record_info(fields, project)}]),
  mnesia:create_table(contributor, [{attributes, record_info(fields, contributor)}, {type, bag}]).

insert_user(Id, Name, ProjectTitles) ->
  User = #user{id = Id, name = Name},
  Fun = fun() ->
      mnesia:write(User),
      lists:foreach(fun(Title) -> 
            [#project{title = Title}] = mnesia:read(project, Title),
            mnesia:write(#contributor{user_id = Id, title = Title})
        end,
        ProjectTitles)
  end,
  mnesia:transaction(Fun).

insert_project(Title, Description) ->
  mnesia:dirty_write(#project{title = Title, description = Description}).
