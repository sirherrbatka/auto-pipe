(ql:quickload 'BORDEAUX-THREADS)
(ql:quickload 'dlist)

(defpackage #:auto-pipe
  (:use :cl
        :asdf
        :BORDEAUX-THREADS))

(defsystem auto-pipe
  :name "auto-pipe"
  :version "0.0.0"
  :license "MIT"
  :author "Marek Kochanowicz (aka shka)"
  :maintainer "Marek Kochanowicz (aka shka)"
  :serial T
  :components ((:file "generic-functions")
               (:file "condition-variable")
               (:file "tools")
               (:file "looper")
               (:file "queue")
               (:file "status-updater")
               (:file "worker")
               (:file "node")
               (:file "controler")))
