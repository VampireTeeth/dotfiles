(add-to-list 'load-path "~/.emacs.d/lisp/")

;; first, declare repositories
(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa" . "http://melpa.org/packages/")
	("nongnu" . "https://elpa.nongnu.org/nongnu/")))

;; Init the package facility
(require 'package)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("04aa1c3ccaee1cc2b93b246c6fbcd597f7e6832a97aaeac7e5891e6863236f9f" "b11edd2e0f97a0a7d5e66a9b82091b44431401ac394478beb44389cf54e6db28" default))
 '(package-selected-packages
   '(evil-leader projectile dimmer consult rg color-theme-sanityinc-tomorrow xah-fly-keys vertico use-package marginalia evil counsel company ace-jump-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
