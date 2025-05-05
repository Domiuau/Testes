//
//  ContentView2.swift
//  Testes
//
//  Created by GUILHERME MATEUS SOUSA SANTOS on 01/04/25.
//

import SwiftUI
import CoreData
import PencilKit

class CoreDataViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    @Published var savedEntities: [DesenhoEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "DesenhoContainer")
        container.loadPersistentStores {
            (description, error) in
            if let error = error {
                print("error ", error)
            } else {
                print("foi")
            }
        }
        
        fetchDesenho()
    }
    
    func marcarComoUtilizado(desenho: DesenhoEntity, isUsado: Bool) {
        print("usado: ", isUsado)
        desenho.usadoNoPrincipal = isUsado
        saveDesenho()
        
        
    }
    
    func colocarClassficacao(desenho: DesenhoEntity, classificacao: String) {
        print("colocando classificacao")
        print(classificacao)
        desenho.classificacao = classificacao
        print(desenho.classificacao)
        saveDesenho()
        print(desenho.classificacao)

    }
    
    func deleteDesenho(desenho: DesenhoEntity) {
        
        container.viewContext.delete(desenho)
        saveDesenho()
        
    }
    
    func fetchDesenho() {
        
        let request = NSFetchRequest<DesenhoEntity>(entityName: "DesenhoEntity")
        
        do {
            savedEntities = try container.viewContext.fetch(request)
            
        } catch let error {
            print(error)
        }
        
        
    }
    
    func addDesenho(data: Data, tamanhoCanva: CGSize) {
        
        let newDesenho = DesenhoEntity(context: container.viewContext)
        newDesenho.desenho = data
        newDesenho.canvaTamanhoX = tamanhoCanva.width
        newDesenho.canvaTamanhoY = tamanhoCanva.height
        newDesenho.classificacao = "sem classificacao"
        saveDesenho()
        print("desenho salvo com sucesso")
        
    }
    
    func saveDesenho() {
        
        do {
            try container.viewContext.save()
            fetchDesenho()
        } catch let error {
            print(error)
        }
    }
    
}

struct ContentView2: View {
    
    @StateObject var vm = CoreDataViewModel()
    let canva = Fase11()
    
    var body: some View {
        
        
        NavigationStack {
            
            VStack {
                
                PencilKitDrawing(canva: canva)
                    .aspectRatio(8/5, contentMode: .fit)
                    .shadow(radius: 10)
                    .padding()
                
                HStack {
                    
                    Spacer()
                    
                    Button {
                        
                        print("tamanho do desenho no canva: ", canva.drawing.bounds.size)
                        print(canva.bounds.size)
                        
                        print(canva.drawing.dataRepresentation().base64EncodedString())
                        print("tamango original: ", canva.bounds.size)
                        
                        vm.addDesenho(data: canva.drawing.dataRepresentation(), tamanhoCanva: canva.bounds.size)
                        
                        canva.drawing = PKDrawing()
                        
                    } label: {
                        Text("salvar desenho")
                            .bold()
                    }
                    
                    Spacer()
                    
                    Text("Quantidade de desenhos salvos \(vm.savedEntities.count)")
                    
                    Spacer()
                    
                    Button {
                        
                        canva.drawing = PKDrawing()
 
                        
                    } label: {
                        Text("limpar canvas")
                            .foregroundColor(Color.red)
                            .bold()
                    }
                    
                    Spacer()
                    
                    
                    
                }
                
                
                NavigationLink {
                    VisualizarDesenhos(desenhos: vm.savedEntities, vm: vm)
                        .shadow(radius: 10)
                } label: {
                    Text("Visualizar desenhos")
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.black)
                        )
                }
                
                //                Button {
                //
                //                    guard let url = Bundle.main.url(forResource: "rabiscos", withExtension: "json") else {
                //                        print("Arquivo não encontrado")
                //                        return
                //                    }
                //
                //                    do {
                //                        let data = try Data(contentsOf: url)
                //                        let decoded = try JSONDecoder().decode([String].self, from: data)
                //
                //                        if let decodedData = Data(base64Encoded: decoded[0], options: .ignoreUnknownCharacters) {
                //
                //                                self.canva.drawing = try PKDrawing(data: decodedData)
                //
                //                        }
                //
                //                    } catch {
                //                        print("Erro ao carregar JSON: \(error)")
                //                    }
                //
                //
                //
                //                } label: {
                //                    Text("imprimir json")
                //                }
                //                .disabled(true)
                //
                //
                //
                //
            }
            
            
        }
        
        
        
        
        
    }
}

#Preview {
    ContentView2()
}
