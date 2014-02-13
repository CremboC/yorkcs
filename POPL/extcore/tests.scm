#lang eopl
(require "syntax.scm")
(require "semantics.scm")
(require "data-structures.scm")
(require "driver.scm")
(require "enviroments.scm")
;;
;
; CORE
;
(define ten   "10")               ;; 10
(define true  "zero?(0)")         ;; #t
(define nope! "zero?(10)")        ;; #f
(define Hmm?  "zero?(zero?(0))")  ;; semantic error
(define HmHm!  "-( 2, zero?(2))") ;; semantic error
(define e1 
    "if zero?( -( 2, 3) ) then 4 else -( 4, -(2,1))") ;; 3
(define if1  ;; 2    
     "if zero?(1) then 10 else if zero?(1) then 1 else 2")
(define if2 ;; 398    
     "if zero?(1) then 10 else -( 400, if zero?(1) then 1 else 2)")
;
; ** Add more tests ***
(define eq "equal?(1, 1)") ;; #t
(define uneq "equal?(2, 5)") ;; #f

(define complexeq "equal?(zero?(0), zero?(1))") ;; error
(define vcomplex "equal?(if zero?(0) then 10 else 0, if zero?(0) then 10 else 0)") ;; #t

(define gr "greater?(1, 3)") ;; #f
(define gr2 "greater?(3, 1)") ;; #t

(define plus "+(1, 9)") ;; 10
(define times "*(2, 9)") ;; 18
(define div "/(10, 5)") ;; 2

(define minus "minus(5)") ;; -5
(define minus2 "minus(20)") ;; -20

(define letus "let ab = 10 in *(ab, 2)") ;; 20
