//
//  FPDemo
//

import FloorPlan

final class Wireframe : IUIWireframe {
    
    var state: State = .menu {
        didSet {
            switch self.state {
            case .menu:
                self.container.content = UI.Container.Screen(Screen.Menu(
                    router: self
                ))
            case .scanner:
                if #available(iOS 16.0, *) {
                    self.container.content = UI.Container.Screen(Screen.Scanner(
                        router: self
                    ))
                }
            case .editor(let project):
                self.container.content = UI.Container.Screen(Screen.Editor(
                    settings: Self.editorSettings(),
                    renderSettings: Self.renderSettings(),
                    project: project
                ))
            }
        }
    }
    let container = UI.Container.State()
    
    init() {
        self.container.content = UI.Container.Screen(Screen.Menu(
            router: self
        ))
    }
    
}

extension Wireframe : IScreenMenuRouter {
    
    func scanner(_ screen: Screen.Menu) {
        self.state = .scanner
    }
    
    func editor(_ screen: Screen.Menu) {
        self.state = .editor(Self.defaultProject())
    }
    
}

@available(iOS 16.0, *)
extension Wireframe : IScreenScannerRouter {
    
    func result(_ screen: Screen.Scanner, project: Project) {
        self.state = .editor(project)
    }
    
    func result(_ screen: Screen.Scanner, error: Error) {
        self.state = .menu
    }
    
}

extension Wireframe {
    
    enum State {
        
        case menu
        case scanner
        case editor(Project)
        
    }
    
    static func defaultProject() -> FloorPlan.Project {
        let project = FloorPlan.Project(
            settings: .init(
                simplify: .init(
                    distance: .init(5, unit: .centimeters)
                )
            )
        )
        let room = project.room(
            name: "First room",
            ceilingHeight: .init(260, unit: .centimeters),
            size: .init(width: 200, height: 160, unit: .centimeters),
            thickness: .init(20, unit: .centimeters)
        )
        if let wall = room.walls.first {
            wall.window(
                origin: .half,
                offset: .init(80, unit: .centimeters),
                size: .init(width: 120, height: 140, unit: .centimeters)
            )
        }
        
        if let wall = room.walls.last {
            wall.door(
                origin: .half,
                offset: .zero,
                size: .init(width: 80, height: 220, unit: .centimeters),
                isPrimary: true
            )
        }
        return project
    }
    
    static func editorSettings() -> Editor.Settings {
        return .init(
            hit: .init(
                distance: .init(64)
            ),
            default: .init(
                room: .init(
                    ceilingHeight: .init(152, unit: .centimeters)
                ),
                roomWall: .init(
                    thickness: .init(10, unit: .centimeters)
                ),
                roomWallDoor: .init(
                    offset: .init(0),
                    size: .init(width: 35, height: 22, unit: .centimeters)
                ),
                roomWallWindow: .init(
                    offset: .init(0),
                    size: .init(width: 35, height: 10, unit: .centimeters)
                ),
                roomInset: .init(
                    size: .init(width: 80, height: 80, unit: .centimeters)
                )
            ),
            guide: .init(
                viewport: .init(
                    angle: .init(degrees: 15),
                    snap: .init(degrees: 3)
                ),
                rule: .init(
                    size: .init(10, unit: .centimeters),
                    snap: .init(3, unit: .centimeters)
                ),
                grid: .init(
                    size: .init(x: 10, y: 10, unit: .centimeters),
                    snap: .init(x: 3, y: 3, unit: .centimeters)
                ),
                lines: .init(
                    snap: .init(5, unit: .centimeters)
                )
            ),
            manipulator: .init(
                offset: .init(50),
                spacing: .init(-4),
                radius: .init(28)
            ),
            viewport: .init(
                canMove: true,
                canRotation: true,
                canScale: true,
                scaleLimit: 0.1..<2.0
            ),
            theme: .init(
                guide: .init(
                    stroke: .init(
                        width: 1,
                        dash: .init(phase: 0, lengths: [ 5, 5 ]),
                        fill: .color(.red)
                    )
                ),
                room: .init(
                    makeInset: .init(
                        image: .init(name: "Wall-MakeWindow")
                    ),
                    drop: .init(
                        image: .init(name: "Corner-Drop")
                    )
                ),
                roomCorner: .init(
                    bevel: .init(
                        image: .init(name: "Corner-Bevel")
                    ),
                    drop: .init(
                        image: .init(name: "Corner-Drop")
                    )
                ),
                roomWall: .init(
                    extrude: .init(
                        image: .init(name: "Wall-Extrude")
                    ),
                    makeDoor: .init(
                        image: .init(name: "Wall-MakeDoor")
                    ),
                    makeWindow: .init(
                        image: .init(name: "Wall-MakeWindow")
                    ),
                    drop: .init(
                        image: .init(name: "Wall-Drop")
                    )
                ),
                roomWallDoor: .init(
                    swap: .init(
                        image: .init(name: "Door-Swap")
                    ),
                    makeRoom: .init(
                        image: .init(name: "Door-MakeRoom")
                    ),
                    drop: .init(
                        image: .init(name: "Door-Drop")
                    )
                ),
                roomWallWindow: .init(
                    drop: .init(
                        image: .init(name: "Window-Drop")
                    )
                ),
                roomInset: .init(
                    rotate: .init(
                        image: .init(name: "Door-Swap")
                    ),
                    drop: .init(
                        image: .init(name: "Window-Drop")
                    )
                )
            ),
            permission: .init(
                room: [ .makeInset, .drop ],
                roomCorner: [ .move, .bevel, .drop ],
                roomWall: [ .move, .extrude, .makeDoor, .makeWindow, .drop ],
                roomWallDoor: [ .move, .swap, .makeRoom, .drop ],
                roomWallWindow: [ .move, .drop ],
                roomWallMeasurement: [ .move ],
                roomInset: [ .move, .rotate, .drop ]
            )
        )
    }
    
    static func renderSettings() -> Render.Settings {
        return .init(
            formatter: .init(
                room: .init(
                    text: .init({ input in
                        let area = input.floorArea
                        let formatter = MeasurementFormatter()
                        formatter.unitOptions = .providedUnit
                        return "\(input.name)\n\(formatter.string(from: area.to(unit: .squareMeters)))"
                    })
                ),
                roomWallMeasurement: .init(
                    text: .init({ input in
                        let formatter = MeasurementFormatter()
                        formatter.unitOptions = .providedUnit
                        return formatter.string(from: input.length.to(unit: .meters))
                    })
                ),
                roomInset: .init(
                    text: .init({ input in
                        let area = input.area
                        let formatter = MeasurementFormatter()
                        formatter.unitOptions = .providedUnit
                        return "Inset\n\(formatter.string(from: area.to(unit: .squareMeters)))"
                    })
                ),
                roomArea: .init(
                    text: .init({ input in
                        return input.name
                    })
                ),
                roomAreaEdgeMeasurement: .init(
                    text: .init({ input in
                        let formatter = MeasurementFormatter()
                        formatter.unitOptions = .providedUnit
                        return formatter.string(from: input.length.to(unit: .meters))
                    })
                )
            ),
            theme: .init(
                room: .init(
                    normal: .init(
                        shape: .init(
                            fill: .color(.init(rgb: 0x606060))
                        ),
                        name: .init(
                            attributes: [
                                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                                .foregroundColor: UIColor.red,
                                .paragraphStyle: {
                                    let style = NSMutableParagraphStyle()
                                    style.alignment = .center
                                    return style
                                }()
                            ]
                        )
                    ),
                    select: .init(
                        shape: .init(
                            fill: .color(.init(rgb: 0x606060))
                        ),
                        name: .init(
                            attributes: [
                                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                                .foregroundColor: UIColor.red,
                                .paragraphStyle: {
                                    let style = NSMutableParagraphStyle()
                                    style.alignment = .center
                                    return style
                                }()
                            ]
                        )
                    )
                ),
                roomCorner: .init(
                    normal: .init(
                        shape: .init(
                            fill: .color(.init(rgb: 0x202020))
                        ),
                        radius: .init(3)
                    ),
                    select: .init(
                        shape: .init(
                            fill: .color(.init(rgb: 0x357baa))
                        ),
                        radius: .init(6)
                    )
                ),
                roomWall: .init(
                    normal: .init(
                        shape: .init(
                            stroke: .init(
                                width: 2,
                                cap: .round,
                                fill: .color(.init(rgb: 0x202020))
                            )
                        )
                    ),
                    select: .init(
                        shape: .init(
                            stroke: .init(
                                width: 4,
                                cap: .round,
                                fill: .color(.init(rgb: 0x357baa))
                            )
                        )
                    )
                ),
                roomWallDoor: .init(
                    normal: .init(
                        frame: .init(
                            fill: .color(.gray),
                            stroke: .init(
                                width: 1,
                                fill: .color(.darkGray)
                            )
                        ),
                        leaf: .init(
                            style: .init(
                                stroke: .init(
                                    width: 1,
                                    fill: .color(.darkGray)
                                )
                            ),
                            startLocation: .init(0.05),
                            endLocation: .init(0.95)
                        )
                    ),
                    select: .init(
                        frame: .init(
                            fill: .color(.init(rgb: 0x357baa)),
                            stroke: .init(
                                width: 1,
                                fill: .color(.darkGray)
                            )
                        ),
                        leaf: .init(
                            style: .init(
                                stroke: .init(
                                    width: 1,
                                    fill: .color(.init(rgb: 0x357baa))
                                )
                            ),
                            startLocation: .init(0.05),
                            endLocation: .init(0.95)
                        )
                    )
                ),
                roomWallWindow: .init(
                    normal: .init(
                        frame: .init(
                            fill: .color(.init(rgb: 0xA4B2CB)),
                            stroke: .init(
                                width: 1,
                                fill: .color(.darkGray)
                            )
                        ),
                        casement: .init(
                            stroke: .init(
                                width: 1,
                                fill: .color(.darkGray)
                            )
                        )
                    ),
                    select: .init(
                        frame: .init(
                            fill: .color(.init(rgb: 0x357baa)),
                            stroke: .init(
                                width: 1,
                                fill: .color(.darkGray)
                            )
                        ),
                        casement: .init(
                            stroke: .init(
                                width: 1,
                                fill: .color(.darkGray)
                            )
                        )
                    )
                ),
                roomWallMeasurement: .init(
                    normal: .init(
                        arrow: .init(
                            fill: .color(.gray),
                            stroke: .init(
                                width: 0.5,
                                fill: .color(.gray)
                            )
                        ),
                        arrowSize: .init(5),
                        guide: .init(
                            stroke: .init(
                                width: 1,
                                dash: .init(phase: 0, lengths: [ 3, 3 ]),
                                fill: .color(.gray)
                            )
                        ),
                        text: .init(
                            attributes: [
                                .font: UIFont.systemFont(ofSize: 10, weight: .regular),
                                .foregroundColor: UIColor.darkGray,
                                .paragraphStyle: {
                                    let style = NSMutableParagraphStyle()
                                    style.alignment = .center
                                    return style
                                }()
                            ]
                        )
                    ),
                    select: .init(
                        arrow: .init(
                            fill: .color(.init(rgb: 0x357baa)),
                            stroke: .init(
                                width: 0.5,
                                fill: .color(.init(rgb: 0x357baa))
                            )
                        ),
                        arrowSize: .init(10),
                        guide: .init(
                            stroke: .init(
                                width: 1,
                                dash: .init(phase: 0, lengths: [ 3, 3 ]),
                                fill: .color(.init(rgb: 0x357baa))
                            )
                        ),
                        text: .init(
                            attributes: [
                                .font: UIFont.systemFont(ofSize: 10, weight: .regular),
                                .foregroundColor: UIColor.red,
                                .paragraphStyle: {
                                    let style = NSMutableParagraphStyle()
                                    style.alignment = .center
                                    return style
                                }()
                            ]
                        )
                    )
                ),
                roomInset: .init(
                    normal: .init(
                        shape: .init(
                            fill: .color(.init(rgb: 0xA4B2CB)),
                            stroke: .init(
                                width: 1,
                                fill: .color(.darkGray)
                            )
                        ),
                        name: .init(
                            attributes: [
                                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                                .foregroundColor: UIColor.red,
                                .paragraphStyle: {
                                    let style = NSMutableParagraphStyle()
                                    style.alignment = .center
                                    return style
                                }()
                            ]
                        )
                    ),
                    select: .init(
                        shape: .init(
                            fill: .color(.init(rgb: 0x357baa)),
                            stroke: .init(
                                width: 1,
                                fill: .color(.darkGray)
                            )
                        ),
                        name: .init(
                            attributes: [
                                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                                .foregroundColor: UIColor.red,
                                .paragraphStyle: {
                                    let style = NSMutableParagraphStyle()
                                    style.alignment = .center
                                    return style
                                }()
                            ]
                        )
                    )
                ),
                roomArea: .init(
                    normal: .init(
                        shape: .init(
                            fill: .color(.flax.with(alpha: 0.4))
                        ),
                        name: .init(
                            attributes: [
                                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                                .foregroundColor: UIColor.red,
                                .paragraphStyle: {
                                    let style = NSMutableParagraphStyle()
                                    style.alignment = .center
                                    return style
                                }()
                            ]
                        )
                    ),
                    select: .init(
                        shape: .init(
                            fill: .color(.flax.with(alpha: 0.8))
                        ),
                        name: .init(
                            attributes: [
                                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                                .foregroundColor: UIColor.red,
                                .paragraphStyle: {
                                    let style = NSMutableParagraphStyle()
                                    style.alignment = .center
                                    return style
                                }()
                            ]
                        )
                    )
                ),
                roomAreaCorner: .init(
                    normal: .init(
                        shape: .init(
                            fill: .color(.init(rgb: 0x202020))
                        ),
                        radius: .init(3)
                    ),
                    select: .init(
                        shape: .init(
                            fill: .color(.init(rgb: 0x357baa))
                        ),
                        radius: .init(6)
                    )
                ),
                roomAreaEdge: .init(
                    normal: .init(
                        shape: .init(
                            stroke: .init(
                                width: 2,
                                cap: .round,
                                fill: .color(.init(rgb: 0x202020))
                            )
                        )
                    ),
                    select: .init(
                        shape: .init(
                            stroke: .init(
                                width: 4,
                                cap: .round,
                                fill: .color(.init(rgb: 0x357baa))
                            )
                        )
                    )
                ),
                roomAreaEdgeMeasurement: .init(
                    normal: .init(
                        offset: .init(20),
                        arrow: .init(
                            fill: .color(.gray),
                            stroke: .init(
                                width: 0.5,
                                fill: .color(.gray)
                            )
                        ),
                        arrowSize: .init(5),
                        guide: .init(
                            stroke: .init(
                                width: 1,
                                dash: .init(phase: 0, lengths: [ 3, 3 ]),
                                fill: .color(.gray)
                            )
                        ),
                        text: .init(
                            attributes: [
                                .font: UIFont.systemFont(ofSize: 10, weight: .regular),
                                .foregroundColor: UIColor.darkGray,
                                .paragraphStyle: {
                                    let style = NSMutableParagraphStyle()
                                    style.alignment = .center
                                    return style
                                }()
                            ]
                        )
                    ),
                    select: .init(
                        offset: .init(25),
                        arrow: .init(
                            fill: .color(.init(rgb: 0x357baa)),
                            stroke: .init(
                                width: 0.5,
                                fill: .color(.init(rgb: 0x357baa))
                            )
                        ),
                        arrowSize: .init(10),
                        guide: .init(
                            stroke: .init(
                                width: 1,
                                dash: .init(phase: 0, lengths: [ 3, 3 ]),
                                fill: .color(.init(rgb: 0x357baa))
                            )
                        ),
                        text: .init(
                            attributes: [
                                .font: UIFont.systemFont(ofSize: 10, weight: .regular),
                                .foregroundColor: UIColor.red,
                                .paragraphStyle: {
                                    let style = NSMutableParagraphStyle()
                                    style.alignment = .center
                                    return style
                                }()
                            ]
                        )
                    )
                )
            )
        )
    }
    
}
