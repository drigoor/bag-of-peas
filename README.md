# Bag of Peas
A game jam or nothing at all


## Screenshots

1. added shapes

![01-shape](/screenshots/01-shape.png)

2. added generation of asteroids

![02-shape-asteroids](/screenshots/02-shape-asteroids.png)

3. added simple state managnment (based on [trivial-gamekit-fistmachine](https://github.com/borodust/trivial-gamekit-fistmachine))

![03-states](/screenshots/03-states.png)


## Current status

- [ ] shapes
  - [x] player
  - [x] asteroids
  - [ ] enemys
- [ ] movement
  - [ ] player
  - [ ] asteroids
  - [ ] enemys
- [x] basic input
- [x] basic state management
- [x] simple menus
- [ ] collision detection
- [ ] particles
- [ ] high scores
- [ ] menu option to turn on/off the antialiasing (maybe with a shortcut?)


## Installation and loading

```bat
mklink /J c:\home\quicklisp\local-projects\bag-of-peas c:\home\projects\lisp\bag-of-peas
```


`Bag of Peas` uses trivial-gamekit, the simple framework for making 2D games by Pavel Korolev.

```lisp
;; load the peas
(ql:quickload :bag-of-peas)

;; run it
(bag-of-peas:run)
```


## Ideas

- [ ] starfield (parallax?)
- [ ] the player's spaceship is fixed in the center and everything around it moves
- [ ] mini map like a radar to see all around (or a given distance if the world is big)
