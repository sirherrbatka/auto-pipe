(in-package :auto-pipe)

(defgeneric send (target &rest data)
  (:documentation "Sends data to the target node."))

(defgeneric state-check (target)
  (:documentation
   "Returns symbol describing the status of the target.
   :functional -- Ready to accept new data. Still has data in the buffor.
   :empty      -- Ready to accept new data. Buffor is empty.
   :saturated  -- Buffor has reached limit of it's size."))

(defgeneric transmit-data (target data sender-id)
  (:documentation
   "Sends data to the nodes reciving from the node under the sender-id."))

(defgeneric wait-for-queue-external (object)
  (:documentation
   "Called by the thread processing data in other node (usually after calling push). Locks condition variable to stop that thread."))

(defgeneric notify-queue-external (object)
  (:documentation
   "Wakes threads locked by the wait-for-queue-external"))

(defgeneric wait-for-queue-internal (object)
  (:documentation
   "Called by the thread processing data from this queue (usually after calling pull). Locks condition variable to stop that thread"))

(defgeneric notify-queue-internal (object)
  (:documentation
   "Wakes threads locked by the wait-for-queue-internal"))

(defgeneric add-node (nodes node-symbol operation)
  (:documentation
   "Adds new node to the nodes object. Node-symbol must be unique as it will be used as the key for the hash table. If node-symbol is already in the key, condition is raised."))

(defgeneric connect-nodes-chain (nodes &rest chain)
  (:documentation
   "Creates pipeline from nodes corresponding to the node symbols supplied as the chain argument.
    The first node (corresponding to the first symbol in the chain argument) is set as sending data
    to the second node (corresponding to the second symbol in the chain), second node sends data to the third and so one."))

(defgeneric join-nodes (a b)
  (:documentation
   "Joins two node-wrappers by setting sending destination of the first to the second."))

(defgeneric pause-nodes (object targets-list)
  (:documentation
   "Pauses the threads processing data in nodes corresponding to the nodes symbols passed as list (targets-list) argument."))

(defgeneric wait-for-cv (object cv targets-list)
  (:documentation
   "Locks the threads processing data in nodes corresponding to the nodes symbols passed as a list (targets-list) argument to wait for condition variable (cv argument)."))

(defgeneric get-all-reciving-from (object node-symbol)
  (:documentation
   "Returns list of all nodes that are currently set to recive data from the node with corresponding symbol."))

(defgeneric send-to-node (object node-symbol &rest data)
  (:documentation
   "Sends data (supplied as data argument) to the node corresponding to the node symbol (node-symbol) argument in the object."))

(defgeneric make-nodes-wait (object condition-variable targets-list)
  (:documentation
   "not implemented?"))

(defgeneric update-reciving-from (object)
  (:documentation
   "not implemented?"))

(defgeneric handle-state (object state)
  (:documentation
   "not implemented?"))
