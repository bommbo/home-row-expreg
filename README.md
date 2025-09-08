# home-row-expreg

Select expansion regions with **single home-row letters** — no numbers, no RET.

## Usage

(use-package expreg
  :straight t
  :defer t)

(use-package home-row-expreg
  :straight (:host github
                   :repo "yourid/home-row-expreg"
                   :files ("*.el"))
  :after expreg
  :bind (("M-=" . home-row-expreg-expand-with-letters))
