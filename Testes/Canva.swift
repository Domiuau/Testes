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
    
    let joze = 34
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        trocaDecor()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    
    
    func trocaDecor() {
        print("fase 1")
    }
    
    
    
}

class Fase11: Canva {
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("fase 1112121")
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func verSeATintaAcabou() {
        
    }
    
}

import SwiftUI
import PencilKit

struct PencilKitDrawing: UIViewRepresentable {
    
    let canvasView: PKCanvasView
    var tamanhoOriginal: CGSize? = nil
    var desenho: Data?
    var tamanhoCanva: CGSize?
    let scrollView = UIScrollView()
    
    // Inicializadores conforme seu código
    init(canva: PKCanvasView) {
        self.canvasView = canva
        self.tamanhoCanva = nil
    }
    
    init(desenho: Data?, canva: PKCanvasView, tamanhoOriginal: CGSize, tamanhoCanva: CGSize) {
        self.desenho = desenho
        self.canvasView = canva
        self.tamanhoOriginal = tamanhoOriginal
        self.tamanhoCanva = tamanhoCanva
        canva.isUserInteractionEnabled = false
        print("tamanho canvinha geometry ", tamanhoCanva)
    }
 
    // O coordinator vai ser o delegate do scroll para o zoom
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        // Cria o UIScrollView que permitirá o zoom via gesto de pinça
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.delegate = context.coordinator
        scrollView.bouncesZoom = true
        scrollView.isScrollEnabled = false
        
        // Configura o canvas
        canvasView.backgroundColor = .white
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.monoline, color: .gray, width: 2)
        
        // Se houver um desenho, aplica a transformação inicial
        if let desenho = desenho {
            do {
                let pkdraw = try PKDrawing(data: desenho)
                let phdrawreference = try PKDrawingReference(data: desenho)
                
                DispatchQueue.main.async {
                    guard let tamanhoOriginal = self.tamanhoOriginal,
                          let tamanhoCanva = self.tamanhoCanva else { return }
                    
                    let tamanhoX = tamanhoCanva.width * pkdraw.bounds.size.width / tamanhoOriginal.width
                    let tamanhoY = tamanhoCanva.height * pkdraw.bounds.size.height / tamanhoOriginal.height
                    
                    print("tamanho original: x ", tamanhoOriginal.width, " y ", tamanhoOriginal.height)
                    print("tamanho desenho ", pkdraw.bounds.size)
                    print("tamanho canva ", tamanhoCanva)
                    print("tamanho x ", tamanhoX)
                    print("tamanho y ", tamanhoY)
                    
                    let scaleX = tamanhoX / pkdraw.bounds.size.width
                    let scaleY = tamanhoY / pkdraw.bounds.size.height
                    
                    print("scale x", scaleX)
                    print("scale y", scaleY)
                    
                    let scale = min(scaleX, scaleY)
                    
                    print("scale ", scale)
                    
                    let scaleTransform = CGAffineTransform(scaleX: scale, y: scale)
                    
                    // Aplica a transformação no desenho do canvas
                    self.canvasView.drawing = phdrawreference.applying(scaleTransform)
                    
                    print("desenho posicao ", self.canvasView.drawing.bounds.origin)
                    print("desenho:", pkdraw.bounds.size)
                    print("\n")
                }
            } catch let error {
                print(error)
                print("erro")
            }
        }
        
        // Adiciona o canvasView como subview do scrollView
        scrollView.addSubview(canvasView)
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        
        // Faz o canvas preencher o conteúdo do scrollView
        NSLayoutConstraint.activate([
            canvasView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            canvasView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            canvasView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            // Opcional: se desejar que o canvasView tenha o mesmo tamanho que o scrollView
            canvasView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            canvasView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // Atualize a view se necessário
    }
    
    // O Coordinator atua como delegate do UIScrollView para o zoom
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: PencilKitDrawing
        
        init(_ parent: PencilKitDrawing) {
            self.parent = parent
        }
        
        // Indica qual view deve ser ampliada
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return parent.canvasView
        }
    }
    
    
}
