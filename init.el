;;; package --- Summary
;;; Commentary: minimal version of my configuration
;;; emacs-init.el --- Kin Chang's Emacs init file.
;;      ___           ___           ___           ___           ___           ___
;;     /  /\         /  /\         /__/\         /__/\         /  /\         /__/\          ___
;;    /  /:/        /  /::\       |  |::\       |  |::\       /  /:/_        \  \:\        /  /\
;;   /  /:/        /  /:/\:\      |  |:|:\      |  |:|:\     /  /:/ /\        \  \:\      /  /:/
;;  /  /:/  ___   /  /:/  \:\   __|__|:|\:\   __|__|:|\:\   /  /:/ /:/_   _____\__\:\    /  /:/
;; /__/:/  /  /\ /__/:/ \__\:\ /__/::::| \:\ /__/::::| \:\ /__/:/ /:/ /\ /__/::::::::\  /  /::\
;; \  \:\ /  /:/ \  \:\ /  /:/ \  \:\~~\__\/ \  \:\~~\__\/ \  \:\/:/ /:/ \  \:\~~\~~\/ /__/:/\:\
;;  \  \:\  /:/   \  \:\  /:/   \  \:\        \  \:\        \  \::/ /:/   \  \:\  ~~~  \__\/  \:\
;;   \  \:\/:/     \  \:\/:/     \  \:\        \  \:\        \  \:\/:/     \  \:\           \  \:\
;;    \  \::/       \  \::/       \  \:\        \  \:\        \  \::/       \  \:\           \__\/
;;     \__\/         \__\/         \__\/         \__\/         \__\/         \__\/
;;; Code:
;;      ___           ___          _____          ___
;;     /  /\         /  /\        /  /::\        /  /\
;;    /  /:/        /  /::\      /  /:/\:\      /  /:/_
;;   /  /:/        /  /:/\:\    /  /:/  \:\    /  /:/ /\
;;  /  /:/  ___   /  /:/  \:\  /__/:/ \__\:|  /  /:/ /:/_
;; /__/:/  /  /\ /__/:/ \__\:\ \  \:\ /  /:/ /__/:/ /:/ /\
;; \  \:\ /  /:/ \  \:\ /  /:/  \  \:\  /:/  \  \:\/:/ /:/
;;  \  \:\  /:/   \  \:\  /:/    \  \:\/:/    \  \::/ /:/
;;   \  \:\/:/     \  \:\/:/      \  \::/      \  \:\/:/
;;    \  \::/       \  \::/        \__\/        \  \::/
;;     \__\/         \__\/                       \__\/
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)

;; ===================================================
;; Usepackage Configure below
;; ===================================================
(use-package exec-path-from-shell
   :if (memq window-system '(mac ns))
   :config
   (exec-path-from-shell-initialize)
   (toggle-frame-maximized))

;; ===================================================
;; BASIC UTILITIES
;; ===================================================
;; (use-package linum-relative
;;   :config
;;   (linum-relative-global-mode)
;;   )
(use-package org :ensure org-plus-contrib :pin org)
(use-package color-theme-sanityinc-tomorrow)
(use-package evil
  :config
  (defalias 'evil-insert-state 'evil-emacs-state)
  :bind ("M-i" . evil-normal-state)
  )
(use-package helm
  :bind (("M-x" . helm-M-x)
;;	 ("C-x r b" . helm-filtered-bookmarks);;
;;	 ("C-x C-f" . helm-find-files)
;;	 ("C-x b" . helm-mini)
	 )
  :config
  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
  (setq helm-autoresize-max-height 0)
  (setq helm-autoresize-min-height 20)
  (helm-autoresize-mode 1)
  (helm-mode 1)
  (setq helm-mini-default-sources '(helm-source-buffers-list
                                  helm-source-recentf
                                  helm-source-bookmarks
                                  helm-source-buffer-not-found))
  (recentf-mode 1)
  )
(use-package company
  :config
  (add-hook 'after-init-hook 'global-company-mode)  
  (use-package company-auctex)  
  (use-package company-tern
    :config
    (add-to-list 'company-backends 'company-tern)
    )
  (company-auctex-init)
  )
(use-package key-chord
  :config
  (key-chord-mode 1)
  )
(use-package multiple-cursors
  :bind (("C->" . mc/mark-next-like-this)
	 ("C-<" . mc/mark-all-like-this)
	 )
  )
(use-package magit
  :bind (("C-x g" . magit-status))
  )
;; (use-package flycheck
;;   :config
;;   (global-flycheck-mode)
;;   )
(use-package projectile
  :config
  (projectile-mode)
  (setq projectile-mode-line
        '(:eval (format " Projectile[%s]"
                        (projectile-project-name))))
  )
(use-package tramp
  :config
  (custom-set-variables
   '(tramp-default-method "ssh" nil (tramp))
   '(tramp-default-user "kinc" nil (tramp))
   '(tramp-default-host "192.241.224.44" nil (tramp)))
  )
;; ===================================================
;; HOOKING UTILITIES
;; ===================================================
(use-package ggtags
  :hook ((js-mode python-mode c++-mode) . ggtags-mode)
  )
;; (use-package flyspell
;;   :hook ((org-mode) . flyspell-mode)
;;   )
(use-package yasnippet
  :config
  (yas-reload-all)
  :hook ((python-mode c-mode c++-mode) . yas-minor-mode)
  )
(use-package smartparens
  :config
  (show-smartparens-global-mode)
  :hook ((js-mode python-mode c++-mode TeX-mode) . smartparens-mode)
  )
;; ===================================================
;; WEB DEVELPMENT
;; ===================================================
(use-package js2-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
  (add-to-list 'interpreter-mode-alist '("node" . js2-mode))
  :hook  ((js2-mode . js2-refactor-mode)
	  (js2-mode . tern-mode)
	  )
  )
(use-package js2-refactor
  :config
  (js2r-add-keybindings-with-prefix "C-c C-r")
  )

(use-package web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.ejs?\\'" . web-mode))
  )
;; ===================================================
;; PYTHON
;; ===================================================

(use-package elpy
  :config
  (elpy-enable)
  (setq python-shell-interpreter "jupyter"
      python-shell-interpreter-args "console --simple-prompt")
  )
;; ===================================================
;; REVEAL.JS
;; ===================================================
;; (use-package ox-reveal
;;   )
;; ===================================================
;; Esv Mode
;; ===================================================
;; (load "~/.emacs.d/esv.el")
;; (require 'esv)
;; (use-package osx-dictionary
;;   :config
;;   (global-set-key (kbd "C-c d") 'osx-dictionary-search-word-at-point)
;;   )

;; ===================================================
;; LaTeX
;; ===================================================
;; (use-package tex
;;   :ensure auctex
;;   )
;; (use-package pdf-tools
;;   :config
;;   (pdf-tools-install)
;;   )
;; (use-package auctex-latexmk
;;   :config
;;   (auctex-latexmk-setup)
;;   (add-hook 'TeX-after-compilation-finished-functions 'TeX-revert-document-buffer)
;;   (add-hook 'TeX-mode-hook '(lambda () (pdf-tools-install)))  
;;   (add-hook 'TeX-mode-hook '(lambda () (setq TeX-command-Show "LatexMk")))
;;   (add-hook 'TeX-mode-hook '(lambda () (setq TeX-command-default "LatexMk")))
  
;;   (setq TeX-view-program-selection '((output-pdf "pdf-tools"))
;;   	TeX-source-correlate-start-server t)
;;   (setq TeX-source-correlate-mode t)
;;   (setq TeX-view-program-list '(("pdf-tools" "TeX-pdf-tools-sync-view")))
;;   (setq auctex-latexmk-inherit-TeX-PDF-mode t)
;;   )
;; ===================================================
;; BackUp Code
;; ===================================================
;; (use-package org
;;   :config
;;   (setq org-directory "~/Dropbox/org")
;;   (setq org-mobile-inbox-for-pull "~/Dropbox/org/inbox.org")
;;   (setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
;;   (setq org-mobile-files '("~/Dropbox/org"))
;;   (setq org-mobile-force-id-on-agenda-items nil)
;; )
;; (use-package doom-themes
;;   :config
;;   (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
;; 	doom-themes-enable-italic t) ; if nil, italics is universally disabled
;;   (load-theme 'doom-one t)
;;   (doom-themes-visual-bell-config)
;;   (doom-themes-neotree-config)  ; all-the-icons fonts must be installed!
;;   (doom-themes-org-config)
;;   )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#373b41" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#b294bb" "#8abeb7" "#c5c8c6"))
 '(beacon-color "#cc6666")
 '(custom-enabled-themes (quote (sanityinc-tomorrow-bright)))
 '(custom-safe-themes
   (quote
    ("82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" default)))
 '(esv-key "c3b0d636e138cd80cff4b2f2f055a70cb9fb3fb9")
 '(fci-rule-color "#373b41")
 '(flycheck-color-mode-line-face-to-color (quote mode-line-buffer-id))
 '(package-selected-packages
   (quote
    (osx-dictionary htmlize ox-reveal magit esup smartparens yasnippet projectile flycheck multiple-cursors company ggtags expand-region evil color-theme-sanityinc-tomorrow auctex-latexmk auctex exec-path-from-shell use-package)))
 '(pdf-view-incompatible-modes nil)
 '(tramp-default-host "192.241.224.44" nil (tramp))
 '(tramp-default-method "ssh" nil (tramp))
 '(tramp-default-user "kinc" nil (tramp))
 '(vc-annotate-background nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#cc6666")
     (40 . "#de935f")
     (60 . "#f0c674")
     (80 . "#b5bd68")
     (100 . "#8abeb7")
     (120 . "#81a2be")
     (140 . "#b294bb")
     (160 . "#cc6666")
     (180 . "#de935f")
     (200 . "#f0c674")
     (220 . "#b5bd68")
     (240 . "#8abeb7")
     (260 . "#81a2be")
     (280 . "#b294bb")
     (300 . "#cc6666")
     (320 . "#de935f")
     (340 . "#f0c674")
     (360 . "#b5bd68"))))
 '(vc-annotate-very-old-color nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
