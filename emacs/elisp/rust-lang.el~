(use-package rust-mode
  :ensure t)

;; Make sure you have installed the rust-analyzer binary
(use-package lsp-mode
  :ensure t
  :init
  :hook
  (
   (rust-mode-hook . lsp-deferred)))

(provide 'rust-lang)
