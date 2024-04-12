(add-to-list 'load-path "~/.emacs.d/lisp/")

(eval-when-compile
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
    :bind (
	   :map evil-normal-state-map
	   ("s" . 'evil-forward-char)
	   ("t" . 'evil-next-line)
	   ("n" . 'evil-previous-line)
	   ("l" . 'evil-search-next)
	   ("L" . 'evil-search-previous)
	   ("u" . 'evil-insert)
	   ("C-u" . 'evil-undo)
	   ("i" . 'evil-undo)

	   :map evil-visual-state-map
	   ("s" . 'evil-forward-char)
	   ("t" . 'evil-next-line)
	   ("n" . 'evil-previous-line)
	   ("l" . 'evil-search-next)
	   ("L" . 'evil-search-previous)
	   )
    :config
    (evil-mode 1)) ;; End evil

  ;; Enable vertico
  (use-package vertico
    :ensure t
    :config
    (vertico-mode t))
  
  ;; Enable Marginalia
  (use-package marginalia
    :after vertico
    :ensure t
    :custom
    (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
    :config
    (marginalia-mode))

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
	   ("C-n" . company-select-previous)
	   ("C-t" . company-select-next)
	   :map company-search-map
	   ("C-n" . company-select-previous)
	   ("C-t" . company-select-next))
    :init
    (global-company-mode 1)
    :config
    )
  );; end of eval-when-compile



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(evil company company-mode ace-jump-mode marginalia use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
