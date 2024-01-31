
% Cannibals and Missionaries Puzzle

% State representation: state(MissionariesLeft, CannibalsLeft, BoatSide)

% Initial state
initial_state(state(3, 3, left)).

% Final state
final_state(state(0, 0, right)).

% Valid states
valid_state(state(M, C, _)) :-
    M >= 0, M =< 3,
    C >= 0, C =< 3,
    (M = 0 ; M >= C),   % Missionaries should be greater or equal to Cannibals, or there are no Missionaries
    (3 - M = 0 ; (3 - M) >= (3 - C)). % Opposite side should also have Missionaries greater or equal to Cannibals, or there are no Missionaries

% Valid moves
valid_move(state(M, C, left), state(M1, C, right)) :-   % Move one missionary from left to right
    M1 is M - 1,
    M1 >= 0.

valid_move(state(M, C, left), state(M, C1, right)) :-   % Move one cannibal from left to right
    C1 is C - 1,
    C1 >= 0.

valid_move(state(M, C, left), state(M1, C1, right)) :-  % Move one missionary and one cannibal from left to right
    M1 is M - 1,
    C1 is C - 1,
    M1 >= 0, C1 >= 0.

valid_move(state(M, C, right), state(M1, C, left)) :-   % Move one missionary from right to left
    M1 is M + 1,
    M1 =< 3.

valid_move(state(M, C, right), state(M, C1, left)) :-   % Move one cannibal from right to left
    C1 is C + 1,
    C1 =< 3.

valid_move(state(M, C, right), state(M1, C1, left)) :-  % Move one missionary and one cannibal from right to left
    M1 is M + 1,
    C1 is C + 1,
    M1 =< 3, C1 =< 3.

% Depth-first search
dfs(State, _, []) :- final_state(State).   % Base case: reached the final state

dfs(State, Visited, [Move | Path]) :-
    valid_move(State, NextState),          % Generate a valid move
    \+ member(NextState, Visited),         % Check if the next state has not been visited
    dfs(NextState, [NextState | Visited], Path),  % Recur with the new state
    interpret_move(State, NextState, Move).      % Interpret the move for printing

% Interpret the move for printing
interpret_move(state(M1, C1, left), state(M2, C2, right), Move) :-
    M is M1 - M2,
    C is C1 - C2,
    Move = move(M, C, left).

interpret_move(state(M1, C1, right), state(M2, C2, left), Move) :-
    M is M2 - M1,
    C is C2 - C1,
    Move = move(M, C, right).

% Solve the puzzle
solve :-
    initial_state(InitialState),
    dfs(InitialState, [InitialState], Path),
    print_solution(Path).

% Print the solution
print_solution([]).
print_solution([Move | Path]) :-
    print_move(Move),
    print_solution(Path).

% Print individual move
print_move(move(M, C, Side)) :-
    format("Move ~w Missionaries and ~w Cannibals to the ~w side.~n", [M, C, Side]).

% Example usage:
% solve.
