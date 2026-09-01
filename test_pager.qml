import QtQuick
import org.kde.plasma.core as PlasmaCore
import plasma.applet.org.kde.plasma.pager 1.0

Item {
    width: 200
    height: 200
    PagerModel {
        id: pm
        pagerType: PagerModel.VirtualDesktops
    }
    Text {
        text: "Count: " + pm.count + " Current: " + pm.currentPage
        anchors.centerIn: parent
    }
    Component.onCompleted: {
        console.log("Pager loaded, count:", pm.count, "current:", pm.currentPage)
    }
}
