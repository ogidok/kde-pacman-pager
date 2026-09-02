pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.taskmanager as TaskManager
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root

    readonly property bool isVertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical

    Layout.minimumWidth: isVertical ? Kirigami.Units.gridUnit : Kirigami.Units.gridUnit * 2
    Layout.minimumHeight: isVertical ? Kirigami.Units.gridUnit * 2 : Kirigami.Units.gridUnit
    
    Layout.fillWidth: !isVertical
    Layout.fillHeight: isVertical

    readonly property var ghostColors: ["#FF0000", "#FFB8FF", "#00FFFF", "#FFB852"]

    TaskManager.VirtualDesktopInfo {
        id: desktopInfo
    }

    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: (sourceName, data) => {
            disconnectSource(sourceName);
        }
    }

    GridLayout {
        anchors.centerIn: parent
        rowSpacing: Kirigami.Units.largeSpacing
        columnSpacing: Kirigami.Units.largeSpacing

        rows: root.isVertical ? desktopInfo.numberOfDesktops : 1
        columns: root.isVertical ? 1 : desktopInfo.numberOfDesktops

        Repeater {
            model: desktopInfo.numberOfDesktops

            delegate: PlasmaCore.ToolTipArea {
                id: delegateRoot
                
                required property int index
                
                readonly property string desktopId: String(desktopInfo.desktopIds[index] || "")
                readonly property string desktopName: desktopInfo.desktopNames[index]
                
                mainText: desktopName

                readonly property bool isCurrent: desktopId !== "" && String(desktopInfo.currentDesktop) === desktopId
                
                TaskManager.TasksModel {
                    id: tasksModel
                    filterByVirtualDesktop: true
                    virtualDesktop: desktopInfo.desktopIds[index]
                }

                readonly property bool hasWindows: tasksModel.count > 0
                readonly property bool shouldShow: isCurrent || hasWindows

                visible: opacity > 0 || shouldShow
                opacity: shouldShow ? (mouseArea.containsMouse ? 0.7 : 1.0) : 0.0
                
                Layout.preferredWidth: shouldShow ? (contentText.implicitWidth + Kirigami.Units.smallSpacing * 2) : 0
                Layout.preferredHeight: shouldShow ? (contentText.implicitHeight + Kirigami.Units.smallSpacing * 2) : 0
                Layout.alignment: Qt.AlignCenter

                Behavior on opacity {
                    NumberAnimation { duration: Kirigami.Units.shortDuration }
                }
                Behavior on Layout.preferredWidth {
                    NumberAnimation { duration: Kirigami.Units.shortDuration }
                }
                Behavior on Layout.preferredHeight {
                    NumberAnimation { duration: Kirigami.Units.shortDuration }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        let cmd = 'dbus-send --session --dest=org.kde.KWin /VirtualDesktopManager org.freedesktop.DBus.Properties.Set string:"org.kde.KWin.VirtualDesktopManager" string:"current" variant:string:"' + delegateRoot.desktopId + '"';
                        executable.connectSource(cmd);
                    }
                }

                Text {
                    id: contentText
                    anchors.centerIn: parent
                    
                    text: delegateRoot.isCurrent ? "󰮯" : "󰊠"
                    color: delegateRoot.isCurrent ? Kirigami.Theme.highlightColor : root.ghostColors[index % root.ghostColors.length]
                    font.pixelSize: Kirigami.Theme.defaultFont.pixelSize * 1.5
                    
                    Behavior on color {
                        ColorAnimation { duration: Kirigami.Units.shortDuration }
                    }
                }

                Component.onCompleted: {
                    console.log("Desktop", index, "ID:", desktopId, "Current:", String(desktopInfo.currentDesktop), "isCurrent:", isCurrent, "hasWindows:", hasWindows)
                }
            }
        }
    }
}
