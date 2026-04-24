import QtQuick 2.15
import QtQuick3D 1.15
import "../utils.js" as Utils

View3D {
    id:viewRoot

    property var game
    property string gameSystem: viewRoot.game ? viewRoot.game.collections.get(0).shortName : ""

    property url imageSource: viewRoot.game ? Utils.boxArt(viewRoot.game, "boxFull") : ""

    //to manage box overlays if exists
    property url imageSourceFrontOverlay: "../assets/images/boxes/" + gameSystem + "_front.png"
    property url imageSourceFrontOverlayBackSide: "../assets/images/boxes/" + gameSystem + "_front_backside.png"
    property url imageSourceBackOverlay: "../assets/images/boxes/" + gameSystem + "_back.png"
    property url imageSourceBackOverlayBackSide: "../assets/images/boxes/" + gameSystem + "_back_backside.png"
    property url imageSourceSpineOverlay: "../assets/images/boxes/" + gameSystem + "_spine.png"

    // Internal property to hold current dimensions
    readonly property var dims: getBoxDimensions(viewRoot.gameSystem)

    // Environment setup optimized for VM
    environment: SceneEnvironment {
        antialiasingMode: SceneEnvironment.MSAA
        antialiasingQuality: SceneEnvironment.High
    }

    // Function to get box dimensions and UV mapping based on the system
    function getBoxDimensions(system) {
        let d = { w: 1.4, h: 2.0, t: 0.35 }; // Default proportions (NeoGeo style)
        let uv = {
            front: { s: 0.42, p: 0.58 },
            spine: { s: 0.15, p: 0.43 },
            back:  { s: 0.43, p: 0.00 }
        };

        if (system === "neogeo") {
            d = { w: 1.45, h: 2.0, t: 0.32 };
            uv = { front: { s: 0.4558, p: 0.55 }, spine: { s: 0.075, p: 0.46 }, back: { s: 0.4540, p: 0.00 } };
        }

        // Return everything in a single object
        return {
            // Box sizes
            width: d.w,
            height: d.h,
            thickness: d.t,

            // Calculate offsets based on scale (1 unit in scale = 50 units in position for #Cube)
            zOffset: (d.t * 100) / 2,
            xOffset: (d.w * 100) / 2,
            yOffset: (d.h * 100) / 2,

            // UV Mapping settings: This defines WHICH part of the texture image is displayed on each face.
            // Think of the texture as a 0.0 to 1.0 coordinate system (0% to 100% of the image width).

            // uvFrontS / uvBackS / uvSpineS (Scale):
            //   Determines the horizontal WIDTH of the slice taken from the image.
            //   Example: 0.42 means this face displays 42% of the total image width.

            // uvFrontP / uvBackP / uvSpineP (Position):
            //   Determines the horizontal STARTING POINT (offset) of the slice.
            //   Example: 0.58 means the slice starts at 58% from the left edge of the image.

            uvFrontS: uv.front.s, uvFrontP: uv.front.p, // Slice for the Front cover
            uvSpineS: uv.spine.s, uvSpineP: uv.spine.p, // Slice for the narrow Spine
            uvBackS:  uv.back.s,  uvBackP:  uv.back.p   // Slice for the Back cover
        };
    }

    // Parent Node to group all faces. Rotating this node rotates the entire box.
    Node {
        id: boxParent
        position: Qt.vector3d(0, 0, 0)

        // --- 1. FRONT FACE ---
        Model {
            id: frontFace
            source: "#Rectangle"
            scale: Qt.vector3d(viewRoot.dims.width, viewRoot.dims.height, 1)
            z: viewRoot.dims.zOffset
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseMap: Texture {
                        source: viewRoot.imageSource
                        // Mapping remains identical to your previous logic
                        scaleU: viewRoot.dims.uvFrontS
                        positionU: viewRoot.dims.uvFrontP
                        // Ensures the texture doesn't wrap unexpectedly
                        tilingModeHorizontal: Texture.ClampToEdge
                        tilingModeVertical: Texture.ClampToEdge
                    }
                }
            ]
        }

        // --- 1bis. FRONT OVERLAY (The SNK Plastic Border) ---
        Model {
            id: frontOverlay
            // Hide it visually
            visible: (viewRoot.imageSourceFrontOverlay == "") ? false : true
            opacity: visible ? 1.0 : 0.0
            // This stops the engine from processing the #Cube geometry entirely.
            source: visible ? "#Rectangle" : ""
            // 1. Define the scale (e.g., 8% larger in width and height)
            property real scaleWidthFactor: 1.14
            property real scaleHeightFactor: 1.03
            scale: Qt.vector3d(viewRoot.dims.width * scaleWidthFactor,
                               viewRoot.dims.height * scaleHeightFactor,
                               1)
            // 2. Calculate the X offset to align the right edges
            // Formula: (OverlayWidth - BoxWidth) / 2
            // We move it to the left (negative X)
            x: (viewRoot.dims.xOffset * scaleWidthFactor) - viewRoot.dims.xOffset
            // 3. Position in front
            z: frontFace.z + 1
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseColor: "white"
                    diffuseMap: Texture {
                        source: viewRoot.imageSourceFrontOverlay
                        tilingModeHorizontal: Texture.ClampToEdge
                        tilingModeVertical: Texture.ClampToEdge
                    }
                }
            ]
        }

        // --- 1ter. FRONT OVERLAY (The SNK Plastic Border) - 3D BACK SIDE (if needed) ---
        Model {
            id: frontOverlay_back
            // Hide it visually
            visible: (viewRoot.imageSourceFrontOverlayBackSide == "") ? false : true
            opacity: visible ? 1.0 : 0.0
            // This stops the engine from processing the #Cube geometry entirely.
            source: visible ? "#Rectangle" : ""
            property real scaleWidthFactor: 1.14
            property real scaleHeightFactor: 1.03
            scale: Qt.vector3d((viewRoot.dims.width * scaleWidthFactor),
                               (viewRoot.dims.height * scaleHeightFactor),
                               1)
            // X offset logic remains the same
            x: (viewRoot.dims.xOffset * scaleWidthFactor) - viewRoot.dims.xOffset
            // Position in back
            z: frontFace.z - 1
            // Rotate 180 degrees so the "front" of the plane faces the back
            eulerRotation.y: 180
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseColor: "white"
                    diffuseMap: Texture {
                        source: viewRoot.imageSourceFrontOverlayBackSide
                        tilingModeHorizontal: Texture.ClampToEdge
                        tilingModeVertical: Texture.ClampToEdge
                        scaleU: -1
                        positionU: 1
                    }
                }
            ]
        }
        // --- 2. THE SPINE (Left Side) ---
        Model {
            id: spineFace
            source: "#Rectangle"
            scale: Qt.vector3d(viewRoot.dims.thickness, viewRoot.dims.height, 1)
            x: -viewRoot.dims.xOffset
            // Rotate the plane to face the side (ZY plane)
            eulerRotation.y: -90
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseMap: Texture {
                        source: viewRoot.imageSource
                        scaleU: viewRoot.dims.uvSpineS
                        positionU: viewRoot.dims.uvSpineP
                        tilingModeHorizontal: Texture.ClampToEdge
                        tilingModeVertical: Texture.ClampToEdge
                    }
                }
            ]
        }

        // --- 2bis. SPINE OVERLAY (The SNK Plastic Border) ---
        Model {
            id: spinOverlay
            // Hide it visually
            visible: (viewRoot.imageSourceSpineOverlay == "") ? false : true
            opacity: visible ? 1.0 : 0.0
            // This stops the engine from processing the #Cube geometry entirely.
            source: visible ? "#Rectangle" : ""
            // 1. Define the scale (e.g., 8% larger in width and height)
            property real scaleWidthFactor: 1.05
            property real scaleHeightFactor: 1.03
            scale: Qt.vector3d(viewRoot.dims.thickness * scaleWidthFactor,
                               viewRoot.dims.height * scaleHeightFactor,
                               1)
            x: - (viewRoot.dims.xOffset + 1)
            // Rotate the plane to face the side (ZY plane)
            eulerRotation.y: -90
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseColor: "white"
                    diffuseMap: Texture {
                        source: viewRoot.imageSourceSpineOverlay
                        tilingModeHorizontal: Texture.ClampToEdge
                        tilingModeVertical: Texture.ClampToEdge
                    }
                }
            ]
        }

        // --- 3. BACK FACE ---
        Model {
            id: backFace
            source: "#Rectangle"
            scale: Qt.vector3d(viewRoot.dims.width, viewRoot.dims.height, 0.001)
            z: -viewRoot.dims.zOffset
            eulerRotation.y: 180
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseMap: Texture {
                        source: viewRoot.imageSource
                        scaleU: viewRoot.dims.uvBackS
                        positionU: viewRoot.dims.uvBackP
                    }
                }
            ]
        }

        // --- 3bis. BACK OVERLAY (The SNK Plastic Border) ---
        Model {
            id: backOverlay

            // Hide it visually
            visible: (viewRoot.imageSourceBackOverlay == "") ? false : true
            opacity: visible ? 1.0 : 0.0

            // This stops the engine from processing the #Cube geometry entirely.
            source: visible ? "#Rectangle" : ""

            // 1. Define the scale (e.g., 8% larger in width and height)
            property real scaleWidthFactor: 1.14
            property real scaleHeightFactor: 1.03
            scale: Qt.vector3d(viewRoot.dims.width * scaleWidthFactor,
                               viewRoot.dims.height * scaleHeightFactor,
                               1)
            eulerRotation.y: 180
            // 2. Calculate the X offset to align the right edges
            // Formula: (OverlayWidth - BoxWidth) / 2
            // We move it to the left (negative X)
            x: (viewRoot.dims.xOffset * scaleWidthFactor) - viewRoot.dims.xOffset

            // 3. Position in front
            z: backFace.z - 1
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseColor: "white"
                    diffuseMap: Texture {
                        source: viewRoot.imageSourceBackOverlay
                        tilingModeHorizontal: Texture.ClampToEdge
                        tilingModeVertical: Texture.ClampToEdge
                    }
                }
            ]
        }

        // --- 3ter. BACK OVERLAY (The SNK Plastic Border) - 3D BACK SIDE (if needed) ---
        Model {
            id: backOverlay_back

            // Hide it visually
            visible: (viewRoot.imageSourceBackOverlayBackSide == "") ? false : true
            opacity: visible ? 1.0 : 0.0

            // This stops the engine from processing the #Cube geometry entirely.
            source: visible ? "#Rectangle" : ""

            // 1. Define the scale (e.g., 8% larger in width and height)
            property real scaleWidthFactor: 1.14
            property real scaleHeightFactor: 1.03
            //eulerRotation.y: 180
            scale: Qt.vector3d(viewRoot.dims.width * scaleWidthFactor,
                               viewRoot.dims.height * scaleHeightFactor,
                               0.01)

            // 2. Calculate the X offset to align the right edges
            // Formula: (OverlayWidth - BoxWidth) / 2
            // We move it to the left (negative X)
            x: (viewRoot.dims.xOffset * scaleWidthFactor) - viewRoot.dims.xOffset

            // 3. Position in back
            z: backFace.z + 1
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseColor: "white"
                    diffuseMap: Texture {
                        source: viewRoot.imageSourceBackOverlayBackSide
                        tilingModeHorizontal: Texture.ClampToEdge
                        tilingModeVertical: Texture.ClampToEdge
                        scaleU: -1
                        positionU: 1
                    }
                }
            ]
        }


        // --- 4. RIGHT SIDE ---
        Model {
            id: rightFace
            source: "#Rectangle"
            scale: Qt.vector3d(viewRoot.dims.thickness, viewRoot.dims.height, 1)
            x: viewRoot.dims.xOffset
            // Rotate 90 degrees to face the right side
            eulerRotation.y: 90
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseColor: "black"
                }
            ]
        }

        // --- 5. TOP FACE ---
        Model {
            id: topFace
            source: "#Rectangle"
            scale: Qt.vector3d(viewRoot.dims.width / 100, viewRoot.dims.thickness / 100, 1)
            y: viewRoot.dims.yOffset
            // Rotate -90 degrees around X to face upwards
            eulerRotation.x: -90
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseColor: "black"
                }
            ]
        }

        // --- 6. BOTTOM FACE ---
        Model {
            id: bottomFace
            source: "#Rectangle"
            scale: Qt.vector3d(viewRoot.dims.width / 100, viewRoot.dims.thickness / 100, 1)
            y: -viewRoot.dims.yOffset
            // Rotate 90 degrees around X to face downwards
            eulerRotation.x: 90
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseColor: "black"
                }
            ]
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
