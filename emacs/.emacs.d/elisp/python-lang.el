;; -*- lexical-binding: t; -*-
(use-package elpy
  :after evil-leader
  :ensure t
  :init
  (elpy-enable)
  (require 'evil-leader)
  (evil-leader/set-key-for-mode 'python-mode
    ;; Shell / REPL
    "e" 'elpy-shell-send-statement-and-step
    "r" 'elpy-shell-send-region-or-buffer
    "z" 'elpy-shell-switch-to-shell
    "f" 'elpy-shell-send-defun
    "F" 'elpy-shell-send-defun-and-go
    "c" 'elpy-shell-send-defclass
    "s" 'elpy-shell-send-top-statement

    ;; Navigation
    "g" 'elpy-goto-definition
    "a" 'elpy-goto-assignment
    "o" 'elpy-occur-definitions
    "n" 'elpy-nav-forward-block
    "p" 'elpy-nav-backward-block

    ;; Editing
    "u" 'elpy-nav-move-line-or-region-up
    "d" 'elpy-nav-move-line-or-region-down
    "[" 'elpy-nav-indent-shift-left
    "]" 'elpy-nav-indent-shift-right

    ;; Refactoring
    "R" 'elpy-refactor-rename
    "v" 'elpy-refactor-extract-variable
    "i" 'elpy-refactor-inline
    "m" 'elpy-multiedit-python-symbol-at-point
    "I" 'elpy-importmagic-fixup

    ;; Debugging
    "D" 'elpy-pdb-debug-buffer
    "b" 'elpy-pdb-toggle-breakpoint-at-point
    "x" 'elpy-pdb-debug-last-exception

    ;; Testing / Search
    "t" 'elpy-test
    "S" 'elpy-rgrep-symbol

    ;; Misc
    "h" 'elpy-doc
    "=" 'elpy-format-code))

   
(provide 'python-lang)
