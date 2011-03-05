;;;;;
;************************************************
; rgr-python.el
;
; python integration
; Richard Riley.
; http://richardriley.net/default/projects/emacs/
;************************************************

;; Notes : python in emacs is a mess. the official python.el seems
;; flakey to say the least and there is little if any concensus on
;; what to use.  I tried to revert to using the officical python.el
;; but (a) could not load iPython without moving it to an autoload
;; and (b) the interpreter didn't work.


(autoload 'python-mode "python-mode" "Python Mode." t)
 (add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
 (add-to-list 'interpreter-mode-alist '("python" . python-mode))

;; (require 'python)

(setq load-path
      (append (list nil
                    "~/.emacs.d/lisp/pymacs/"
                    "~/.emacs.d/lisp/pysmell/"
                    "~/.emacs.d/lisp/pylint/elisp/"
                    "~/.emacs.d/lisp/python-mode/"
                    )
              load-path))


(require 'pymacs)

(when (load "flymake" t)
  (defun flymake-pycheckers-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "pycheckers"  (list local-file)))))


(add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pycheckers-init))

(require 'ipython)
(setq python-python-command "ipython")
(setq py-python-command-args '( "-colors" "Linux"))

;; (pymacs-load "ropemacs" "rope-")
(setq ropemacs-confirm-saving nil
      ropemacs-guess-project t
      ropemacs-enable-autoimport t
      )


(add-hook 'python-mode-hook 
          (lambda () 
            (unless (eq buffer-file-name nil) (flymake-mode 1)) ;dont invoke flymake on temporary buffers for the interpreter
            (local-set-key [f2] 'flymake-goto-prev-error)
            (local-set-key [f3] 'flymake-goto-next-error)
            ))

(require 'anything-ipython)
 (add-hook 'python-mode-hook #'(lambda ()
                                 (define-key py-mode-map (kbd "M-<tab>") 'anything-ipython-complete)))
 (add-hook 'ipython-shell-hook #'(lambda ()
                                   (define-key py-mode-map (kbd "M-<tab>") 'anything-ipython-complete)))


(provide 'rgr-python)