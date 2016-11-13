;; (add-to-list 'load-path "/Users/simon/dev/r/ess-15.09-1/lisp/")
;; (load "ess-site")

;;; Code:

(defun my-c-mode-common-hook ()
  ;; my customizations for all of c-mode and related modes
  (linum-mode)
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

(provide 'simon)
;;; simon.el ends here
