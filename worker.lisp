(in-package :auto-pipe)


(defun make-worker (fn targets-fn)
  (lambda (&rest args)
    (values (apply fn args)
            (funcall targets-fn))))


(defun run-worker (worker updater args)
  (multiple-value-bind (out target) (apply worker args)
    (transmit-data target out (get-id updater))))
