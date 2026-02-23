;; Enable evil
(use-package evil
  :ensure t
  :bind
  (:map evil-normal-state-map
   ("s" . 'evil-forward-char)
   ("t" . 'evil-next-line)
   ("n" . 'evil-previous-line)
   ("l" . 'evil-search-next)
   ("L" . 'evil-search-previous)
   ("u" . 'evil-insert)
   ("C-u" . 'evil-undo)
   ("i" . 'evil-insert)

   :map evil-visual-state-map
   ("s" . 'evil-forward-char)
   ("t" . 'evil-next-line)
   ("n" . 'evil-previous-line)
   ("l" . 'evil-search-next)
   ("L" . 'evil-search-previous))

  :config
  (evil-mode 1)) ;; End evil

;; Evil-leader
(use-package evil-leader
  :after evil
  :ensure t
  :init
  (global-evil-leader-mode)
  :config
  (evil-leader/set-leader "<SPC>")
  (evil-leader/set-key
    "s s" 'swiper-isearch
    "f f" 'counsel-find-file
    "b b" 'ivy-switch-buffer
    "w w" 'evil-window-next
    "w s" 'evil-window-split
    "w v" 'evil-window-vsplit
    "w o" 'delete-other-windows
    "w c" 'evil-window-delete
    "b d" 'kill-buffer))

;; Enable vertico
(use-package vertico
  :ensure t
  :config
  (vertico-mode t))

;; Enable Marginalia
(use-package marginalia
  :after vertico
  :ensure t
  :init
  (marginalia-mode)
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil)))

(use-package consult
  :bind
  (("C-c c b" . 'consult-buffer)
   ("C-c c f" . 'consult-find)
   ("C-c c r" . 'consult-ripgrep)
   ("C-c c l" . 'consult-line)))

;; Enable the Ace jump mode
(use-package ace-jump-mode
  :ensure t
  :config
  (define-key global-map (kbd "C-c SPC") 'ace-jump-mode))

;; Enable company mode
(use-package company
  :ensure t
  :bind (("C-SPC" . company-search-candidates)
	 :map company-active-map
	 ("<backtab>" . company-select-previous)
	 ("<tab>" . company-select-next)
	 :map company-search-map
	 ("<backtab>" . company-select-previous)
	 ("<tab>" . company-select-next))
  :init
  (global-company-mode 1))

;; Enable Counsel, Ivy and Swiper
(use-package counsel
  :ensure t
  :config
  (global-set-key (kbd "C-s") 'swiper-isearch)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "M-y") 'counsel-yank-pop)
  (global-set-key (kbd "C-h f") 'counsel-describe-function)
  (global-set-key (kbd "C-h v") 'counsel-describe-variable)
  (global-set-key (kbd "C-h l") 'counsel-find-library)
  (global-set-key (kbd "C-h i") 'counsel-info-lookup-symbol)
  (global-set-key (kbd "C-h u") 'counsel-unicode-char)
  (global-set-key (kbd "C-h j") 'counsel-set-variable)
  (global-set-key (kbd "C-x b") 'ivy-switch-buffer)
  (global-set-key (kbd "C-c v") 'ivy-push-view)
  (global-set-key (kbd "C-c V") 'ivy-pop-view)
  ) ;; end of counsel, ivy and swiper


;; Enable projectile
(use-package projectile
  :ensure t
  :bind
  (:map projectile-mode-map
	("C-c p" . 'projectile-command-map))
  :config
  (projectile-mode +1))

;; Enable color-theme-sanityinc-tomorrow
(use-package color-theme-sanityinc-tomorrow
  :ensure t
  :config
  (load-theme 'sanityinc-tomorrow-eighties))

;; Enable RipGrep
(use-package rg
  :ensure t
  :config
  (rg-enable-default-bindings)) ;; end of the ripgrep

;; Enable Dimmer
(use-package dimmer
  :ensure t
  :config
  (dimmer-mode 1))


;; Enable AI agent-shell
(use-package agent-shell
    :ensure t
    :ensure-system-package
    ;; Add agent installation configs here
    ((claude . "brew install claude-code")
     (claude-agent-acp . "npm install -g @zed-industries/claude-agent-acp")))

(provide 'general)
