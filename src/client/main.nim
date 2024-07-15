# Client window
import os

import alasgar

import config, logger

import ../world/[Meshes, Player]

var
    WINDOW_WIDTH: int = 1280
    WINDOW_HEIGHT: int = 720
    WINDOW_FULLSCREEN: bool = false

var 
    W_pressed = false
    S_pressed = false
    A_pressed = false
    D_pressed = false

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

    let player = newPlayer(scene, "Player")
    let playerEntity = player.entity
    playerEntity.material.castShadow = true
    playerEntity.program(proc(script: ScriptComponent) =
        let t = 2 * runtime.age
        script.transform.euler = vec3(
            sin(t),
            cos(t),
            sin(t) * cos(t),
        )
    )
    #[
    playerEntity.program(
        proc(script: ScriptComponent) =
            if isKeyDown(KEY_W) and not W_pressed:
                W_pressed = true
                log("W pressed", "debug")
            elif isKeyUp(KEY_W) and W_pressed:
                W_pressed = false
                log("W released", "debug")
            
            if isKeyDown(KEY_S) and not S_pressed:
                S_pressed = true
                log("S pressed", "debug")
            elif isKeyUp(KEY_S) and S_pressed:
                S_pressed = false
                log("S released", "debug")
            
            if isKeyDown(KEY_A) and not A_pressed:
                A_pressed = true
                log("A pressed", "debug")
            elif isKeyUp(KEY_A) and A_pressed:
                A_pressed = false
                log("A released", "debug")
            
            if isKeyDown(KEY_D) and not D_pressed:
                D_pressed = true
                log("D pressed", "debug")
            elif isKeyUp(KEY_D) and D_pressed:
                D_pressed = false
                log("D released", "debug")
    )]#
    #playerEntity.transform.scale = vec3(3)

    let planeEntity = newEntity(scene, "Ground")
    add(planeEntity, newPlaneMesh(1, 1))
    add(scene, planeEntity)

    planeEntity.transform.position = vec3(0, -3, 0)
    planeEntity.transform.scale = vec3(200, 1, 200)
    planeEntity.material.castShadow = false

    # Creates the light entity
    let lightEntity = newEntity(scene, "Light")
    add(
        lightEntity, 
        newDirectLightComponent(
            direction=vec3(0) - vec3(-4, 5, 4),
            shadow=true,
        )
    )

    add(scene, planeEntity)
    add(scene, lightEntity)
    add(scene, cameraEntity)

    render(scene)

    # todo: add input system
    #parseEvent(ptr currentEvent, vec2(WINDOW_WIDTH, WINDOW_HEIGHT), ptr currentInput)
    loop()

    