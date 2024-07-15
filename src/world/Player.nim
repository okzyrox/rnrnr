import alasgar

import ../client/logger

import Meshes

type Player* = object
    name*: string
    
    mesh*: MeshComponent

    position*: Vec3
    scale*: Vec3

    # internal
    entity*: Entity
    id: int
    scripts: seq[proc(script: ScriptComponent)]

proc add*(scripts: varargs[proc(script: ScriptComponent)], script: proc(script: ScriptComponent)) =
    scripts.add(script)

proc add*(player: Player, script: proc(script: ScriptComponent)) =
    player.scripts.add script

proc newPlayer*(scene: Scene, name: string): Player =
    result = Player(
        name: name, 
        mesh: newCubeMesh(), 
        position: vec3(0, 0, 0), 
        scale: vec3(1, 1, 1),
        entity: newEntity(scene, name),
        id: 0,
        scripts: @[]
    )

    add(result.entity, result.mesh)
    add(scene, result.entity)

    log("Created player: " & name, "debug")

proc updatePlayer*(player: Player) =
    player.entity.transform.position = player.position
    player.entity.transform.scale = player.scale

#[
proc addScript*(player: Player, script: proc(script: ScriptComponent)) =
    removeComponents(player.entity)
    player.add(script)
    for add_script in player.scripts:
        program(player.entity, proc(s: ScriptComponent) = 
            add_script(s)
        )
    
    log("Added script to player: " & player.name, "debug")

]#