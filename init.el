(add-to-list 'load-path "~/.emacs.d/")
(require 'ido)
(require 'color-theme)
(require 'color-theme-tango)
(color-theme-tango)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
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

;; set ipython as the default python shell. 
(setq ipython-command "/usr/bin/ipython")
(require 'ipython)

(require 'python-mode)
(autoload 'python-mode "python-mode" "Python Mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))

(require 'rect-mark)
(global-set-key (kbd "C-x r C-SPC") 'rm-set-mark)
(global-set-key (kbd "C-x r C-x")   'rm-exchange-point-and-mark)
(global-set-key (kbd "C-x r C-w")   'rm-kill-region)
(global-set-key (kbd "C-x r M-w")   'rm-kill-ring-save)


(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
(ac-config-default)

(ansi-color-for-comint-mode-on)

(font-lock-add-keywords
 'python-mode
 '(("^[^\n]\\{80\\}\\(.*\\)$"
    1 font-lock-warning-face prepend)))

;; jump to line no.
(global-set-key "\M-g" 'goto-line)


(defun django-shell (&optional argprompt)
  (interactive "P")
  ;; Set the default shell if not already set
  (labels ((read-django-project-dir 
        (prompt dir)
        (let* ((dir (read-directory-name prompt dir))
               (manage (expand-file-name (concat dir "manage.py"))))
          (if (file-exists-p manage)
              (expand-file-name dir)
            (progn
              (message "%s is not a Django project directory" manage)
              (sleep-for .5)
              (read-django-project-dir prompt dir))))))
(let* ((dir (read-django-project-dir 
             "project directory: " 
             default-directory))
       (project-name (first 
                      (remove-if (lambda (s) (or (string= "src" s) (string= "" s))) 
                                 (reverse (split-string dir "/")))))
       (buffer-name (format "django-%s" project-name))
       (manage (concat dir "manage.py")))
  (cd dir)
  (if (not (equal (buffer-name) buffer-name))
      (switch-to-buffer-other-window
       (apply 'make-comint buffer-name manage nil '("shell")))
    (apply 'make-comint buffer-name manage nil '("shell")))
  (make-local-variable 'comint-prompt-regexp)
  (setq comint-prompt-regexp (concat py-shell-input-prompt-1-regexp "\\|"
                                     py-shell-input-prompt-2-regexp "\\|"
                                     "^([Pp]db) "))
  (add-hook 'comint-output-filter-functions
            'py-comint-output-filter-function)
  ;; pdbtrack

  (add-hook 'comint-output-filter-functions 'py-pdbtrack-track-stack-file)
  (setq py-pdbtrack-do-tracking-p t)
  (set-syntax-table py-mode-syntax-table)
  (use-local-map py-shell-map)
  ;;making changes
  (setenv "DJANGO_SETTINGS_MODULE" "settings")
  ;;(setenv "PYTHONPATH" default-directory)
  ;;end of changes
  (run-hooks 'py-shell-hook))))


(load-library "init_python.el")

