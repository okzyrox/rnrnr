# Client window
import os

import alasgar

import config, logger

import ../world/[Meshes]

var
    WINDOW_WIDTH: int = 1280
    WINDOW_HEIGHT: int = 720
    WINDOW_FULLSCREEN: bool = false

proc runClient*() =
    if not fileExists("config.json"):
        log("No config file found, creating one", "warn")
        saveSettings(defaultSettings, "config.json")
    
    var loaded_settings = loadSettings("config.json")

    if loaded_settings.windowWidth > 0 and loaded_settings.windowWidth != WINDOW_WIDTH:
        WINDOW_WIDTH = loaded_settings.windowWidth

    if loaded_settings.windowHeight > 0 and loaded_settings.windowHeight != WINDOW_HEIGHT:
        WINDOW_HEIGHT = loaded_settings.windowHeight

    if loaded_settings.maxFPS > 0 and loaded_settings.maxFPS != settings.maxFPS:
        settings.maxFPS = loaded_settings.maxFPS
    
    if loaded_settings.exitOnEsc != settings.exitOnEsc:
        settings.exitOnEsc = loaded_settings.exitOnEsc
    
    log("Loaded all settings", "debug")

    # todo: log gl options
    # currently getting sigsev errors trying to do the same thing alasgar does with the gl versions stuffs

    window("rnrnr", WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_FULLSCREEN, true)
    
    ## ideally make the scene objects dependent on a list of objects
    ## rather than adding them in line by line
    let 
        scene = newScene()
        cameraEntity = newEntity(scene, "Camera")

    scene.background = parseHex("ffffff")

    cameraEntity.transform.position = vec3(5, 5, 5)

    add(
        cameraEntity, 
        newPerspectiveCamera(
            90, 
            runtime.ratio, 
            0.1, 
            100.0, 
            vec3(0) - cameraEntity.transform.position
        )
    )

    let playerEntity = newEntity(scene, "Player")
    add(playerEntity, newPlayerMesh())

    program(playerEntity, proc(script: ScriptComponent) =
        let t = 2 * runtime.age
        # Rotates the cube using euler angles
        script.transform.euler = vec3(
            sin(t),
            cos(t),
            sin(t) * cos(t),
        )
    )

    add(scene, playerEntity)
    playerEntity.transform.scale = vec3(3)

    let lightEntity = newEntity(scene, "Light")
    lightEntity.transform.position = vec3(4, 5, 4)

    add(
        lightEntity, 
        newPointLightComponent()
    )
    add(scene, lightEntity)
    add(scene, cameraEntity)

    render(scene)
    loop()

    