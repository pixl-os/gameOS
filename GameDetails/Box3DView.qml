import QtQuick 2.15
import QtQuick3D 1.15
import "../utils.js" as Utils

View3D {
    id:viewRoot

     // Function to get box dimensions, UV mapping based and other informations on the system
    function getBoxInfo(game) {

        let system = game ? game.collections.get(0).shortName : "";
        //default value
        let validSystem = true;
        let imageSource = "";
        //to manage box overlays if exists
        let hasFrontOverlay = false;
        let hasFrontOverlayBackSide = false;
        let hasBackOverlay = false;
        let hasBackOverlayBackSide = false;
        let hasSpineOverlay = false;
        let hasLatchOverlay = false;
        let latchAjustement = 0.0;
        let hasBottomOverlay = false;
        let hasTopOverlay = false;

        let defaultColor = "white"
        let useSpineForRightFace = false;

        let zoom = 265 // zoom used usually in game view for all system
        let referenceWidth = 540 //maximum witdh in 720p for 3D view

        let d = { w: 1.4, h: 2.0, t: 0.35 }; // Default proportions (NeoGeo style)
        let o =  "" //keep empty by default, possible values : "vertical" or "horizontal"
        let uv = {
            front: { s: 0.42, p: 0.58 },
            spine: { s: 0.15, p: 0.43 },
            back:  { s: 0.43, p: 0.00 }
        };
        //console.log("getBoxInfo - system : " + system);
        //***************************** part to add/change/update by system *************************************
        if (system === "neogeo") {
            zoom = 265 // zoom used usally in game view for neogeo
            d = { w: 1.45, h: 2.0, t: 0.32 };
            uv = { front: { s: 0.4558, p: 0.55 },
                   spine: { s: 0.075, p: 0.46 },
                   back: { s: 0.4540, p: 0.00 }
            };
            o = "vertical";
            hasFrontOverlay = true;
            hasFrontOverlayBackSide = true;
            hasBackOverlay = true;
            hasBackOverlayBackSide = true;
            hasSpineOverlay = true;
            hasLatchOverlay = true;
            latchAjustement = 10.0;
        }
        else if (system === "snes") { //box orientation is usually horizontal
            //console.log("game.title : " + game.title);
            if(game.title.toLowerCase().includes("(japan)")){
                //console.log("region : japan");
                let d = { w: 1.09, h: 2.0, t: 0.31 };
                uv = { front: { s: 0.43, p: 0.57 },
                       spine: { s: 0.1238, p: 0.44 },
                       back: { s: 0.43, p: 0.00 }
                };
                o =  "vertical";
                useSpineForRightFace = true;
            }
            else{
                //console.log("region : other");
                let d = { w: 1.41, h: 2.0, t: 0.36 };
                uv = { front: { s: 0.455, p: 0.545 },
                       spine: { s: 0.089, p: 0.455 },
                       back: { s: 0.45, p: 0.00 }
                };
                o =  "horizontal";
                useSpineForRightFace = true;
            }
        }
        else{
            validSystem = false;
        }
        // for texture from scrap
        if(validSystem){
            imageSource = game ? Utils.boxArt(game, "boxFull") : "";
        }
        else{
            imageSource = ""
        }
        //******************************************************************************************************

        // Return everything in a single object
        return {
            //box system
            system: system,
            //image source of texture
            imageSource: imageSource,
            // Box sizes
            width: d.w,
            height: d.h,
            thickness: d.t,
            //Box texture orientation
            orientation: o, // "horizontal" or "vertical"
            //BoxOverlay to put in front of textures and by faces
            hasFrontOverlay: imageSource != "" ? hasFrontOverlay : false,
            hasFrontOverlayBackSide: imageSource != "" ? hasFrontOverlayBackSide : false,
            hasBackOverlay: imageSource != "" ? hasBackOverlay : false,
            hasBackOverlayBackSide: imageSource != "" ? hasBackOverlayBackSide : false,
            hasSpineOverlay: imageSource != "" ? hasSpineOverlay : false,
            hasLatchOverlay: imageSource != "" ? hasLatchOverlay : false,
            latchAjustement: latchAjustement,
            hasTopOverlay: imageSource != "" ? hasTopOverlay : false,
            hasBottomOverlay: imageSource != "" ? hasBottomOverlay : false,

            //default color to replace texture if missing
            defaultColor: defaultColor,
            useSpineForRightFace: useSpineForRightFace,
            zoom: zoom,

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

    property var game
    property var box
    property url imageSource
    property string previousOrientation: ""

    //to manage box overlays if exists in this theme
    property url imageSourceFrontOverlay
    property url imageSourceFrontOverlayBackSide
    property url imageSourceBackOverlay
    property url imageSourceBackOverlayBackSide
    property url imageSourceSpineOverlay
    property url imageSourceLatchOverlay
    property url imageSourceTopOverlay
    property url imageSourceBottomOverlay

// 1. Create a private flag initialized to false
    property bool _isComponentReady: false
    
    Component.onCompleted: {
        //console.log("Visible width of View3D is now (on Completed):", width)
        
        // 2. Set the flag to true now that the component is fully built
        _isComponentReady = true
        
        // Optional: If game was already changed during startup, 
        // run the logic once right here now that we are ready
        if (width > 0) {
            executeGameLogic()
        }
    }
    onGameChanged:{
        // 3. Guard clause: Ignore the signal if the component isn't ready yet
        if (!_isComponentReady)
            return;
            
        // 4. Guard clause: Ensure we have a valid layout size
        if (width === 0)
            return;
        executeGameLogic()
    }
    
    function executeGameLogic(){
        //console.log("onGameChanged")
        //viewRoot.game ? console.log("game.title : " + game.title) : console.log("game.title : " + "");
        
        //console.log("viewRoot.imageSource : " + viewRoot.imageSource);
        //console.log("animation3D.property : " + animation3D.property);
        //console.log("previousOrientation : " + previousOrientation);
        //check if image exists and if any orientation exixts (if not, it's not configured and deactivated by default)
        viewRoot.box = viewRoot.game ? getBoxInfo(viewRoot.game) : nil
        viewRoot.imageSource = viewRoot.box.imageSource
        //to manage box overlays if exists in this theme
        viewRoot.imageSource = viewRoot.box.imageSource
        viewRoot.imageSourceFrontOverlay = viewRoot.box.hasFrontOverlay ?  "../assets/images/boxes/" + viewRoot.box.system + "_front.png" : ""
        viewRoot.imageSourceFrontOverlayBackSide = viewRoot.box.hasFrontOverlayBackSide ? "../assets/images/boxes/" + viewRoot.box.system + "_front_backside.png" : ""
        viewRoot.imageSourceBackOverlay = viewRoot.box.hasBackOverlay ? "../assets/images/boxes/" + viewRoot.box.system + "_back.png" : ""
        viewRoot.imageSourceBackOverlayBackSide = viewRoot.box.hasBackOverlayBackSide ? "../assets/images/boxes/" + viewRoot.box.system + "_back_backside.png" : ""
        viewRoot.imageSourceSpineOverlay = viewRoot.box.hasSpineOverlay ? "../assets/images/boxes/" + viewRoot.box.system + "_spine.png" : ""
        viewRoot.imageSourceLatchOverlay = viewRoot.box.hasLatchOverlay ? "../assets/images/boxes/" + viewRoot.box.system + "_latch.png" : ""
        viewRoot.imageSourceTopOverlay = viewRoot.box.hasTopOverlay ? "../assets/images/boxes/" + viewRoot.box.system + "_top.png" : ""
        viewRoot.imageSourceBottomOverlay = viewRoot.box.hasBottomOverlay ? "../assets/images/boxes/" + viewRoot.box.system + "_bottom.png" : ""

        if(viewRoot.imageSource != ""){
            if(viewRoot.box.orientation !== ""){
                //console.log("viewRoot.box.orientation : " + viewRoot.box.orientation);
                if(previousOrientation !== viewRoot.box.orientation){
                    //stop animation during update
                    animation3D.running = false;
                    viewRoot.update();
                    animation3D.running = true;
                }
            }
        }
        else{
            //stop animation during update
            animation3D.running = false;
        }
        previousOrientation = viewRoot.imageSource != "" ? viewRoot.box.orientation : "";
        //console.log("new previousOrientation : " + previousOrientation);
    }

    // Environment setup optimized for VM
    environment: SceneEnvironment {
        antialiasingMode: SceneEnvironment.MSAA
        antialiasingQuality: SceneEnvironment.High
    }

    // Parent Node to group all faces. Rotating this node rotates the entire box.
    Node {
        id: boxParent
        position: Qt.vector3d(0, 0, 0)
        
        Component.onDestruction: {
        //console.log("Component.onDestruction")
        
        // 1. Instantly stop the animation to release the property binding
        animation3D.stop();
        
        // 2. Clear out the meshes to prevent the engine from rendering 
        // a final frame with missing/null textures
        frontFace.source = "";
        frontOverlay.source = "";
        frontOverlay_back.source = "";
        spineFace.source = "";
        spinOverlay.source = "";
        backFace.source = "";
        backOverlay.source = "";
        backOverlay_back.source = "";
        rightFace.source = "";
        latchOverlay.source = "";
        topFace.source = "";
        bottomFace.source = "";
        }

        // --- 1. FRONT FACE ---
        Model {
            id: frontFace
            // Hide it visually
            visible: (viewRoot.imageSource == "") ? false : true
            opacity: visible ? 1.0 : 0.0
            // This stops the engine from processing the #Cube geometry entirely.
            source: visible ? "#Rectangle" : ""
            scale: Qt.vector3d(viewRoot.box.width, viewRoot.box.height, 1)
            z: viewRoot.box.zOffset
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseColor: viewRoot.box.defaultColor
                    diffuseMap: Texture {
                        source: viewRoot.imageSource
                        // Mapping remains identical to your previous logic
                        scaleU: viewRoot.box.uvFrontS
                        positionU: viewRoot.box.uvFrontP
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
            scale: Qt.vector3d(viewRoot.box.width * scaleWidthFactor,
                               viewRoot.box.height * scaleHeightFactor,
                               1)
            // 2. Calculate the X offset to align the right edges
            // Formula: (OverlayWidth - BoxWidth) / 2
            // We move it to the left (negative X)
            x: (viewRoot.box.xOffset * scaleWidthFactor) - viewRoot.box.xOffset
            // 3. Position in front
            z: frontFace.z + 1
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseColor: viewRoot.box.defaultColor
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
            scale: Qt.vector3d((viewRoot.box.width * scaleWidthFactor),
                               (viewRoot.box.height * scaleHeightFactor),
                               1)
            // X offset logic remains the same
            x: (viewRoot.box.xOffset * scaleWidthFactor) - viewRoot.box.xOffset
            // Position in back
            z: frontFace.z - 1
            // Rotate 180 degrees so the "front" of the plane faces the back
            eulerRotation.y: 180
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseColor: viewRoot.box.defaultColor
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
            // Hide it visually
            visible: (viewRoot.imageSource == "") ? false : true
            opacity: visible ? 1.0 : 0.0
            // This stops the engine from processing the #Cube geometry entirely.
            source: visible ? "#Rectangle" : ""
            scale: Qt.vector3d(viewRoot.box.thickness, viewRoot.box.height, 1)
            x: -viewRoot.box.xOffset
            // Rotate the plane to face the side (ZY plane)
            eulerRotation.y: -90
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseColor: viewRoot.box.defaultColor
                    diffuseMap: Texture {
                        source: viewRoot.imageSource
                        scaleU: viewRoot.box.uvSpineS
                        positionU: viewRoot.box.uvSpineP
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
            scale: Qt.vector3d(viewRoot.box.thickness * scaleWidthFactor,
                               viewRoot.box.height * scaleHeightFactor,
                               1)
            x: - (viewRoot.box.xOffset + 1)
            // Rotate the plane to face the side (ZY plane)
            eulerRotation.y: -90
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseColor: viewRoot.box.defaultColor
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
            // Hide it visually
            visible: (viewRoot.imageSource == "") ? false : true
            opacity: visible ? 1.0 : 0.0
            // This stops the engine from processing the #Cube geometry entirely.
            source: visible ? "#Rectangle" : ""
            scale: Qt.vector3d(viewRoot.box.width, viewRoot.box.height, 0.001)
            z: -viewRoot.box.zOffset
            eulerRotation.y: 180
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseColor: viewRoot.box.defaultColor
                    diffuseMap: Texture {
                        source: viewRoot.imageSource
                        scaleU: viewRoot.box.uvBackS
                        positionU: viewRoot.box.uvBackP
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
            scale: Qt.vector3d(viewRoot.box.width * scaleWidthFactor,
                               viewRoot.box.height * scaleHeightFactor,
                               1)
            eulerRotation.y: 180
            // 2. Calculate the X offset to align the right edges
            // Formula: (OverlayWidth - BoxWidth) / 2
            // We move it to the left (negative X)
            x: (viewRoot.box.xOffset * scaleWidthFactor) - viewRoot.box.xOffset

            // 3. Position in front
            z: backFace.z - 1
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseColor: viewRoot.box.defaultColor
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
            scale: Qt.vector3d(viewRoot.box.width * scaleWidthFactor,
                               viewRoot.box.height * scaleHeightFactor,
                               0.01)

            // 2. Calculate the X offset to align the right edges
            // Formula: (OverlayWidth - BoxWidth) / 2
            // We move it to the left (negative X)
            x: (viewRoot.box.xOffset * scaleWidthFactor) - viewRoot.box.xOffset

            // 3. Position in back
            z: backFace.z + 1
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseColor: viewRoot.box.defaultColor
                    diffuseMap: Texture {
                        source: viewRoot.imageSourceBackOverlayBackSide
                        //tilingModeHorizontal: Texture.ClampToEdge
                        //tilingModeVertical: Texture.ClampToEdge
                        scaleU: -1
                        positionU: 1
                    }
                }
            ]
        }

        // --- 4. RIGHT FACE ---
        Model {
            id: rightFace
            // Hide it visually
            visible: ((viewRoot.imageSource !== "") && viewRoot.box.useSpineForRightFace) ? true : false
            opacity: visible ? true : false
            // This stops the engine from processing the #Cube geometry entirely.
            source: visible ? "#Rectangle" : ""
            scale: Qt.vector3d(viewRoot.box.thickness, viewRoot.box.height, 1)
            x: viewRoot.box.xOffset + viewRoot.box.latchAjustement
            // Rotate 90 degrees to face the right side
            eulerRotation.y: 90
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseColor: viewRoot.box.defaultColor
                    diffuseMap: Texture {
                        source: viewRoot.imageSource
                        scaleU: viewRoot.box.uvSpineS
                        positionU: viewRoot.box.uvSpineP
                        tilingModeHorizontal: Texture.ClampToEdge
                        tilingModeVertical: Texture.ClampToEdge
                    }
                }
            ]
        }

        // --- 4bis. RIGHT OVERLAY - Latch Overlay ---
        Model {
            id: latchOverlay
            // Hide it visually
            visible: viewRoot.imageSourceLatchOverlay == "" ? false : true
            opacity: visible ? true : false
            // This stops the engine from processing the #Cube geometry entirely.
            source: visible ? "#Rectangle" : ""
            // 1. Define the scale (e.g., 8% larger in width and height)
            property real scaleWidthFactor: 1.05
            property real scaleHeightFactor: 1.03
            scale: Qt.vector3d(viewRoot.box.thickness * scaleWidthFactor,
                               viewRoot.box.height * scaleHeightFactor,
                               1)
            x: viewRoot.box.xOffset + viewRoot.box.latchAjustement
            // Rotate 90 degrees to face the right side
            eulerRotation.y: 90
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseColor: viewRoot.box.defaultColor
                    diffuseMap: Texture {
                        source: viewRoot.imageSourceLatchOverlay
                        tilingModeHorizontal: Texture.ClampToEdge
                        tilingModeVertical: Texture.ClampToEdge
                    }
                }
            ]
        }

        // --- 5. TOP FACE ---
        Model {
            id: topFace
            source: "#Rectangle"
            scale: Qt.vector3d(viewRoot.box.width, viewRoot.box.thickness, 1)
            y: viewRoot.box.yOffset
            // Rotate -90 degrees around X to face upwards
            eulerRotation.x: -90
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseColor: viewRoot.box.defaultColor
                }
            ]
        }

        // --- 6. BOTTOM FACE ---
        Model {
            id: bottomFace
            source: "#Rectangle"
            scale: Qt.vector3d(viewRoot.box.width, viewRoot.box.thickness, 1)
            y: -viewRoot.box.yOffset
            // Rotate 90 degrees around X to face downwards
            eulerRotation.x: 90
            materials: [
                DefaultMaterial {
                    lighting: DefaultMaterial.NoLighting
                    diffuseColor: viewRoot.box.defaultColor
                }
            ]
        }

        // Continuous rotation animation to showcase the 3D effect
        NumberAnimation {
            id: animation3D
            target: boxParent
            property: "eulerRotation." + ((viewRoot.box.orientation === "horizontal") ? "x" : "y" ) // Dynamically build the property string
            from: 0; to: 360; duration: 10000; loops: Animation.Infinite
            running: viewRoot.enabled

            // When 'running' becomes false, snap the rotation back to 0
            onRunningChanged: {
                if (!running) {
                    //console.log("previousOrientation : " + previousOrientation);
                    //console.log("viewRoot.box.orientation : " + viewRoot.box.orientation);
                    if(previousOrientation !== viewRoot.box.orientation){
                        //console.log("reset rotation values !!!!");
                        boxParent.eulerRotation.x = 0;
                        boxParent.eulerRotation.y = 0;
                        if(viewRoot.box.orientation === "horizontal"){
                            boxParent.eulerRotation.z = 90;
                        }
                        else{
                            boxParent.eulerRotation.z = 0;
                        }
                    }
                }
            }
        }
    }

    // Camera positioned to view the box
    PerspectiveCamera {
        id: camera
        z: viewRoot.box.zoom
    }
}
