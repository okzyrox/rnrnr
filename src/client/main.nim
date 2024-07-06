# Client window
import os

import alasgar

import config, logger

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
        # Creates a new scene
        scene = newScene()
        # Creates camera entity
        cameraEntity = newEntity(scene, "Camera")

    # Sets camera position
    scene.background = parseHex("ffffff")

    # Sets the camera position
    cameraEntity.transform.position = vec3(5, 5, 5)
    # Adds a perspective camera component to entity
    add(
        cameraEntity, 
        newPerspectiveCamera(
            75, 
            runtime.ratio, 
            0.1, 
            100.0, 
            vec3(0) - cameraEntity.transform.position
        )
    )
    # Makes the camera entity child of the scene
    add(scene, cameraEntity)

    # Creates the cube entity, by default position is 0, 0, 0
    let cubeEntity = newEntity(scene, "Cube")
    # Add a cube mesh component to entity
    add(cubeEntity, newCubeMesh())
    # Adds a script component to the cube entity
    program(cubeEntity, proc(script: ScriptComponent) =
        let t = 2 * runtime.age
        # Rotates the cube using euler angles
        script.transform.euler = vec3(
            sin(t),
            cos(t),
            sin(t) * cos(t),
        )
    )
    # Makes the cube enity child of the scene
    add(scene, cubeEntity)
    # Scale it up
    cubeEntity.transform.scale = vec3(2)

    # Creates the light entity
    let lightEntity = newEntity(scene, "Light")
    # Sets light position
    lightEntity.transform.position = vec3(4, 5, 4)
    # Adds a point light component to entity
    add(
        lightEntity, 
        newPointLightComponent()
    )
    # Makes the light entity child of the scene
    add(scene, lightEntity)
    # Makes the camera entity child of the scene
    add(scene, cameraEntity)

    render(scene)
    loop()

    