(setq gc-cons-threshold 100000000)
(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold 800000)))

(setq package-check-signature nil)

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu"   . "https://elpa.gnu.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t)

(setq inhibit-startup-screen t
      inhibit-startup-echo-area-message t
      initial-scratch-message nil)

(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(global-display-line-numbers-mode t)
(set-face-attribute 'line-number nil :foreground "#555")

(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

(use-package doom-themes
  :config
  (load-theme 'doom-tokyo-night t)
  (custom-set-faces
   '(font-lock-comment-face ((t (:foreground "#eeeeee" :italic t))))
   '(font-lock-keyword-face ((t (:foreground "#c678dd" :bold t))))
   '(font-lock-string-face ((t (:foreground "#98be65"))))))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom (doom-modeline-height 22))

(use-package evil
  :init (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  (setq evil-default-state 'normal))

(use-package evil-terminal-cursor-changer
  :config (evil-terminal-cursor-changer-activate))

(use-package sr-speedbar
  :defer t
  :config
  (setq sr-speedbar-width 30
        sr-speedbar-right-side nil
        sr-speedbar-skip-other-window-p nil
        speedbar-show-unknown-files t
        speedbar-use-images nil))

(defun my/file-explorer-toggle ()
  "Use: Toggle"
  (interactive)
  (require 'sr-speedbar)
  (sr-speedbar-toggle)
  (run-with-timer 0.02 nil
                  (lambda ()
                    (let ((speedbar-win (get-buffer-window " SPEEDBAR")))
                      (if speedbar-win
                          (select-window speedbar-win)
                        (let ((speedbar-win-alt (get-buffer-window "*SPEEDBAR*")))
                          (when speedbar-win-alt
                            (select-window speedbar-win-alt))))))))

(global-unset-key (kbd "<f3>"))
(global-set-key (kbd "<f3>") 'my/file-explorer-toggle)

(with-eval-after-load 'evil
  (evil-define-key 'normal 'global (kbd "SPC e") 'my/file-explorer-toggle))

(with-eval-after-load 'speedbar
  (evil-set-initial-state 'speedbar-mode 'motion)
  (evil-define-key 'motion speedbar-mode-map (kbd "RET") 'speedbar-edit-line)
  (evil-define-key 'normal speedbar-mode-map (kbd "RET") 'speedbar-edit-line)
  (evil-define-key 'motion speedbar-mode-map (kbd "C-m") 'speedbar-edit-line)
  (evil-define-key 'normal speedbar-mode-map (kbd "C-m") 'speedbar-edit-line)

  (evil-define-key 'motion speedbar-mode-map (kbd "u") 'speedbar-up-directory)
  (evil-define-key 'normal speedbar-mode-map (kbd "u") 'speedbar-up-directory)
  (evil-define-key 'motion speedbar-mode-map (kbd ".") 'speedbar-up-directory)
  (evil-define-key 'normal speedbar-mode-map (kbd ".") 'speedbar-up-directory)
  (evil-define-key 'motion speedbar-mode-map (kbd "-") 'speedbar-up-directory)
  (evil-define-key 'normal speedbar-mode-map (kbd "-") 'speedbar-up-directory))

(use-package cc-mode
  :ensure nil
  :config
  (add-to-list 'auto-mode-alist '("\\.c\\'" . c-mode))
  (add-to-list 'auto-mode-alist '("\\.h\\'" . c-mode))
  (add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-mode)))

(use-package rust-mode
  :config (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode)))

(use-package python-mode
  :config (add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode)))

(use-package typescript-mode
  :config (add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode)))

(use-package js
  :ensure nil
  :config (add-to-list 'auto-mode-alist '("\\.js\\'" . js-mode)))

(use-package markdown-mode :defer t)
(use-package logview :defer t)

(setq gdb-many-windows t
      gdb-show-main t)

(xterm-mouse-mode 1)

(define-key key-translation-map (kbd "ESC") (kbd "C-g"))

(with-eval-after-load 'evil
  (define-key evil-insert-state-map [escape] 'evil-normal-state)
  (setq evil-esc-delay 0))
