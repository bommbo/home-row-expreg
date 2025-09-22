# home-row-expreg

Select expansion regions with **single home-row letters** — no numbers, no RET.

## Dependencies

- [expreg](https://github.com/casouri/expreg/)

## Installation

```elisp
(use-package home-row-expreg
  :straight (:host github
				   :repo "bommbo/home-row-expreg"
				   :files ("*.el"))
  :after expreg
  :demand t
  :custom
;; corlor
;;  (home-row-expreg-label-color "#FF6B6B")

;; keys
;;  (setq home-row-expreg-ergo-keys
;;	  '(?a ?b ?c ?d ?e ?f ?g ?h ?i ?j ?k ?l ?m
;;		?n ?o ?p ?q ?r ?s ?t ?u ?v ?w ?x ?y ?z))

;;  (setq home-row-expreg-ergo-keys (string-to-list "abcdefghijklmnopqrstuvwxyz"))

;;  (setq home-row-expreg-ergo-keys (number-sequence ?a ?z))
  :bind
;;  ("C-c =" . home-row-expreg-expand-with-letters)
)
```
