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
    
    func fetchDesenho() {
        
        let request = NSFetchRequest<DesenhoEntity>(entityName: "DesenhoEntity")
        
        do {
            savedEntities = try container.viewContext.fetch(request)

        } catch let error {
            print(error)
        }
        
        
    }
    
    func addDesenho(data: Data) {
        
        let newDesenho = DesenhoEntity(context: container.viewContext)
        newDesenho.desenho = data
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
    let canva = Canva()
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                PencilKitDrawing(canva: canva)
                
                Button {
                    
                    print("tamanho do desenho no canva: ", canva.drawing.bounds.size)
                    vm.addDesenho(data: canva.drawing.dataRepresentation())
                    
                } label: {
                    Text("salvar desenho")
                }
                
                Text("Quantidade de desenhos salvos \(vm.savedEntities.count)")
                NavigationLink {
                    VisualizarDesenhos(desenhos: vm.savedEntities)
                } label: {
                    Text("Visualizar desenhos")
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.black)
                        )
                }

                Button {
                    
                    canva.tool = PKInkingTool(.marker, color: UIColor.systemPink, width: 30)

                    
                } label: {
                    Text("trocar cor")
                }


                
            }
            
        }
        

        
    }
}

#Preview {
    ContentView2()
}
