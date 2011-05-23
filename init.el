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
 '(py-pychecker-command "~/.emacs.d/pychecker.sh")
 '(py-pychecker-command-args (quote ("")))
 '(python-check-command "~/.emacs.d/pychecker.sh")
 '(show-paren-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#2e3436" :foreground "#eeeeec" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 98 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))

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

(require 'redspace-mode)
(redspace-mode)

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


(load-library "init_python.el")

(load-library "init_erlang.el")

(load-library "init_haskell.el")

(load-file "~/.emacs.d/cedet-1.0pre6/common/cedet.el")
(global-ede-mode 1)                      ; Enable the Project management system
(semantic-load-enable-code-helpers)      ; Enable prototype help and smart completion
(global-srecode-minor-mode 1)            ; Enable template insertion menu


(add-to-list 'load-path "~/.emacs.d/ecb-2.40/")
(require 'ecb)

(require 'erc)

(require 'org-install)
(setq jabber-account-list
    '(("vmenon@abextratech.com"
       (:network-server . "talk.google.com")
       (:connection-type . ssl))
       ("menonvikas@gmail.com"
       (:network-server . "talk.google.com")
       (:connection-type . ssl))))