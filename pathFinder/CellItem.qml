import QtQuick 2.0

Rectangle {
    id: cell
    property int type: 0
    // 0 -- simple cell
    // 1 -- obstacle
    // 2 -- start cell
    // 3 -- end cell
    width: 16; height: 16
    color: "lightgreen"
    border.color: "white"
    border.width: 1
    radius: 3

    Text {
        anchors.centerIn: parent
        id: text
        color: "darkred"
        font.pointSize: 10
    }


    function highLight(dir){
        if(dir!==''){
            color = "white";
            text.text = dir;
        }
        else{
            color = "lightgreen";
            text.text = "";
        }
    }

    function setObstacle(ttype){
        type = ttype;
        updateColor();
    }

    function setStart(){
        // clear previous cell
        var prevCellItem = grid.children[startIndex];
        prevCellItem.type = 0;
        prevCellItem.updateColor();

        // set start cell
        startIndex = index;
        type = 2;
        updateColor();
    }

    function setEnd(){
        // clear previous cell
        var prevCellItem = grid.children[endIndex];
        prevCellItem.type = 0;
        prevCellItem.updateColor();

        // set start cell
        endIndex = index;
        type = 3;
        updateColor();
    }

    function updateColor(){
        switch(type){
        case 0:
            color = "lightgreen"
            break;
        case 1:
            color = "red"
            break;
        case 2:
            color = "blue"
            break;
        case 3:
            color = "yellow"
            break;
        }
    }

}
