import json
import logger

type ClientSettings* = object
    windowWidth*: int
    windowHeight*: int
    maxFPS*: int
    exitOnEsc*: bool
    debug*: bool

    version*: int

const SettingsVersion = 1

var defaultSettings* = ClientSettings(
    windowWidth: 1280,
    windowHeight: 720,
    maxFPS: 60,
    exitOnEsc: false,
    debug: false,

    version: SettingsVersion
)

proc updateSettings(settings: ClientSettings): ClientSettings =
    var updatedSettings = settings

    log("Updating settings to newer version", "debug")

    if settings.windowWidth == 0: updatedSettings.windowWidth = defaultSettings.windowWidth
    if settings.windowHeight == 0: updatedSettings.windowHeight = defaultSettings.windowHeight
    if settings.maxFPS == 0: updatedSettings.maxFPS = defaultSettings.maxFPS
    if not settings.exitOnEsc: updatedSettings.exitOnEsc = defaultSettings.exitOnEsc
    if not settings.debug: updatedSettings.debug = defaultSettings.debug
    
    updatedSettings.version = SettingsVersion

    return updatedSettings

proc loadSettings*(filename: string): ClientSettings =
    var settings = open(filename, fmRead)
    defer: settings.close()

    var settingsJson = parseJson(settings.readAll())

    var loadedSettings = defaultSettings

    log("Loading settings", "debug")

    if "windowWidth" in settingsJson: loadedSettings.windowWidth = settingsJson["windowWidth"].getInt()
    if "windowHeight" in settingsJson: loadedSettings.windowHeight = settingsJson["windowHeight"].getInt()
    if "maxFPS" in settingsJson: loadedSettings.maxFPS = settingsJson["maxFPS"].getInt()
    if "exitOnEsc" in settingsJson: loadedSettings.exitOnEsc = settingsJson["exitOnEsc"].getBool()
    if "debug" in settingsJson: loadedSettings.debug = settingsJson["debug"].getBool()
    if "version" notin settingsJson: loadedSettings = updateSettings(loadedSettings)

    if settingsJson["version"].getInt() != SettingsVersion:
        loadedSettings = updateSettings(loadedSettings)

    return loadedSettings

proc saveSettings*(settings: ClientSettings, filename: string) =
    var settingsJson = %*{
        "windowWidth": settings.windowWidth,
        "windowHeight": settings.windowHeight,
        "maxFPS": settings.maxFPS,
        "exitOnEsc": settings.exitOnEsc,
        "debug": settings.debug,
        "version": SettingsVersion
    }

    var settingsFile = open(filename, fmWrite)
    defer: settingsFile.close()

    log("Saving settings to file", "debug")

    settingsFile.write($settingsJson)