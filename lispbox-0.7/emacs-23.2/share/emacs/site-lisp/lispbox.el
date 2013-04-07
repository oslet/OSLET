(require 'cl)

(defun lispbox-list-to-filename (list)
  (apply 
   #'concat 
   (maplist
    #'(lambda (cons)
        (if (cdr cons) (file-name-as-directory (car cons)) (car cons)))
    list)))

(defun lispbox-file (rest)
  (concat 
   (file-name-as-directory
    (expand-file-name
     (or (getenv "LISPBOX_HOME")
         (file-name-directory load-file-name))))
   rest))

(defun lispbox-find-lisps ()
  (dolist (file (file-expand-wildcards (lispbox-file "*/lispbox-register.el")))
    (load file)))

(defun lispbox-install-lisp-license (license-path lisp-name)
  (let ((license (concat (file-name-directory load-file-name) (lispbox-list-to-filename license-path))))
    (if (not (file-exists-p license))
      (let* ((prompt (format "Need to install license for %s . Please enter name of file where you saved it: " lisp-name))
             (to-install (read-file-name prompt)))
        (copy-file (expand-file-name to-install) license)))))

(global-font-lock-mode t)

(setq load-path (cons (lispbox-file "slime-20110205.092829") load-path))
(setenv "SBCL_HOME" (lispbox-file "sbcl-1.0.42/lib/sbcl"))
(setenv "CCL_DEFAULT_DIRECTORY" (lispbox-file "ccl-1.6-linuxx86"))
(require 'slime)
(slime-setup '(slime-fancy slime-asdf slime-banner))
(lispbox-find-lisps)

(provide 'lispbox)

;;custom
(add-to-list 'load-path "~/oslet/lispbox-0.7/emacs-23.2/share/emacs/site-lisp/custom")
(load "custom.el")
;; 启动Emacs的时候最大化Emacs
;;(require 'maxframe-settings)
;; 最大化
;; 实现全屏效果，快捷键为f11
(global-set-key [f11] 'my-fullscreen) 
(defun my-fullscreen ()
(interactive)
(x-send-client-message
nil 0 nil "_NET_WM_STATE" 32
'(2 "_NET_WM_STATE_FULLSCREEN" 0))
)
;; 最大化
(defun my-maximized ()
(interactive)
(x-send-client-message
nil 0 nil "_NET_WM_STATE" 32
'(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0))
(x-send-client-message
nil 0 nil "_NET_WM_STATE" 32
'(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
)
;; 启动emacs时窗口最大化
(my-maximized)
