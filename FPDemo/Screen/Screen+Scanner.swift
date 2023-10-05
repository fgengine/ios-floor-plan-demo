//
//  FPDemo
//

import FloorPlan

@available(iOS 16.0, *)
protocol IScreenScannerRouter : AnyObject {
    
    func result(_ screen: Screen.Scanner, project: Project)
    func result(_ screen: Screen.Scanner, error: Error)
    
}

extension Screen {
    
    @available(iOS 16.0, *)
    final class Scanner : IScreen, IScreenViewable {
        
        weak var router: IScreenScannerRouter?
        unowned var container: IUIContainer?
        
        private let done: UI.View.Button
        private let overlayLayout: UI.Layout.Composition
        private let overlay: UI.View.Custom
        private let scanner: FloorPlan.Scanner.View
        let view: UI.View.Custom
        
        init(
            router: IScreenScannerRouter
        ) {
            self.router = router
            
            self.done = Self._button(title: "Done")
            
            self.scanner = .init()
            
            self.overlayLayout = .init(
                entity: .margin(
                    inset: .init(horizontal: 32, vertical: 32),
                    entity: .position(
                        mode: .topRight,
                        entity: .view(self.done)
                    )
                )
            )
            
            self.overlay = .init()
                .content(self.overlayLayout)
            
        
        self.view = .init()
            .content(.composition(
                entity: .zStack([
                    .view(self.scanner),
                    .view(self.overlay)
                ])
            ))
        }
        
        func setup() {
            self.done.onPressed(self, { $0._onPressedDone() })
            self.scanner.onFinish(self, { $0._onFinish($1) })
        }
        
        func apply(inset: UI.Container.AccumulateInset) {
            self.overlayLayout.inset = inset.natural
        }
        
    }
    
}

@available(iOS 16.0, *)
private extension Screen.Scanner {
    
    func _onPressedDone() {
        if self.done.isSelected == true {
            switch self.scanner.result {
            case .success(let value): self.router?.result(self, project: value)
            case .failure(let error): self.router?.result(self, error: error)
            case .none: break
            }
        } else {
            self.scanner.finish()
        }
    }
    
    func _onFinish(_ result: Result< Project, Error >) {
        self.done.select(true)
    }
    
}

@available(iOS 16.0, *)
private extension Screen.Scanner {
    
    static func _button(
        title: String
    ) -> UI.View.Button {
        let normalBackgroundColor = UI.Color(rgb: 0x7a7a7a)
        let selectedBackgroundColor = UI.Color.powderBlue
        let normalTextColor = UI.Color(rgb: 0x101010)
        let selectedTextColor = UI.Color.white
        let backgroundView = UI.View.Rect()
            .fill(normalBackgroundColor)
            .cornerRadius(.auto)
        let textView = UI.View.Text()
            .text(title)
            .textFont(UI.Font(weight: .bold, size: 20))
            .textColor(normalTextColor)
        return UI.View.Button()
            .height(.fixed(40))
            .background(backgroundView)
            .primary(textView)
            .onStyle({ [unowned backgroundView, unowned textView] button, _ in
                if button.isSelected == true {
                    backgroundView.fill = selectedBackgroundColor
                    textView.textColor = selectedTextColor
                } else {
                    backgroundView.fill = normalBackgroundColor
                    textView.textColor = normalTextColor
                }
            })
    }
    
}
