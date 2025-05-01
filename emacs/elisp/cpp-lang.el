(use-package lsp-mode
  :ensure t
  :bind-keymap ("C-c l" . lsp-command-map)
  :hook ((lsp-mode . lsp-enable-which-key-integration))
  :config (setq lsp-completion-enable-additional-text-edit nil))

(use-package lsp-ui
  :commands lsp-ui-mode
  :ensure t)

(use-package ccls
  :ensure t
  :config
  (setq ccls-executable "ccls")
  (setq lsp-prefer-flymake nil)
  (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  :hook ((c-mode c++-mode objc-mode) .
         (lambda () (require 'ccls) (lsp))))

(use-package flycheck
  :ensure t)

(use-package yasnippet
  :ensure t
  :config (yas-global-mode))

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package lsp-treemacs
  :ensure t)


(defun code-compile()
  (interactive)
  (unless (file-exists-p "Makefile")
    (set (make-local-variable 'compile-command)
	 (let ((file (file-name-nondirectory buffer-file-name)))
	   (format "%s -o out/%s %s"
		   (if (equal (file-name-extension file) "cpp") "g++" "gcc")
		   (file-name-sans-extension file)
		   file)))
    (compile compile-command)))

(global-set-key (kbd "C-c C-g c") 'code-compile)

(provide 'cpp-lang)
