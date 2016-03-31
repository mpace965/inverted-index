#lang racket

(require srfi/13)

(define (inverted-index-from-file path)
  (let ([h (make-hash)])
    (define (iterate-lines hash lines offset)
      (let ([current-line (first lines)])
        (cond
          [(null? (rest lines)) (inverted-index current-line h offset)]
          [else (iterate-lines (inverted-index current-line h offset) (rest lines) (+ offset (string-length current-line)))])))
    (iterate-lines h (file->lines path) 0)))
  
; TODO fix start index bug from occurence in previous line (maybe make a pair and keep track of line number and position in line)
(define (inverted-index text [h (make-hash)] [offset 0])
  (let ([split (string-split text)])
    (map (lambda (s)
           (let* ([list (hash-ref h s [(lambda () empty)])]
                  [start (if (null? list) 0 (+ (first list) (string-length s)))]
                  [index (string-contains text s start (string-length text))])
             (hash-set! h s (cons (+ index offset) list))))
         split)
    h))