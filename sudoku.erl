-module(sudoku).
-export([main/0]).

check_board(Board) ->  
    check_row(Board),
    check_column(Board).

check_row(Board) when length(Board) /= 9 ->  
    io:format("Error: Must have 9 rows. Found ~p rows~n", [length(Board)]),  
    exit(error);
check_row(_) ->  
    io:format("Rows Correct... ").
    
check_column([]) ->
    io:format("Columns Correct... ~n~n");
check_column([Row | _ ]) when length(Row) /= 9 -> 
    io:format("Error: Must have 9 columns. ~p columns found.", [length(Row)]),
    exit(error);
check_column([_|Rest]) ->
    check_column(Rest).
    
display_board([], _) ->
    ok;
display_board([Num | Rest], RowCount) ->
    io:format("~w ~w ~w | ~w ~w ~w | ~w ~w ~w~n", Num),
    case RowCount rem 3 of 0 when RowCount /= 9 ->
        io:format("------+-------+------~n", []);
    _ -> ok end,
    display_board(Rest, RowCount + 1).


% -------------------------------------------
solve(Board) ->
    solve(Board, find_number(Board)).

solve(Board, none) ->
    Board;
solve(Board, {Row, Col}) ->
    ValidNumber = [Num || Num <- lists:seq(1, 9), is_valid(Board, Row, Col, Num)],
    try_Number(Board, Row, Col, ValidNumber).

find_number(Board) ->
    find_number(Board, 1).
find_number([], _) ->
    none;
find_number([Row | Rest], RowIndex) ->
    case 
        lists:member(0, Row) of 
        true ->
            ColIndex = zero_row(Row, 1), {RowIndex, ColIndex};
        false ->
            find_number(Rest, RowIndex + 1)
    end.

zero_row([0 | _], ColIndex) ->
    ColIndex;
zero_row([_ | Rest], ColIndex) ->
    zero_row(Rest, ColIndex + 1).

try_Number(_Board, _Row, _Col, []) ->
    false;
try_Number(Board, Row, Col, [Candidate | Rest]) ->
    NewBoard = set_cell(Board, Row, Col, Candidate),
    Solution = solve(NewBoard),
    try_solution(Solution, Board, Row, Col, Rest).

try_solution(false, Board, Row, Col, Rest) ->
    try_Number(Board, Row, Col, Rest);
try_solution(Solution, _Board, _Row, _Col, _Rest) ->
    Solution.

set_cell(Board, Row, Col, Num) ->
    [if I == Row -> update_row(RowList, Col, Num);
         true -> RowList
     end || {RowList, I} <- lists:zip(Board, lists:seq(1, length(Board)))].
update_row(Row, Col, Num) ->
    [if I == Col -> Num;
         true -> Elem
     end || {Elem, I} <- lists:zip(Row, lists:seq(1, length(Row)))].


is_valid(Board, Row, Col, Num) ->
    RowList = lists:nth(Row, Board),
    valid_row(RowList, Num) andalso
    valid_column(Board, Col, Num) andalso
    valid_grid(Board, Row, Col, Num).
valid_row(Row, Num) ->
    not lists:member(Num, Row).
get_column(Board, ColIndex) ->
    [lists:nth(ColIndex, Row) || Row <- Board].
valid_column(Board,ColIndex, Num) ->
    not lists:member(Num, get_column(Board, ColIndex)).
get_grid(Board, Row, Col) ->
    RowStart = ((Row - 1) div 3) * 3,
    ColStart = ((Col - 1) div 3) * 3,
    GridRows = lists:sublist(Board, RowStart + 1, 3),
    lists:flatten([ lists:sublist(RowList, ColStart + 1, 3) || RowList <- GridRows ]).
valid_grid(Board, Row, Col, Num) ->
    not lists:member(Num, get_grid(Board, Row, Col)).
% --------------------------------------------

thanks() ->
    io:fwrite("~nThank you for playing~n").

main() ->
    Board =
    [
        [0, 0, 0,   0, 0, 0,    0, 1, 0],
        [1, 0, 0,   0, 0, 0,    0, 0, 0],
        [0, 0, 0,   0, 0, 0,    0, 0, 9],

        [0, 0, 0,   0, 0, 0,    0, 0, 0],
        [0, 0, 0,   0, 1, 0,    0, 0, 0],
        [0, 0, 0,   0, 0, 0,    0, 0, 1],

        [0, 0, 0,   0, 0, 0,    0, 0, 0],
        [0, 9, 0,   0, 0, 0,    0, 0, 0],
        [0, 0, 0,   1, 0, 0,    0, 0, 0]
    ],

    check_board(Board),
    io:format("~nSudoku Board~n"),
    display_board(Board, 1),
    io:format("~nSudoku Solved~n"),
    SolvedBoard = solve(Board),
    display_board(SolvedBoard, 1),
    thanks().