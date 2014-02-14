#lang racket
(define (visit-doctor name)
  (begin
    (print (list 'hello name))
    (print '(what seems to be the trouble?))
    (doctor-driver-loop name)))
(define history '(start))
(define (doctor-driver-loop name)
  (begin
    (newline)
    (display '**)
    (let ((user-response (read)))
      (set! history (cons history user-response))
      (if (equal? user-response '(goodbye))
                (begin
                   (print (list 'goodbye name))
                   (print '(see you next week))
                )
                (begin
                    (print (reply user-response))
                    (doctor-driver-loop name)
                )))))
(define (reply user-response)
  (if (fifty-fifty)
        (append (qualifier) (change-person user-response))
        (hedge)))
(define (fifty-fifty) (= (random 2) 0))
(define (qualifier)
  (pick-random '((you seem to think)
                 (you feel that)
                 (why do you believe)
                 (why do you say)
                 (you are the only one that thinks that)
                 (lol))))
(define (hedge)
  (pick-random
   '((please go on)
     (you should probably see a professional)
     (I have doubts regarding that)
     (many people have the same sorts of feelings)
     (many of my patients have told me the same thing)
     (please continue))))
(define (replace pattern replacement lst)
  (cond ((null? lst) '())
        ((equal? (car lst) pattern)
                 (cons replacement
                       (replace pattern replacement (cdr lst)))
        )
        (else (cons (car lst)
                    (replace pattern replacement (cdr lst)))
        )))
(define (many-replace replacement-pairs lst)
  (if (null? replacement-pairs)
         lst
         (let ((pat-rep (car replacement-pairs)))
                (replace (car pat-rep)
                         (cadr pat-rep)
                         (many-replace (cdr replacement-pairs)
                                       lst)))))
(define (change-person phrase)
  (many-replace '((your-1 your) (are-1 are) (you-1 you)
                  (are am) (you i) (your my) 
                  (i you-1) (me you-1) (am are-1) (my your-1))
                phrase))
(define (pick-random lst) (list-ref lst (random (length lst))))