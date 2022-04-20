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
        guide: Settings.Guide(
            viewport: Settings.Guide.Viewport(
                angle: AngleFloat(degrees: 15),
                snap: AngleFloat(degrees: 3)
            ),
            rule: Settings.Guide.Rule(
                size: 10,
                snap: 3
            ),
            grid: Settings.Guide.Grid(
                size: PointFloat(x: 10, y: 10),
                snap: PointFloat(x: 3, y: 3)
            ),
            lines: Settings.Guide.Lines(
                snap: 5
            )
        ),
        manipulator: Settings.Manipulator(
            offset: 50,
            spacing: 4,
            radius: 22
        ),
        viewport: Settings.Viewport(
            canMove: true,
            canRotation: true,
            canScale: true,
            scaleLimit: 0.1..<2.0
        ),
        theme: Settings.Theme(
            room: Settings.Theme.Room(
                fill: .pattern(GraphicsPattern(
                    image: Image(name: "Wall-Pattern")
                )),
                stroke: GraphicsStroke(
                    width: 1,
                    fill: .color(Color(rgb: 0x202020))
                )
            ),
            corner: Settings.Theme.Corner(
                radius: DistanceFloat(real: 3),
                fill: .color(Color(rgb: 0x202020))
            ),
            cornerSelect: Settings.Theme.Corner(
                radius: DistanceFloat(real: 6),
                fill: .color(Color(rgb: 0x357baa))
            ),
            cornerBevel: Settings.Theme.Manipulator(
                image: Image(name: "Corner-Bevel")
            ),
            cornerDrop: Settings.Theme.Manipulator(
                image: Image(name: "Corner-Drop")
            ),
            wall: Settings.Theme.Wall(
                base: Settings.Theme.Wall.Base (
                    stroke: GraphicsStroke(
                        width: 2,
                        cap: .round,
                        fill: .color(Color(rgb: 0x202020))
                    )
                ),
                measurement: Settings.Theme.Wall.Measurement(
                    fill: .color(Color(UIColor.gray)),
                    stroke: GraphicsStroke(
                        width: 0.5,
                        fill: .color(Color(UIColor.gray))
                    )
                ),
                measurementGuide: Settings.Theme.Wall.MeasurementGuide(
                    stroke: GraphicsStroke(
                        width: 1,
                        dash: GraphicsLineDash(phase: 0, lengths: [3,3]),
                        fill: .color(Color(UIColor.gray))
                    )
                )
            ),
            wallSelect: Settings.Theme.Wall(
                base: Settings.Theme.Wall.Base (
                    stroke: GraphicsStroke(
                        width: 4,
                        cap: .round,
                        fill: .color(Color(rgb: 0x357baa))
                    )
                ),
                measurement: Settings.Theme.Wall.Measurement(
                    fill: .color(Color(UIColor.gray)),
                    stroke: GraphicsStroke(
                        width: 1,
                        fill: .color(Color(UIColor.gray))
                    )
                ),
                measurementGuide: Settings.Theme.Wall.MeasurementGuide(
                    stroke: GraphicsStroke(
                        width: 1,
                        dash: GraphicsLineDash(phase: 0, lengths: [2,1]),
                        fill: .color(Color(UIColor.gray))
                    )
                )
            ),
            wallExtrude: Settings.Theme.Manipulator(
                image: Image(name: "Wall-Extrude")
            ),
            wallDrop: Settings.Theme.Manipulator(
                image: Image(name: "Wall-Drop")
            ),
            wallMakeWindow: Settings.Theme.Manipulator(
                image: Image(name: "Wall-MakeWindow")
            ),
            wallMakeDoor: Settings.Theme.Manipulator(
                image: Image(name: "Wall-MakeDoor")
            ),
            door: Settings.Theme.Door(
                frame: Settings.Theme.Door.Frame(
                    fill: .color(Color(rgb: 0x888888)),
                    stroke: GraphicsStroke(
                        width: 1,
                        fill: .color(Color(UIColor.darkGray))
                    )
                ),
                leaf: Settings.Theme.Door.Leaf(
                    stroke: GraphicsStroke(
                        width: 1,
                        fill: .color(Color(UIColor.darkGray))
                    )
                ),
                leafStartLocation: PercentFloat(0.05),
                leafEndLocation: PercentFloat(0.95)
            ),
            doorSelect: Settings.Theme.Door(
                frame: Settings.Theme.Door.Frame(
                    fill: .color(Color(rgb: 0x357baa)),
                    stroke: GraphicsStroke(
                        width: 1,
                        fill: .color(Color(UIColor.darkGray))
                    )
                ),
                leaf: Settings.Theme.Door.Leaf(
                    stroke: GraphicsStroke(
                        width: 1,
                        fill: .color(Color(rgb: 0x357baa))
                    )
                ),
                leafStartLocation: PercentFloat(0.05),
                leafEndLocation: PercentFloat(0.95)
            ),
            doorMakeRoom: Settings.Theme.Manipulator(
                image: Image(name: "Door-MakeRoom")
            ),
            doorDrop: Settings.Theme.Manipulator(
                image: Image(name: "Door-Drop")
            ),
            window: Settings.Theme.Window(
                frame: Settings.Theme.Window.Frame(
                    fill: .color(Color(rgb: 0xA4B2CB)),
                    stroke: GraphicsStroke(
                        width: 1,
                        fill: .color(Color(UIColor.darkGray))
                    )
                ),
                casement: Settings.Theme.Window.Casement(
                    stroke: GraphicsStroke(
                        width: 1,
                        fill: .color(Color(UIColor.darkGray))
                    )
                )
            ),
            windowSelect: Settings.Theme.Window(
                frame: Settings.Theme.Window.Frame(
                    fill: .color(Color(rgb: 0x357baa)),
                    stroke: GraphicsStroke(
                        width: 1,
                        fill: .color(Color(UIColor.darkGray))
                    )
                ),
                casement: Settings.Theme.Window.Casement(
                    stroke: GraphicsStroke(
                        width: 1,
                        fill: .color(Color(UIColor.darkGray))
                    )
                )
            ),
            windowDrop: Settings.Theme.Manipulator(
                image: Image(name: "Window-Drop")
            )
        ),
        defaults: Settings.Defaults(
            wall: Settings.Defaults.Wall(
                thickness: 10
            ),
            window: Settings.Defaults.Window(
                offset: 8.5,
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
