(add-to-list 'load-path "~/.emacs.d/")
(require 'ido)
(require 'color-theme)
(require 'color-theme-tango)
(require 'erc)
(color-theme-tango)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-options-version "2.40")
 '(ido-enable-flex-matching t)
 '(ido-mode (quote both) nil (ido))
 '(initial-buffer-choice nil)
 '(py-shell-switch-buffers-on-execute nil)
 '(show-paren-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#2e3436" :foreground "#eeeeec" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 98 :width normal :foundry "unknown" :family "Monaco")))))

(require 'framemove)
(windmove-default-keybindings)
(setq framemove-hook-into-windmove t)

(setq inhibit-startup-message t)
(tool-bar-mode 0)

(global-set-key "\C-z" nil)
(setq c++-mode-hook
    (function (lambda ()
                (setq indent-tabs-mode nil)
                (setq c-indent-level 4))))

(show-paren-mode 1)
(setq show-paren-delay 0)
(transient-mark-mode t)

;; This is no longer required, since we now use ws-trim.el which autmatically trims any white spaces on the same line.
;;(require 'redspace-mode)
;;(redspace-mode)

(require 'rect-mark)
(global-set-key (kbd "C-x r C-SPC") 'rm-set-mark)
(global-set-key (kbd "C-x r C-x")   'rm-exchange-point-and-mark)
(global-set-key (kbd "C-x r C-w")   'rm-kill-region)
(global-set-key (kbd "C-x r M-w")   'rm-kill-ring-save)

(defun toggle-fullscreen (&optional f)
  (interactive)
  (let ((current-value (frame-parameter nil 'fullscreen)))
      (set-frame-parameter nil 'fullscreen
         (if (equal 'fullboth current-value)
             (if (boundp 'old-fullscreen) old-fullscreen nil)
                 (progn (setq old-fullscreen current-value)
                        'fullboth)))))
(global-set-key [f11] 'toggle-fullscreen)



(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
(ac-config-default)

(ansi-color-for-comint-mode-on)

;; jump to line no.
(global-set-key "\M-g" 'goto-line)


;;(load-library "init_python.el")
(autoload 'python-mode "init_python" nil t)

(autoload 'erlang-mode "init_erlang" nil t)

(autoload 'haskell-mode "init_haskell" nil t)

;; (load-file "~/.emacs.d/cedet-1.0pre6/common/cedet.el")
;; (global-ede-mode 1)                      ; Enable the Project management system
;; (semantic-load-enable-code-helpers)      ; Enable prototype help and smart completion
;; (global-srecode-minor-mode 1)            ; Enable template insertion menu


;; (add-to-list 'load-path "~/.emacs.d/ecb-2.40/")
;; (require 'ecb)

(require 'erc)

(setq jabber-account-list
    '(("vmenon@abextratech.com"
       (:network-server . "talk.google.com")
       (:connection-type . ssl))
       ("menonvikas@gmail.com"
       (:network-server . "talk.google.com")
       (:connection-type . ssl))))

(toggle-scroll-bar -1)
(menu-bar-mode -1)

;;;; ************************************************************************
;;;; *** strip trailing whitespace on write
;;;; ************************************************************************
;;;; ------------------------------------------------------------------------
;;;; --- ws-trim.el - [1.3] ftp://ftp.lysator.liu.se/pub/emacs/ws-trim.el
;;;; ------------------------------------------------------------------------
(require 'ws-trim)
(global-ws-trim-mode t)
(set-default 'ws-trim-level 2)
(setq ws-trim-global-modes '(guess (not message-mode eshell-mode)))
(add-hook 'ws-trim-method-hook 'joc-no-tabs-in-java-hook)

;; simpler implementation to delete trailing white spaces (but only before saving)
;;(add-hook 'before-save-hook 'delete-trailing-whitespace)

(defun joc-no-tabs-in-java-hook ()
  "WS-TRIM Hook to strip all tabs in Java mode only"
  (interactive)
  (if (string= major-mode "jde-mode")
      (ws-trim-tabs)))

;; Copy from clipboard
(setq x-select-enable-clipboard t)

;; Set to the location of your Org files on your local system
(setq org-directory "~/org")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/org/flagged.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/MobileOrg")

;; Adding header information
;;(add-hook 'emacs-lisp-mode-hook 'auto-make-header)

;; Adding google client
;; Download and make from http://emacspeak.googlecode.com/files/g-client.tar.bz2
(add-to-list 'load-path "~/.emacs.d/g-client/")
(load-library "g")

;Adding smart operator
(require 'smart-operator)

;Required per org manual. Needed for using org version 7.7
(require 'org-install)

;; This is required for browsing sites like gmail
(setq w3m-use-cookies t)

;; Show column numbers while viewing any files
(column-number-mode 1)

