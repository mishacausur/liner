//
//  MetalHelper.swift
//  liner
//
//  Created by Misha Causur on 07.02.2023.
//

import SwiftUI
import MetalKit

struct Metal: View {
    @State private var metalView = MTKView()
    @State private var renderer: Renderer?
    var body: some View {
        MetalRepresentable(metalView: $metalView)
            .onAppear { renderer = .init(metal: metalView) } 
    }
}

#if os(macOS)
typealias ViewRepresentable = NSViewRepresentable
#elseif os(iOS)
typealias ViewRepresentable = UIViewRepresentable
#endif

struct MetalRepresentable: ViewRepresentable {
    @Binding var metalView: MTKView
    
#if os(macOS)
    func makeNSView(context: Context) -> some NSView {
        metalView
    }
    
    func updateNSView(_ uiView: NSViewType, context: Context) {
        updateMetalView()
    }
    
#elseif os(iOS)
    func makeUIView(context: Context) -> MTKView {
        metalView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
        updateMetalView()
    }
#endif
    
    func updateMetalView() {
    }
}

struct MetalView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Metal()
            Text("Metal")
        }
    }
}
