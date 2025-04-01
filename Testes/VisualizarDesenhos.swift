//
//  VisualizarDesenhos.swift
//  Testes
//
//  Created by GUILHERME MATEUS SOUSA SANTOS on 01/04/25.
//

import SwiftUI

struct VisualizarDesenhos: View {
    
    let desenhos: [DesenhoEntity]
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                ForEach(desenhos) {
                    desenhoFeito in
                    
                    PencilKitDrawing(desenho: desenhoFeito.desenho, canva: Canva())
                        .frame(width: 700, height: 550)
                    
                    
                }
                
                Rectangle()
                
            }
        }
        
        
        
        
    }
}

#Preview {
    VisualizarDesenhos(desenhos: [])
}
