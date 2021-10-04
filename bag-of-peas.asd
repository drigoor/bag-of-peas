(asdf:defsystem :bag-of-peas
  :description "A game jam or nothing at all"
  :author "Rodrigo Correia <https://github.com/drigoor>"
  :version "0.0.0ervilhas"
  :depends-on (:trivial-gamekit)
  :serial t
  :components ((:file "package")
               (:file "main")))
