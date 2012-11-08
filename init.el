(add-to-list 'load-path "~/.emacs.d/pymacs-0.25/")
(add-to-list 'load-path "~/.emacs.d/init_scripts/")
(add-to-list 'load-path "~/.emacs.d/ensime/elisp/")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#ad7fa8" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes (quote (deeper-blue)))
 '(ido-enable-flex-matching t)
 '(ido-mode (quote both) nil (ido))
 '(inhibit-startup-screen t)
 '(initial-buffer-choice nil)
 '(py-shell-name "ipython")
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(describe-char-unicodedata-file "~/.emacs.d/UnicodeData.txt")
 '(unicodedata-file "~/.emacs.d/UnicodeDataFull.txt")
)
(set-face-attribute 'default nil :font "Consolas-13")

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/package.el"))
  (package-initialize))

(load "package")

(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'ctrl
      mac-option-modifier 'none)

(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-option-modifier 'meta)

(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

(require 'ido)
(require 'rect-mark)

(global-set-key (kbd "C-x r C-SPC") 'rm-set-mark)
(global-set-key (kbd "C-x r C-x")   'rm-exchange-point-and-mark)
(global-set-key (kbd "C-x r C-w")   'rm-kill-region)
(global-set-key (kbd "C-x r M-w")   'rm-kill-ring-save)

(autoload 'python-mode "init_python" nil t)
(add-hook 'python-mode 'pretty-lambda)
(autoload 'haskell-mode "init_haskell" nil t)
(autoload 'scala-mode "init_scala" nil t)

