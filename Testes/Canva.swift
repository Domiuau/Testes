//
//  Canva.swift
//  Testes
//
//  Created by GUILHERME MATEUS SOUSA SANTOS on 01/04/25.
//

import Foundation
import PencilKit
import SwiftUI

class Canva: PKCanvasView {
    
    
    
}

struct PencilKitDrawing: UIViewRepresentable {
    
    let canvasView: PKCanvasView
    var desenho: Data?
    
    init(canva: PKCanvasView) {
        self.canvasView = canva
    }
    
    init(desenho: Data?, canva: PKCanvasView) {
        self.desenho = desenho
        self.canvasView = canva
        
    }
    
    func makeUIView(context: Context) -> PKCanvasView {
        
        canvasView.backgroundColor = .white
        canvasView.isDrawingEnabled = true
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .brown, width: 10)
        
        if let desenho = desenho {
            
            do {
                
                let pkdraw = try PKDrawing(data: desenho)
                let phdrawreference = try PKDrawingReference(data: desenho)
                
                let canvasSize = canvasView.bounds.size
                let scaleX = canvasSize.width / pkdraw.bounds.size.width
                let scaleY = canvasSize.height / pkdraw.bounds.size.height
                let scale = min(scaleX, scaleY)
                print("largura desenho:" ,pkdraw.bounds.size.width)
                print("largura canva: ", canvasSize.width)
                print("scala ", scale)
                
                self.canvasView.drawing = phdrawreference.applying(CGAffineTransform(scaleX: scale, y: 100))
               // self.canvasView.drawing = pkdraw


                canvasView.backgroundColor = .yellow
                print("desenho ", pkdraw.bounds.size)
                
                
                
            } catch let error {
                print(error)
                print("erro")
            }
            
            DispatchQueue.main.async {
                print("Largura desenho:", self.canvasView.drawing.bounds.size)
                print("Largura canvas:", self.canvasView.bounds.size)
                
            }
            
        }
        
        
        return canvasView
    }
    
    
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // Atualize a view se necessário
    }
    
}
