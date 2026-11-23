% UN Delegates: d(Tie, Country, Concern, Age, Pet, Hobby)
% Positions 1..5 = Delegate #1..#5 (left to right)

ages([40,45,50,55,60]).
youngest(A) :- ages(L), min_list(L, A).

% Helper predicates for the relative clues 
end(H, E)           :- H = [E|_].
end(H, E)           :- last(H, E).                       % at one of the ends

left_of(H, A, B)    :- append(_, [A|T], H), member(B, T). % A somewhere left of B
next_to(H, A, B)    :- append(_, [A,B|_], H).             % A and B adjacent
next_to(H, A, B)    :- append(_, [B,A|_], H).
right_exact(H, A, B):- append(_, [B,A|_], H).             % A directly right of B
btw(H, X, A, B)     :- append(_, [A|T1], H),              % A < X < B, in that order
                       append(_, [X|T2], T1),
                       member(B, T2).

% Each value used only once per attribute
arg_of(N, T, A) :- arg(N, T, A).
all_different(H) :-
    forall(between(1, 6, N),
           ( maplist(arg_of(N), H, Col), sort(Col, S), length(S, 5) )).

% The puzzle
solve(H) :-
    length(H, 5),

    % 1) Clues that fix an exact position
    nth1(1, H, d(_,_,_,50,_,_)),            % first: the 50-year-old
    nth1(2, H, d(_,_,_,_,_,gardening)),     % second: likes Gardening
    nth1(3, H, d(_,_,_,45,_,_)),            % third: the 45-year-old

    % 2) Clues that fix "one of the ends"
    end(H, d(white,_,_,_,_,_)),             % White tie at an end
    end(H, d(_,_,climate,_,_,_)),           % Climate Change at an end
    end(H, d(_,_,poverty,_,_,_)),           % Poverty at an end
    end(H, d(_,_,_,_,cat,_)),               % Cat at an end

    % 3) Clues that tie two attributes together (pairs)
    youngest(Y),
    member(d(_,_,_,40,_,jogging), H),       % 40-year-old likes Jogging
    member(d(blue,_,_,_,_,woodworking), H), % Blue tie likes Woodworking
    member(d(_,_,deforestation,_,fish,_), H),% Deforestation has a Fish

    % 4) Relative-position clues
    right_exact(H, d(_,_,_,_,dog,_), d(_,_,_,_,_,jogging)),
    left_of(H, d(black,_,_,_,_,_), d(_,_,_,_,turtle,_)),
    left_of(H, d(green,_,_,_,_,_), d(_,_,_,_,snake,_)),
    btw(H, d(green,_,_,_,_,_),  d(white,_,_,_,_,_),  d(_,american,_,_,_,_)),
    btw(H, d(green,_,_,_,_,_),  d(_,french,_,_,_,_), d(_,_,climate,_,_,_)),
    btw(H, d(_,_,_,_,_,scuba),  d(green,_,_,_,_,_),  d(_,_,_,_,_,jogging)),
    btw(H, d(_,canadian,_,_,_,_), d(_,_,_,_,_,gardening), d(_,_,_,_,_,jogging)),
    btw(H, d(_,_,_,Y,_,_), d(_,_,deforestation,_,_,_), d(_,_,_,55,_,_)),
    next_to(H, d(_,german,_,_,_,_),    d(_,_,_,45,_,_)),
    next_to(H, d(_,brazilian,_,_,_,_), d(_,_,_,50,_,_)),
    next_to(H, d(_,_,immigrants,_,_,_), d(blue,_,_,_,_,_)),

    % 5) Make sure every value (including the unnamed ones) is placed
    member(d(red,_,_,_,_,_), H),
    member(d(_,_,nuclear,_,_,_), H),
    member(d(_,_,_,_,_,reading), H),
    member(d(_,german,_,_,_,_), H),
    member(d(_,brazilian,_,_,_,_), H),
    member(d(_,french,_,_,_,_), H),
    member(d(_,american,_,_,_,_), H),
    member(d(_,canadian,_,_,_,_), H),

    all_different(H).

% Output: every country with its concern
main :-
    solve(H), !,
    forall(nth1(I, H, d(_,Country,Concern,_,_,_)),
           format("Delegate #~w: ~w -> ~w~n", [I, Country, Concern])).
