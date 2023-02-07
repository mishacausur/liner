//
//  Renderer.swift
//  liner
//
//  Created by Misha Causur on 07.02.2023.
//

import MetalKit

class Renderer: NSObject {
    
    init(metal: MTKView) {
        super.init()
    }
}

extension Renderer: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        <#code#>
    }
    
    func draw(in view: MTKView) {
        #if DEBUG
        print("metal draws")
        #endif
    }
}
