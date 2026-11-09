;; -*- lexical-binding: t; -*-
(use-package eglot
  :ensure nil
  :hook (python-mode . eglot-ensure))   
   
(provide 'python-lang)
