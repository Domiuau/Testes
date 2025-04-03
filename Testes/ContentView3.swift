import SwiftUI
import PencilKit

// Wrapper para permitir a codificação de PKDrawing
struct CodablePKDrawing: Codable {
    let drawingData: Data
    
    init(drawing: PKDrawing) {
        self.drawingData = drawing.dataRepresentation()
    }
    
    // Método auxiliar para recuperar a PKDrawing, se necessário
    func toPKDrawing() -> PKDrawing {
        do {
            return try PKDrawing(data: drawingData)

        } catch let error {
            
        }
        
        return PKDrawing()
    }
}

// Estrutura que representa os dados a serem armazenados
struct Rabisco: Codable {
    var nome: String
    var rabiscos: [CodablePKDrawing]
}

struct ContentView3: View {
    
    // Exemplo: criação de um desenho vazio.
    // Em um cenário real, você provavelmente obterá o desenho de uma Canvas/PencilKit.
    var dummyDrawing: PKDrawing {
        return PKDrawing()
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Salvar rabisco no JSON")
            
            Button(action: {
                // Cria um exemplo de objeto Rabisco
                let novoRabisco = Rabisco(
                    nome: "Exemplo de Rabisco",
                    rabiscos: [CodablePKDrawing(drawing: dummyDrawing)]
                )
                
                // Codifica o objeto em JSON
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                do {
                    let jsonData = try encoder.encode(novoRabisco)
                    
                    // Caminho para o diretório de Documentos do app
                    if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let fileURL = documentDirectory.appendingPathComponent("rabisco.json")
                        
                        // Salva os dados JSON no arquivo
                        try jsonData.write(to: fileURL)
                        print("Arquivo salvo em: \(fileURL)")
                    }
                } catch {
                    print("Erro ao codificar ou salvar o JSON: \(error)")
                }
            }, label: {
                Text("Salvar JSON")
            })
        }
        .padding()
    }
}
