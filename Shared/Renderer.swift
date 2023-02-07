//
//  Renderer.swift
//  liner
//
//  Created by Misha Causur on 07.02.2023.
//

import MetalKit

class Renderer: NSObject {
    static var device: MTLDevice!
    static var queue: MTLCommandQueue!
    static var library: MTLLibrary!
    var mesh: MTKMesh!
    var buffer: MTLBuffer!
    var poplineState: MTLRenderPipelineState!
    
    init(metal: MTKView) {
        guard let device = MTLCreateSystemDefaultDevice(),
              let queue = device.makeCommandQueue() else {
            fatalError("Exception: Graphic engine is not found")
        }
        Renderer.device = device
        Renderer.queue = queue
        metal.device = device
        let allocator = MTKMeshBufferAllocator(device: device)
        let size: Float = 0.8
        let mmesh = MDLMesh(
            boxWithExtent: [size, size, size],
            segments: [1, 1, 1],
            inwardNormals: false,
            geometryType: .triangles,
            allocator: allocator
        )
        do {
            mesh = try MTKMesh(mesh: mmesh, device: device)
        } catch (let error) {
            #if DEBUG
            print(error.localizedDescription)
            #endif
        }
        buffer = mesh.vertexBuffers[0].buffer
        let library = device.makeDefaultLibrary()
        Renderer.library = library
        let vertex = library?.makeFunction(name: "vertex_main")
        let fragment = library?.makeFunction(name: "fragment_main")
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = vertex
        descriptor.fragmentFunction = fragment
        descriptor.colorAttachments[0].pixelFormat = metal.colorPixelFormat
        descriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mmesh.vertexDescriptor)
        do {
            poplineState = try device.makeRenderPipelineState(descriptor: descriptor)
        } catch (let error) {
            #if DEBUG
            print(error.localizedDescription)
            #endif
        }
        super.init()
        metal.clearColor = MTLClearColor(
            red: 1,
            green: 1,
            blue: 0.8,
            alpha: 1
        )
        metal.delegate = self
    }
}

extension Renderer: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        #if DEBUG
        print("metal draws")
        #endif
        guard let commandBuffer = Renderer.queue.makeCommandBuffer(),
              let descriptor = view.currentRenderPassDescriptor,
              let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else { return }
        encoder.setRenderPipelineState(poplineState)
        encoder.setVertexBuffer(buffer, offset: 0, index: 0)
        mesh.submeshes.forEach {
            encoder.drawIndexedPrimitives(
                type: .triangle,
                indexCount: $0.indexCount,
                indexType: $0.indexType,
                indexBuffer: $0.indexBuffer.buffer,
                indexBufferOffset: $0.indexBuffer.offset
            )
        }
        
        encoder.endEncoding()
        guard let drawable = view.currentDrawable else { return }
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
