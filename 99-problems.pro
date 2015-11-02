% P-99: Ninety-Nine Prolog Problems
% http://www.ic.unicamp.br/~meidanis/courses/mc336/2009s2/prolog/problemas/


% P01 (*) Find the last element of a list.
my_last(X, [X]).
my_last(X, [_|T]) :- my_last(X, T).


% P02 (*) Find the last but one element of a list.
zweitletztes(X, [X, _]).
zweitletztes(X, [_|T]) :- zweitletztes(X, T).


% P03 (*) Find the K'th element of a list.
element_at(X, [X|_], 1).
element_at(X, [_|T], N) :- N1 is N - 1, element_at(X, T, N1).


% P04 (*) Find the number of elements of a list.
len([], 0).
len([_|T], N) :- len(T, K), N is K + 1.


% P05 (*) Reverse a list.
rev([], []).
rev([H|T], R) :- rev(T, T1), append(T1, [H], R).


% P06 (*) Find out whether a list is a palindrome.
palindrome(L) :- rev(L, L1), L = L1.


% P07 (**) Flatten a nested list structure.
my_flatten([], []).
my_flatten(X, [X]) :- not(is_list(X)).
my_flatten([H|T], Flat) :- my_flatten(H, H1), my_flatten(T, T1), append(H1, T1, Flat).


% P08 (**) Eliminate consecutive duplicates of list elements.
compress([], []).
compress([A, A | T], Compressed) :- compress([A|T], Compressed).
compress([H|T], [H|T1]) :- compress(T, T1).


% P09 (**) Pack consecutive duplicates of list elements into sublists.
pack([], []).
pack([A, A | T], [[A|S] | T1]) :- pack([A|T], [S|T1]).
pack([H|T], [[H] | T1]) :- pack(T, T1).


% P10 (*) Run-length encoding of a list.
encode(L, Encoded) :- pack(L, Packed), count_sublists(Packed, Encoded).

count_sublists([], []).
count_sublists([[A|Rest] | T], [[Count, A] | T1]) :- length([A|Rest], Count), count_sublists(T, T1).


% P11 (*) Modified run-length encoding.
encode_modified(L, Encoded) :- encode(L, E), simplify_sublists(E, Encoded).

simplify_sublists([], []).
simplify_sublists([[1, A] | T], [A|T1]) :- simplify_sublists(T, T1).
simplify_sublists([H|T], [H|T1]) :- simplify_sublists(T, T1).


% P12 (**) Decode a run-length encoded list.
decode([], []).
decode([[Count, A] | T], Decoded) :- repeat(A, Count, Repeated), decode(T, T1), append(Repeated, T1, Decoded).
decode([A|T], [A|T1]) :- decode(T, T1).

repeat(_, 0, []).
repeat(A, Count, [A|T]) :- C1 is Count - 1, repeat(A, C1, T).


% P13 (**) Run-length encoding of a list (direct solution).
encode_direct([], []).
encode_direct([H|T], [[N1, H] | T1]) :- encode_direct(T, [[N, H] | T1]), N1 is N + 1.
encode_direct([H|T], [[2, H] | T1]) :- encode_direct(T, [H|T1]).
encode_direct([H|T], [H|T1]) :- encode_direct(T, T1).


% P14 (*) Duplicate the elements of a list.
dupli([], []).
dupli([H|T], [H, H | T1]) :- dupli(T, T1).


% P15 (**) Duplicate the elements of a list a given number of times.
dupli([], _, []).
dupli([H|T], N, L) :- repeat(H, N, H1), dupli(T, N, T1), append(H1, T1, L).


% P16 (**) Drop every N'th element from a list.
drop(L, N, L1) :- drop1(L, N, N, L1).

drop1([], _, _, []).
drop1([_|T], 1, N, T1) :- drop1(T, N, N, T1).
drop1([H|T], I, N, [H|T1]) :- I1 is I - 1, drop1(T, I1, N, T1).


% P17 (*) Split a list into two parts; the length of the first part is given.
split(L, 0, [], L).
split([H|T], N, [H|T1], L2) :- N1 is N - 1, split(T, N1, T1, L2).


% P18 (**) Extract a slice from a list.
slice(L, I, K, L1) :- I1 is I - 1, split(L, K, L2, _), split(L2, I1, _, L1).


% P19 (**) Rotate a list N places to the left.
rotate(L, N, L1) :- N < 0, length(L, Len), N1 is Len + N, rotate(L, N1, L1).
rotate(L, N, L1) :- split(L, N, Left, Right), append(Right, Left, L1).


% P20 (*) Remove the K'th element from a list.
% remove_at(List, Index, Element, Result).
remove_at([H|T], 1, H, T).
remove_at([H|T], I, E, [H|T1]) :- I1 is I - 1, remove_at(T, I1, E, T1).


% P21 (*) Insert an element at a given position into a list.
% insert_at(List, Index, Element, Result).
insert_at(L, 1, E, [E|L]).
insert_at([H|T], I, E, [H|T1]) :- I1 is I - 1, insert_at(T, I1, E, T1).


% P22 (*) Create a list containing all integers within a given range.
range(From, To, []) :- From > To.
range(From, To, [From|Range]) :- F1 is From + 1, range(F1, To, Range).


% P23 (**) Extract a given number of randomly selected elements from a list.
rnd_select(_, 0, []).
rnd_select(List, Count, [E|Numbers]) :- rnd_select1(List, E, Rest), C1 is Count - 1, rnd_select(Rest, C1, Numbers).

rnd_select1(List, Element, Rest) :- length(List, Len), Len1 is Len + 1,
                                    random(1, Len1, I), remove_at(List, I , Element, Rest).


% P24 (*) Lotto: Draw N different random numbers from the set 1..M.
lotto(N, M, L) :- range(1, M, Pool), rnd_select(Pool, N, L).


% P25 (*) Generate a random permutation of the elements of a list.
rnd_permu(List, Permut) :- length(List, Len), rnd_select(List, Len, Permut).
