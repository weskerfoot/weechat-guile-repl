(weechat:register "GuileREPL" "wes" "0.1" "None" "Guile REPL" "" "")

(define (displayln str)
  (weechat:print buffer str))

(define (exec code)
  (let ((mod (resolve-module '(srfi srfi-1))))
    (module-use! mod
                 (interaction-environment))
    (catch #t
           (lambda ()
             (weechat:print buffer
                          (format "~a"
                            (eval-string code mod))))
           (lambda (key . parameters)
             (weechat:print buffer (format "~a:~{~a ~}" key parameters))))))

(define (repl-input data buffer input-data)
              (exec input-data)
  weechat:WEECHAT_RC_OK)

(define (repl-close data buffer)
  weechat:WEECHAT_RC_OK)

(define buffer
  (weechat:buffer_new
    "Guile REPL"
    "repl-input"
    ""
    "repl-close"
    ""))

(weechat:buffer_set
  buffer
  "title"
  "Guile REPL")

(weechat:buffer_set
  buffer
  "localvar_set_no_log" "1")

