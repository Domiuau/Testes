//
//  VisualizarDesenhos.swift
//  Testes
//
//  Created by GUILHERME MATEUS SOUSA SANTOS on 01/04/25.
//

import SwiftUI

struct VisualizarDesenhos: View {
    
    let desenhos: [DesenhoEntity]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(desenhos) { desenhoFeito in
                        GeometryReader { geometry in
                            PencilKitDrawing(desenho: desenhoFeito.desenho, canva: Canva(), tamanhoOriginal: CGSize(width: desenhoFeito.canvaTamanhoX, height: desenhoFeito.canvaTamanhoY), tamanhoCanva: geometry.size)
                                
                        }
                        .aspectRatio(8/5, contentMode: .fit)
                        
                    }
                }
                
                Rectangle()
                
            }.padding()
        }
        
        
        
        
    }
}

#Preview {
    VisualizarDesenhos(desenhos: [])
}
