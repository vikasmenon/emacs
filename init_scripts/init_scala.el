;; Load the ensime lisp code...
(push "~/scala/scala-2.9.2/bin/" exec-path)
(push "~/sbt/bin/" exec-path)
(require 'scala-mode)
(require 'ensime)

;; This step causes the ensime-mode to be started whenever
;; scala-mode is started for a buffer. You may have to customize this step
;; if you're not using the standard scala mode.
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)
