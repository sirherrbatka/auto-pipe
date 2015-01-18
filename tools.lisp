(in-package :auto-pipe)


(defun hash-to-values-list (table)
  (declare (type hash-table table))
  (loop for v being the hash-values in table
     collect v into out
     finally (return out)))


(defun hash-to-keys-list (table)
  (declare (type hash-table table))
  (loop for k being the hash-keys in table
     collect k into out
     finally (return out)))
