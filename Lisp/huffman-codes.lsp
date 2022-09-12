;Huffman-codes.lisp

;legge una lista di coppie e ritorna in output un albero di huffman
(defun he-generate-huffman-tree 
  (symbols-n-weights)
  (if (< (length symbols-n-weights) 2)
    (error "Huffman-tree non può essere generato con un solo simbolo o meno")
    (he-generate-tree symbols-n-weights)))

(defun he-generate-tree 
  (symbols-n-weights)
  (if (null (cdr symbols-n-weights))
    (car symbols-n-weights)
    (let ((ordered (stable-sort symbols-n-weights 'mag-p)))
      (he-generate-tree 
        (append 
          (list 
            (cons 
              (flatten (list (caar ordered) (caadr ordered)))
              (cons 
                (somma ordered) 
                (cons (car ordered) (list (cadr ordered))))))
          (cddr ordered))))))



;La funzione mag-p definisce una relazione d'ordinamento tra due elementi:
(defun mag-p 
  (a b) 
  (cond  
    ((and (null(proper-list-p a)) (proper-list-p b)) 
      (if (< (cdr a) (cadr b)) 
          T 
          nil))
    ((and (proper-list-p a) (null(proper-list-p b))) 
      (if (< (cadr a) (cdr b)) 
          T
          nil))
    ((and (null(proper-list-p a)) (null(proper-list-p b))) 
      (if (<  (cdr a) (cdr b)) 
          T
          nil))
    (t  
      (if (<  (cadr a) (cadr b)) 
          T
          nil))
  )
)

(defun somma (a)
  (cond 
    ((and (null(proper-list-p (cdar a))) (proper-list-p (cdadr a)))
      (+ (cdar a)(cadadr a)))   
    ((and (proper-list-p (cdar a)) (null(proper-list-p (cdadr a))))
      (+ (cadar a)(cdadr a))) 
    ((and (null(proper-list-p(cdar a))) (null(proper-list-p(cdadr a))))
      (+ (cdar a)(cdadr a)))  
    (t 
      (+(cadar a)(cadadr a)))

  )
)

(defun flatten (x)
  (cond 
    ((null x) x)
    ((atom x) (list x))
    (T 
      (append (flatten (first x)) (flatten (rest x))))))

;Proper-list-p controlla se "a" è una lista o una cons-cell con due elementi
(defun proper-list-p (x) 
  (not (null (handler-case 
              (list-length x) 
              (type-error () nil)))) 
)
; Ritorna in output il messagio decodificato di una lista di bits.
(defun he-decode (bits huffman-tree)
  (labels 
    ((he-decode-1 (bits current-branch)
        (unless (null bits)
          (let ((next-branch (choose-branch (first bits) current-branch)))
            (if (leaf-p next-branch)
              (cons 
                (leaf-symbol next-branch) 
                (he-decode-1 
                  (rest bits) huffman-tree)) 
              (he-decode-1 (rest bits) next-branch))))))
    (he-decode-1 bits huffman-tree)))

;Ritorna in output la codifica di un messagio in forma di lista.
;Data in input una lista di caratteri e un albero di huffman         
(defun he-encode (message huffman-tree)
  (labels 
    ((he-encode-1 (message current-branch)
        (unless (null message)
          (let ((next-branch 
            (choose-next-encoding-branch current-branch (first message))))
            (if (leaf-p next-branch)
              (if 
                (equal (node-left current-branch) next-branch)
                (cons 0 (he-encode-1 (rest message) huffman-tree))
                (cons 1 (he-encode-1 (rest message) huffman-tree)))
              (if 
                (equal (node-left current-branch) next-branch)
                (cons 0 
                  (he-encode-1  message 
                    (if (in-p(car next-branch) (first message))
                      next-branch
                      huffman-tree)))
                (cons 1 
                  (he-encode-1  message 
                    (if (in-p(car next-branch) (first message))
                      next-branch
                      huffman-tree)))))))))
    (he-encode-1 message huffman-tree)))

;legge  un  testo da  un  file  e poi richiama  he-encode su  quanto  letto.
(defun he-encode-file (filename huffman-tree) 
  (with-open-file (stream filename)
    (let ((stringlist
     (mapcar 'string (coerce (string-upcase (read-line stream nil)) 'list))))
      (he-encode 
        (mapcar 
          (lambda (a) 
            (find-symbol (string a))) stringlist)
             huffman-tree)))) 

;Ritorna in ouput una lista simbolo-codifica per ogni simbolo
(defun he-generate-symbol-bits-table (huffman-tree)
  (labels ((bits-table(list)
        (if  (not (null list))
          (cons 
              (cons (car list) (he-encode (list (car list)) huffman-tree)) 
              (bits-table (rest list )))
          nil)))
    (bits-table (car huffman-tree))))


(defun node-left (branch)
  (if (not (atom branch))
    (caddr branch)))

(defun node-right (branch)
  (if (not (atom branch))
    (cadddr branch)))

(defun leaf-p (branch)
  (cond ((null (proper-list-p branch))
             T)
        (T nil)))

(defun leaf-symbol (leaf)
  (car leaf))

(defun choose-branch (bit branch) 
  (cond 
    ((= 0 bit) 
      (node-left branch))
    ((= 1 bit) 
      (node-right branch)) 
    (t 
      (error "Bad bit ~D." bit))))

(defun choose-next-encoding-branch (branch current-symbol)
  (cond 
    ((in-p (car (node-left branch)) current-symbol) 
      (node-left branch))
    ((in-p (car (node-right branch)) current-symbol) 
      (node-right branch))
    (T 
      (error "Error!"))))

(defun in-p (lista element)
  (if (null lista)
    nil
    (or (eql (if (atom lista) lista (car lista)) element) 
        (if  (not (atom lista)) 
          (in-p (rest lista) element)))))

;stampa a  terminale un  huffman-tree e serve essenzialmente  per  debugging.
(defun he-print-huffman-tree (huffman-tree)
  (cond ((listp huffman-tree)
          (format t "~S ~S ~%" (car huffman-tree) (cadr huffman-tree))
          (print-tree (node-left huffman-tree) (node-right huffman-tree)))
        (t(error "Error, il parametro dato non e' una lista"))

  )
)
(defun print-tree (left-branch right-branch)
    (cond 
      ((and(proper-list-p left-branch)(proper-list-p right-branch))
          (format t "~S ~S ~%"  (cons(car left-branch)(cadr left-branch))
                                (cons(car right-branch)(cadr right-branch)))
          (print-tree (node-left left-branch) (node-right left-branch))                 
          (print-tree (node-left right-branch) (node-right right-branch)))
      ((and(null(proper-list-p left-branch))(proper-list-p right-branch))
          (format t "~S ~S ~%" left-branch
                                  (cons(car right-branch)(cadr right-branch)))
          (print-tree (node-left right-branch) (node-right right-branch)))
      ((and(proper-list-p left-branch)(null(proper-list-p right-branch)))
          (format t "~S ~S ~%"  (cons(car left-branch)(cadr left-branch))
                                    right-branch)
          (print-tree (node-left left-branch) (node-right left-branch)))
      (t 
          (format t "~S ~S ~%"  left-branch
                              right-branch))
    )
)    
