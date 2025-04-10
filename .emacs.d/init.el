(require 'org)

(org-babel-load-file
 (expand-file-name "config.org"
  user-emacs-directory)
 )

;; (find-file (concat user-emacs-directory "config.org"))

;; (org-babel-tangle)

;; (load-file (concat user-emacs-directory "init.el"))

;; (byte-compile-file (concat user-emacs-directory "init.el"))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("835868dcd17131ba8b9619d14c67c127aa18b90a82438c8613586331129dda63" "8146edab0de2007a99a2361041015331af706e7907de9d6a330a3493a541e5a6" "1d5e33500bc9548f800f9e248b57d1b2a9ecde79cb40c0b1398dec51ee820daf" default))
 '(package-selected-packages
   '(reverse-im define-word use-package-chords use-package-hydra use-package-el-get lsp-python ivy doom-modeline lsp-dart doom-themes dashboard yasnippet-classic-snippets web-mode use-package protobuf-mode ppd-sr-speedbar page-break-lines nhexl-mode neotree lua-mode lsp-mode jedi gnu-elpa-keyring-update django-snippets django-mode dart-server dart-mode auto-yasnippet auto-compile apropospriate-theme ace-window ac-helm))
 '(warning-suppress-types '((use-package) (use-package) (use-package))))
