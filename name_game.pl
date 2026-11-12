% Lab 9 - Name Game.

name_game :-
    writeln('Hi. This is the Name Game.'),
    writeln('Create a name using the given letters a, b, c.'),
    game_menu([a,b,c]).

allowed_letter(a).
allowed_letter(b).
allowed_letter(c).

show_letters(Letters) :-
    write('Current letters: '), writeln(Letters),
    atomic_list_concat(Letters, '', Name),
    format('Current name: ~w~n', [Name]).

menu_text :-
    nl, writeln('Choose from the following:'),
    writeln('1- Display the current set of letters'),
    writeln('2- Add a letter'),
    writeln('3- Add a letter at the top'),
    writeln('4- Add a letter at the bottom'),
    writeln('5- Delete a letter'),
    writeln('6- Delete all letters'),
    writeln('7- Exit'),
    writeln('8- Move a letter '),
    write('Enter your choice: ').

game_menu(Letters) :-
    menu_text,
    read(Choice),
    game_action(Choice, Letters).

% Default add is at the end.
game_action(1, Letters) :-
    show_letters(Letters), game_menu(Letters).
game_action(2, Letters) :-
    add_bottom(Letters).
game_action(3, Letters) :-
    read_letter(Letter),
    ( allowed_letter(Letter) ->
        game_menu([Letter|Letters])
    ; writeln('Use only a, b, or c.'), game_menu(Letters)
    ).
game_action(4, Letters) :-
    add_bottom(Letters).
game_action(5, Letters) :-
    write('Letter to delete: '), read(Letter),
    ( select(Letter, Letters, Updated) ->
        writeln('One occurrence deleted.'), game_menu(Updated)
    ; writeln('Letter not found.'), game_menu(Letters)
    ).
game_action(6, _) :-
    writeln('All letters deleted.'), game_menu([]).
game_action(7, _) :-
    writeln('Goodbye!').
game_action(8, Letters) :-
    write('Position of letter to move (starting at 1): '), read(From),
    write('New position (starting at 1): '), read(To),
    ( integer(From), integer(To), From > 0, To > 0,
      nth1(From, Letters, Letter, Rest),
      nth1(To, Updated, Letter, Rest) ->
        writeln('Letter moved.'), game_menu(Updated)
    ; writeln('Invalid position.'), game_menu(Letters)
    ).
game_action(_, Letters) :-
    writeln('Invalid choice.'), game_menu(Letters).

read_letter(Letter) :-
    write('Enter a letter (a, b, or c): '), read(Letter).

add_bottom(Letters) :-
    read_letter(Letter),
    ( allowed_letter(Letter) ->
        append(Letters, [Letter], Updated), game_menu(Updated)
    ; writeln('Use only a, b, or c.'), game_menu(Letters)
    ).
