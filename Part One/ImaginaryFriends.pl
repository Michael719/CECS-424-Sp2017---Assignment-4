% Problem #1, "It's a animal", Dell Logic Puzzles, October 1999
% Each man (mr so-and-so) got a tie from a adventure.
animal(grizzly_bear).
animal(moose).
animal(seal).
animal(zebra).

child(joanne).
child(lou).
child(ralph).
child(winnie).

adventure(circus).
adventure(rock_band).
adventure(spaceship).
adventure(train).

solve :-
    animal(JoannesAnimal), animal(LousAnimal), animal(RalphsAnimal), animal(WinniesAnimal),
    all_different([JoannesAnimal, LousAnimal, RalphsAnimal, WinniesAnimal]),
    
    adventure(JoannesAdventure), adventure(LousAdventure),
    adventure(RalphsAdventure), adventure(WinniesAdventure),
    all_different([JoannesAdventure, LousAdventure, RalphsAdventure, WinniesAdventure]),

    Triples = [ [joanne, JoannesAnimal, JoannesAdventure],
                [lou, LousAnimal, LousAdventure],
                [ralph, RalphsAnimal, RalphsAdventure],
                [winnie, WinniesAnimal, WinniesAdventure] ],
   
    % 1. The seal(who isn't the creation of either Joanne or Lou) neither rode to the moon in a spaceship
    %    nor took a trip around the world on a magic train
    \+ member([joanne, seal, _], Triples),
    \+ member([lou, seal, _], Triples),
    \+ member([_, seal, spaceship], Triples),
    \+ member([_, seal, train], Triples),
    
    % 2. Joanne's imaginary friend(who isn't the grizzly bear) went to the circus.
    \+ member([joanne, grizzly_bear, _], Triples),
       member([joanne, _, circus], Triples),
    
    % 3. Winnie's imaginary friend is a zebra.
       member([winnie, zebra, _], Triples),
    
    % 4. The grizzly bear didn't board the spaceship to the moon.
    \+ member([_, grizzly_bear, spaceship], Triples),
        
    tell(joanne, JoannesAnimal, JoannesAdventure),
    tell(lou, LousAnimal, LousAdventure),
    tell(ralph, RalphsAnimal, RalphsAdventure),
    tell(winnie, WinniesAnimal, WinniesAdventure).

% Succeeds if all elements of the argument list are bound and different.
% Fails if any elements are unbound or equal to some other element.
all_different([H | T]) :- member(H, T), !, fail.
all_different([_ | T]) :- all_different(T).
all_different([_]).

tell(X, Y, Z) :-
    write(X), write(' wrote about a '), write(Y),
    write(' in a '), write(Z), write('.'), nl.