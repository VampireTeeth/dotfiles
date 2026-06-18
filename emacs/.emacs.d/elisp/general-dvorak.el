(require 'general)

;; Dvorak keybindings for evil: s/t/n/l navigate, u/i insert.
(with-eval-after-load 'evil
  (dolist (binding '(("s" . evil-forward-char)
                     ("t" . evil-next-line)
                     ("n" . evil-previous-line)
                     ("l" . evil-search-next)
                     ("L" . evil-search-previous)
                     ("u" . evil-insert)
                     ("C-u" . evil-undo)
                     ("i" . evil-insert)))
    (define-key evil-normal-state-map (kbd (car binding)) (cdr binding)))
  (dolist (binding '(("s" . evil-forward-char)
                     ("t" . evil-next-line)
                     ("n" . evil-previous-line)
                     ("l" . evil-search-next)
                     ("L" . evil-search-previous)))
    (define-key evil-visual-state-map (kbd (car binding)) (cdr binding))))

(provide 'general-dvorak)
