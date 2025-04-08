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
    @State var itemSelecionado: DesenhoEntity?
    @State private var isSheetPresented = false
    @State var vm: CoreDataViewModel
    
    
    
    var body: some View {
        
        
        
        NavigationStack {
            
            ScrollView {
                
                VStack {
                    
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(desenhos) { desenhoFeito in
                            GeometryReader { geometry in
                                
                                NavigationLink {
                                    ExibirDetalhesDesenho(desenhoEntity: desenhoFeito, vm: vm)
                                } label: {
                                    ZStack(alignment: .topLeading) {
                                        
                                        Circle()
                                            .fill(desenhoFeito.usadoNoPrincipal ? Color.green : Color.red)
                                            .frame(width: 50, height: 50)
                                            .zIndex(1)
                                        
                                        PencilKitDrawing(desenho: desenhoFeito.desenho, canva: PKCanvasView(), tamanhoOriginal: CGSize(width: desenhoFeito.canvaTamanhoX, height: desenhoFeito.canvaTamanhoY), tamanhoCanva: geometry.size)
                                            .zIndex(0)
                                        
                                        
                                    }
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

struct ExibirDetalhesDesenho: View {
    
    let desenhoEntity: DesenhoEntity
    @State var usadoNoPrincipal: Bool
    @State var vm: CoreDataViewModel
    @State private var showDeleteConfirmation = false
    @Environment(\.dismiss) var dismiss

    init(desenhoEntity: DesenhoEntity, vm: CoreDataViewModel) {
        self.desenhoEntity = desenhoEntity
        usadoNoPrincipal = desenhoEntity.usadoNoPrincipal
        self.vm = vm
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Toggle("Utilizado no principal", isOn: $usadoNoPrincipal)
                    .onChange(of: usadoNoPrincipal) { novoValor in
                        vm.marcarComoUtilizado(desenho: desenhoEntity, isUsado: novoValor)
                    }
                Text("width: \(desenhoEntity.canvaTamanhoX) height: \(desenhoEntity.canvaTamanhoY)")
                    .bold()
                    .font(.title)
                if let desenhoData = desenhoEntity.desenho {
                    Text(desenhoData.base64EncodedString())
                } else {
                    Text("Nenhum dado")
                }
            }
            .padding()
        }
        .onAppear {
            print("width: \(desenhoEntity.canvaTamanhoX) height: \(desenhoEntity.canvaTamanhoY)")
            if let desenhoData = desenhoEntity.desenho {
                print(desenhoData.base64EncodedString())
            }
        }
        .navigationBarItems(trailing:
            Button {
                showDeleteConfirmation = true
            } label: {
                Text("Deletar")
                    .foregroundColor(.red)
                    .bold()
            }
        )
        .alert(isPresented: $showDeleteConfirmation) {
            Alert(
                title: Text("Confirmação"),
                message: Text("Tem certeza que deseja deletar este desenho?"),
                primaryButton: .destructive(Text("Deletar"), action: {
                    vm.deleteDesenho(desenho: desenhoEntity)
                    dismiss()
                }),
                secondaryButton: .cancel()
            )
        }
    }
}






