;;;
;;; hjkl-mode.el
;;;
;;; author: Satoshi Namai
;;;
;;; Time-stamp: <2012-08-13 04:28:28 (namai)>
;;;

(require 'key-chord)

(defun turn-on-hjkl-mode ()
  (interactive)
  (message "%s" "-- NORMAL --")
  (hjkl-mode t))

(defun turn-off-hjkl-mode ()
  (interactive)
  (message "%s" "-- INSERT --")
  (hjkl-mode -1))

(defun hjkl/delete-line-on-cursor ()
  (interactive)
  (kill-new (thing-at-point 'line))
  (delete-region (point-at-bol) (+ 1 (point-at-eol)))
  (back-to-indentation))

(defun hjkl/insert-next-line ()
  (interactive)
  (hjkl-mode -1)
  (open-line 1)
  (forward-line)
  (beginning-of-line))

(defun hjkl/yank ()
  (interactive)
  (forward-line)
  (yank))

(defun hjkl/yank-to-next-line ()
  (interactive)
  (forward-line)
  (beginning-of-line)
  (yank)
  (beginning-of-line))

(defun hjkl/set-marker ()
  (interactive)
  (set-marker (make-marker) (point)))

(defun hjkl/undo ()
  (interactive)
  (if (fboundp 'undo-tree-undo)
      (undo-tree-undo)
    (undo)))

(defvar hjkl-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "j") 'next-line)
    (define-key map (kbd "k") 'previous-line)
    (define-key map (kbd "l") 'forward-char)
    (define-key map (kbd "h") 'backward-char)
    (define-key map (kbd "0") 'move-beginning-of-line)
    (define-key map (kbd "$") 'move-end-of-line)
    (define-key map (kbd "g g") 'beginning-of-buffer)
    (define-key map (kbd "G") 'end-of-buffer)
    (define-key map (kbd "i") 'turn-off-hjkl-mode)
    (define-key map (kbd "o") 'hjkl/insert-next-line)
    (define-key map (kbd "d d") 'hjkl/delete-line-on-cursor)
    (define-key map (kbd "y") 'kill-ring-save)
    (define-key map (kbd "x") 'delete-char)
    (define-key map (kbd "d w") 'kill-word)
    (define-key map (kbd "p") 'hjkl/yank)
    (define-key map (kbd "P") 'hjkl/yank-to-next-line)
    (define-key map (kbd "v") 'set-mark-command)
    (define-key map (kbd "u") 'hjkl/undo)
    map))

(define-minor-mode hjkl-mode
  "hjkl-mode is a minor-mode. hjkl-mode provide keybind to move cursor by vim-keybinds."
  :lighter " vi" :keymap hjkl-mode-map)

(key-chord-mode 1)
(key-chord-define-global "jk" 'turn-on-hjkl-mode)

(provide 'hjkl-mode)
