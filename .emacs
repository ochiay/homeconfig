;; по мотивам https://habrahabr.ru/post/248663/
;; system-type definition
(defun system-is-linux()
  (string-equal system-type "gnu/linux"))
(defun system-is-windows()
  (string-equal system-type "windows-nt"))
;; (when (system-is-linux)
;;   (require 'server)
;;   (unless (server-runnig-p)
;;     (server-start)))
(defalias 'yes-or-no-p 'y-or-n-p)

;; #MODES
(electric-pair-mode 1)
(package-initialize)
(desktop-save-mode 1)
(set-face-attribute 'default nil :height 110)
;;(set-frame-font Font nil t)
(set-default-font "-PfEd-DejaVu Sans Mono-normal-normal-normal-*-*-*-*-*-m-0-iso10646-1")
;;visual
(tool-bar-mode -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode 1)
(global-font-lock-mode t)
(show-paren-mode t)
(blink-cursor-mode -1)
(delete-selection-mode t) ;; ГОСПОДИ, КАК ЖЕ МНЕ ЭТОГО НЕ ХВАТАЛО
;;(setq show-paren-style 'expression) ;; выделить цветом выражения между {},[],()
(fringe-mode '(8 . 0)) ;; органичитель текста только слева
(setq-default indicate-empty-lines t) ;; отсутствие строки выделить глифами рядом с полосой с номером строки
(setq-default indicate-buffer-boundaries 'left) ;; индикация только слева
(setq make-backup-files        nil)
;;(setq auto-save-default        nil)
;;(setq auto-save-list-file-name nil)

;; #FUNCTIONS
;;
(defun set-window-width (n)
  (interactive "nWindow width:")
  ;;(message "%s" n)
  (adjust-window-trailing-edge (selected-window) (- n (window-width)) t)
  )
;;(add-hook 'prog-mode-hook (lambda() set-window-width "80"))
;; revert all buffers
(defun revert-all-buffers ()
  "Refreshes all open buffers from their respective files."
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (and (buffer-file-name) (file-exists-p (buffer-file-name)) (not (buffer-modified-p)))
        (revert-buffer t t t) )))
  (message "Refreshed open files."))
;; russian hotkeys
(defun reverse-input-method (input-method)
  "Build the reverse mapping of single letters from INPUT-METHOD."
  (interactive
   (list (read-input-method-name "Use input method (default current): ")))
  (if (and input-method (symbolp input-method))
      (setq input-method (symbol-name input-method)))
  (let ((current current-input-method)
        (modifiers '(nil (control) (meta) (control meta))))
    (when input-method
      (activate-input-method input-method))
    (when (and current-input-method quail-keyboard-layout)
      (dolist (map (cdr (quail-map)))
        (let* ((to (car map))
               (from (quail-get-translation
                      (cadr map) (char-to-string to) 1)))
          (when (and (characterp from) (characterp to))
            (dolist (mod modifiers)
              (define-key local-function-key-map
                (vector (append mod (list from)))
                (vector (append mod (list to)))))))))
    (when input-method
      (activate-input-method current))))
(reverse-input-method 'russian-computer)
;; rus.hot.end
(defun abs-enter()
  "new-line independent of posiotin in string "
  (interactive)
  (end-of-line)
  (newline-and-indent)
  )
(defun speedbar-up()
  (interactive)
  (speedbar-update-contents)
  (speedbar)
  )

;; #VARIABLES
;; --- simple startup settings
(setq frame-title-format ": %b")
(setq ring-bell-function 'ignore)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t) ;;null startup add
(setq-default truncate-lines t)
(setq web-mode-engines-alist
      '(("django" . "\\.html\\'"))
      )
;; -- indent settings
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default c-basic-offset 4)
(setq-default standart-indent 4)
(defalias 'list-buffers 'ibuffer)
;;(setq truncate-partial-width-windows nil)

;; #HOTKEYS
(define-prefix-command 'ctr-w-pref)
(define-key ctr-w-pref (kbd "j")    'other-window)
(define-key ctr-w-pref (kbd "k")    'previous-multiframe-window)
(define-key ctr-w-pref (kbd "w")    'kill-region)
(define-key ctr-w-pref (kbd "C-w")  'kill-region)
(define-key ctr-w-pref (kbd "g")    'goto-line)
(define-key ctr-w-pref (kbd "a")    'align-regexp)
(define-key ctr-w-pref (kbd "C-j")  'scroll-down-command)
(define-key ctr-w-pref (kbd "C-k")  'scroll-up-command)
(define-key ctr-w-pref (kbd "v")    'scroll-other-window)
(define-key ctr-w-pref (kbd "p")    'scroll-other-window-down)
(define-key ctr-w-pref (kbd "s")    'set-window-width)
(global-set-key (kbd "C-w")         'ctr-w-pref)
;; switch beggining of lines
(global-set-key (kbd "C-a")         'back-to-indentation)
(global-set-key (kbd "C-S-a")         'move-beginning-of-line)
;;
(global-set-key (kbd "C-x w")       'kill-region)
(global-set-key (kbd "C-<return>")  'abs-enter)
(global-set-key (kbd "<f5>")        'save-buffer)
(global-set-key (kbd "<f6>")        'revert-buffer)
(global-set-key (kbd "<f7>")        'whitespace-mode)
(global-set-key (kbd "<f8>")        'find-file)
(global-set-key (kbd "<f9>")        'compile)
(global-set-key (kbd "<f2>")        'bs-show)
(global-set-key (kbd "<f12>")       'speedbar-up)
(global-set-key (kbd "<C-f12>")     'speedbar-update-contents)
(global-set-key (kbd "C-S-k")       'kill-whole-line)
(global-set-key (kbd "C-x x")       'delete-char)
(global-set-key (kbd "C-'")         'comment-or-uncomment-region)
(global-set-key (kbd "C-,")         'backward-kill-word)
(global-set-key (kbd "C-.")         'kill-word)
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "M-d")         'bookmark-set)
(global-set-key (kbd "C-d")         'bookmark-jump)
(global-set-key (kbd "C-S-d")       'bookmark-bmenu-list)
(global-set-key (kbd "C-x j")       'imenu)
(global-set-key (kbd "<C-f5>")      'eval-buffer)
(global-set-key (kbd "C-f")         'forward-word)
(global-set-key (kbd "C-b")         'backward-word)
(global-set-key (kbd "M-f")         'forward-char)
(global-set-key (kbd "M-b")         'backward-char)
(define-key local-function-key-map "\033[73;5~" [(control return)])
(define-key local-function-key-map "\033[37;6~" [(control ?L)])
(define-key local-function-key-map "\033[46;5~" (kbd "C-."))
(define-key local-function-key-map "\033[44;5~" (kbd "C-,"))
(windmove-default-keybindings       'meta)

;; #HOOKS
;; -- clear whitespaces and untabify
(defun format-current-buffer()
  (indent-region (point-min) (point-max)))
(defun untabify-current-buffer()
  (if (not indent-tabs-mode)
      (untabify (point-min) (point-max)))
  nil)

(add-hook 'python-mode-hook 'jedi:setup)
;;(add-hook 'python-mode-hook 'jedi:ac-setup)
(setq jedi:coplete-on-dot t)
;; (add-hook 'before-save-hook 'format-current-buffer)
(add-hook 'before-save-hook 'untabify-current-buffer)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(defun custom-c-hook ()
  (c-set-style "gnu")
  (setq c-basic-offset 2)
  (setq tab-width 2)
  (setq indent-tabs-mode nil)
  (global-font-lock-mode t)
  (c-set-offset 'arglist-intro '++)
  (c-set-offset 'arglist-close 0)
  )

(add-hook 'c++-mode-hook 'custom-c-hook)
;; (add-hook 'c++-mode-hook
;;           (lambda ()
;;             (c-set-offset 'arglist-intro '+)
;;             (c-set-offset 'arglist-close 0) ))

(defun my-python-hook ()
  (setq tab-width 4)
  )
(add-hook 'python-mode-hook 'my-python-hook)
(defun web-mode-electric-pair-disable()
  (setq electric-pair-mode nil))
(add-hook 'web-mode-hook 'web-mode-electric-pair-disable)

;; #PLUGINS
(require 'auto-complete)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
;;pack neotree
;;(add-to-list 'load-path "~/.emacs.d/plugins/neotree")
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
;;pack yasnippet
(require 'yasnippet)
(yas-global-mode 1)
(setq yas/indent-line 'auto)
;;pack popup            ;; use popup menu for yas-choose-value

(require 'popup)
;;pack yafolding
;;(add-to-list 'load-path "~/.emacs.d/plugins_del/yafolding.el.dir")
;; (require 'yafolding)
;; (add-hook 'prog-mode-hook
;;           (lambda () (yafolding-mode)))
;; (add-hook 'web-mode-hook
;;           (lambda () (yafolding-mode)))

(require 'auto-complete-config)
(global-set-key (kbd "M-x") 'helm-M-x)

(require 'helm)
(require 'helm-config)

(helm-mode 1)


(ac-config-default)
;;(add-to-list 'load-path "~/.emacs.d/plugins/webmode")
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.html?\\'"      . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'"      . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'"  . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'"    . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'"    . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'"        . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
;;(add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
(setq web-mode-code-indent-offset 2)
(setq web-mode-markup-indent-offset 2)
;; add some shotcuts in popup menu mode
;; (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
;;(defi)
(define-key popup-menu-keymap (kbd "C-n") 'popup-next)
(define-key popup-menu-keymap (kbd "TAB") 'popup-next)
(define-key popup-menu-keymap (kbd "<tab>") 'popup-next)
(define-key popup-menu-keymap (kbd "<backtab>") 'popup-previous)
(define-key popup-menu-keymap (kbd "C-p") 'popup-previous)
;;
(defun yas-popup-isearch-prompt (prompt choices &optional display-fn)
  (when (featurep 'popup)
    (popup-menu*
     (mapcar
      (lambda (choice)
        (popup-make-item
         (or (and display-fn (funcall display-fn choice))
             choice)
         :value choice))
      choices)
     :prompt prompt
     ;; start isearch mode immediately
     :isearch t
     )))
(setq yas-prompt-functions '(yas-popup-isearch-prompt yas-ido-prompt yas-no-prompt))

;; THEME
;; (require 'apropospriate)
(load-theme 'apropospriate-dark t) ;;(load-theme 'zenburn t)

;; CUSTOM
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["black" "#d55e00" "#009e73" "#f8ec59" "#0072b2" "#cc79a7" "#56b4e9" "white"])
 '(beacon-color "#F8BBD0")
 '(company-quickhelp-color-background "#4F4F4F")
 '(company-quickhelp-color-foreground "#DCDCCC")
 '(custom-safe-themes
   (quote
    ("c3e6b52caa77cb09c049d3c973798bc64b5c43cc437d449eacf35b3e776bf85c" "70f5a47eb08fe7a4ccb88e2550d377ce085fedce81cf30c56e3077f95a2909f2" "a8c595a70865dae8c97c1c396ae9db1b959e86207d02371bc5168edac06897e6" "5a0eee1070a4fc64268f008a4c7abfda32d912118e080e18c3c865ef864d1bea" "40f6a7af0dfad67c0d4df2a1dd86175436d79fc69ea61614d668a635c2cd94ab" default)))
 '(evil-emacs-state-cursor (quote ("#D50000" hbar)))
 '(evil-insert-state-cursor (quote ("#D50000" bar)))
 '(evil-normal-state-cursor (quote ("#F57F17" box)))
 '(evil-visual-state-cursor (quote ("#559a58" box)))
 '(fci-rule-color "#383838")
 '(helm-mode t)
 '(highlight-indent-guides-auto-enabled nil)
 '(highlight-symbol-colors
   (quote
    ("#F57F17" "#559a58" "#0097A7" "#42A5F5" "#7E57C2" "#D84315")))
 '(highlight-symbol-foreground-color "#3f5a66")
 '(highlight-tail-colors (quote (("#F8BBD0" . 0) ("#f0f0f0" . 100))))
 '(nrepl-message-colors
   (quote
    ("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3")))
 '(org-agenda-files nil)
 '(package-selected-packages
   (quote
    (django-mode auto-yasnippet django-snippets ac-helm auto-compile jedi apropospriate-theme async helm-core popup nhexl-mode projectile helm zenburn-theme popup-complete yasnippet-snippets yasnippet-classic-snippets auto-complete web-mode yasnippet neotree ggtags htmlize lua-mode flymake-lua)))
 '(pdf-view-midnight-colors (quote ("#DCDCCC" . "#383838")))
 '(pos-tip-background-color "#f7aef7aef7ae")
 '(pos-tip-foreground-color "#78909C")
 '(safe-local-variable-values
   (quote
    ((eval when
           (require
            (quote rainbow-mode)
            nil t)
           (rainbow-mode 1))
     (engine . django))))
 '(tabbar-background-color "#fcccfcccfccc")
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   (quote
    ((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3"))))
 '(vc-annotate-very-old-color "#DC8CC3"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'scroll-left 'disabled nil)
