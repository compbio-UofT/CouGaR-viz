#lang racket
#| Bidirected edges
   A image of a small bi-directed graph is shown here,
   [1]http://ars.els-cdn.com/content/image/1-s2.0-S0166218X07000704-gr1.jpg

   http://www.cs.toronto.edu/~misko/data
   ((from_chromosome from_coordinate) (to_chromosome to_coordinate) edge_type edge_width)

   There are 4 edge types corresponding to the direction of the two arrow
   heads at each end of the edge.
     0: an arrow head leaving the from node and entering the to node: o>-->o
     1: an arrow head entering the from node and leaving the to node: o<--<o
     2: an arrow head leaving the from node and leaving the to node: o>--<o
     3: an arrow entering the from node and entering the to node: o<-->o

   Type 0 and Type 1 are actually redundant, since you can just swap the from/to
     to get the other type. But I still use both... , it makes it easier instead of
     switching the to/from. |#

(define-values (genomic-color somatic-color arrow-color)
  (values "red" (make-color 0 150 255) "aquamarine"))
(define-values (intra-line-spacing inter-line-spacing) (values 150 135))
;(define-values (intra-line-spacing inter-line-spacing) (values 80 85))
(define node-edge-tension 1/5)
(define-values (node-scale arrow-scale edge-scale) (values 20 25 1/4))
(define-values (node-width node-height) (values 3 30))
(define-values (gene-track-height gene-track-spacing) (values 8 6) )
(define-values (gene-forward-colour gene-reverse-colour) (values (make-color 133 160 0) (make-color 210 53 210)))
(define-values (gene-tail-length gene-tail-height) (values 20 (/ gene-track-height 3)))

(displayln "gene annotations file:")
(define gene-list-file (read-line))

(displayln "Genomic-Somatic data file name:")
(define data-file-name (read-line))
(define-values (genomic somatic)
  #;(values '(((1 204164224) (1 204460185) 0 31)
  ((1 203739460) (1 203739600) 0 24)
  ((2 8820428) (2 8848699) 0 34)
  ((1 202862653) (1 202869731) 0 13)
  ((2 16073416) (2 16086121) 0 51)
  ((1 202189702) (1 202209755) 0 28)
  ((1 204978974) (1 205097026) 0 30)
  ((1 202215128) (1 202425257) 0 30)
  ((2 8921728) (2 8931952) 0 44)
  ((2 8864662) (2 8912431) 0 56)
  ((1 204099353) (1 204163072) 0 31)
  ((1 203705025) (1 203739460) 0 29)
  ((1 204720689) (1 204804363) 0 32)
  ((1 202709642) (1 202862653) 0 29)
  ((1 203369070) (1 203705025) 0 14)
  ((2 15743871) (2 15744183) 0 17)
  ((1 202427657) (1 202427731) 0 3)
  ((2 8848699) (2 8864662) 0 24)
  ((1 202427731) (1 202709433) 0 32)
  ((1 204833560) (1 204971128) 0 31)
  ((2 8917257) (2 8921728) 0 45)
  ((1 204971128) (1 204978974) 0 13)
  ((1 202209755) (1 202215128) 0 13)
  ((1 204163072) (1 204164224) 0 12)
  ((1 205221193) (1 205356414) 0 12)
  ((1 205097026) (1 205098379) 0 30)
  ((2 16086525) (2 16170477) 0 50)
  ((2 16170477) (2 16174542) 0 31)
  ((2 16086121) (2 16086525) 0 39)
  ((1 202869731) (1 202869943) 0 12)
  ((1 204060723) (1 204098935) 0 30)
  ((2 8931952) (2 8963783) 0 56)
  ((1 202869943) (1 203015412) 0 14)
  ((1 204804363) (1 204804717) 0 7)
  ((1 205098379) (1 205219579) 0 29)
  ((1 203739600) (1 203739603) 0 6)
  ((1 201862828) (1 202189702) 0 11)
  ((2 8912431) (2 8917257) 0 44)
  ((1 203015763) (1 203246644) 0 14)
  ((1 203888194) (1 204056467) 0 29)
  ((1 203266639) (1 203369070) 0 31)
  ((1 204625362) (1 204720689) 0 32)
  ((1 204460185) (1 204608941) 0 14)
  ((1 204804717) (1 204833560) 0 30)
  ((1 202709433) (1 202709642) 0 9)
  ((1 203739603) (1 203888194) 0 29)
  ((1 204056467) (1 204060723) 0 13)) '(((1 202869943) (1 204056467) 2 23)
                       ((1 204163072) (1 204460185) 2 28)
                       ((2 8917257) (2 8921728) 0 1)
                       ((1 203015412) (1 203015763) 0 21)
                       ((1 202427731) (1 205219579) 1 28)
                       ((2 8963783) (2 15743871) 0 64)
                       ((1 204971128) (1 204978974) 0 24)
                       ((1 202209755) (1 202215128) 0 12)
                       ((1 202709433) (1 202709642) 0 12)
                       ((1 203266639) (1 204804363) 1 38)
                       ((1 203705025) (2 16170477) 1 13)
                       ((1 204608941) (2 8931952) 0 12)
                       ((2 15744183) (2 16073416) 0 76)
                       ((1 201862828) (1 205356414) 1 14)
                       ((1 202425257) (1 204804717) 0 10)
                       ((1 204098935) (1 204099353) 0 33)
                       ((1 205221193) (2 16086121) 1 15)
                       ((1 202862653) (1 202869731) 0 19)
                       ((1 203246644) (2 8912431) 2 18)
                       ((2 8848699) (2 16086525) 0 15)
                       ((1 205097026) (1 205098379) 2 2)
                       ((1 204720689) (1 204833560) 0 2)
                       ((2 8820428) (2 16174542) 1 47)
                       ((1 203369070) (1 204164224) 0 32)
                       ((1 202189702) (1 204060723) 3 19)
                       ((1 204625362) (2 8864662) 3 68)))
  (with-input-from-file data-file-name (λ () (values (read) (read)))))
(displayln "SVG file name [no suffix, and blank appends \".svg\" to data file name]:")
(define output-file-name
  (let ([svg-file-name (string-trim (read-line))])
    (string-append (if (equal? "" svg-file-name) data-file-name svg-file-name)
                   ".svg")))

(define (interval-positive a)
  (<= (second a) (third a)))   
(define (interval-abs-distance a b)
  (if (not (equal? (first a) (first b))) +inf.0 (abs (- (first a) (first b)))))
(define (interval-flip a)
  (list (first a) (third a) (second a)))
(define (interval-overlap? a b)
  (if (> (first (interval-overlap a b)) 0) #t #f))
(define (interval-overlap a b)
  (cond 
    ;make sure same chr
    [(not (equal? (first a) (first b))) (list 0 0 0)]
    ;make sure both intervals are correct
    [(not (interval-positive a)) (interval-overlap (interval-flip a) b)]
    [(not (interval-positive b)) (interval-overlap a (interval-flip b))]
    ;lets see if there is overlap!
    [(and (>= (third b) (second a)) (<= (second b) (third a))) (list (first a) (max (second a) (second b)) (min (third a) (third b)) (fourth b) (fifth b))]
    [else (list 0 0 0 )]))
(define (interval-less-than a b)
  (cond 
    [(< (first a) (first b)) #t]
    [(> (first a) (first b)) #f]
    ;on same chr
    [(not (interval-positive a)) (interval-less-than (interval-flip a) b)]
    [(not (interval-positive b)) (interval-less-than a (interval-flip b))]
    ;both positive
    [(< (third a) (third b)) #t]
    [else #f]))

(define/match (g-g x) [(`((,schr ,scoord) (,echr ,ecoord) ,name ,strand)) (list schr scoord ecoord name strand)])
(define genes (sort (map g-g (file->list gene-list-file)) interval-less-than))
      
(define (add-to-overlay ox a) 
  ;(displayln a)
  (define-values (oy added h) (for/fold ([o '()] [i #f] [l 0])
    ([r ox])
    (define last-coord (last r))
    ;buffer by 2000
    (if (and (not i) (< (+ 80000 (third last-coord)) (second a)))
        ;add it here
        (values (append o (list (append r (list a)))) #t (+ l 1))
        (values (append o (list r)) i (+ l 1)))))
  (if added oy (append oy (list (list (+ h 1) a)))))

(define (gene-overlay a)
  (for/fold ([overlay '()])
    ([g genes])
    (define overlap (interval-overlap a g))
    (if (> (first overlap) 0) (add-to-overlay overlay overlap) overlay)))

(define-match-expander singleton (syntax-rules ()
    [(singleton «pat») (and (? (λ (s) (and (sequence? s) (= (sequence-length s) 1))))
                            #;(app (λ (s) (sequence-ref s 0)) «pat»)
                            (app sequence->list (list «pat»)))]))
(define-match-expander couple (syntax-rules ()
    [(couple «pat₀» «pat₁») (and (? (λ (s) (and (sequence? s) (= (sequence-length s) 2))))
                                 (app sequence->list (list «pat₀» «pat₁»)))]))
#;(define (singleton-extract s) (sequence-ref s 0))
;
(define-values (π π/2) (values pi (/ pi 2)))


(define/match (v-v e) [(`(,from ,to ,_ ,_ ,_ ,_)) `(,from ,to)])
(define (2ples→pairs 2ples) (map (λ (2ple) (apply cons 2ple)) 2ples))

(define (find-edge ℓ v₀ v₁) (findf (match-lambda [`(,(== v₀) ,(== v₁) ,_ ,_ ,_ ,_) true]
                                                 [else false])
                                   ℓ))
(define (weight ℓ v₀ v₁) (fourth (find-edge ℓ v₀ v₁)))
(define (expected ℓ v₀ v₁) (truncate (if (< 30 (fifth (find-edge ℓ v₀ v₁))) (/ (sixth (find-edge ℓ v₀ v₁)) (fifth (find-edge ℓ v₀ v₁))) -2)))
(define (type ℓ v₀ v₁) (third (find-edge ℓ v₀ v₁)))

(define (adjacencies ℓ) (for/fold ([v↦vs (hash)])
                          ([(v₀ v₁) (in-dict (2ples→pairs ℓ))])
                          (dict-update v↦vs v₀ (λ (vs) (set-add vs v₁)) (set))))
(define (ends d) (for/set ([(v vs) d] #:when (= (set-count vs) 1)) v))
(define (middles d) (set-subtract (list->set (dict-keys d)) (ends d)))
;
(define (line d ℓ)
  (define (line′ ℓ) (line d ℓ))
  (match ℓ [`(,v ,v-pre . ,_)
            (match (dict-ref d v)
              [(couple v₀ v₁) (define v-next (if (equal? v₀ v-pre) v₁ v₀))
                              (define ℓ-extended `(,v-next . ,ℓ))
                              (if (set-member? (ends d) v-next)
                                  ℓ-extended
                                  (line′ ℓ-extended))])]))
;
(define (lines d) (for/list ([v (ends d)])
                    (match-define (singleton v′) (dict-ref d v))
                    (define initial-line `(,v′ ,v))
                    (if (set-member? (ends d) v′) initial-line (line d initial-line))))

(require data/order)
(define (<< p₀ p₁) (equal? '< (datum-order p₀ p₁)))
(define (prune-reversed ℓs) (filter-not (λ (ℓ) (<< (last ℓ) (first ℓ))) ℓs))

(define d (adjacencies (let ([ℓ (map v-v genomic)]) (append ℓ (map reverse ℓ)))))
(define g-lines (sort (prune-reversed (lines d)) << #:key first))


(require slideshow slideshow/code)
(current-font-size node-scale)

(require unstable/gui/pict)
(define (back pict back-color) 
  (cc-superimpose (color back-color (filled-rectangle (+ 2 (pict-width pict))
                                                      (+ 2 (pict-height pict))))
                  pict))
(define (numeric-label number label-color)
  (back (color label-color (text (number->string number) 'default node-scale)) "white"))


(define (bp-to-pos interval coord width)
  (* (/ (- coord (second interval)) (- (third interval) (second interval) )) width))
  
(define (pic-overlay interval o ximage x0 y0 width first-in-line last-in-line)
  (displayln interval)
  (for/fold ([image ximage])
    ;over every row
    ([r o])
    ;get the layer
    (define h (first r))
    ;for each interval in the layer add to image
    (for/fold ([child-image image])
      ([child-interval (rest r)])
      (define overlap (interval-overlap interval child-interval))
      (define start-now (or first-in-line (if (>= (second child-interval) (second interval)) #t #f)))
      (define end-now (if (< (third child-interval) (third interval)) #t #f))
      (define x-start (+ x0 (bp-to-pos interval (max (second interval) (second child-interval)) width)))
      (define x-width (max 3 (- (bp-to-pos interval (min (third interval) (third child-interval)) width) (- x-start x0))))
      (define y-start (- (- y0 (/ node-height 2)) (* (+ h 1.5) (+ gene-track-spacing gene-track-height))))
      (define gene-colour 
        (if (equal? (fifth child-interval) '+)
            gene-forward-colour
            gene-reverse-colour))
      (cond [(> (first overlap) 0) 
             (define image-with-gene (pin-under child-image x-start y-start (colorize (filled-rectangle x-width gene-track-height) gene-colour)))
             (define image-with-gene-ftail
               (if (and first-in-line (< (second child-interval) (second interval)))
                   (pin-over image-with-gene (- x-start gene-tail-length) (+ y-start (- (/ gene-track-height 2) (/ gene-tail-height 2))) (colorize (filled-rectangle gene-tail-length gene-tail-height) gene-colour))
                   image-with-gene))
             (define image-with-gene-ftail-etail
               (if (and last-in-line (> (third child-interval) (third interval)))
                   (pin-over image-with-gene-ftail (+ x-start x-width) (+ y-start (- (/ gene-track-height 2) (/ gene-tail-height 2))) (colorize (filled-rectangle gene-tail-length gene-tail-height) gene-colour))
                   image-with-gene-ftail))
             (define image-with-gene-ftail-etail-label
               (if start-now
                   (pin-over image-with-gene-ftail-etail (+ x-start 3) (- y-start (/ gene-track-height 2)) (colorize (text (symbol->string (fourth child-interval)) (cons 'bold null)) (make-color 20 20 15)))
                   image-with-gene-ftail-etail))
             image-with-gene-ftail-etail-label]
            [else child-image]))))
    
(define blank-block (colorize (filled-rectangle 20 20) (make-color 0 0 0 0)))

(define (text-coord c)
  (if (> c 999) 
      (string-append (text-coord (floor (/ c 1000))) "," (number->string (modulo c 1000)))
      (number->string c)))



(define (text-node a)
  (define chr 
    (cond 
      [(equal? (first a) 23) "chrX"]
      [(equal? (first a) 24) "chrY"]
      [else (string-append "chr" (number->string (first a)))]))
  (string-append chr ":" (text-coord (second a))))

(define (text-length a)
  (define d (abs (- (third a) (second a))))
  (cond 
    [(> d 99999) (string-append (real->decimal-string (/ d 1000000) 2) "M")]
    [(> d 99) (string-append (real->decimal-string (/ d 1000) 2) "K")]
    [else (string-append (number->string d) "")]))

(define (line-image-and-v↦node ℓ)
  ;(define v↦node (for/hash ([v ℓ]) (values v (code #,v))))
  (define v↦node (for/hash ([v ℓ]) (values v (filled-rectangle node-width node-height))))
  (define nodes (for/list ([v ℓ]) (dict-ref v↦node v)))
  (define from (first ℓ))
  (define to (last ℓ))
  (define check-interval (list (first from) (- (second from) 1) (+ (second to) 1))) ;interval of line from left to right
  (define overlay (gene-overlay check-interval))
  (define initial-image (hc-append 10 blank-block (text (text-node from) (cons 'bold null)) (apply hc-append (if (equal? (first from) 102) intra-line-spacing (* 1 intra-line-spacing)) nodes) (text (text-node to) (cons 'bold null)) blank-block))
  ;add in the start and end node annotations
  
  (displayln overlay)
  (values (for/fold ([image initial-image])
            ([v₀ (drop-right ℓ 1)]
             [node₀ (drop-right nodes 1)]
             [v₁ (drop ℓ 1)]
             [node₁ (drop nodes 1)])
            
            (define copy-count (weight genomic v₀ v₁))
            (define edge-height (+ (/ copy-count 4) 1))
            (define-values (x0 y0) (rc-find image node₀))
            (define-values (x1 y1) (lc-find image node₁))
            (define gwidth (- x1 x0))
            (define interval (list (first v₀) (second v₀) (second v₁)))
            
            ;get the genomic edge and overlay genes
            (define edge-with-genes (pin-over (pic-overlay interval overlay image (- x0 (/ node-width 2)) y0 (+ node-width gwidth) (equal? (first ℓ) v₀) (equal? (last ℓ) v₁)) x0 (- y0 (/ edge-height 2) ) ( colorize (filled-rectangle gwidth edge-height) genomic-color)))
            ;label the length of the edge
            (define edge-length-label (text (text-length interval) (cons 'bold null)))
            (define edge-with-genes-and-length (pin-over edge-with-genes (+ x0 (/ (- gwidth (pict-width edge-length-label)) 2) ) (- y0 (/ (pict-height edge-length-label) 2)) edge-length-label))
            ;add the copy count
            (define copy-count-label (text (string-append (number->string copy-count) " (" (number->string (expected genomic v₀ v₁)) ")")  (cons 'bold null)))
            (pin-over edge-with-genes-and-length (+ x0 (/ (- gwidth (pict-width copy-count-label)) 2) ) (- (- y0  (pict-height copy-count-label)) (/ node-height 2)) copy-count-label)
            
            #;(pin-label-line
             #;(numeric-label edge-weight genomic-color)
             (color genomic-color (text (number->string edge-weight) 'default node-scale))
             #:y-adjust (- node-scale)
                            
             #:color genomic-color
             #:line-width (* edge-weight edge-scale)
                            
             image
             node₀ rc-find node₁ lc-find)
            #;(hc-append image (filled-rectangle intra-line-spacing edge-weight))
            )
          
          v↦node))

(require unstable/hash)
(define-values (lines-image v↦node)
  (for/fold ([image (blank)] [all-v↦node (hash)])
    ([ℓ g-lines])
    (define-values (ℓ-image v↦node) (line-image-and-v↦node ℓ))
    (values (vc-append inter-line-spacing image ℓ-image)
            (hash-union all-v↦node v↦node))))

(define result
  (for/fold ([image lines-image])
    ([(v₀ v₁) (in-dict (2ples→pairs (map v-v somatic)))])
    (match-define (list v₀-image v₁-image) (map (curry dict-ref v↦node) (list v₀ v₁)))
    (define-values (_₀ v₀-y) (cc-find image v₁-image))
    (define-values (_₁ v₁-y) (cc-find image v₀-image))
    (define ⊥ π/2)
    (define-values (edge-weight edge-type) (values (weight somatic v₀ v₁) (type somatic v₀ v₁)))
    (define ↑ (color arrow-color (arrowhead arrow-scale π/2)))
    (define ↓ (rotate ↑ π))
    (define-values (v₀↗ v₁↗) (values (<= v₀-y v₁-y) (<= v₁-y v₀-y)))
    (define (finder ↗?) (if ↗? ct-find cb-find))
    (define-values (v₀↕ v₁↕) (values (if (equal? v₀↗ (even? edge-type)) ↑ ↓)
                                     (if (equal? v₁↗ (<= 1 edge-type 2)) ↑ ↓)))
    
    (define image-w/o-↕
    (if (< (expected somatic v₀ v₁) edge-weight) 
      (pin-line
       #:color somatic-color #:under? true
       #:start-angle (if v₀↗ ⊥ (- ⊥)) #:end-angle (if v₁↗ (- ⊥) ⊥)
       #:start-pull node-edge-tension #:end-pull node-edge-tension
       #:line-width (max 2 (* edge-weight edge-scale))
      (pin-line
       #:color "DeepSkyBlue" #:under? true
       #:start-angle (if v₀↗ ⊥ (- ⊥)) #:end-angle (if v₁↗ (- ⊥) ⊥)
       #:start-pull node-edge-tension #:end-pull node-edge-tension
       #:line-width (max 2 (* (expected somatic v₀ v₁) edge-scale))
       image
       v₀-image (finder v₀↗) v₁-image (finder v₁↗))
       v₀-image (finder v₀↗) v₁-image (finder v₁↗))
      
       (pin-line
       #:color "DeepSkyBlue" #:under? true
       #:start-angle (if v₀↗ ⊥ (- ⊥)) #:end-angle (if v₁↗ (- ⊥) ⊥)
       #:start-pull node-edge-tension #:end-pull node-edge-tension
       #:line-width (max 2 (* (expected somatic v₀ v₁) edge-scale))
      (pin-line
       #:color somatic-color #:under? true
       #:start-angle (if v₀↗ ⊥ (- ⊥)) #:end-angle (if v₁↗ (- ⊥) ⊥)
       #:start-pull node-edge-tension #:end-pull node-edge-tension
       #:line-width (max 2 (* edge-weight edge-scale))
       image
       v₀-image (finder v₀↗) v₁-image (finder v₁↗))
       v₀-image (finder v₀↗) v₁-image (finder v₁↗))))

    
    (define (arrow-location ↗? v-image) ((finder ↗?) image-w/o-↕ v-image))
    (define-values (x₀ y₀) (arrow-location v₀↗ v₀-image))
    (define-values (x₁ y₁) (arrow-location v₁↗ v₁-image))
    (define angle (atan (- y₁ y₀) (- x₁ x₀))) ; for future feature
    (define (add-arrow image x y ↗? ↑/↓)
      (pin-over image (- x (/ (pict-width ↑/↓) 2)) (- y (if ↗? (pict-height ↑/↓) 0)) ↑/↓))
    (add-arrow (add-arrow image-w/o-↕ x₀ y₀ v₀↗ v₀↕)
               x₁ y₁ v₁↗ v₁↕)))

#;(show-pict result)
#;(pict->bitmap result)
#;result

(require racket/draw)
(define svg (new svg-dc% ; there's also post-script-dc% and pdf-dc%
                 [width (pict-width result)] [height (pict-height result)]
                 [output output-file-name] [exists 'replace]))
(send* svg (start-doc "Rendering to SVG") (start-page))
(draw-pict result svg 0 0)
(send* svg (end-page) (end-doc))
