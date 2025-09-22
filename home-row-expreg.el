;;; home-row-expreg.el --- Select expansion regions with home-row letters  -*- lexical-binding: t; -*-

;; Author:  bommbo
;; URL:     https://github.com/bommbo/home-row-expreg
;; Version: 0.2.0
;; Package-Requires: ((emacs "30.1"))
;; Keywords: convenience, region, expreg, letter, home-row

;;; Commentary:

;; After each `expreg-expand', overlay single home-row letters
;; (h j k l ; g f d s a …) on the resulting regions.
;; Press the letter you see to select that region instantly—
;; no numbers, no RET, no combos.

;;; Code:

(defgroup home-row-expreg nil
  "Select expansion regions with home-row letters."
  :group 'convenience
  :prefix "home-row-expreg-")

(defcustom home-row-expreg-label-color "yellow"
  "Foreground color for region labels."
  :type 'color
  :group 'home-row-expreg)

(defface home-row-expreg-letter-face
  `((t :foreground ,home-row-expreg-label-color
	   :weight bold))
  "Face for single-letter labels."
  :group 'home-row-expreg)

(defcustom home-row-expreg-ergo-keys
  '(?h ?j ?k ?l ?\; ?g ?f ?d ?s ?a
	   ?y ?u ?i ?o ?p ?r ?t ?v ?b ?n ?m ?e ?w ?q ?c ?x ?z)
  "Letters offered for selection, ordered by ergonomics."
  :type '(repeat character)
  :group 'home-row-expreg)

(defcustom home-row-expreg-max-regions 26
  "Maximum number of regions to label."
  :type 'integer
  :group 'home-row-expreg)

(defvar-local home-row-expreg--overlays nil
  "List of overlays showing region letters.")

;;;###autoload
(defun home-row-expreg-expand-with-letters ()
  "Expand and label regions with home-row letters for instant selection."
  (interactive)
  (let ((regions (home-row-expreg--collect-sequence)))
	(if (null regions)
		(message "No expansion regions found")
	  (unwind-protect
		  (progn
			(home-row-expreg--show-labels regions)
			(let ((choice (home-row-expreg--read-choice (length regions))))
			  (when choice
				(home-row-expreg--apply choice regions))))
		(home-row-expreg--cleanup)))))

(defun home-row-expreg--collect-sequence ()
  (let ((regions '())
		(origin (point))
		(mark   (when (region-active-p) (mark)))
		(count  0))
	(save-excursion
	  (save-restriction
		(goto-char origin)
		(deactivate-mark)
		(while (and (< count home-row-expreg-max-regions)
					(condition-case nil
						(let ((old-beg (if (region-active-p) (region-beginning) (point)))
							  (old-end (if (region-active-p) (region-end) (point))))
						  (call-interactively 'expreg-expand)
						  (when (region-active-p)
							(let ((new-beg (region-beginning))
								  (new-end (region-end)))
							  (unless (and (= new-beg old-beg) (= new-end old-end))
								(let ((new-region (cons new-beg new-end)))
								  (unless (member new-region regions)
									(push new-region regions)
									(cl-incf count)))))))
					  (error nil))))))
	(goto-char origin)
	(if mark (progn (set-mark mark) (activate-mark)) (deactivate-mark))
	(reverse regions)))

(defun home-row-expreg--show-labels (regions)
  (home-row-expreg--cleanup)
  (cl-loop for region in regions
		   for idx from 0
		   for char = (char-to-string (nth idx home-row-expreg-ergo-keys))
		   do (push (home-row-expreg--make-overlay (car region) (cdr region) char)
					home-row-expreg--overlays)))

(defun home-row-expreg--make-overlay (beg end char)
  (let* ((buffer-font (face-attribute 'default :family))
		 (label (propertize char
							'face `(:family ,buffer-font
										   :height 1.0
										   :foreground ,home-row-expreg-label-color
										   :weight bold)
							'display '(raise 0.0)))
		 (left  (make-overlay beg beg))
		 (right (make-overlay end end)))
	(overlay-put left  'before-string label)
	(overlay-put right 'after-string  label)
	(list left right)))

(defun home-row-expreg--read-choice (len)
  (let* ((keys (cl-subseq home-row-expreg-ergo-keys 0 len))
		 (prompt (format "Choose region (%s): "
						 (string-join (mapcar #'char-to-string keys) "")))
		 (char (read-char prompt)))
	(cond
	 ((memq char keys) (+ 1 (cl-position char keys)))
	 ((memq char '(?q ?\C-g)) (message "Selection cancelled") nil)
	 (t (message "Invalid key: %c" char) nil))))

(defun home-row-expreg--apply (choice regions)
  (let ((region (nth (1- choice) regions)))
	(goto-char (car region))
	(set-mark (cdr region))
	(activate-mark)
	(message "Selected region %c: %d–%d"
			 (nth (1- choice) home-row-expreg-ergo-keys)
			 (car region) (cdr region))))

(defun home-row-expreg--cleanup ()
  "Delete all letter overlays."
  (mapc #'delete-overlay (flatten-list home-row-expreg--overlays))
  (setq home-row-expreg--overlays nil))

;;;###autoload
(define-minor-mode home-row-expreg-mode
  "Use home-row letters to select expansion regions."
  :global t
  :keymap (let ((map (make-sparse-keymap)))
			(define-key map (kbd "M-=") #'home-row-expreg-expand-with-letters)
			map))

(provide 'home-row-expreg)
;;; home-row-expreg.el ends here
