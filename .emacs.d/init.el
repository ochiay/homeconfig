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
   '(yasnippet-snippets page-break-lines consult treemacs-magit treemacs-projectile yasnippet which-key vterm vertico-posframe use-package reverse-im rainbow-delimiters pyvenv python-mode python-black persp-mode orderless olivetti marginalia magit lua-mode lsp-dart eglot doom-themes doom-modeline django-mode define-word dashboard corfu)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
