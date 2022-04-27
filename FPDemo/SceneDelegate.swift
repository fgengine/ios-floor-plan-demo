//
//  SceneDelegate.swift
//  FPDemo
//
//  Created by Alexander Trifonov on 10.03.2022.
//

import UIKit
import KindKitMath
import KindKitView
import KindKitGraphics
import FloorPlanEditor
import FloorPlanDescription

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    lazy var stagePlanSettings = Settings(
        simplifyDistance: 5,
        selectDistance: 20,
        guide: .init(
            viewport: .init(
                angle: AngleFloat(degrees: 15),
                snap: AngleFloat(degrees: 3)
            ),
            rule: .init(
                size: 10,
                snap: 3
            ),
            grid: .init(
                size: PointFloat(x: 10, y: 10),
                snap: PointFloat(x: 3, y: 3)
            ),
            lines: .init(
                snap: 5
            )
        ),
        manipulator: .init(
            offset: 50,
            spacing: 4,
            radius: 22
        ),
        viewport: .init(
            canMove: true,
            canRotation: true,
            canScale: true,
            scaleLimit: 0.1..<2.0
        ),
        theme: .init(
            room: .init(
                style: .init(
                    fill: .color(Color(rgb: 0x606060))
                ),
                name: .init(
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                        .foregroundColor: UIColor.red,
                    ]
                )
            ),
            corner: .init(
                style: .init(
                    fill: .color(Color(rgb: 0x202020))
                ),
                radius: DistanceFloat(real: 3)
            ),
            cornerSelect: Settings.Theme.Corner(
                style: .init(
                    fill: .color(Color(rgb: 0x357baa))
                ),
                radius: DistanceFloat(real: 6)
            ),
            cornerBevel: .init(
                image: Image(name: "Corner-Bevel")
            ),
            cornerDrop: .init(
                image: Image(name: "Corner-Drop")
            ),
            wall: .init(
                stroke: GraphicsStroke(
                    width: 2,
                    cap: .round,
                    fill: .color(Color(rgb: 0x202020))
                )
            ),
            wallSelect: .init(
                stroke: GraphicsStroke(
                    width: 4,
                    cap: .round,
                    fill: .color(Color(rgb: 0x357baa))
                )
            ),
            wallExtrude: .init(
                image: Image(name: "Wall-Extrude")
            ),
            wallDrop: .init(
                image: Image(name: "Wall-Drop")
            ),
            wallMakeWindow: .init(
                image: Image(name: "Wall-MakeWindow")
            ),
            wallMakeDoor: .init(
                image: Image(name: "Wall-MakeDoor")
            ),
            door: .init(
                frame: .init(
                    fill: .color(Color(rgb: 0x888888)),
                    stroke: GraphicsStroke(
                        width: 1,
                        fill: .color(Color(UIColor.darkGray))
                    )
                ),
                leaf: .init(
                    style: .init(
                        stroke: GraphicsStroke(
                            width: 1,
                            fill: .color(Color(UIColor.darkGray))
                        )
                    ),
                    startLocation: PercentFloat(0.05),
                    endLocation: PercentFloat(0.95)
                )
            ),
            doorSelect: .init(
                frame: .init(
                    fill: .color(Color(rgb: 0x357baa)),
                    stroke: GraphicsStroke(
                        width: 1,
                        fill: .color(Color(UIColor.darkGray))
                    )
                ),
                leaf: .init(
                    style: .init(
                        stroke: GraphicsStroke(
                            width: 1,
                            fill: .color(Color(rgb: 0x357baa))
                        )
                    ),
                    startLocation: PercentFloat(0.05),
                    endLocation: PercentFloat(0.95)
                )
            ),
            doorMakeRoom: .init(
                image: Image(name: "Door-MakeRoom")
            ),
            doorDrop: .init(
                image: Image(name: "Door-Drop")
            ),
            window: .init(
                frame: .init(
                    fill: .color(Color(rgb: 0xA4B2CB)),
                    stroke: GraphicsStroke(
                        width: 1,
                        fill: .color(Color(UIColor.darkGray))
                    )
                ),
                casement: .init(
                    stroke: GraphicsStroke(
                        width: 1,
                        fill: .color(Color(UIColor.darkGray))
                    )
                )
            ),
            windowSelect: .init(
                frame: .init(
                    fill: .color(Color(rgb: 0x357baa)),
                    stroke: GraphicsStroke(
                        width: 1,
                        fill: .color(Color(UIColor.darkGray))
                    )
                ),
                casement: .init(
                    stroke: GraphicsStroke(
                        width: 1,
                        fill: .color(Color(UIColor.darkGray))
                    )
                )
            ),
            windowDrop: .init(
                image: Image(name: "Window-Drop")
            ),
            measurement: .init(
                arrow: .init(
                    fill: .color(Color(UIColor.gray)),
                    stroke: GraphicsStroke(
                        width: 0.5,
                        fill: .color(Color(UIColor.gray))
                    )
                ),
                guide: .init(
                    stroke: GraphicsStroke(
                        width: 1,
                        dash: GraphicsLineDash(phase: 0, lengths: [ 3, 3 ]),
                        fill: .color(Color(UIColor.gray))
                    )
                ),
                text: .init(
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 10, weight: .regular),
                        .foregroundColor: UIColor.darkGray,
                    ]
                )
            ),
            measurementSelect: .init(
                arrow: .init(
                    fill: .color(Color(rgb: 0x357baa)),
                    stroke: GraphicsStroke(
                        width: 0.5,
                        fill: .color(Color(rgb: 0x357baa))
                    )
                ),
                guide: .init(
                    stroke: GraphicsStroke(
                        width: 1,
                        dash: GraphicsLineDash(phase: 0, lengths: [ 3, 3 ]),
                        fill: .color(Color(rgb: 0x357baa))
                    )
                ),
                text: .init(
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 10, weight: .regular),
                        .foregroundColor: UIColor.red,
                    ]
                )
            ),
            guide: .init(
                stroke: GraphicsStroke(
                    width: 1,
                    dash: GraphicsLineDash(phase: 0, lengths: [ 5, 5 ]),
                    fill: .color(Color(UIColor.red))
                )
            )
        ),
        defaults: Settings.Defaults(
            wall: Settings.Defaults.Wall(
                thickness: 10
            ),
            window: Settings.Defaults.Window(
                offset: 0,
                size: SizeFloat(
                    width: 35,
                    height: 10
                )
            ),
            door: Settings.Defaults.Door(
                offset: 0,
                size: SizeFloat(
                    width: 35,
                    height: 22
                )
            )
        )
    )
    lazy var stagePlanProject: Project = {
        let project = Project(
            settings: self.stagePlanSettings
        )
        let stage = project.stage(
            name: "First floor"
        )
        let room = stage.room(
            name: "First room",
            size: Size(width: 200, height: 160),
            thickness: self.stagePlanSettings.defaults.wall.thickness
        )
        if let wall = room.walls.first {
            let window = wall.window(
                origin: .half,
                defaults: self.stagePlanSettings.defaults.window
            )
        }
        
        if let wall = room.walls.last {
            let door = wall.door(
                origin: .half,
                defaults: self.stagePlanSettings.defaults.door,
                isPrimary: true
            )
        }
        return project
    }()
    lazy var stagePlanEditor = FloorPlanEditor.Module()
    lazy var viewController = ViewController(
        container: RootContainer(
            contentContainer: self.stagePlanEditor.container(
                project: self.stagePlanProject
            )
        )
    )

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let scene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: scene)
            window.rootViewController = self.viewController
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
}
