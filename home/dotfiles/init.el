; -*- lexical-binding: t; -*-
;;; Code:
(eval-and-compile
  (setq use-package-expand-minimally t)
  (setq use-package-enable-imenu-support t)
  (setq use-package-hook-name-suffix nil))

(eval-when-compile
  (require 'use-package))

;; User setup

(setq user-full-name "Adarsh Amirtham"
      user-mail-address "adarsh@tarides.com")

;; ui

(use-package emacs
  :defer t
  :init
  (add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-12"))
  (setq custom-file "~/.config/emacs/custom.el")

  :custom
  ;; use UTF-8 by default
  (prefer-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-selection-coding-system 'utf-8)
  (set-file-name-coding-system 'utf-8)
  (set-clipboard-coding-system 'utf-8)
  (set-buffer-file-coding-system 'utf-8)

  (use-dialog-box nil)
  (use-file-dialog nil)
  (tooltip-mode nil)  (inhibit-startup-screen t)
  (initial-scratch-message nil)
  (inhibit-startup-echo-area-message t)
  (global-display-line-numbers-mode t)
  (menu-bar-mode nil)
  (tool-bar-mode nil)

  ;; use human-readable sizes in dired
  (setq-default dired-listing-switches "-alh")

  ;; life is too short to type yes or no
  (defalias 'yes-or-no-p 'y-or-n-p)

  ;; always highlight code
  (global-font-lock-mode 1)
  ;; refresh a buffer if changed on disk
  (global-auto-revert-mode 1)

  ;; highlight the current line
  (global-hl-line-mode))

(use-package scroll-bar
  :defer t
  :custom
  (scroll-bar-mode nil))

(use-package which-key
  :demand t
  :after evil
  :diminish which-key-mode
  :custom
  (which-key-allow-evil-operators t)
  (which-key-show-remaining-keys t)
  (which-key-sort-order 'which-key-prefix-then-key-order)
  :config (which-key-mode))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Enable global-visual-line-mode
(setq global-visual-line-mode t)

;; evil

(use-package evil
  ; :demand t causes the package to be loaded immediately
  :demand t
  :diminish evil-mode
  :custom
  (evil-want-Y-yank-to-eol t)
  (evil-want-integration t)
  (evil-want-keybinding nil)
  (evil-split-window-below t)
  (evil-vsplit-window-right t)
  (evil-echo-state nil)
  (evil-undo-system 'undo-redo)
  (evil-respect-visual-line-mode t)
  (evil-disable-insert-state-bindings t)
  (evil-want-C-d-scroll nil)
  (evil-want-C-u-scroll nil)
  (evil-want-C-w-delete t)
  (evil-want-keybindin)
  :hook
  (after-init-hook . evil-mode))

(use-package evil-collection
  :hook
  (evil-mode-hook . evil-collection-init))

(use-package evil-commentary
  :diminish evil-commentary-mode
  :hook
  (evil-mode-hook . evil-commentary-mode))

;; Use General for key bindings

(use-package general
  :demand t
  :config
  (general-evil-setup t)

  (general-create-definer leader-def
    :states '(normal motion emacs)
    :keymaps 'override
    :prefix "SPC"
    :non-normal-prefix "C-SPC")

  (general-create-definer localleader-def
    :states '(normal motion emacs)
    :keymaps 'override
    :prefix "SPC m"
    :non-normal-prefix "C-SPC m")

  (localleader-def "" '(:ignore t :wk "mode"))

  (leader-def
   :states 'normal
   "q q" 'save-buffers-kill-terminal
   "q r" 'restart-emacs
   "q f" 'delete-frame

   "w q" 'evil-window-delete
   "w h" 'evil-window-left
   "w j" 'evil-window-down
   "w k" 'evil-window-up
   "w l" 'evil-window-right
   "w m" 'delete-other-windows
   "w n" 'evil-window-new
   "w s" 'evil-window-split
   "w v" 'evil-window-vsplit

   "b b" 'counsel-switch-buffer
   "b d" 'kill-this-buffer
   "b p" 'previous-buffer
   "b n" 'next-buffer 

   ":" 'counsel-M-x

  "SPC" 'counsel-projectile-find-file
   "/" 'counsel-projectile-rg

   "f f" 'counsel-find-file
   "f r" 'counsel-recentf

   "o f" 'make-frame

   ;; org-roam
   "n i" 'org-roam-node-insert
   "n f" 'org-roam-node-find
   "n c" 'org-roam-capture))


;; Ivy and Counsel

(use-package ivy
  :demand t
  :diminish ivy-mode
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t))

(use-package counsel
  :demand t)

;; org-roam

(use-package org-roam
  :config
  (setq org-roam-directory (file-truename "~/meta/notes"))
  (org-roam-db-autosync-mode))

;; backups and autosaves

(use-package files
  :defer t
  :preface
  (defvar emacs-tmp-dir
    (expand-file-name "emacs" temporary-file-directory))

  (defvar autosave-tmp-dir
    (expand-file-name "autosave" emacs-tmp-dir))

  :custom
  (make-backup-files nil)
  (backup-by-copying t)
  (delete-old-versions t)
  (kept-old-versions 5)
  (kept-new-versions 5)
  (backup-directory-alist `(("." . ,emacs-tmp-dir)))
  (auto-save-default t)
  (auto-save-include-big-deletions t)
  (create-lockfiles nil)
  (auto-save-list-file-prefix autosave-tmp-dir))

;; Projectile

(use-package projectile
  :demand t
  :diminish projectile-mode
  :general
  (leader-def
   "p" `(:keymap projectile-command-map :package projectile))
  :init
  (projectile-mode +1))

(use-package counsel-projectile
  :demand t)

(use-package envrc
  :diminish envrc-mode
  :config (envrc-global-mode))

(use-package magit
  :commands magit
  :general
  (leader-def
   "g"  '(:ignore t :wk "git")
   "gs" '(magit :wk "git status")
   "gg" '(magit :wk "git status")))


;; OCaml

(use-package ocamlformat
  :custom (ocamlformat-enable 'enable-outside-detected-project)
  :hook (before-save-hook . ocamlformat-before-save))

(use-package merlin
  :general
  (localleader-def
    "l" 'merlin-locate
    "t" 'merlin-type-enclosing
    "d" 'merlin-document)
  :hook
  (tuareg-mode-hook . merlin-mode))

(use-package tuareg
  :mode
  ("\\.ml\\'" . tuareg-mode)
  ("\\.mli\\'" . tuareg-mode))

;; Scheme hacking

(use-package rainbow-delimiters
  :diminish rainbow-delimiters-mode
  :hook
  (emacs-lisp-mode-hook . rainbow-delimiters-mode)
  (scheme-mode-hook . rainbow-delimiters-mode)
  (lisp-interaction-mode-hook . rainbow-delimiters-mode)
  (lisp-data-mode-hook . rainbow-delimiters-mode))

(show-paren-mode 1)

(use-package smartparens
  :diminish smartparens-strict-mode
  :hook
  (emacs-lisp-mode-hook . smartparens-strict-mode)
  (scheme-mode-hook . smartparens-strict-mode)
  (lisp-interaction-mode-hook . smartparens-strict-mode)
  (lisp-data-mode-hook . smartparens-strict-mode)
  :config
  (sp-pair "`" nil :actions nil)
  (sp-pair "'" nil :actions nil))

(use-package lispyville
  :diminish lispyville-mode
  :hook
  (emacs-lisp-mode-hook . lispyville-mode)
  (scheme-mode-hook . lispyville-mode)
  (lisp-interaction-mode-hook . lispyville-mode)
  (lisp-data-mode-hook . lispyville-mode)
  :config
  (lispyville-set-key-theme '(operators additional slurp/barf-cp)))

(use-package geiser-mode
  :custom
  (geiser-active-implementations '(guile))
  :bind
  (:map geiser-mode-map
        ("C-c C-e" . geiser-eval-last-sexp))
  :general
  ('normal "C-c C-e" 'geiser-eval-last-sexp)
  ('normal "SPC m '" 'run-geiser))

;; Elisp

(use-package elisp-mode
  :general
  (localleader-def
    :keymaps 'emacs-lisp-mode-map
    :major-modes t
    "e" '(:ignore t :wk "eval")
    "ee" 'eval-defun
    "es" 'eval-last-sexp
    "eb" 'eval-buffer
    "er" 'eval-region))

;; YAML

(use-package yaml-mode)

;; PDF

(use-package pdf-tools
   :config
   (pdf-tools-install)
   (setq-default pdf-view-display-size 'fit-width))
