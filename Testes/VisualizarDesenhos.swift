//
//  VisualizarDesenhos.swift
//  Testes
//
//  Created by GUILHERME MATEUS SOUSA SANTOS on 01/04/25.
//

import SwiftUI
import PencilKit

struct VisualizarDesenhos: View {
    
    let desenhos: [DesenhoEntity]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    @State var stringData: String = ""
    @State var tamanhoX: Double = 0
    @State var tamanhoY: Double = 0

    @State private var isSheetPresented = false

    
    var body: some View {
        

        
        NavigationStack {
            
            ScrollView {
                
                VStack {
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(desenhos) { desenhoFeito in
                            GeometryReader { geometry in
                                PencilKitDrawing(desenho: desenhoFeito.desenho, canva: PKCanvasView(), tamanhoOriginal: CGSize(width: desenhoFeito.canvaTamanhoX, height: desenhoFeito.canvaTamanhoY), tamanhoCanva: geometry.size)
                                    .onTapGesture {
                                        
                                        
                                        
                                        stringData = desenhoFeito.desenho!.base64EncodedString()
                                        tamanhoX = desenhoFeito.canvaTamanhoX
                                        tamanhoY = desenhoFeito.canvaTamanhoY
                                        
                                        print()
                                        print(stringData)
                                        print("width: ", tamanhoX, "height: ", tamanhoY)
                                        print()
                                        
                                        
                                        
                                    }
                                    .sheet(isPresented: $isSheetPresented) {
                                        MinhaSheetView(stringData: stringData, tamanhoX: tamanhoX, tamanhoY: tamanhoY)
                                                }
                                    
                            }
                            .aspectRatio(8/5, contentMode: .fit)
                            
                            
                        }
                    }
                    
                    Rectangle()
                    
                }.padding()
            }
        }
    }
    

}

struct MinhaSheetView: View {
    
    @State var stringData: String
    @State var tamanhoX: Double
    @State var tamanhoY: Double
    
    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 20) {
                
                Text("width: \(tamanhoX) height: \(tamanhoY)")
                Text("data: " + stringData)
                
                
                }
        
        }
        .padding()
    }
}



#Preview {
    VisualizarDesenhos(desenhos: [])
}
