import tables

type TaskContext* = ref object  
  caption*: string
  timing*: int64
  info*: seq[string]
  warn*: seq[string]
  err*: seq[string]
  skipped*: bool

type GlobalContext* = ref object
  stop*:bool
  timing*: int64
  tasks*: OrderedTable[string, TaskContext]
  completed*: OrderedTable[string, TaskContext]

var
  context = GlobalContext()

context.tasks = initOrderedTable[string, TaskContext]()

proc globalContext*(): GlobalContext =
  return context

proc getOrAddContext*(name: string): var TaskContext =
  if not context.tasks.contains(name):
    let newContext = TaskContext(caption: name, info: @[], err: @[], skipped: true)
    context.tasks.add(name, newContext)
  return context.tasks[name]