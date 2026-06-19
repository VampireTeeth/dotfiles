(require 'general)

;; Dvorak keybindings for evil: s/t/n/l navigate, u/i insert.
(with-eval-after-load 'evil
  (let ((motion '(("s" . evil-forward-char)
                  ("t" . evil-next-line)
                  ("n" . evil-previous-line)
                  ("l" . evil-search-next)
                  ("L" . evil-search-previous)))
        (normal-only '(("u" . evil-insert)
                       ("C-u" . evil-undo)
                       ("i" . evil-insert))))
    (dolist (b motion)
      (define-key evil-normal-state-map (kbd (car b)) (cdr b))
      (define-key evil-visual-state-map (kbd (car b)) (cdr b)))
    (dolist (b normal-only)
      (define-key evil-normal-state-map (kbd (car b)) (cdr b)))))

(provide 'general-dvorak)
