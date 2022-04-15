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
                stroke: GraphicsStroke(
                    width: 2,
                    cap: .round,
                    fill: .color(Color(rgb: 0x202020))
                )
            ),
            wallSelect: Settings.Theme.Wall(
                stroke: GraphicsStroke(
                    width: 4,
                    cap: .round,
                    fill: .color(Color(rgb: 0x357baa))
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
            windowDrop: Settings.Theme.Manipulator(
                image: Image(name: "Window-Drop")
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
                )
            ),
            doorDrop: Settings.Theme.Manipulator(
                image: Image(name: "Door-Drop")
            )
        ),
        defaults: Settings.Defaults(
            wall: Settings.Defaults.Wall(
                thickness: 4
            ),
            window: Settings.Defaults.Window(
                offset: 8.5,
                size: SizeFloat(
                    width: 30,
                    height: 10
                )
            ),
            door: Settings.Defaults.Door(
                offset: 0,
                size: SizeFloat(
                    width: 30,
                    height: 22
                )
            )
        )
    )
    lazy var stagePlanProject: Project = {
        let project = Project(
            settings: self.stagePlanSettings
        )
        let stage = Project.Stage()
        project.append(stage: stage)
        let room = Project.Stage.Room(
            size: Size(width: 200, height: 160), thickness: 4
        )
        if let wall = room.walls.first {
            let window = Project.Stage.Room.Wall.Window(
                origin: .half,
                defaults: self.stagePlanSettings.defaults.window
            )
            wall.append(window: window)
        }
        if let wall = room.walls.last {
            let door = Project.Stage.Room.Wall.Door(
                origin: .half,
                defaults: self.stagePlanSettings.defaults.door
            )
            wall.append(door: door)
        }
        stage.append(room: room)
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
