//
//  FPDemo
//

import FloorPlan

protocol IScreenMenuRouter : AnyObject {
    
    func scanner(_ screen: Screen.Menu)
    func editor(_ screen: Screen.Menu)
    
}

extension Screen {
    
    final class Menu : IScreen, IScreenViewable {
        
        weak var router: IScreenMenuRouter?
        unowned var container: IUIContainer?
        
        private let scanner: UI.View.Button
        private let editor: UI.View.Button
        private let layout: UI.Layout.Composition
        let view: UI.View.Custom
        
        init(
            router: IScreenMenuRouter
        ) {
            self.router = router
            self.scanner = Self._button(title: "Scanner")
            self.editor = Self._button(title: "Editor")
            
            self.layout = .init(
                entity: .margin(
                    inset: .init(horizontal: 32, vertical: 32),
                    entity: .position(
                        mode: .bottom,
                        entity: .vStack(
                            alignment: .fill,
                            spacing: 8,
                            entities: [
                                .view(self.scanner),
                                .view(self.editor)
                            ]
                        )
                    )
                )
            )
            
            self.view = .init()
                .content(self.layout)
                .color(.white)
        }
        
        func setup() {
            self.scanner.onPressed(self, { $0._pressedScanner() })
            self.editor.onPressed(self, { $0._pressedEditor() })
        }
        
        func apply(inset: UI.Container.AccumulateInset) {
            self.layout.inset = inset.natural
        }
        
    }
    
}

private extension Screen.Menu {
    
    func _pressedScanner() {
        self.router?.scanner(self)
    }
    
    func _pressedEditor() {
        self.router?.editor(self)
    }
    
}

private extension Screen.Menu {
    
    static func _button(
        title: String
    ) -> UI.View.Button {
        let textView = UI.View.Text()
            .text(title)
            .textFont(UI.Font(weight: .bold, size: 20))
            .textColor(UI.Color(rgb: 0x101010))
        return UI.View.Button()
            .height(.fixed(40))
            .background(UI.View.Rect()
                .fill(.init(rgb: 0x7a7a7a))
                .cornerRadius(.auto)
            )
            .primary(textView)
    }
    
}
