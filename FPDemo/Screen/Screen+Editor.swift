//
//  FPDemo
//

import FloorPlan

extension Screen {
    
    final class Editor : IScreen, IScreenViewable {
        
        unowned var container: IUIContainer?
        
        let undoButton: UI.View.Button
        let redoButton: UI.View.Button
        let overlayLayout: UI.Layout.Composition
        let overlay: UI.View.Custom
        let editor: FloorPlan.Editor.View.Canvas
        let view: UI.View.Custom
        
        init(
            settings: FloorPlan.Editor.Settings,
            renderSettings: FloorPlan.Render.Settings,
            project: FloorPlan.Project
        ) {
            self.undoButton = Self._historyButton(title: "UNDO")
                .isLocked(project.canUndo == false)
            
            self.redoButton = Self._historyButton(title: "REDO")
                .isLocked(project.canUndo == false)
            
            self.overlayLayout = .init(
                entity: .fill(
                    .margin(
                        inset: .init(horizontal: 8, vertical: 4),
                        entity: .hAccessory(
                            leading: .view(self.undoButton),
                            center: .none(),
                            trailing: .view(self.redoButton),
                            filling: true
                        )
                    )
                )
            )
            
            self.overlay = .init()
                .content(self.overlayLayout)
            
            self.editor = .init(settings: settings, renderSettings: renderSettings, project: project)
                .color(.white)
            
            self.view = .init()
                .content(.composition(
                    entity: .zStack([
                        .view(self.editor),
                        .view(self.overlay)
                    ])
                ))
        }
        
        func setup() {
            self.undoButton.onPressed(self, { $0._pressedUndo() })
            self.redoButton.onPressed(self, { $0._pressedRedo() })
            self.editor.onHistory(self, { $0._onHistory() })
            self.editor.onSelect(self, { $0._onSelect($1) })
        }
        
        func apply(inset: UI.Container.AccumulateInset) {
            self.overlayLayout.inset = inset.natural
        }
        
    }
    
}

private extension Screen.Editor {
    
    func _pressedUndo() {
        self.editor.undo()
    }
    
    func _pressedRedo() {
        self.editor.redo()
    }
    
    func _onHistory() {
        self.undoButton.isLocked = self.editor.canUndo == false
        self.redoButton.isLocked = self.editor.canRedo == false
    }
    
    func _onSelect(_ hit: Project.Hit?) {
    }
    
}

private extension Screen.Editor {
    
    static func _historyButton(
        title: String
    ) -> UI.View.Button {
        let normalTextColor = UI.Color(rgb: 0x101010)
        let lockedTextColor = UI.Color(rgb: 0x606060)
        let textView = UI.View.Text()
            .text(title)
            .textFont(UI.Font(weight: .bold, size: 20))
            .textColor(normalTextColor)
        return UI.View.Button()
            .height(.fixed(40))
            .background(UI.View.Rect()
                .fill(.init(rgb: 0x7a7a7a))
                .cornerRadius(.auto)
            )
            .primary(textView)
            .onStyle({ [unowned textView] button, _ in
                if button.isLocked == true {
                    textView.textColor = lockedTextColor
                } else {
                    textView.textColor = normalTextColor
                }
            })
    }
    
}
