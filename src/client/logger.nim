#[
  logging system

  taken from my other projects
]#

import strutils, times

type Logger = object
    file:File

var loggers = newSeq[Logger]()

proc addLogger*(file:File) = 
    loggers.add Logger(file:file)

template log*(text: string, level: string) =
  let 
    logModule = instantiationInfo().filename
    logString = "[$#][$#] - [$#]: $#" % [getClockStr(), logModule, level, text]

  for logger in loggers:
     # Only print debug logs when debugging was defined during compilation
     # arguably should change to a toggleable setting, but I haven't figured out configs and whatnot
     # Given that it has to account for many things like:
      # - Handling newer or older versions of a config
      # - Handling invalid data in a config
      # - Default config settings
      # - Reading and writing configs
      # - etc
    if level == "debug" and defined(debugging):
      logger.file.writeLine logString
      logger.file.flushFile
    else:
      logger.file.writeLine logString
      logger.file.flushFile