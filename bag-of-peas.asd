(asdf:defsystem :bag-of-peas
  :description "A game jam or nothing at all"
  :author "Rodrigo Correia <https://github.com/drigoor>"
  :version "0.0.0ervilhas"
  :depends-on (:trivial-gamekit
               :trivial-gamekit-fistmachine)
  :pathname "src/"
  :serial t
  :components ((:file "package")
               (:file "util")
               (:module "states"
                :components ((:file "loading-screen")
                             (:file "main-menu")
                             (:file "gameplay")))
               (:file "main")))
