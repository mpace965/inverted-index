#lang racket

(require srfi/13)

(define (inverted-index-from-file path)
  (inverted-index-from-list (file->lines path)))

(define (inverted-index text)
  (inverted-index-from-list (split-newlines text)))

(define (inverted-index-from-list list [h (make-hash)])
  (define (iterate-lines hash line-number lines)
    (let* ([line (first lines)]
           [split (string-split line)])
      (cond
        [(null? (rest lines)) (map ((curry add-to-hash) h line line-number) split)]
        [else (iterate-lines (map ((curry add-to-hash) h line line-number) split) (+ line-number 1) (rest lines))])))
  (iterate-lines h 0 list) h)

(define (add-to-hash h line line-number s)
  (let* ([pair (hash-ref h s [(lambda () empty)])]
         [start (if (or (null? pair) (not (equal? (car pair) line-number))) 0 (+ (cdr pair) (string-length s)))]
         [index (string-contains line s start (string-length line))])
    (hash-set! h s (cons (cons line-number index) pair))) h)

(define (split-newlines text)
  (define (iterate-string list s)
    (let ([newline-index (string-index s #\newline)])
      (cond
        [(false? newline-index) (cons s list)]
        [else (iterate-string (cons (substring s 0 newline-index) list) (substring s (+ newline-index 1) (string-length s)))])))
  (reverse (iterate-string empty text)))