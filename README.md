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
  :demand t)
;; (global-set-key (kbd "C-c =") #'home-row-expreg-expand-with-letters)
```
