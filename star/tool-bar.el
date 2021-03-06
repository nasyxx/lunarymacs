;;; Icons

(add-to-list
 'image-load-path
 (expand-file-name "etc/images/bootstrap" user-emacs-directory))

;;; Global map

;; Control the sequence of icons.
(setq tool-bar-map (make-sparse-keymap))

(define-key tool-bar-map [isearch-forward]
  `(menu-item "Forward String..." isearch-forward
              :enable t
              :help "Search forward for a string as you type it"
              :image ,(find-image '((:type png :file "search.png")))))

(define-key tool-bar-map [paste]
  `(menu-item "Paste" yank
              :enable t
              :help "Paste (yank) text most recently cut/copied"
              :image ,(find-image '((:type png :file "paste.png")))))

(define-key tool-bar-map [copy]
  `(menu-item "Copy" ns-copy-including-secondary
              :enable mark-active
              :help "Copy text in region between mark and current position"
              :image ,(find-image '((:type png :file "copy.png")))))

(define-key tool-bar-map [cut]
  `(menu-item "Cut" kill-region
              :enable (and mark-active (not buffer-read-only))
              :help "Cut (kill) text in region between mark and current position"
              :image ,(find-image '((:type png :file "cut.png")))))

(define-key tool-bar-map [undo]
  `(menu-item "Undo" undo
              :enable (and (not buffer-read-only)
                           (not (eq t buffer-undo-list))
                           (if (eq last-command 'undo)
                               (listp pending-undo-list)
                             (consp buffer-undo-list)))
              :help "Undo last edits"
              :image ,(find-image '((:type png :file "undo.png")))))

(define-key tool-bar-map [save-buffer]
  `(menu-item "Save" save-buffer
              :enable (and (buffer-modified-p)
                           (buffer-file-name)
                           (menu-bar-non-minibuffer-window-p))
              :help "Save current buffer to its file"
              :image ,(find-image '((:type png :file "save-buffer.png")))))

(define-key tool-bar-map [save-buffer]
  `(menu-item "Save" save-buffer
              :enable (and (buffer-modified-p)
                           (buffer-file-name)
                           (menu-bar-non-minibuffer-window-p))
              :help "Save current buffer to its file"
              :image ,(find-image '((:type png :file "save-buffer.png")))))

(define-key tool-bar-map [dired]
  `(menu-item "Open Directory..." dired
              :enable (menu-bar-non-minibuffer-window-p)
              :help "Read a directory, to operate on its files"
              :image ,(find-image '((:type png :file "dired.png")
                                    (:type png :file "open-folder.png")))))

(define-key tool-bar-map [kill-buffer]
  `(menu-item "Close" kill-this-buffer
              :enable (kill-this-buffer-enabled-p)
              :help "Discard (kill) current buffer"
              :image ,(find-image '((:type png :file "kill-buffer.png")))))

(define-key tool-bar-map [open-file]
  `(menu-item "Open File..." menu-find-file-existing
              :enable (menu-bar-non-minibuffer-window-p)
              :help "Read an existing file into an Emacs buffer"
              :image ,(find-image '((:type png :file "menu-find-file-existing.png")
                                    (:type png :file "open-file.png")))))

(define-key tool-bar-map [new-file]
  `(menu-item "Visit New File..." find-file
              :enable (menu-bar-non-minibuffer-window-p)
              :help "Specify a new file's name, to edit the file"
              :image ,(find-image '((:type png :file "find-file.png")
                                    (:type png :file "new-file.png")))))

(define-key tool-bar-map [helpme]
  `(menu-item "Help" helpme
              :help "Show help"
              :image ,(find-image '((:type png :file "helpme.png")
                                    (:type png :file "help.png")))))

;;; Always right

(defvar tool-bar-right-map (make-sparse-keymap)
  "Icons in this map is almost always on the right.")

(defvar tool-bar-right-mode t
  "When non-nil, tool-bar-right-map takes effect.")

;; (define-key tool-bar-right-map [tool-bar sidebar-mode]
;;   `(menu-item "Sidebar" sidebar-mode
;;               :help "Toggle sidebar"
;;               :image ,(find-image '((:type png :file "sidebar-mode.png")
;;                                     (:type png :file "sidebar.png")))))

(define-key tool-bar-right-map [tool-bar bookmark-set]
  `(menu-item "Bookmark" bookmark-set
              :help "Add bookmark"
              :image ,(find-image '((:type png :file "bookmark-set.png")
                                    (:type png :file "bookmark-plus.png")))))

(define-key tool-bar-right-map [tool-bar menu-set-font]
  `(menu-item "Set font" menu-set-font
              :help "Set font"
              :image ,(find-image '((:type png :file "menu-set-font.png")
                                    (:type png :file "fonts.png")))))

(define-key tool-bar-right-map [tool-bar read-only-mode]
  `(menu-item "Read-only" read-only-mode
              :help "Toggle buffer read-only"
              :image ,(find-image '((:type png :file "read-only-mode.png")
                                    (:type png :file "lock.png")))))

(setf (alist-get 'tool-bar-right-mode minor-mode-map-alist)
      tool-bar-right-map)

;;; Isearch

(setq isearch-tool-bar-map (make-sparse-keymap))

(define-key isearch-tool-bar-map [isearch-repeat-backward]
  `(menu-item "Repeat backward" isearch-repeat-backward
              :help "Repeat search backward"
              :image ,(find-image '((:type png :file "isearch-repeat-backward.png")
                                    (:type png :file "left-arrow.png")))))

(define-key isearch-tool-bar-map [isearch-repeat-forward]
  `(menu-item "Repeat forward" isearch-repeat-forward
              :help "Repeat search forward"
              :image ,(find-image '((:type png :file "isearch-repeat-forward.png")
                                    (:type png :file "right-arrow.png")))))

(define-key isearch-tool-bar-map [isearch-cancel]
  `(menu-item "Abort" isearch-cancel
              :help "Abort search"
              :image ,(find-image '((:type png :file "isearch-cancel.png")
                                    (:type png :file "stop.png")))))

(define-key isearch-tool-bar-map [isearch-exit]
  `(menu-item "Finish" isearch-exit
              :help "Finish search leaving point where it is"
              :image ,(find-image '((:type png :file "isearch-exit.png")
                                    (:type png :file "complete.png")))))

(define-key isearch-tool-bar-map [isearch-occur]
  `(menu-item "Replace" isearch-occur
              :help "Show each search hit"
              :image ,(find-image '((:type png :file "isearch-occur.png")
                                    (:type png :file "show.png")))))

(define-key isearch-tool-bar-map [isearch-query-replace]
  `(menu-item "Replace" isearch-query-replace
              :help "Replace search string"
              :image ,(find-image '((:type png :file "isearch-query-replace.png")
                                    (:type png :file "replace.png")))))

;; (define-key isearch-tool-bar-map [isearch-delete-char]
;;   `(menu-item "Undo" isearch-delete-char
;;               :help "Undo last input item"
;;               :image ,(find-image '((:type png :file "isearch-delete-char.png")
;;                                     (:type png :file "backspace.png")))))

(define-key isearch-tool-bar-map [isearch-describe-mode]
  `(menu-item "Replace" isearch-describe-mode
              :help "Get help for Isearch"
              :image ,(find-image '((:type png :file "isearch-describe-mode.png")
                                    (:type png :file "help.png")))))

;;; Info mode

(setq info-tool-bar-map (make-sparse-keymap))

(define-key info-tool-bar-map [quit-window]
  `(menu-item "Exit" quit-window
              :help "Stop reading Info"
              :image ,(find-image '((:type png :file "quit-window.png")
                                    (:type png :file "stop.png")))))

(define-key info-tool-bar-map [Info-search]
  `(menu-item "Search..." Info-search
              :help "Search for regular expression in this Info file"
              :image ,(find-image '((:type png :file "Info-search.png")
                                    (:type png :file "search.png")))))

(define-key info-tool-bar-map [Info-index]
  `(menu-item "Lookup a String..." Info-index
              :help "Look for a string in the index items"
              :image ,(find-image '((:type png :file "Info-index.png")
                                    (:type png :file "index.png")))))

(define-key info-tool-bar-map [Info-goto-node]
  `(menu-item "Go to Node..." Info-goto-node
              :help "Go to a named node"
              :image ,(find-image '((:type png :file "Info-goto-node.png")
                                    (:type png :file "node-list.png")))))

(define-key info-tool-bar-map [Info-top-node]
  `(menu-item "Top" Info-top-node
              :help "Go to top node of file"
              :image ,(find-image '((:type png :file "Info-top-node.png")
                                    (:type png :file "home.png")))))

(define-key info-tool-bar-map [Info-up]
  `(menu-item "Up" Info-up
              :help "Go up in the Info tree"
              :enable (Info-check-pointer "up")
              :image ,(find-image '((:type png :file "Info-up.png")
                                    (:type png :file "arrow-up.png")))))

(define-key info-tool-bar-map [Info-next]
  `(menu-item "Next" Info-next
              :help "Go to the next node"
              :enable (Info-check-pointer "next")
              :image ,(find-image '((:type png :file "Info-next.png")
                                    (:type png :file "arrow-right.png")))))

(define-key info-tool-bar-map [Info-prev]
  `(menu-item "Previous" Info-prev
              :help "Go to the previous node"
              :enable (Info-check-pointer "prev[ious]*")
              :image ,(find-image '((:type png :file "Info-prev.png")
                                    (:type png :file "arrow-left.png")))))

(define-key info-tool-bar-map [Info-history-forward]
  `(menu-item "Forward in history" Info-history-forward
              :help "Go back in history to the last node you were at"
              :enable Info-history-forward
              :image ,(find-image '((:type png :file "Info-history-forward.png")
                                    (:type png :file "redo.png")))))

(define-key info-tool-bar-map [Info-history-back]
  `(menu-item "Back in history" Info-history-back
              :help "Go back in history to the last node you were at"
              :enable Info-history
              :image ,(find-image '((:type png :file "Info-history-forward.png")
                                    (:type png :file "undo.png")))))

;;; Org Mode

(define-key org-mode-map [tool-bar org-toggle-inline-images]
  `(menu-item "Show image" org-toggle-inline-images
              :help "Toggle inline image display"
              :image ,(find-image '((:type png :file "org-toggle-inline-images.png")
                                    (:type png :file "image.png")))))


;;; Text mode

(define-key text-mode-map [tool-bar olivetti-shrink]
  `(menu-item "Contract" olivetti-shrink
              :help "Contract page"
              :enable '(bound-and-true-p 'olivetti-mode)
              :image ,(find-image '((:type png :file "olivetti-shrink.png")
                                    (:type png :file "contract.png")))))

(define-key text-mode-map [tool-bar olivetti-expand]
  `(menu-item "Expand" olivetti-expand
              :help "Expand page"
              :enable '(bound-and-true-p 'olivetti-mode)
              :image ,(find-image '((:type png :file "olivetti-expand.png")
                                    (:type png :file "expand.png")))))
