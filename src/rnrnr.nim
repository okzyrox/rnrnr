import client/[main, logger]

when isMainModule:
  logger.addLogger(stdout)
  logger.addLogger(open("rnrnr.log", fmWrite))

  log("Starting rnrnr", "info")
  runClient()

  log("Closing...", "info")
