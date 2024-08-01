;; install smex 
(menu-bar-mode 0)
(tool-bar-mode 0)
(setq inhibit-splash-screen t) 
(set-frame-font "Ubuntu Mono 17")
(ido-mode 1) ; for navigation
;; (setq make-backup-files nil) ; stop creating ~ files
(setq backup-directory-alist            '((".*" . "~/.Trash")))
(setq-default tab-width 2)
(setq tab-width 2)



(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)


(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)
(global-set-key (kbd "C-`") 'other-window)


;; ---------- GOLANG programming  ---------
;; (add-hook 'go-mode-hook 'lsp-deferred)

;; ;; Company mode
;; (setq company-idle-delay 0)
;; (setq company-minimum-prefix-length 1)

;; ;; Go - lsp-mode
;; ;; Set up before-save hooks to format buffer and add/delete imports.
;; (defun lsp-go-install-save-hooks ()
;;   (add-hook 'before-save-hook #'lsp-format-buffer t t)
;;   (add-hook 'before-save-hook #'lsp-organize-imports t t))
;; (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; ;; Start LSP Mode and YASnippet mode
;; (add-hook 'go-mode-hook #'lsp-deferred)
;; (add-hook 'go-mode-hook #'yas-minor-mode)
;; ---------- end GOLANG programming  ---------



;; ---------- SCALA programming  ---------


(package-initialize)

;; Install use-package if not already installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)

;; Enable defer and ensure by default for use-package
;; Keep auto-save/backup files separate from source code:  https://github.com/scalameta/metals/issues/1027
(setq use-package-always-defer t
      use-package-always-ensure t
      backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; ;; Enable scala-mode for highlighting, indentation and motion commands
;; (use-package scala-mode
;;   :interpreter ("scala" . scala-mode))

;; ;; Enable sbt mode for executing sbt commands
;; (use-package sbt-mode
;;   :commands sbt-start sbt-command
;;   :config
;;   ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
;;   ;; allows using SPACE when in the minibuffer
;;   (substitute-key-definition
;;    'minibuffer-complete-word
;;    'self-insert-command
;;    minibuffer-local-completion-map)
;;    ;; sbt-supershell kills sbt-mode:  https://github.com/hvesalai/emacs-sbt-mode/issues/152
;;    (setq sbt:program-options '("-Dsbt.supershell=false")))



;; ;; Enable nice rendering of diagnostics like compile errors.
;; (use-package flycheck
;;   :init (global-flycheck-mode))

;; (use-package lsp-mode
;;   ;; Optional - enable lsp-mode automatically in scala files
;;   ;; You could also swap out lsp for lsp-deffered in order to defer loading
;;   :hook  (scala-mode . lsp)
;;          (lsp-mode . lsp-lens-mode)
;;   :config
;;   ;; Uncomment following section if you would like to tune lsp-mode performance according to
;;   ;; https://emacs-lsp.github.io/lsp-mode/page/performance/
;;   ;; (setq gc-cons-threshold 100000000) ;; 100mb
;;   ;; (setq read-process-output-max (* 1024 1024)) ;; 1mb
;;   ;; (setq lsp-idle-delay 0.500)
;;   ;; (setq lsp-log-io nil)
;;   ;; (setq lsp-completion-provider :capf)
;;   (setq lsp-prefer-flymake nil)
;;   ;; Makes LSP shutdown the metals server when all buffers in the project are closed.
;;   ;; https://emacs-lsp.github.io/lsp-mode/page/settings/mode/#lsp-keep-workspace-alive
;;   (setq lsp-keep-workspace-alive nil))

;; ;; Add metals backend for lsp-mode
;; (use-package lsp-metals)

;; ;; Enable nice rendering of documentation on hover
;; ;;   Warning: on some systems this package can reduce your emacs responsiveness significally.
;; ;;   (See: https://emacs-lsp.github.io/lsp-mode/page/performance/)
;; ;;   In that case you have to not only disable this but also remove from the packages since
;; ;;   lsp-mode can activate it automatically.
;; (use-package lsp-ui)

;; ;; lsp-mode supports snippets, but in order for them to work you need to use yasnippet
;; ;; If you don't want to use snippets set lsp-enable-snippet to nil in your lsp-mode settings
;; ;; to avoid odd behavior with snippets and indentation
;; (use-package yasnippet)

;; ;; Use company-capf as a completion provider.
;; ;;
;; ;; To Company-lsp users:
;; ;;   Company-lsp is no longer maintained and has been removed from MELPA.
;; ;;   Please migrate to company-capf.
;; (use-package company
;;   :hook (scala-mode . company-mode)
;;   :config
;;   (setq lsp-completion-provider :capf))

;; ;; Posframe is a pop-up tool that must be manually installed for dap-mode
;; (use-package posframe)

;; ;; Use the Debug Adapter Protocol for running tests and debugging
;; (use-package dap-mode
;;   :hook
;;   (lsp-mode . dap-mode)
;;   (lsp-mode . dap-ui-mode))



(defun my-newline-and-indent ()
  "Run `newline' and `indent-relative' in sequence."
  (interactive)
  (newline)
  (indent-relative))

(defun my-space ()
	"Print space and do nothing else"
	(interactive)
	(insert " "))

(add-hook 'scala-mode-hook
					(lambda () (local-set-key (kbd "RET")  'my-newline-and-indent )))

(add-hook 'scala-mode-hook
					(lambda () (local-set-key (kbd "SPC")  'my-space )))


(add-to-list 'load-path "~/my/prog/scala/emacs-scala-mode/")
(load "scala-mode.el")

;; ---------- end SCALA programming  ---------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
	 [default default default italic underline success warning error])
 '(ansi-color-names-vector
	 ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes '(misterioso))
 '(ispell-dictionary nil)
 '(package-selected-packages '(haskell-mode use-package smex)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
