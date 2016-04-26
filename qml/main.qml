/*
  This file is part of the qt-arsdk project examples.

  Copyright © 2015-2016 Tom Swindell <t.swindell@rubyx.co.uk>
  All Rights Reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.

    2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.

    3. The name of the author may not be used to endorse or promote products
    derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY Tom Swindell "AS IS" AND ANY EXPRESS OR IMPLIED
  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/
import QtQuick 2.5

import ARSDK 1.0
import Material 0.3

ApplicationWindow {
    id: main

    property real altitude
    property real latitude
    property real longitude

    property real pitch
    property real roll
    property real yaw

    property real speedX
    property real speedY
    property real speedZ

    property real percent

    property real pan
    property real tilt

    visible: true

    title: qsTr("Qt ARSDK Example")

    theme {
        primaryColor: 'blue'
        accentColor: 'red'
        tabHighlightColor: 'white'
    }

    Component.onCompleted: {
        arsdk.connectToDevice("192.168.42.1");
    }

    initialPage: Page {
        id: firstPage

        title: main.title

        backAction: Action {
            name: qsTr("Menu")
            iconName: 'navigation/menu'
            onTriggered: console.log("TRIGGERED!");
        }

        Column {
            anchors {
                top: parent.top
                topMargin: 16 * Units.dp
                left: parent.left
                leftMargin: 16 * Units.dp
            }

            spacing: 8 * Units.dp

            Label {text: "Battery: " + main.altitude + "%"}

            Label {text: "Altitude: " + main.altitude}
            Label {text: "Latitude: " + main.latitude}
            Label {text: "Longitude: " + main.longitude}

            Label {text: "Pitch: " + main.pitch}
            Label {text: "Roll: " + main.roll}
            Label {text: "Yaw: " + main.yaw}

            Label {text: "Speed X: " + main.speedX}
            Label {text: "Speed Y: " + main.speedY}
            Label {text: "Speed Z: " + main.speedZ}

            Label {text: "Camera P: " + main.pan}
            Label {text: "Camera T: " + main.tilt}
        }
    }

    ARController {
        id: arsdk

        // TODO: Move to C++ plugin and implement buffers.
        function addPropertyListener(projId, className, commandName) {
            appendCommandListener(projId, className, commandName, function(params) {
                for(var k in params) main[k] = params[k];
            });
        }

        onError: {
            error.text = arsdk.errorString;
        }

        onStatusChanged: {
            switch(status)
            {
            case ARController.Connecting:
                console.log("Connecting...");
                break;

            case ARController.Connected:
                console.log("Connected");
                break;

            case ARController.Disconnected:
                console.log("Disconnected");
                break;
            }
        }

        Component.onCompleted: {
            addPropertyListener(0, 'CommonState',   'BatteryStateChanged');
            addPropertyListener(1, 'PilotingState', 'PositionChanged');
            addPropertyListener(1, 'PilotingState', 'AttitudeChanged');
            addPropertyListener(1, 'PilotingState', 'SpeedChanged');
            addPropertyListener(1, 'CameraState',   'OrientationChanged');

            appendCommandListener(1, 'PilotingState', 'FlyingStateChanged', function(params) {
                var flyingStates = ['landed', 'takingoff', 'hovering', 'flying', 'landing', 'emergency'];
                arsdk.flyingState = flyingStates[params.state];
            })

            appendCommandListener(1, 'PilotingState', 'AlertStateChanged', function(params) {
                var alertStates = ['none', 'user', 'cut_out', 'critical_battery', 'low_battery', 'too_much_angle'];
                arsdk.alertState = alertStates[params.state];
            })

            appendCommandListener(1, 'PilotingState', 'NavigateHomeStateChanged', function(params) {
                var homingStates = ['available', 'inProgress', 'unavailable', 'pending'];
                var homingStateReasons = ['userRequest', 'connectionLost', 'lowBattery', 'finished', 'stopped', 'disabled', 'enabled'];
                arsdk.homeState = homingStates[params.state];
                arsdk.homeStateReason = homingStateReasons[params.reason];
            })

            appendCommandListener(1, 'SettingsState', 'MotorErrorStateChanged', function(params) {
            })
        }
    }
}
