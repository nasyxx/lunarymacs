;;; -*- lexical-binding: t -*-

;;; Key

(with-eval-after-load 'general
  ;;;; Outshine
  (luna-default-leader
    "tl" #'luna-toggle-left-margin
    "iu" #'insert-char
    "sr" #'luna-color-rg-search-input
    "o" '(:ignore t :which-key "outline")
    "o <tab>" #'outline-toggle-children
    "os" #'outline-show-all
    "oh" #'outline-hide-body)
  (global-unset-key (kbd "C-<down-mouse-1>"))
  (general-define-key
   :keymaps 'override
   ;; this is binded by default,
   ;; but flyspell mode shadows it
   "C-M-i" #'outshine-cycle-buffer
   "C-<mouse-1>" #'mc/add-cursor-on-click
   ;;;; Move up/down
   "M-P" #'luna-move-up
   "M-N" #'luna-move-down
   ;;;; Hippie
   "M-/" #'hippie-expand
   ;;;; Hungry delete
   "<backspace>" #'luna-hungry-delete)
  ;;;; Expand Region
  ;; (luna-g-leader
  ;;   "v" #'er/expand-region)
  (luna-default-leader
    "v" #'er/expand-region)
  ;;;; Helpful
  (general-define-key
   :keymaps 'override
   "C-h f" #'helpful-callable
   "C-h v" #'helpful-variable
   "C-h k" #'helpful-key)
  (general-define-key
   :keymaps 'helpful-mode-map
   "b" #'helpful-previous-helpful-buffer
   "f" #'helpful-next-helpful-buffer)
  ;;;; Kill Ring Select
  (luna-cx-leader
    ;; C-y is too uncomfortable to reach
    ;; so C-p here we go
    "C-p" #'luna-kill-ring-select
    "<C-i>" #'luna-insert-special-symbol)
  ;;;; Minimap
  (luna-default-leader "tm" #'minimap-mode)
  ;;;; avy
  (luna-default-leader
    "k" #'avy-goto-char-timer))


(mve (global-set-key (kbd "<S-return>") #'luna-return-cancel-completion) nil)

;;; Package

;;;; Edit

;; (load-package (camelsnake-mode :fetcher github :repo "casouri/camelsnake-mode")
;;   :commands camelsnake-mode)

(load-package ws-butler
  :defer 3
  :config (ws-butler-global-mode))

(load-package expand-region
  :config
  ;; it interferes angel.el's region transient map
  ;; specifically, the region-deactive-hook
  ;; doesn't run right after the region highlight is off
  (setq expand-region-fast-keys-enabled nil)
  :commands
  er/expand-region
  er/mark-defun
  er/mark-word
  er/mark-symbol
  er/mark-inside-quotes
  er/mark-outside-quotes
  er/mark-inside-pairs
  er/mark-outside-pairs
  er/contract-region)

(load-package isolate
  :commands (isolate-quick-add
             isolate-quick-change
             isolate-quick-delete
             isolate-long-add
             isolate-long-change
             isolate-long-delete))

(load-package undo-tree
  :config (global-undo-tree-mode)
  (setq undo-tree-visualizer-timestamps t
        undo-tree-visualizer-diff t
        undo-tree-auto-save-history t
        undo-tree-history-directory-alist `(("." . ,luna-cache-dir))))

;;;; Navigation

(load-package recentf-ext
  :commands (recentf counsel-recentf))

(load-package avy
  :commands (avy-goto-char
             avy-goto-char-2
             avy-goto-char-timer)
  :config
  (setq avy-background t)
  (setq avy-all-windows nil))

(load-package minimap
  :config
  (setq
   minimap-width-fraction 0.1
   minimap-window-location 'right
   minimap-update-delay 0)
  (custom-theme-set-faces 'user
                          '(minimap-active-region-background
                            ((((background dark)) (:background "#61526E"))
                             (t (:background "#d3d3e7")))))
  :commands minimap-mode)

;; used for chinese editiing on macOS
;; TODO autoload this
;; (load| switch-input-mode)


;;;; Code Structure

(load-package outshine
  :commands outshine-cycle-buffer
  :init
  (add-hook 'outline-minor-mode-hook 'outshine-mode)
  (add-hook 'prog-mode-hook 'outline-minor-mode)
  (defvar outline-minor-mode-prefix (kbd "C-c o")))


(load-package color-rg
  :init
  (define-key isearch-mode-map (kbd "M-s M-s") 'isearch-toggle-color-rg)
  :commands (isearch-toggle-color-rg
             color-rg-search-input
             color-rg-search-symbol
             color-rg-search-project
             color-rg-search-project-rails
             luna-color-rg-search-input)
  :config
  (defun luna-color-rg-search-input (&optional keyword directory files)
    ;; Save window configuration before do search.
    ;; Just save when `color-rg-window-configuration-before-search' is nil
    ;; Or current buffer is not `color-rg-buffer' (that mean user not quit color-rg and search again in other place).
    (interactive)
    (when (or (not color-rg-window-configuration-before-search)
              (not (string-equal (buffer-name) color-rg-buffer)))
      (setq color-rg-window-configuration-before-search (current-window-configuration))
      (setq color-rg-buffer-point-before-search (point)))
    ;; Set `enable-local-variables' to :safe, avoid emacs ask annoyingly question when open file by color-rg.
    (setq enable-local-variables :safe)
    ;; Search.
    (let* ((search-keyboard
            (or keyword
                (color-rg-read-input)))
           (search-directory
            (read-directory-name "Dir: " default-directory))
           (search-files
            (or files
                "everything")))
      (color-rg-search search-keyboard search-directory search-files))))



(load-package visual-regexp
  :commands (vr/replace
             vr/query-replace
             vr/mc-mark))

(load-package multiple-cursors
  :commands (mc/edit-lines
             mc/add-cursor-on-click)
  :init (setq mc/list-file (expand-file-name "mc-lists.el" luna-cache-dir))
  )

;;;; Help

(load-package helpful
  :commands (helpful-callable
             helpful-variable
             helpful-key
             helpful-at-point)
  :config
  (setq helpful-max-buffers 5)
  ;; don't pop new window
  (require 'subr-x)
  (setq helpful-switch-buffer-function
        (lambda (buf) (if-let ((window (display-buffer-reuse-mode-window buf '((mode . helpful-mode)))))
                          ;; ensure the helpful window is selected for `helpful-update'.
                          (select-window window)
                        ;; line above returns nil if no available window is found
                        (pop-to-buffer buf))))
  (defvar luna-helpful-history () "History of helpful, a list of buffers.")
  (advice-add #'helpful-update :around #'luna-helpful@helpful-update)
  (advice-add #'helpful--buffer :around (lambda (oldfunc &rest _)
                                          (let ((buf (apply oldfunc _)))
                                            (push buf luna-helpful-history)
                                            buf))))

(defun luna-helpful@helpful-update (oldfunc)
  "Insert back/forward buttons."
  (funcall oldfunc)
  (let ((inhibit-read-only t))
    (goto-char (point-min))
    (insert-text-button "Back"
                        'action #'helpful-previous-helpful-buffer)
    (insert " / ")
    (insert-text-button "Forward"
                        'action #'helpful-next-helpful-buffer)
    (insert "\n\n")))

(defun helpful-previous-helpful-buffer ()
  (interactive)
  (let ((buf (current-buffer)))
    (previous-buffer)
    (while (and (not (eq major-mode 'helpful-mode))
                (not (eq (current-buffer) buf)))
      (previous-buffer))))

(defun helpful-next-helpful-buffer ()
  (interactive)
  (let ((buf (current-buffer)))
    (next-buffer)
    (while (and (not (eq major-mode 'helpful-mode))
                (not (eq (current-buffer) buf)))
      (next-buffer))))

;;; Config

;;;; Default

(electric-pair-mode)
;; (push '(?< . ?>) electric-pair-pairs)
(add-hook 'emacs-lisp-mode-hook
          (lambda () (setq-local electric-pair-text-pairs
                                 (append '((?` . ?'))
                                         electric-pair-text-pairs))))

(electric-quote-mode)
(minibuffer-electric-default-mode)

;; smooth scrolling
(setq scroll-conservatively 101)
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse t) ;; scroll window under mouse

(with-eval-after-load 'general
  (general-define-key
   :states '(normal insert)
   "C-;" #'luna-insert-semi-at-eol
   )
  (general-define-key
   :states 'normal
   "J" #'luna-scroll-down-reserve-point
   "K" #'luna-scroll-up-reserve-point))

;; utf-8
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8)
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))


;;;; split screen vertically in ediff
(setq ediff-split-window-function #'split-window-horizontally)

;;;; Kill Ring

(defun luna-kill-ring-select ()
  "Select from `kill-ring' and yank.
Helm and ivy starts will remap this function,
so the definition doesn't really matter."
  (interactive)
  (message "This is intended to be remapped by either Helm or ivy star."))

;;;; Fix

(defun luna-return-cancel-completion ()
  "Cancel completion and return."
  (interactive)
  (company-abort)
  (newline nil t))
;;;; Xref
(setq xref-prompt-for-identifier
      '(not xref-find-references xref-find-definitions xref-find-definitions-other-window xref-find-definitions-other-frame))

;;;; Hippie
(add-to-list 'hippie-expand-try-functions-list #'dabbrev-expand)

;;; Functions

(defvar luna-left-margin-window nil
  "Left margin window")

(defvar luna-left-margin-buffer (get-buffer-create " luna-left-margin")
  "Empty buffer used by `luna-left-margin-mode'.")

(define-minor-mode luna-left-margin-mode
  "Create a empty window to the left that act as a margin."
  :lighter ""
  :global t
  (if luna-left-margin-mode
      (unless luna-left-margin-window
        (setq luna-left-margin-window
              (display-buffer-in-side-window luna-left-margin-buffer '((side . left)))))
    (when (and luna-left-margin-window (window-live-p luna-left-margin-window))
      (delete-window luna-left-margin-window)
      (setq luna-left-margin-window nil))))

(defun luna-toggle-left-margin ()
  "Toggle left margin side window."
  (interactive)
  (if luna-left-margin-window
      (window-toggle-side-windows)
    (luna-left-margin-mode)))

(defun luna--line-beg (point)
  "Return the line beginning of POINT."
  (save-excursion
    (goto-char point)
    (line-beginning-position)))

(defun luna--line-end (point)
  "Return the line end of POINT."
  (save-excursion
    (goto-char point)
    (line-end-position)))

(defun luna-transpose-region/line (count)
  "Transpose region or current line with the line COUNT from current line.
negative COUNT means go up.

Transpose down one line means COUNT = 0, look at source for the reason."
  ;; if the cursor is at end of a line, move to the beginning of
  ;; the next line to include the trailing newline
  (let* ((region1 (if (region-active-p)
                      (cons (luna--line-beg (region-beginning))
                            ;; include the trailing newline
                            (1+ (luna--line-end (region-end))))
                    ;; include the trailing newline
                    (cons (line-beginning-position) (1+ (line-end-position)))))
         (region2 (save-excursion
                    ;; normalize starting point
                    ;; go to the beginning of beg/end of region1
                    (if (< count 0)
                        (goto-char (car region1))
                      (goto-char (cdr region1)))
                    ;; go up/down to beg of line of region2
                    (forward-line count)
                    ;; include the trailing newline
                    (cons (line-beginning-position) (1+ (line-end-position))))))
    (transpose-regions (car region1) (cdr region1) (car region2) (cdr region2))))

(defun luna-move-down ()
  "Move region or current line down one line."
  (interactive)
  (luna-transpose-region/line 0))

(defun luna-move-up ()
  "Move region or current line down one line."
  (interactive)
  (luna-transpose-region/line -1))

;;;; smart-delete

;; rainbow!
'(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((())))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))


(defvar luna-hungry-delete-black-list '(org-mode text-mode fundamental-mode markdown-mode)
  "A list of major mode in where `luna-hungry-delete' should behave like normal delete.")

(defun luna-hungry-delete ()
  "Smart and clean delete.
If we are at the beginning of a line, backspace
deletes all whitespace before and after point
and moves point to the previous line."
  (interactive)
  (require 'cl-lib)
  (cl-labels ((normal-delete () (if (region-active-p)
                                    (delete-region (region-beginning) (region-end))
                                  (if (and (not (eql (point) (point-max)))
                                           (eql (alist-get (char-before) '((?{ . ?}) (?\[ . ?\])
                                                                           (?\( . ?\)) (?\" . ?\")
                                                                           (?\' . ?\') (?“ . ?”) (?‘ . ?’)))
                                                (char-after)))
                                      ;; if we are in the middle of a empty pair, i.e., "|" or (|)
                                      ;; delete both
                                      (progn (forward-char)
                                             (backward-delete-char 2))
                                    (call-interactively #'backward-delete-char-untabify)))))
    (if (or (region-active-p)
            (<= (car (syntax-ppss)) 0)
            (minibufferp (current-buffer)))
        ;; if we are at top-level
        ;; do normal delete
        (normal-delete)
      ;; if the point is not before the line but inside it, do normal delete
      ;; otherwise do hungry delete
      ;;
      ;; 1. we first delete all white spaces, then insert newline and indent properly
      ;; 2. but if there is only a closing delimiter, i.e., } or ),
      ;;    we don't insert new line.
      ;; 3. if we ends up in the same place before hungry delete,
      ;;    that means the user is trying to delete back to the previous line,
      ;;    then do that.
      (let* ((point (point)) ; staring point
             (bolt (save-excursion
                     ;; `beginning-of-line-text' seems to ignore comment for some reason,
                     (beginning-of-line)
                     (skip-chars-forward " \t")
                     (point)))
             ;; beginning of the region that we are to delete
             (beg (save-excursion (while (member (char-before) '(?\n ?\s ?\t))
                                    (backward-char))
                                  (point)))
             ;; end of that region
             (end (save-excursion (goto-char bolt)
                                  (while (member (char-after) '(?\n ?\s ?\t))
                                    (forward-char))
                                  (point))))
        (if (<= point bolt)
            ;; actually decide to delete stuff
            (progn
              (delete-region beg end)
              (unless (eql (char-after) ?\))
                (call-interactively #'newline))
              ;; so we did all this and ends up not changing anything
              ;; why? because the user doesn't want to delete excess white space and add newline
              ;; but to delete back to previous line! do that.
              (when (eql (point) end)
                (delete-region beg end)
                (unless (eql (char-before) ?\()
                  (insert ?\s))))
          ;; not at beginning of text, just do normal delete
          (normal-delete))))))

;;; Other functions

(defun luna-open-log () (interactive) (find-file "~/log.org"))


(defun luna-insert-current-date ()
  "insert date for blog composing"
  (interactive)
  (insert (shell-command-to-string "echo -n $(date +%Y-%m-%d)")))


(defun luna-insert-semi-at-eol ()
  "Insert semicolon at end of line."
  (interactive)
  (save-excursion
    (end-of-line)
    (insert ";")))


(defun luna-jump-newline-below ()
  "create new line above/below without breaking current line"
  (interactive)
  (end-of-line)
  (newline-and-indent))


(defun luna-jump-newline-above ()
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (previous-line))


(defun luna-scroll-down-reserve-point ()
  (interactive)
  (scroll-up 2)
  (next-line)
  (next-line))


(defun luna-scroll-up-reserve-point ()
  (interactive)
  (scroll-down 2)
  (previous-line)
  (previous-line))


(defun luna-sudo-edit (&optional arg)
  "Edit currently visited file as root.

With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))


(defun luna-autoinsert (description)
  "Autoinsert what auto-insert inserts."
  (interactive "MDescription: ")
  (let* ((filename (file-name-nondirectory (buffer-file-name)))
         (year (format-time-string "%Y"))
         (feature (file-name-base (buffer-file-name))))
    (insert (format ";;; %s --- %s      -*- lexical-binding: t; -*-

;; Author: Yuan Fu <casouri@gmail.com>

;;; This file is NOT part of GNU Emacs

;;; Commentary:
;;

;;; Code:
;;

(provide '%s)

;;; %s ends here"
                    filename description feature filename))))

;;;###autoload
(defun luna-autoinsert-copyright (description)
  "Autoinsert what auto-insert inserts with copyright."
  (interactive "MDescription: ")
  (let* ((filename (file-name-nondirectory (buffer-file-name)))
         (year (format-time-string "%Y"))
         (feature (file-name-base (buffer-file-name))))
    (insert (format ";;; %s --- %s      -*- lexical-binding: t; -*-

;; Copyright (C) %s Yuan Fu.

;; Author: Yuan Fu <casouri@gmail.com>
;; Maintainer: Yuan Fu <casouri@gmail.com>
;; Keywords:
;; Package-Requires: ((emacs \"\"))
;; Version:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; This file is NOT part of GNU Emacs

;;; Commentary:
;;

;;; Code:
;;

(provide '%s)

;;; %s ends here"
                    filename description feature filename))))

(defvar luna-special-symbol-alist '(("(c)" . "©")
                                    ("tm" . "™")
                                    ("p" . " ")
                                    ("s" . "§")
                                    ("---" . "—") ; em dash
                                    ("--" . "–") ; en dash
                                    ("..." . "…")
                                    ("<" . "⃖")
                                    (">" . "⃗")
                                    ("^" . "ꜛ")
                                    ("v" . "ꜜ")
                                    ("<<" . "←")
                                    (">>" . "→")
                                    ("^^" . "↑")
                                    ("vv" . "↓")
                                    ("l" . "‘")
                                    ("r" . "’")
                                    ("ll" . "“")
                                    ("rr" . "”")
                                    (" " . " ") ; non-breaking spacef
                                    ("hand" . "☞")
                                    )
  "Alist used by `luna-insert-special-symbol'.")

(defun luna-insert-special-symbol (surname)
  "Insert special symbol at point, SURNAME is used to search for symbol.
E.g. SURNAME (c) to symbol ©."
  (interactive "MAbbrev: ")
  (insert (catch 'ret (dolist (elt luna-special-symbol-alist)
                        (when (equal (car elt) surname)
                          (throw 'ret (cdr elt)))
                        ""))))

(defvar-local luna-package-prefix nil
  "The prefix of the package you are writing in the current buffer.")

(defun luna-insert-prefix ()
  "Insert `luna-package-prefix'."
  (interactive)
  (if luna-package-prefix
      (insert luna-package-prefix)
    (message "No prefix defined.")))

(defun luna-set-prefix (prefix)
  "Set current buffer's package prefix."
  (interactive "s")
  (setq luna-package-prefix prefix))

;;; autoload.el ends here


;;; config.el ends here