import ../contexts
import strutils
import tables
import time

proc prettyReport*(context: GlobalContext) =
    echo "nimb report"

    for task in context.tasks.values:
        if task.skipped:
            continue

        echo task.caption.indent(1, "\t")
        for line in task.info:
            echo line.indent(2, "\t")

        if task.warn.len > 0:
            echo "warnings: $1".indent(2, "\t") % [$task.warn.len]
            for line in task.warn:
                echo line.indent(3, "\t")

        if task.err.len > 0:
            echo "errors: $1".indent(2, "\t") % [$task.err.len]
            for line in task.err:
                echo line.indent(3, "\t")

    echo "executed tasks:"
    for task in context.tasks.values:
        if  task.skipped:
            continue
        let taskTiming = float(task.timing) * 0.001        
        let taskTimingStr = "$1 ms" % [$taskTiming]
        let line = "$1 $2" % [task.caption, taskTimingStr]
        echo line.indent(1, "\t")

    let globalTiming = float(context.timing) * 0.001
    echo "nimb done in $1 ms" % [$globalTiming]
