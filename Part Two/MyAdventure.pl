:- dynamic i_am_at/1, at/2, holding/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).

/*beginning location */

i_am_at(room).

/* These facts describe how the rooms are connected. */

path(room, w, top_of_stairs).
path(top_of_stairs, e, room).

path(top_of_stairs, w, sisters_room) :-
        write('Even if you weren''t late for school, you still would not go in there.'), nl,
        fail.

path(top_of_stairs, d, bottom_of_stairs).
path(bottom_of_stairs, u, top_of_stairs).

path(bottom_of_stairs, s, outside) :- 
        at(left_shoe, on_body),
        at(right_shoe, on_body).
path(bottom_of_stairs, s, outside) :- 
        at(left_shoe, on_body),
        write('You''re missing your other shoe!'), nl,
        fail.
path(bottom_of_stairs, s, outside) :- 
        at(right_shoe, on_body),
        write('You''re missing your other shoe!'), nl,
        fail.        
path(bottom_of_stairs, s, outside) :-
        write('You can''t head outside without shoes on!'), nl,
        fail.

path(bottom_of_stairs, w, living_room).
path(living_room, e, bottom_of_stairs).

path(bottom_of_stairs, n, bathroom).
path(bathroom, s, bottom_of_stairs).

path(living_room, n, kitchen).
path(kitchen, s, living_room).

path(living_room, w, parents_room).
path(parents_room, e, living_room).

/* These facts tell where the various objects in the game
   are located. */

at(backpack, parents_room).
at(left_shoe, bathroom).
at(right_shoe, kitchen).

/* These rules describe how to pick up an object. */

take(X) :-
        at(X, on_body),
        write('You''re already wearing it!'),
        nl, !.

take(X) :-
        i_am_at(Place),
        at(X, Place),
        retract(at(X, Place)),
        assert(at(X, on_body)),
        write('OK.'),
        nl, !.

take(_) :-
        write('I don''t see it here.'),
        nl.


/* These rules describe how to put down an object. */

drop(X) :-
        at(X, on_body),
        i_am_at(Place),
        retract(at(X, on_body)),
        assert(at(X, Place)),
        write('OK.'),
        nl, !.

drop(_) :-
        write('You aren''t holding it!'),
        nl.


/* These rules define the direction letters as calls to go/1. */

n :- go(n).

s :- go(s).

e :- go(e).

w :- go(w).

u :- go(u).

d :- go(d).


/* This rule tells how to move in a given direction. */

go(Direction) :-
        i_am_at(Here),
        path(Here, Direction, There),
        retract(i_am_at(Here)),
        assert(i_am_at(There)),
        look, !.

go(_) :-
        write('You can''t go that way.').


/* This rule tells how to look about you. */

look :-
        i_am_at(Place),
        describe(Place),
        nl,
        notice_objects_at(Place),
        nl.


/* These rules set up a loop to mention all the objects
   in your vicinity. */

notice_objects_at(Place) :-
        at(X, Place),
        write('There is a '), write(X), write(' here.'), nl,
        fail.

notice_objects_at(_).


/* This rule tells how to die. */

die :-
        finish.


/* Under UNIX, the "halt." command quits Prolog but does not
   remove the output window. On a PC, however, the window
   disappears before the final output can be seen. Hence this
   routine requests the user to perform the final "halt." */

finish :-
        nl,
        write('The game is over. Please enter the "halt." command.'),
        nl.


/* This rule just writes out game instructions. */

instructions :-
        nl,
        write('Enter commands using standard Prolog syntax.'), nl,
        write('Available commands are:'), nl,
        write('start.                    -- to start the game.'), nl,
        write('n.  s.  e.  w.  u.  d.    -- to go in that direction.'), nl,
        write('take(Object).             -- to pick up an object.'), nl,
        write('drop(Object).             -- to put down an object.'), nl,
        write('look.                     -- to look around you again.'), nl,
        write('instructions.             -- to see this message again.'), nl,
        write('halt.                     -- to end the game and quit.'), nl,
        nl.


/* This rule prints out instructions and tells where you are. */

start :-
        instructions,
        look.


/* These rules describe the various rooms.  Depending on
   circumstances, a room may have more than one description. */

describe(room) :-
        write('Your sanctuary. You would skip class and play video games'), nl,
        write('all day but you have an important test in a few minutes.'), nl,
        write('The door''s on the west side let''s roll!'), nl.

describe(top_of_stairs) :- 
        write('You are at the top of the stairs. Lil sis''s door is to the west.'), nl,
        write('You should probably go down the the stairs though.'), nl.

describe(bottom_of_stairs) :- 
        write('You are at the bottom of the stairs. To the north of here is the bathroom.'), nl,
        write('The door to the outside is south. To the west is the living room. '), nl.

describe(living_room) :- 
        write('You''re in the living room. Your parent''s room is west'), nl,
        write('of here. The kitchen is north of here.'), nl.

describe(bathroom) :- 
        write('You are in the bathroom. Luckily you showered last night so no need '), nl,
        write('to do that again right now.'), nl.

describe(kitchen) :- 
        write('You are in the kitchen. Unfortunately there is no time to make food.'), nl.

describe(parents_room) :-
        write('You are in your parent''s room. There''s a note here that says: "Hey son, your sister '), nl,
        write('was messing with your stuff after you knocked out. We were able to find the backpack '), nl,
        write('but we can''t find your shoes, sorry. Hope you find them in time! Have fun at school! xo."'), nl.

describe(outside) :- 
        at(left_shoe, on_body),
        at(right_shoe, on_body),
        at(backpack, on_body),
        write('Sweet you made it out in time! You passed the test with flying colors '), nl, 
        write('and ended up becaming a CEO of your own company. You win at life!'), nl,
        finish, !.
describe(outside) :- 
        at(left_shoe, on_body),
        at(right_shoe, on_body),
        write('You left the house and got to class in time, but you forgot your backpack! '), nl, 
        write('Without your backpack you couldn''t take the test. You failed, ended up dropping ' ), nl,
        write('out of school, and dying from owing a drug lord too much money. Don''t forget your backpack next time!' ), nl,
        finish, !.
