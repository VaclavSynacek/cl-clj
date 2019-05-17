;; # Common Lisp for Prague Clojure meetup
;; 
;; Vaclav Synacek https://vaclav.synacek.com
;; 2019-05-15
;;  
;;
;; ## Philosophy and why
;;
;; * Software is the only field in which people are generally ignorant
;;   about history
;;   (Richard P. Gabriel http://www.dreamsongs.com/PoetryOfProgramming.html)
;;
;; * New is always better (HIMYM)
;;
;; * -> read some history
;;   * Coders at Work
;;   * History of Mind Expanding Technology
;;
;;
;; * Clojure is so good, because it is
;;   * lisp - code is data
;;   * functional
;;   * polished
;;
;;
;; * What is (common) lisp anyway
;;   * How much of Clojure goodness comes from the lisp heritage?
;;   * What do the other lisps not have and Clojure does?
;;   * live software - dead software
;;   * lisp lore - unix philosophy
;;
;;
;; Agenda:
;;   The same
;;   The similar
;;   The different
;;   The interesting/superior
;;   (and the ugly everywhere in between)
;;
;;
;; ****************************************************************
;; ## The same
;; ****************************************************************
;;
;; This part can be sent to clojure AND cl repls.

(list 1 2 3 4 5)

(+ 1 2)
(* 3 4 5 6)

(print "hello from all the lisps")

(when 1
  (print "works in every lispy language"))

(if 1
  (print "this one works too and look division by 0")
  (/ 10 0))

(load "macro")


;; ****************************************************************
;; ## The similar
;; ****************************************************************
;;
;; from here on only cl repls


;; ### Functions

;; ==> (defn ... )

(defun add (a b)
   (+ a b))

(add -1 1)

(defun not-possitional (&key first last)
  (format t "someone might be called ~A ~A~%" first last))

(not-possitional :last "Nakamoto" :first "Satoshi")

;; ==> (fn ...)
;; ==> #(.. %)

(lambda (x) (* x x))

((lambda (x) (* x x)) 3)


;; ### Let

(let
  ((x 2)
   (y 40))
  (add x y))

(let*
  ((x 2)
   (2x (* 2 x)))
  (add 2x x))


;; ### global variables and atoms

;; ==> (def some-num 10)
(defparameter +some-num+ 10)

;; ==> (defonce *global-counter* (atom 0))
(defvar *global-counter* 0)

;; ==> (reset! *global-counter* 20)
(setf *global-counter* 20)

;; ==> (swap! *global-counter* inc)
(incf *global-counter*)


(let
  ((x 0))
  (setf x 41)
  (incf x)
  x)


;; ### a little bit of lists and vectors

(defvar *some-list* (list 1 2 3))

(setf *some-list* (append *some-list* (list 4 5 6)))

*some-list*

(first *some-list*)
(fifth *some-list*)
(rest *some-list*)
(nth 5 *some-list*)

;; ### Truthiness

(when t
  (print "t is the true symbol"))

(when "most things"
  (print "most things are true"))

(when (list nil nil nil)
  (print "non emplty lists is true, regardless of the contents"))

(when nil
  (print "will not print, nil is false"))

(list)

'()

(when '()
  (print "will not print, empty list is false"))

;; ### Some predicates
;; ==> clj ...?

(evenp 2)
(evenp 1)
(plusp -1)
(zerop 0)
(realp 1)
(integerp 0.5)
(complexp (sqrt -1))
(realp 1/3)
(digit-char-p #\1)
(upper-case-p #\B)


;; ### Little bits of math

(* 5 (+ 1/2 1/3))

(+ 1/3 (sqrt -1))

;; ### Litle bit of higher order functions

; ==> clj filter, but lisp-2
(remove-if-not #'evenp (list 1 2 3 4 5 6))

;; ==> clj remove
(remove-if
  (lambda (x) (= (mod x 2) 0)) 
  (list 1 2 3 4 5 6))

(remove-if
  #'integerp
  (list 1 2 3 4 5 6 7 8 9 10 11 12)
  :key (lambda (x) (/ x 3))
  :start 7)

(remove-if-not
  #'digit-char-p
  "5 words in string with numbers 123 at the end 456"
  :count 12
  :from-end t)

(sort
  (list -5 -4 -3 -2 -1 0 1 2 3 4 5)
  #'<
  :key #'abs)

(reduce
  #'*
  (list -3.14 1 2 3 4 5 6 7 8 9 "rubbish" "I" "don't" "care" "about")
; only these    ^ ^ ^ 
  :initial-value 1000
  :start 2
  :end 5)

; ==> clj map
(mapcar #'sqrt '(-2 -1 0 1 2))

;; =>> (into <type> (map ....

(map 'list #'1+ '(0 1 2 3 4 5))

(map 'vector #'1+ '(0 1 2 3 4 5))

; ==> clj inc
(1+ 3)

; ==> clj [1 2 3]
(vector 1 2 3)

#(1 2 3) 

(map 'vector (lambda (x) (* 3 x)) #(1 2 3))


;; ****************************************************************
;; ## The different
;; ****************************************************************
;;

;; ### Equality in mutable world

(let*
  ((a (list 1 2 3))
   (b (append '(1 2) '(3))))
  (when (eq a b) (print "they are eq"))
  (when (eql a b) (print "they are eql"))
  (when (equal a b) (print "they are equal"))
  (when (equalp a b) (print "they are equalp"))
  "----") 

(let*
  ((a 2/1)
   (b 2.0))
  (when (eq a b) (print "they are eq"))
  (when (eql a b) (print "they are eql"))
  (when (equal a b) (print "they are equal"))
  (when (equalp a b) (print "they are equalp"))
  (when (= a b) (print "they are ="))
  "----") 

(let*
  ((a 42)
   (b a))
  (when (eq b a) (print "they are eq"))
  (when (eql b a) (print "they are eql"))
  (when (equal b a) (print "they are equal"))
  (when (equalp b a) (print "they are equalp"))
  (when (= a b) (print "they are ="))
  "----") 

;; ### Loops
;;

(loop for i upto 10 collect i)

(loop for i in (list 10 20 30 40) collect (sqrt i))

(loop for i in (loop repeat 100 collect (random 10000))
   counting (evenp i) into evens
   counting (oddp i) into odds
   summing i into total
   maximizing i into max
   minimizing i into min
   finally (return (list min max total evens odds)))

(macroexpand '(loop for i upto 10 collect i))


;; ### Formating and printing
;;


;; ==> clj (clojure.pprint/cl-format .... ) {:added "1.2"}
(format nil "Some string with a number ~A in it and one more ~A" 42 23/25)

(progn
  (format t "Some string with a number ~A in it~%" 42)
  (format t "~15$~%" pi)
  (format t "~42$~%" 523347633027360537213687137/3143988327398957279342419750374600193)
  (format t "~,,'.,4:d~%" 100000000)
  (format t "Binary? ~b~%" 1000000)
  (format t "Nowbody will know what I read (~@r)~%" 1984)
  (format t "~{~#[~;~a~;~a and ~a~:;~@{~a~#[~; and ~:;, ~]~}~]~}~%" `(1 2 3 4 5))
  nil)

;; ### Datastructures
;; (and the ugliness inbetween)


;; #### List
(defvar *list*)
(setf *list* (list 10 20 30))

(format t "Second element of list: ~A~%" (second *list*))
(format t "Second element of sequence: ~A~%" (elt *list* 1))

(setf (second *list*) "Prostřední")
*list*


;; #### Vector (One dimenstional array)
(let
  ((vector (vector 10 20 30)))
  (format t "Second element of vector: ~A~%" (svref vector 1))
  (format t "Sec el of 1-dim array: ~A~%" (aref vector 1))
  (format t "Second element of sequence: ~A~%" (elt vector 1))
  (setf (svref vector 1) "Prostřední")
  vector)

;; #### N-Dimensional Array
(let
  ((three-by-three (make-array '(3 3 3) :initial-element 0)))
  (format t "Middle element: ~A~%" (aref three-by-three 1 1 1))
  (setf (aref three-by-three 1 1 1) "M")
  three-by-three)


;; #### Hash-table
(defvar *langs* (make-hash-table))
(setf (gethash :clj *langs*) "Clojure")
(setf (gethash :cl  *langs*)  "Common Lisp")
(setf (gethash :sch *langs*) "Chicken Scheme") 

(gethash :cl *langs*)

*langs*

;; #### P-List

(defvar *my-plist* (list :clj "Clojure" :cl "Common Lisp"))

(getf *my-plist* :clj)

(setf (getf *my-plist* :cl) "Uncommon Lisp")
*my-plist*

;; #### Struct

(defstruct person
           first-name
           second-name
           age)

(defvar *someone*
  (make-person :first-name "Jan" :second-name "Novák" :age 42))

(format t "someone is ~A years old~%" (person-age *someone*))
(setf (person-first-name *someone*) "Honza")
*someone*


;; #### Other datastructures
;;		A-LIST
;;    the whole CLOS
;;		Sets
;;		...
;;
;;    Libraries
;;				"Access"
;;				"FSet"
;;				"cl21"  


;; ###


;; ****************************************************************
;; ## The superior
;; ****************************************************************

;; ### History
;;
;; 1958 Lisp
;; 60s - 80s several dialects
;; 1981 - 1994 standardization
;; 1994 ANSI Common Lisp
;;
;; => Big laguage defined by standard. Probably the only one.

;; ----------------------------------------------------------------

;; ### Implementations
;; 
;; "portable common lisp"
;;
;; Non exhauastive list of cl implementations:
;;
;; * SBCL compiler producing very fast code
;; * CCL fast compiler
;; * ECL compiles through plain C and runs anywhere, including Android
;; * CLISP interpreter with no compilation overhead -> scripting
;; * Clasp interoperates between C++ and Common Lisp code, on LLVM
;; * ABCL runs on the JVM
;; * mocl runs on iOS/Android
;; * LispWorks commercial support
;; * ACL has a concurrent garbage collector

;; try with sbcl, ccl, ecl and abcl

(defun factor (n &optional (acc '()))
  (when (> n 1) (loop with max-d = (isqrt n)
                      for d = 2 then (if (evenp d) (1+ d) (+ d 2)) do
                        (cond ((> d max-d) (return (cons (list n 1) acc)))
                              ((zerop (rem n d)) 
                               (return (factor (truncate n d) (if (eq d (caar acc))
                                                                  (cons 
                                                                   (list (caar acc) (1+ (cadar acc)))
                                                                   (cdr acc))
                                                                  (cons (list d 1) acc)))))))))


(time (factor 1234567890123456789012345678901234567890))


;; ----------------------------------------------------------------
;; ### Optimizations

;; try with sbcl, ccl

(defun mul (a b)
  (declare (optimize (speed 3) (debug 0) (safety 0)))
  (* a b))

(disassemble #'mul)


(defun mul2 (a b)
  (declare (optimize (speed 0) (debug 3) (safety 3)))
  (* a b))

(disassemble #'mul2)


(mul2 2 3 4)

(mul 2 3 4)

;; ----------------------------------------------------------------
;; ### GoTo
;;
;; just kidding
;; well not really
;;


(defun algorithm-s (n max) ; max is N in Knuth's algorithm
  (let (seen               ; t in Knuth's algorithm
        selected           ; m in Knuth's algorithm
        u                  ; U in Knuth's algorithm
        (records ()))      ; the list where we save the records selected
    (tagbody
     s1
       (setf seen 0)
       (setf selected 0)
     s2
       (setf u (random 1.0))
     s3
       (when (>= (* (- max seen) u) (- n selected)) (go s5))
     s4
       (push seen records)
       (incf selected)
       (incf seen)
       (if (< selected n)
           (go s2)
           (return-from algorithm-s (nreverse records)))
     s5
       (incf seen)
       (go s2))))

(algorithm-s 5 100)

(defun algorithm-s-refactor (n max)
  (loop for seen from 0
     when (< (* (- max seen) (random 1.0)) n)
     collect seen and do (decf n)
     until (zerop n)))

;; ----------------------------------------------------------------
;; ### Condition Handling
;;
;; Exceptions are bad, use condition signaling instead
;; 
;; recommended video:
;;   The Remote Agent Experiment:
;;       Debugging Code from 60 Million Miles Away
;;   https://www.youtube.com/watch?v=_gZK0tW8EhQ

;; ### CLOS
;; like multimethods on steroid


;; *******************************************************************

;; # The End

;; Where to next (in that order):
;; * http://stevelosh.com/blog/2018/08/a-road-to-common-lisp/
;; * http://www.gigamonkeys.com/book/
;; * http://www.paulgraham.com/onlisp.html




