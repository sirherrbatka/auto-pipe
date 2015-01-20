(in-package :auto-pipe)


(defclass node-wrapper ()
  ((m-node
    :initarg :node
    :accessor get-node)
   (m-sends-to
    :accessor get-sends-to
    :initform (make-list 0))
   (m-recives-from
    :accessor get-recives-from
    :initform (make-list 0))))


(defclass node-collection ()
  ((m-nodes
    :initform (make-hash-table :test 'eq)
    :accessor get-nodes))
  (:documentation "The object holding nodes (inside node-wrappers) and acting as any context for node symbols."))


(defclass controler (node-collection)
  ())


(defmethod transmit-data ((target node-collection) data sender-id)
  (with-slots (m-nodes) target
    (let* ((node-wrapper (gethash sender-id m-nodes))
           (node (get-node node-wrapper)))
      (mapc (lambda (hash) (let ((state (send (get-node (gethash hash m-nodes))
                                              data)))
                             (when (eq state :saturated)
                               (wait-for-queue-external node))
                             state))
            (get-sends-to node-wrapper)))))


(defmethod pause-nodes ((object node-collection) targets-list)
  (declare (type list targets-list))
  (with-slots (m-nodes) object
    (mapc #'pause
          (mapcar (lambda (x) (slot-value (gethash x m-nodes)
                                          'm-node))
                  targets-list))))


(defmethod get-all-reciving-from ((object node-collection) node-symbol)
  (mapcar (lambda (x) (slot-value (gethash x (slot-value object 'm-nodes))
                                  'm-node))
          (get-recives-from (gethash id (slot-value object 'm-nodes)))))


(defmethod add-node ((nodes node-collection) node-symbol operation)
  (with-slots (m-nodes) nodes
    (setf (gethash node-symbol m-nodes)
          (make-instance 'node-wrapper
                         :node (make-instance 'node
                                              :controler nodes
                                              :id node-symbol
                                              :buffer-maximum-size 20
                                              :function operation))))
  nodes)


(defmethod connect-nodes-chain ((nodes node-collection) &rest chain)
    (with-slots (m-nodes) nodes
      (let ((previous nil))
        (dolist (current chain nodes)
          (unless (null previous)
            (join-nodes (gethash previous m-nodes)
                        (gethash current m-nodes)))
          (setf previous current)))))


(defmethod join-nodes ((a node-wrapper) (b node-wrapper))
  (setf (get-sends-to a)
        (cons (get-id (get-node b))
              (get-sends-to a)))
  (setf (get-recives-from b)
        (cons (get-id (get-node a))
              (get-recives-from b))))


(defmethod send-to-node ((object node-collection) node-symbol &rest data)
  (apply #'send (get-node (gethash node-id
                                   (get-nodes object)))
         data))
