(require 'org)

(org-babel-load-file
 (expand-file-name "config.org"
  user-emacs-directory)
 )

;; (find-file (concat user-emacs-directory "config.org"))

;; (org-babel-tangle)

;; (load-file (concat user-emacs-directory "init.el"))

;; (byte-compile-file (concat user-emacs-directory "init.el"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(consult corfu dashboard define-word django-mode doom-modeline
             doom-themes eglot emmet-mode lsp-dart lua-mode magit
             marginalia olivetti orderless page-break-lines persp-mode
             python-black python-mode pyvenv rainbow-delimiters
             reverse-im treemacs-magit treemacs-projectile use-package
             vertico-posframe vterm web-mode which-key yasnippet
             yasnippet-snippets)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
