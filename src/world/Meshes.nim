import alasgar
import strutils
import std/tables
import ../client/logger

proc loadObj(filePath: string): (seq[Vertex], seq[uint32]) =
  log("Loading Model: " & filePath, "debug")
  var
    positions: seq[Vec3]
    uvs: seq[Vec2]
    normals: seq[Vec3]
    vertices: seq[Vertex]
    indices: seq[uint32]
    vertexMap: Table[string, uint32]

  for line in lines(filePath):
    let parts = line.splitWhitespace()
    if parts.len == 0 or parts[0] == "#": continue
    case parts[0]
    of "v":
      positions.add(vec3(parseFloat(parts[1]), parseFloat(parts[2]), parseFloat(parts[3])))
    of "vt":
      uvs.add(vec2(parseFloat(parts[1]), parseFloat(parts[2])))
    of "vn":
      normals.add(vec3(parseFloat(parts[1]), parseFloat(parts[2]), parseFloat(parts[3])))
    of "f":
      for i in 1..parts.len - 1:
        let vertexDef = parts[i]
        if not (vertexDef in vertexMap):
          let indices = vertexDef.split("/")
          let posIndex = parseInt(indices[0]) - 1
          let uvIndex = if indices[1] != "": parseInt(indices[1]) - 1 else: -1
          let normIndex = if indices[2] != "": parseInt(indices[2]) - 1 else: -1

          let position = positions[posIndex]
          let uv = if uvIndex >= 0: uvs[uvIndex] else: vec2(0.0, 0.0)
          let normal = if normIndex >= 0: normals[normIndex] else: vec3(0.0, 0.0, 0.0)

          let vertex = newVertex(position, normal, uv)
          vertices.add(vertex)
          vertexMap[vertexDef] = uint32(vertices.len - 1)
        indices.add(vertexMap[vertexDef])
  return (vertices, indices)

# player
# currently the resources folder has to be packaged with the binary
# todo: make it compiled?
var playerMeshInstance: Mesh
var (playerMeshVertices, playerMeshIndices) = loadObj("resources/models/avatar.obj")

proc newPlayerMesh*(): MeshComponent =
    new(result)
    if playerMeshInstance == nil:
       playerMeshInstance = newMesh(playerMeshVertices, playerMeshIndices)
    result.instance  = playerMeshInstance
