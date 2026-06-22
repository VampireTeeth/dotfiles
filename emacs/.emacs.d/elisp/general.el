;; Evil — layout-agnostic core; key remaps live in layout-specific files.
(use-package evil
  :ensure t
  :config
  (evil-mode 1))

;; Evil-leader
(use-package evil-leader
  :after evil
  :ensure t
  :init
  (global-evil-leader-mode)
  :config
  (evil-leader/set-leader "<SPC>")
  (evil-leader/set-key
    "SPC" 'counsel-M-x
    ";"   'eval-expression
    "s s" 'swiper-isearch
    "f f" 'counsel-find-file
    "b b" 'ivy-switch-buffer
    "w w" 'evil-window-next
    "w s" 'evil-window-split
    "w v" 'evil-window-vsplit
    "w o" 'delete-other-windows
    "w c" 'evil-window-delete
    "b d" 'kill-buffer))

(use-package evil-terminal-cursor-changer
  :after evil
  :ensure t
  :config
  (unless (display-graphic-p)
    (evil-terminal-cursor-changer-activate)))

;; Enable vertico
(use-package vertico
  :ensure t
  :config
  (vertico-mode t))

;; Marginalia is not working very well in higher version of Emacs — disabled.
;; (use-package marginalia
;;   :after vertico
;;   :ensure t
;;   :init (marginalia-mode)
;;   :custom
;;   (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil)))

(use-package consult
  :ensure t
  :custom
  ;; Include dotfiles in ripgrep results; exclude .git/ to avoid flooding.
  (consult-ripgrep-args
   (concat "rg --null --line-buffered --color=never --max-columns=1000 --path-separator / "
           "--smart-case --no-heading --with-filename --line-number --search-zip "
           "--hidden --glob=!.git/"))
  ;; Same for fd: descend into dot-directories (e.g. .emacs.d/) but skip .git/.
  (consult-fd-args
   '((if (executable-find "fdfind" 'remote) "fdfind" "fd")
     "--full-path --color=never --hidden --exclude .git"))
  :config
  (defun my/consult-find-dwim ()
    "Use `consult-fd' when fd is on PATH, else fall back to `consult-find'."
    (interactive)
    (if (or (executable-find "fd") (executable-find "fdfind"))
        (call-interactively #'consult-fd)
      (call-interactively #'consult-find)))

  (defun my/consult-ripgrep-in-dir ()
    "Run `consult-ripgrep' but prompt for the search directory."
    (interactive)
    (consult-ripgrep '(4)))

  (with-eval-after-load 'evil-leader
    (evil-leader/set-key
      "c b" 'consult-buffer
      "c f" 'my/consult-find-dwim
      "c r" 'consult-ripgrep
      "c R" 'my/consult-ripgrep-in-dir
      "c l" 'consult-line)))

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
  (global-set-key (kbd "C-c V") 'ivy-pop-view))

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
  (rg-enable-default-bindings))

;; Enable Dimmer
(use-package dimmer
  :ensure t
  :config
  (dimmer-mode 1))

;; Bridge Emacs kill-ring to the system clipboard in terminal sessions.
;; xclip dispatches to pbcopy/pbpaste, xclip/xsel, or wl-copy/wl-paste.
(use-package xclip
  :ensure t
  :config
  (xclip-mode 1))


;; General system package utilities
(defun my/ensure-pkg-config ()
  "Ensure pkg-config is installed."
  (unless (executable-find "pkg-config")
    (cond
     ((executable-find "brew")   (shell-command "brew install pkg-config"))
     ((executable-find "pacman") (shell-command "yay -S pkgconf"))
     ((executable-find "apt")    (shell-command "apt install -y pkg-config"))
     (t (warn "pkg-config: no supported package manager found")))))

(defun my/libvterm-installed-p ()
  "Return non-nil if libvterm is installed."
  (my/ensure-pkg-config)
  (zerop (call-process "pkg-config" nil nil nil "--exists" "vterm")))

;; Enable vterm
(use-package vterm
  :ensure t
  :init
  (unless (and (executable-find "cmake")
               (executable-find "libtool")
               (my/libvterm-installed-p))
    (let ((cmd (cond
                ((executable-find "brew")   "brew install cmake libtool libvterm")
                ((executable-find "pacman") "yay -S cmake libtool libvterm")
                ((executable-find "apt")    "apt install -y cmake libtool libtool-bin libvterm-dev"))))
      (if cmd
          (shell-command cmd)
        (warn "vterm: no supported package manager found to install dependencies")))))

;; Enable AI agent-shell
(defvar my/ampcode-install-cmd
  (cond
   ((executable-find "brew")   "brew install ampcode")
   ((executable-find "pacman") "yay -S ampcode")
   ((executable-find "apt")    "apt install -y ampcode")))

(defvar my/claude-install-cmd
  (cond
   ((executable-find "brew")   "brew install claude-code")
   ((executable-find "pacman") "yay -S claude-code")
   ((executable-find "apt")    "apt install -y claude-code")))

(use-package agent-shell
    :ensure t
    :init
    (unless (executable-find "claude")
      (if my/claude-install-cmd
          (shell-command my/claude-install-cmd)
        (warn "agent-shell: no supported package manager found to install claude")))
    (unless (executable-find "claude-agent-acp")
      (shell-command "npm install -g @zed-industries/claude-agent-acp"))
    (unless (executable-find "amp")
      (if my/ampcode-install-cmd
          (shell-command my/ampcode-install-cmd)
        (warn "agent-shell: no supported package manager found to install ampcode")))
    (unless (executable-find "acp-amp")
      (shell-command "npm install -g @superagenticai/acp-amp"))
    (unless (executable-find "codex-acp")
      (shell-command "npm install -g @zed-industries/codex-acp")))

(defun my/agent-shell-ampcode ()
  "Interactively open an agent-shell session for Ampcode."
  (interactive)
  (agent-shell--dwim
   :config (agent-shell-make-agent-config
            :identifier 'ampcode
            :mode-line-name "Amp"
            :buffer-name "*Amp-Agent*"
            :client-maker (lambda (buffer)
                            (agent-shell--make-acp-client
                             :command "npx"
                             :command-params '("-y" "@superagenticai/acp-amp")
                             :context-buffer buffer))
            :install-instructions "Install via: npm install -g @superagenticai/acp-amp")
   :new-shell t))

;; Tramp — reuse a single SSH connection for 15 minutes to speed up remote ops.
(let ((ssh-control-dir (expand-file-name "~/.ssh/control")))
  (make-directory ssh-control-dir t)
  (use-package tramp
    :ensure nil
    :defer t
    :custom
    (tramp-ssh-controlmaster-options
     (concat "-o ControlMaster=auto -o ControlPersist=15m"
             " -o ControlPath=" ssh-control-dir "/ssh-%C"))))

(provide 'general)
