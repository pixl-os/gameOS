//created by BozoTheGeek 17/12/2022 for "gameOS-pixl (Christmas 2022 Edition)"

import QtQuick 2.0
import QtQuick.Particles 2.15

Item{
    width: parent.width
    height: parent.height
    z:300

//******************************for christmas ;-)
ParticleSystem { id: particles }

ImageParticle {
    system: particles
    sprites: Sprite {
        name: "snow"
        source: "../assets/images/snowflake.png"
        frameCount: 51
        frameDuration: 40
        frameDurationVariation: 8
    }
    z: 300
}

Wander {
    id: wanderer
    system: particles
    anchors.fill: parent
    xVariance: 30
    pace: 100
}

Emitter {
    system: particles
    emitRate: 20
    lifeSpan: 7000
    velocity: PointDirection { y:80; yVariation: 40; }
    acceleration: PointDirection { y: 3 }
    size: 20
    sizeVariation: 10
    width: parent.width
    height: 100
}
//***********************************************************
}


