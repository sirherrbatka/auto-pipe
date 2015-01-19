(in-package :auto-pipe)


(defun make-worker (fn targets-fn)
  "Returns closure called worker. Targets-fn is a function that is supposed to return object that is supposed to be used as first argument of the run-worker (see run-worker)"
  (lambda (&rest args)
    (values (apply fn args)
            (funcall targets-fn))))


(defun run-worker (worker updater args)
  "Runs worker, binds returned data to local variables, calls transmit-data on the second returned value"
  (multiple-value-bind (out target) (apply worker args)
    (transmit-data target out (get-id updater))))
