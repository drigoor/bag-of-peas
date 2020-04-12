(asdf:defsystem #:gamez
  :description "Game Zero - Spring Lisp Game Jam 2020 entry"
  :author "Rodrigo Correia <https://github.com/drigoor>"
  :depends-on (#:trivial-gamekit)
  :pathname "src/"
  :serial t
  :components ((:file "package")
               (:file "main")))
