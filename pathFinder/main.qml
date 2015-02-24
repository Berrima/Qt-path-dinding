import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import "./src/finders/AStarFinder.js" as FinderModule
import "./src/core/Grid.js" as GridModule
import "./src/core/DiagonalMovement.js" as DiagonalMovementModule



ApplicationWindow {
    title: qsTr("Hello World")
    width: 1048
    height: 700
    visible: true
    property int startIndex: 450
    property int endIndex: 700

    property int rowCount: 40
    property int colCount: 40

    id: appId

    Component.onCompleted: clearAll();

    function highLightCell(index,on){
        var cellItem = grid.children[index];
        cellItem.highLight(on);
    }

    function cellType(index){
        var cellItem = grid.children[index];
        return cellItem.checked;
    }

    function getGrid(){
        var retGrid = [];
        var tmpRow = [];
        for(var i = 0; i <grid.children.length;i++ ){
            if(i%colCount == 0 && i!=0){
                retGrid.push(tmpRow);
                tmpRow = [];                
            }

            var cellItem = grid.children[i];
            var type = cellItem.type;
            if(type ===0||type === 2|| type === 3){
                tmpRow.push(0);
            }
            else if(type ===1)
                tmpRow.push(1);

        }
        return retGrid;
    }

    function clearAll(){
        for(var i = 0; i <grid.children.length-1;i++ ){
            var cellItem = grid.children[i];
            if(i == startIndex)
                cellItem.setStart();
            else if(i == endIndex)
                cellItem.setEnd();
            else{
                cellItem.setObstacle(0);
                cellItem.highLight('');
            }
        }
    }
    function clearPath(){
        for(var i = 0; i <grid.children.length-1;i++ ){
            var cellItem = grid.children[i];
            var type = cellItem.type;
            if(type === 0)
                highLightCell(i,'');
        }
    }

    function getDir(nextXX,nextYY,xx,yy){
        var isUp = nextYY<yy;
        var isDown = nextYY>yy;
        var isLeft = nextXX<xx;
        var isRight = nextXX>xx;
        var dir;

        if(isUp){
            if(isLeft)
                dir = '↖';
            else if(isRight)
                dir = '↗';
            else
                dir = '↑';
        }

        else if(isDown){
            if(isLeft)
                dir = '↙';
            else if(isRight)
                dir = '↘';
            else
                dir = '↓';
        }

        else{
            if(isLeft)
                dir = '←';
            else if(isRight)
                dir = '→';
        }

        return dir;
    }

    function walkPath(path){
        for(var i = 1; i <path.length-1;i++ ){
            var nextXX = path[i+1][0];
            var nextYY = path[i+1][1];

            var xx = path[i][0];
            var yy = path[i][1];
            var index = (yy)*colCount+xx;
            var dir = getDir(nextXX,nextYY,xx,yy);
            highLightCell(index,dir);
        }
    }

    Row{
        anchors.fill: parent
        spacing: 5
        Rectangle {
            x: 0
            y: 0
            width:150
            height: appId.height



            GroupBox {

                Column {
                    ExclusiveGroup { id: tabPositionGroup }
                    RadioButton {
                        id: placeStart
                        text: "Start"
                        checked: true
                        exclusiveGroup: tabPositionGroup
                    }
                    RadioButton {
                        id: placeEnd
                        text: "Target"
                        exclusiveGroup: tabPositionGroup
                    }
                    RadioButton {
                        id: placeObstacle
                        text: "Wall"
                        exclusiveGroup: tabPositionGroup
                    }
                    RadioButton {
                        id: clearWall
                        text: "Clear"
                        exclusiveGroup: tabPositionGroup
                    }
                    Button{
                        text: "Solve"
                        onClicked: {
                            var gridMatrix = getGrid();

                            var mapGrid = new GridModule.Grid(colCount,rowCount,gridMatrix);
                            var options = {
                                allowDiagonal: true,
                                dontCrossCorners: true,
                                heuristic: FinderModule.Heuristic.euclidean,
                                weight: 1,
                                diagonalMovement: DiagonalMovementModule.DiagonalMovement.OnlyWhenNoObstacles
                            };

                            var finder = new FinderModule.AStarFinder(options);
                            var startY = Math.floor(startIndex/colCount);
                            var startX = startIndex%colCount;
                            var endY = Math.floor(endIndex/colCount);
                            var endX = endIndex%colCount;
                            var path = finder.findPath(startX, startY, endX, endY, mapGrid);
                            clearPath();
                            walkPath(path);
                        }
                    }
                    Button{
                        text: "Clear all"
                        onClicked: {
                            clearAll();
                        }
                    }

                }
            }
        }


        Rectangle {
            width: colCount*17; height: rowCount*17;
            color:"gray"
            Grid {
                id: grid
                rows: rowCount; columns: colCount; spacing: 1
                Repeater {
                    model: rowCount*colCount
                    id: repeater
                    CellItem{
                    }
                }               
            }
            MouseArea{
                anchors.fill: parent
                onMouseXChanged: {
                    var cell = grid.childAt(mouseX,mouseY);
                    if(!cell)
                        return;
                    if(placeObstacle.checked)
                        cell.setObstacle(1);
                    else if(clearWall.checked)
                        cell.setObstacle(0);
                    else if(placeStart.checked)
                        cell.setStart();
                    else if(placeEnd.checked)
                        cell.setEnd();
                }

                onMouseYChanged: {
                    var cell = grid.childAt(mouseX,mouseY);
                    if(!cell)
                        return;
                    if(placeObstacle.checked)
                        cell.setObstacle(1);
                    else if(clearWall.checked)
                        cell.setObstacle(0);
                    else if(placeStart.checked)
                        cell.setStart();
                    else if(placeEnd.checked)
                        cell.setEnd();
                }
            }

        }
    }
}
