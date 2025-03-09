% c = compile c(demo). = checks to see if demo is compile-able.
% YOU MUST SAVE FIRST THEN COMPILE EACH TIME BEFORE YOU RUN NEW CODE
% Don't forget to add new functions to the export section

%Thank you Bro. Macbeth 

-module(demo).
-export([hello/0, hello/1, test/0]).

% if you want to run and see the functions:
% demo:hello().
hello() -> io:fwrite("Hello, World!~n").

% Now depending on which function you want to use, just type inside the () to store the value into name.
% demo:hello("Ryan"). = get Hello "Ryan"!
hello(Name) -> io:format("Hello ~p! ~n", [Name]).

% Here to store function equations
average(A,B) -> (A+B) / 2.
average(A,B,C) -> (A+B+C) / 3.
average(A,B,C,D) -> (A+B+C+D) / 4.

% isnot  /=
% quadratic(A, B, C) when A == 0 ->
%     io:format("Not a quadratic~n");

% Different way to write the A == 0
quadratic(0, _, _) ->
    io:format("Not a quadratic~n");


% When Guard is like an "if statment", where ; is the if. 
quadratic(A, B, C) when 4*A*C > B*B ->
    io:format("Complex Roots~n");

quadratic(A, B, C) ->
    Temp = math:sqrt(B*B - 4*A*C),
    R1 = (-1*B + Temp) / (2*A),
    R2 = (-1*B + Temp) / (2*A),

    io:format("R1 = ~p R2 = ~p~n", [R1, R2]).

% There's no "for loops", just recalling the same functions
% This is an infinite loop
% series(Start, Stop) ->
%     io:format("~p ",[Start]),
%     series(Start+1, Stop).
series(Start, Stop) when Start > Stop->
    io:format("~n");
series(Start, Stop) ->
    io:format("~p ", [Start]),
    series(Start+1, Stop).


pair_process(A, B, Lambda) ->
    Lambda(A, B).

% Functions to Display a list. Make sure to have an If statement to know when to end the list
display_list([]) ->
    io:format("~n");
display_list([First|Rest]) ->
    io:format("~p ", [First]),
    display_list(Rest).


test() ->
    hello(),
    hello("Ryan"),

    % Capitalize the variables to store data in. Case-sensitive
    Result1 = average(10, 20),
    Result2 = average(20, 30, 40),
    Result3 = average(50, 60, 70, 80),

    io:format("~p ~p ~p~n", [Result1, Result2, Result3]),

    quadratic(2, 3, -4),
    quadratic(1, 0, -4),
    quadratic(2, 3, 4),
    quadratic(0, 3, 1),

    series(1, 10),

    Multiply = fun(X, Y) -> X*Y end,

    pair_process(2, 5, fun (X, Y) -> X+Y end),
    pair_process(2, 5, Multiply),
    pair_process(2, 5, fun average/2),

    L1 = [2, 4, 6, 8, 10],
    L2 = [0|L1],
    [0,2,4,6,8,10] = L2,

    L3 = L2 ++ [100, 200],
    % io:format("~p~n", [L3]),
    display_list(L3),

    ok.