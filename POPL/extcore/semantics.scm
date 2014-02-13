#lang eopl
;; Semantic interpreter for CORE
(provide  (all-defined-out))
(require "syntax.scm")
(require "data-structures.scm")
(require "enviroments.scm")
;; 
;; (execute ...) takes an abstract syntax representation of a program,
;; and returns its Expressed Value
;;
(define (execute prog)
  (cases program prog
    (a-program (exp) (value-of exp (empty-env)))
  )
)
;;
;; (value-of ...) takes an abstract syntax representation of an expression
;; and returns its Expressed Value

;; ** Requires editing the ???s **
(define (value-of expr env)                     
  (cases expression expr    
    (const-exp (num) (->ExpVal num) )
    (diff-exp (exp1 exp2)
        (->ExpVal (- (<-ExpVal (value-of exp1)) (<-ExpVal (value-of exp2))) )
    )
    (zero?-exp (exp)
       (if (zero? (<-ExpVal (value-of exp))) (->ExpVal #t) (->ExpVal #f))
    )
    (if-exp (test true-exp false-exp)
         (if (ExpVal->bool (value-of test))
                  (value-of true-exp)
                  (value-of false-exp)
         ) 
    )
    (equal-exp (first-exp second-exp)
         (reg = first-exp second-exp)
    )
    (greater-exp (first-exp second-exp)
         (reg > first-exp second-exp)
    )
    (less-exp (first-exp second-exp)
         (reg < first-exp second-exp)
    )
    (plus-exp (first-exp second-exp)
         (reg + first-exp second-exp)
    )
    (times-exp (first-exp second-exp)
         (reg * first-exp second-exp)
    )
    (divide-exp (first-exp second-exp)
         (reg / first-exp second-exp)
    )
    (minus-exp (first-exp)
         (->ExpVal (- (<-ExpVal (value-of first-exp)) (* 2 (<-ExpVal  (value-of first-exp)))))
    )
    (var-exp (var)
         'abc
    )
    (let-exp (identifier exp body)
       (extend-env identifier (value-of exp env) env)
       env
       ;;(->ExpVal (value-of body (apply-env env identifier)))
    )
  )
)

(define (reg arg first-exp second-exp)
  (->ExpVal (arg (<-ExpVal (value-of first-exp)) (<-ExpVal (value-of second-exp))))
)

