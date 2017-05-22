/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

.pragma library

function roundNumber(number, digits)
{
    var multiple = Math.pow(10, digits);
    return Math.round(number * multiple) / multiple;
}

function formatTime(sec)
{
    var value = sec
    var seconds = value % 60
    value /= 60
    value = (value > 1) ? Math.round(value) : 0
    var minutes = value % 60
    value /= 60
    value = (value > 1) ? Math.round(value) : 0
    var hours = value
    if (hours > 0) value = hours + "h:"+ minutes + "m"
    else value = minutes + "min"
    return value
}

function formatDistance(meters)
{
    var dist = Math.round(meters)
    if (dist > 1000 ){
        if (dist > 100000){
            dist = Math.round(dist / 1000)
        }
        else{
            dist = Math.round(dist / 100)
            dist = dist / 10
        }
        dist = dist + " km"
    }
    else{
        dist = dist + " m"
    }
    return dist
}


function SalesmanNode(prev_id,lat, lon, marker){
    this.id = prev_id;
    this.lat = lat
    this.lon = lon
    this.neighbors = {}
    this.neighborIds = []
    this.visited = false;
    this.marker = marker;
}

SalesmanNode.prototype.addNeighbor = function(neighbor, cost){
    if(neighbor.lat !== this.lat || neighbor.lon !== this.lon){
        //console.log("In node " + this.id + "'s addNeighbor(), adding node " + neighbor.id + " ... ");
        this.neighborIds.push(neighbor.id);
        this.neighbors[neighbor.id] = {
            node: neighbor,
            cost: cost

        };
    } else {
        //console.log("In node " + this.id + "'s addNeighbor(), detected that node " + neighbor.id + " is a duplicate");
    }
}

SalesmanNode.prototype.print = function(){
    console.log("    Neighbor Node: " + this.id);
    console.log("              Lat: " + this.lat);
    console.log("              Lon: " + this.lon);
}

SalesmanNode.prototype.getStr = function(){
    return "" + this.id;
}

function SalesmanGraph(){
    this.ids = []
    this.nodes = {}
    this.markers = []
}

SalesmanGraph.prototype.print = function(){

    //console.log("Let's look at the graph::");
    for(var i = 0; i < this.ids.length; i++){
        var out_str = "";


        out_str += this.ids[i] + ": ---";
//        console.log("On node " + this.ids[i] + ": ");
//        console.log("  Lat: " + this.nodes[this.ids[i]].lat);
//        console.log("  Lon: " + this.nodes[this.ids[i]].lon);
        var neighborIds = this.nodes[this.ids[i]].neighborIds;
        for(var j = 0; j < neighborIds.length; j++){
            //this.nodes[this.ids[i]].neighbors[neighborIds[j]].node.print();
            out_str += "---" + this.nodes[this.ids[i]].neighbors[neighborIds[j]].node.getStr();
            //console.log(" --COST: " + this.nodes[this.ids[i]].neighbors[this.nodes[this.ids[i]].neighborIds[j]].cost);
            out_str += "(" + this.nodes[this.ids[i]].neighbors[this.nodes[this.ids[i]].neighborIds[j]].cost + ")---";
        }
        //console.log(out_str);

    }
}

SalesmanGraph.prototype.addNode = function(lat, lon, marker){
    var id;
    if(this.ids.length < 1){
        id = 1;
    } else {
        id = this.nodes[this.ids[this.ids.length - 1]].id + 1;
    }

    this.nodes[id] = new SalesmanNode(id, lat, lon, marker);
    var curNode = this.nodes[id];
    this.ids.push(id)
    console.log('just added node with id: ' + id);
    for(var i = 0; i < this.ids.length; i++){
        console.log('in addNode(), looking at: ' + this.nodes[this.ids[i]].id + ', lat: ' + this.nodes[this.ids[i]].lat + "");
        var neighbor = this.nodes[this.ids[i]];
        var diffLat = Math.abs(curNode.lat - neighbor.lat);
        var diffLon= Math.abs(curNode.lon - neighbor.lon);
        var distance = Math.sqrt( Math.pow(diffLat * 100, 2) + Math.pow(diffLon * 100, 2) );

//        neighbor.neighbors[curNode.id] = {
//           node: curNode,
//           cost: distance
//        };
//        neighbor.neighborIds.push(curNode.id);
//        curNode.neighbors[neighbor.id] = {
//           node: neighbor,
//           cost: distance
//        };
//        curNode.neighborIds.push(neighbor.id);

        neighbor.addNeighbor(curNode, distance);
        curNode.addNeighbor(neighbor, distance);
    }
}


SalesmanGraph.prototype.removeFront = function(marker){
    //this.nodes = {}
    //this.markers = []
    console.log("Removing front!...");

    var result = {

        newMarkers: null,
        newPolyPath: []
    };
    console.log("|  About To Iterate " + this.ids.length + " ids...");


    for(var i = 0; i < this.ids.length; i++){
        console.log("|  this.ids["+i+"] = " + this.ids[i]);
        if(typeof this.nodes[this.ids[i]] === 'undefined' || this.nodes[this.ids[i]] === null){
            console.log("|  |  UNDEFINED OR NULL NODE");

        } else {

            if(this.nodes[this.ids[i]].marker.coordinate.latitude === marker.coordinate.latitude
                    && this.nodes[this.ids[i]].marker.coordinate.longitude === marker.coordinate.longitude){
                console.log("|  |  REMOVING THIS NODE");
                this.nodes[this.ids[i]] = null;
                this.ids.splice(i, 1);

            } else {
                console.log("|  |  ADDING THIS NODE TO PATH");
                result.newPolyPath.push({
                    latitude: this.nodes[this.ids[i]].lat,
                    longitude: this.nodes[this.ids[i]].lon
                });
            }

            if(this.markers[i] === marker){
                console.log("|  |  REMOVING THIS MARKER");
                this.markers.splice(i, 1);
            }

        }
    }

    result.newMarkers = this.markers;

    return result;

}

SalesmanGraph.prototype.shortestPath = function(lat, lon){
    var fromNode = new SalesmanNode(85, lat, lon, null);

    for(var i = 0; i < this.ids.length; i++){
        //console.log('in shortestPath(), looking at: ' + this.nodes[this.ids[i]].id + ', lat: ' + this.nodes[this.ids[i]].lat + "");
        var neighbor = this.nodes[this.ids[i]];
        var diffLat = Math.abs(fromNode.lat - neighbor.lat);
        var diffLon= Math.abs(fromNode.lon - neighbor.lon);
        var distance = Math.sqrt( Math.pow(diffLat * 100, 2) + Math.pow(diffLon * 100, 2) );

        neighbor.addNeighbor(fromNode, distance);
        fromNode.addNeighbor(neighbor, distance);
    }


    // do algorithm

    //this.print();

    var newCoords = [];
    var newMarkers = new Array();

    var curNode = fromNode;
    newCoords.push({
       latitude: curNode.lat,
       longitude: curNode.lon
    });
    var done = false;

    for(var k = 0; k < this.ids.length; k++){
        this.nodes[this.ids[k]].visited = false;
    }
    //console.log("Starting salesman algorithm from node " + curNode.id);
    var iter = 0;
    var index = 0;
    var currentMinNode = null;
    while(!done){
        var allNeighborsVisited = true;
        var currentMin = Number.POSITIVE_INFINITY;
        //console.log("while() iter " + iter);
        for(i = 0; i < curNode.neighborIds.length; i++){
            var currentNode = curNode.neighbors[curNode.neighborIds[i]];
            //console.log("     on neighbor " + currentNode.node.id);
            if(!currentNode.node.visited){
                allNeighborsVisited = false;
                //console.log("          not yet visited!");
                if(currentNode.cost < currentMin){
                    currentMin = currentNode.cost;
                    currentMinNode = currentNode;
                    //console.log("               and its the min neighbor with cost " + currentMin);
                }
            } else {
                //console.log("          already visited!");

            }
        }
        if(allNeighborsVisited){
            //console.log("I have that all neighbors were visited");
            done = true;

        } else {
            index++;
            curNode.visited = true;
            curNode = currentMinNode.node;
            //console.log("I have that all neighbors were NOT yet visited, now iterating on node " + curNode.id);
            newCoords.push({
               latitude: curNode.lat,
               longitude: curNode.lon
            });
            //curNode.marker.sourceItem.number.text = "" + index;
            newMarkers.push(curNode.marker);
        }
        iter++;
        if(iter > 20) break;

    }




    for(i = 0; i < this.ids.length; i++){
        for(var j = 0; j < this.nodes[this.ids[i]].neighborIds.length; j++){
            if(this.nodes[this.ids[i]].neighbors[this.nodes[this.ids[i]].neighborIds[j]].node === fromNode){
                this.nodes[this.ids[i]].neighborIds.splice(j, 1);
                break;
            }
        }

    }

    return {
        pathCoords: newCoords,
        markers: newMarkers
    };



}


SalesmanGraph.prototype.shortestPathExact = function(lat, lon){
    var fromNode = new SalesmanNode(85, lat, lon, null);

    for(var i = 0; i < this.ids.length; i++){
        console.log('in shortestPath(), looking at: ' + this.nodes[this.ids[i]].id + ', lat: ' + this.nodes[this.ids[i]].lat + "");
        var neighbor = this.nodes[this.ids[i]];
        var diffLat = Math.abs(fromNode.lat - neighbor.lat);
        var diffLon= Math.abs(fromNode.lon - neighbor.lon);
        var distance = Math.sqrt( Math.pow(diffLat * 100, 2) + Math.pow(diffLon * 100, 2) );

        neighbor.addNeighbor(fromNode, distance);
        fromNode.addNeighbor(neighbor, distance);
    }


    // do algorithm

    //this.print();

    var newCoords = [];
    var newMarkers = new Array();

    var curNode = fromNode;
    newCoords.push({
       latitude: curNode.lat,
       longitude: curNode.lon
    });
    var done = false;

    for(var k = 0; k < this.ids.length; k++){
        this.nodes[this.ids[k]].visited = false;
    }

    /*
        Held-Karp Algorithm:

    */






}

SalesmanGraph.prototype.addMarker = function(marker){
    this.markers.push(marker);
}

//function SalesmanPath(){
//    this.path = []
//    this.totalCost = Number.POSITIVE_INFINITY
//}

//SalesmanPath.prototype.addNodeToPath = function(nodeId, edgeCost){
//    this.path.push(nodeId);
//    this.totalCost += edgeCost;
//}


var DangerousChemicals = {
    "Abrin": "#B0171F",
    "Arsine (SA)" : "#EE30A7",
    "Benzene (CA)" : "#8B008B",
    "Bromine (CA)" : "#4B0082",
    "Bromobenzylcyanide (CA)" : "#00FF7F",
    "Chlorine (CL)" : "#458B00",
    "Chloroacetophenone (CN)" : "#BDB76B",
    "Chlorobenzylidenemalononitrile (CS)" : "#FFB90F",
    "Chloropicrin (PS)" : "#FF8C00",
    "Cyanide" : "#CD3333",
    "Cyanogen chloride (CK)" : "#848484",
    "Dibenzoxazepine (CR)" : "#FFD801",
    "Hydrogen fluoride (hydrofluoric acid)" : "#F9966B",
    "Hydrogen cyanide (AC)" : "#C35817",
    "Lewisite (L, L-1, L-2D2691E, L-3)" : "#7FFF00",
    "Mustard gas (H)" : "#6495ED",
    "Nitrogen mustard (HN-1, HN-2, HN-3)" : "#B8860B",
    "Paraquat" : "#006400",
    "Phosgene (CG)" : "#8B008B",
    "Phosgene oxime (CX)" : "#FF8C00",
    "Potassium cyanide (KCN)" : "#8B0000",
    "Ricin" : "#E9967A",
    "Riot control agents/tear gas" : "#8FBC8F",
    "Sarin (GB)" : "#B22222",
    "Sodium azide" : "#FFD700",
    "Sodium cyanide (NaCN)" : "#DAA520",
    "Soman (GD)" : "#ADFF2F",
    "Stibine" : "#FF69B4",
    "Strychnine" : "#90EE90",
    "Sulfur mustard (H)" : "#7CFC00",
    "Tabun (GA)" : "#20B2AA",
    "Tear gas/riot control agents" : "#C71585",
    "VX" : "#808000"
};

var ChemicalNames = [];

for(var name in DangerousChemicals){
    if(DangerousChemicals.hasOwnProperty(name)){
        ChemicalNames.push(name);
    }
}

