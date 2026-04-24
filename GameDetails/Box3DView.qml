import QtQuick 2.15
import QtQuick3D 1.15

View3D {
    id:viewRoot

    property url imageSource: ""

    // Environment setup optimized for VM
    environment: SceneEnvironment {
        antialiasingMode: SceneEnvironment.MSAA
        antialiasingQuality: SceneEnvironment.High
    }

    // Parent Node to group all faces. Rotating this node rotates the entire box.
    Node {
        id: boxParent
        position: Qt.vector3d(0, 0, 0)

        // --- 1. FRONT FACE ---
        Model {
            source: "#Cube"
            // Scale: Width 1.4, Height 2.0, Depth almost 0
            scale: Qt.vector3d(1.4, 2.0, 0.001)
            z: 17.5 // Offset by half of total thickness (35 / 2)

            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseMap: Texture {
                        source: viewRoot.imageSource
                        scaleU: 0.42     // Focus on Metal Slug artwork (Right side)
                        positionU: 0.58  // Offset to the right
                    }
                }
            ]
        }

        // --- 2. THE SPINE (Left Side) ---
        Model {
            source: "#Cube"
            // Scale: Width almost 0, Height 2.0, Depth (Thickness) 0.35
            scale: Qt.vector3d(0.001, 2.0, 0.35)
            x: -70 // Offset by half of total width (140 / 2)

            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseMap: Texture {
                        source: viewRoot.imageSource
                        scaleU: 0.15     // Focus on the thin spine area (Center)
                        positionU: 0.43  // Adjusted to center the spine title
                    }
                }
            ]
        }

        // --- 3. BACK FACE ---
        Model {
            source: "#Cube"
            scale: Qt.vector3d(1.4, 2.0, 0.001)
            z: -17.5 // Offset to the rear
            eulerRotation.y: 180 // Flip to face the back correctly

            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseMap: Texture {
                        source: viewRoot.imageSource
                        scaleU: 0.43     // Focus on back description (Left side)
                        positionU: 0.0
                    }
                }
            ]
        }

        // --- 4. RIGHT SIDE ---
        Model {
            source: "#Cube"
            scale: Qt.vector3d(0.001, 2.0, 0.35)
            x: 70
            materials: [ DefaultMaterial { lighting: DefaultMaterial.NoLighting; diffuseColor: "black" } ]
        }

        // --- 5. TOP FACE ---
        Model {
            source: "#Cube"
            scale: Qt.vector3d(1.4, 0.001, 0.35)
            y: 100
            materials: [ DefaultMaterial { lighting: DefaultMaterial.NoLighting; diffuseColor: "black" } ]
        }

        // --- 6. BOTTOM FACE ---
        Model {
            source: "#Cube"
            scale: Qt.vector3d(1.4, 0.001, 0.35)
            y: -100
            materials: [ DefaultMaterial { lighting: DefaultMaterial.NoLighting; diffuseColor: "black" } ]
        }

        // Continuous rotation animation to showcase the 3D effect
        NumberAnimation on eulerRotation.y {
            from: 0; to: 360; duration: 10000; loops: Animation.Infinite
        }
    }

    // Camera positioned to view the box
    PerspectiveCamera {
        id: camera
        // Change from 500 to 350 to zoom in (smaller number = closer)
        z: 250
    }
}
