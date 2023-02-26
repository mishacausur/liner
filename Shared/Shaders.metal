//
//  Shaders.metal
//  liner
//
//  Created by Misha Causur on 26.02.2023.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
  float4 position [[attribute(0)]];
};

vertex float4 vertex_main(const VertexIn vertexIn [[stage_in]]) {
  return vertexIn.position;
}

/*renderEncoder.drawIndexedPrimitives(
  type: .triangle,
  indexCount: submesh.indexCount,
  indexType: submesh.indexType,
  indexBuffer: submesh.indexBuffer.buffer,
  indexBufferOffset: 0)
*/
