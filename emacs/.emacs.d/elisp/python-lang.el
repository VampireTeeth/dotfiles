;; -*- lexical-binding: t; -*-
(use-package eglot
  :ensure t
  ;; ... your existing config ...
  :hook (python-base-mode . eglot-ensure)
  :config
  (add-to-list 'eglot-server-programs
               '((python-base-mode :language-id "python") . ("ty" "server"))))
   
(provide 'python-lang)
