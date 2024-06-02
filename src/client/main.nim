# Client window

import alasgar



proc runClient*() =
    window("Not rnr", 1280, 720, false, true)
    
    let 
        # Creates a new scene
        scene = newScene()
        # Creates camera entity
        cameraEntity = newEntity(scene, "Camera")
        cubeEntity = newEntity(scene, "Cube")

    # Sets camera position
    cameraEntity.transform.position = vec3(5, 5, 5)
    
    
    addComponent(
        cameraEntity, 
        newPerspectiveCamera(
            75, 
            engine().ratio, 
            0.1, 
            100.0, 
            vec3(0) - cameraEntity.transform.position
        )
    )


    addChild(scene, cameraEntity)

    # Creates cube entity, by default position is 0, 0, 0
    
    # Add a cube mesh component to entity
    addComponent(cubeEntity, newCubeMesh())
    # Makes the cube enity child of the scene
    addChild(scene, cubeEntity)
    # Scale it up
    cubeEntity.transform.scale = vec3(2)
    
    render(scene)
    loop()