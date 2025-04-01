import SwiftUI
import PencilKit

class Fase1 {
    
    let canva = CanvasPersonalizado()

    
}

class CanvasPersonalizado: PKCanvasView {
    
    struct XYCor {
        
        let point: CGPoint
        let cor: UIColor
        
    }
    
    private var timer: DispatchSourceTimer?
    private var timer2: DispatchSourceTimer?
    private var vetorLinhas: [XYCor] = []
    var cor: UIColor = .red
    var cor2: UIColor = .blue
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let point = touch.location(in: self)
            print(point)
            vetorLinhas.append(XYCor(point: CGPoint(x: point.x, y: point.y), cor: cor))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if let touch = touches.first {
            let point = touch.location(in: self)
            vetorLinhas.append(XYCor(point: CGPoint(x: point.x, y: point.y), cor: cor))

        }
    }
    
    override func draw(_ rect: CGRect) {
          
    }
    
}

struct PencilKitDrawingView: UIViewRepresentable {
    
    let points: [CGPoint]
    let points2: [CGPoint]
    let canvasView = CanvasPersonalizado()
    
    func makeUIView(context: Context) -> PKCanvasView {
        
        canvasView.backgroundColor = .white
        let desenho = createDrawing(from: points)
        canvasView.drawing.append(createDrawing(from: points2))
        canvasView.isDrawingEnabled = true
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .green

        
        DispatchQueue.main.async {
            print("Largura desenho:", self.canvasView.drawing.bounds.size)
            print("Largura canvas:", self.canvasView.bounds.size)             
            
        }
        

        return canvasView
    }
    
    
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // Atualize a view se necessário
    }
    
    private func createDrawing(from points: [CGPoint]) -> PKDrawing {
        // Verifica se há pelo menos um ponto
        guard points.count > 1 else { return PKDrawing() }
        
        // Define a configuração do traço
        let ink = PKInk(.monoline, color: .black)
        var controlPoints: [PKStrokePoint] = []
        
        // Converte os pontos em PKStrokePoint
        points.forEach { point in
            let strokePoint = PKStrokePoint(
                location: point,
                timeOffset: 0,
                size: CGSize(width: 20, height: 20),
                opacity: 1,
                force: 1,
                azimuth: 1,
                altitude: .pi / 2
            )
            controlPoints.append(strokePoint)
        }
        
        
        // Cria o caminho do traço
        let path = PKStrokePath(controlPoints: controlPoints, creationDate: Date())
        
        // Cria o traço
        let stroke = PKStroke(ink: ink, path: path)
        
        // Cria um array de traços e adiciona o traço criado
        let strokes = [stroke]
        
        // Retorna o desenho com os traços
        return PKDrawing(strokes: strokes)
    }
    
}

struct ContentView: View {
    var body: some View {
        
        PencilKitDrawingView(points: [
            CGPoint(x: 10, y: 10),
            CGPoint(x: 50, y: 80),
            CGPoint(x: 100, y: 50),
            CGPoint(x: 800, y: 800)
        ], points2: [
            CGPoint(x: 10, y: 10),
            CGPoint(x: 50, y: 80),
            CGPoint(x: 100, y: 50),
            CGPoint(x: 150, y: 100)
        ]
                             
                             
        )
    }
}

struct PencilKitDrawingView_Previews: PreviewProvider {
    static var previews: some View {
        PencilKitDrawingView(points: [
            CGPoint(x: 10, y: 10),
            CGPoint(x: 10, y: 10),
            CGPoint(x: 20, y: 20),
            CGPoint(x: 800, y: 800)
        ], points2: [
            CGPoint(x: 100, y: 10),
            CGPoint(x: 150, y: 80),
            CGPoint(x: 200, y: 50),
            CGPoint(x: 250, y: 100)
        ]
                             
                             
        )
    }
}
