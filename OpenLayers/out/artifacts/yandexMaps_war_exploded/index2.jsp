<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>ArcGIS</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="viewport" content="initial-scale=1, maximum-scale=1, user-scalable=no">
    <link rel="stylesheet" href="https://openlayers.org/en/v3.20.1/css/ol.css" type="text/css">
    <!-- The line below is only needed for old environments like Internet Explorer and Android 4.x -->
    <script src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL"></script>
    <script src="https://openlayers.org/en/v3.20.1/build/ol.js"></script>

    <script src="https://code.jquery.com/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>

    <link rel="stylesheet" href="https://js.arcgis.com/3.19/esri/themes/calcite/dijit/calcite.css">
    <link rel="stylesheet" href="https://js.arcgis.com/3.19/esri/themes/calcite/esri/esri.css">

    <link rel="stylesheet" href="https://js.arcgis.com/3.19/dijit/themes/claro/claro.css">
    <link rel="stylesheet" href="https://js.arcgis.com/3.19/esri/css/esri.css">
    <script src="https://js.arcgis.com/3.19/"></script>

    <!-- Bootstrap core CSS -->
    <link href="css/bootstrap.css" rel="stylesheet">


    <style>
        #map {
            height: 400px;
            width: 100%;
            margin: 0px;
            padding: 0;
            border:solid 2px lightskyblue;
        }

        #HomeButton {
            position: absolute;
            top: 145px;
            left: 340px;
            z-index: 100;
        }

        #LocateButton {
            position: absolute;
            top: 185px;
            left: 340px;
            z-index: 100;
        }


        .esriLayer {
            width: 95%;
        }

        header {
            margin-top: 0;
            position: relative;
            width: 100%;
            height: 50px;
            background: #b1dcfb;
        }

        header.clone {
            position: fixed;
            top: -100px;
            width: 80%;
            margin-left: 20%;
            transition: 0.4s top ease-in;
        }

        body.down header.clone {
            top: 0;
            left: 0;
            right: 0;
            z-index: 999;
        }

        h2 {
            font-family: monospace;
            color: #606060;
            margin-top: 0px;
            margin-bottom: 0px;
        }

        ul {
            list-style: none;
            margin: 0 auto;
        }
        a {
            text-decoration: none;
            font-family: "Trebuchet MS";
            transition: .1s linear;
            width: 100%;
        }
        i {
            margin-right: 10px;
        }
        nav {
            display: block;
            width: 20%;
            height: 100%;
            margin: 0 auto 30px;
        }
        .two ul {
            background: #D4E7EE;
            overflow: auto;
            padding: 0;
            height: 100%;
        }
        .two li {
            float: none;
        }
        .two a {
            display: block;
            text-decoration: none;
            padding: 1em;
            border-right: 0px solid #ADC0CE;
            background: rgba(173, 192, 206, .3);
            color: black;
            margin-bottom: 5px;
        }
        .two a:hover {
            background: #ADC0CE;
            border-right: 20px solid #b1dcfb;
            padding: 15px 0 13px 15px;
        }

        #basemapGallery a{
        background: none;
        border-right: 0;
        padding: 0;
        }

        #menu {  /* селектор блока, который будет оставаться на месте */
            position: fixed;
            z-index: 101;
        }
    </style>

    <script>
        require([
            "esri/dijit/LayerList",
            "esri/dijit/LocateButton",
            "esri/dijit/Basemap",
            "esri/dijit/BasemapLayer",
            "esri/dijit/BasemapGallery",
            "esri/dijit/HomeButton",
            "esri/map",
            "esri/dijit/Scalebar",
            "dojo/dom",
            "dojo/on",
            "esri/tasks/query",
            "esri/tasks/QueryTask",
            "esri/layers/ArcGISTiledMapServiceLayer",
            "esri/layers/ArcGISDynamicMapServiceLayer",
            "esri/dijit/Legend",
            "esri/dijit/Measurement",
            "esri/layers/FeatureLayer",

            "dijit/layout/BorderContainer",
            "dijit/layout/ContentPane",
            "dijit/TitlePane",
            "dijit/form/CheckBox",
            "dojo/domReady!"
        ], function(LayerList,LocateButton,Basemap,BasemapLayer,BasemapGallery,HomeButton,Map,Scalebar,dom,on,Query,QueryTask,ArcGISTiledMapServiceLayer,ArcGISDynamicMapServiceLayer,Legend,Measurement,FeatureLayer) {
            map = new Map("map", {
                basemap: "osm",  //For full list of pre-defined basemaps, navigate to http://arcg.is/1JVo6Wd
                center: [45.0, 53.12], // longitude, latitude
                zoom: 7
            });

            var sLayer = new ArcGISDynamicMapServiceLayer("http://arcgis.lotsman.net:6080/arcgis/rest/services/Penzaenergo_end/penzaenergo_dump_work/MapServer");
            map.addLayer(sLayer);

            var myWidget = new LayerList({
                map: map,
                layers: [{
                    layer: sLayer,
                    id: "Penza Energo",
                    subLayers: true
                }],
                //layer: atlasLayer
            }, "layerList");
            myWidget.startup();

            var home = new HomeButton({
                map: map
            }, "HomeButton");
            home.startup();

            geoLocate = new LocateButton({
                map: map
            }, "LocateButton");
            geoLocate.startup();


            //topo map
            var topoLayer = new BasemapLayer({url:'http://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer'});
            // topo item for gallery
            var topoBasemap = new Basemap({
                layers: [topoLayer],
                id: 'topo',
                title: 'Topo',
                thumbnailUrl:'http://www.arcgis.com/sharing/rest/content/items/6e03e8c26aad4b9c92a87c1063ddb0e3/info/thumbnail/topo_map_2.jpg'
            });

            //dark grey
            var dkGreyLayer = new BasemapLayer({url:'http://services.arcgisonline.com/arcgis/rest/services/Canvas/World_Dark_Gray_Base/MapServer'});
            var dkGreyLabelsLayer = new BasemapLayer({url:'http://services.arcgisonline.com/arcgis/rest/services/Reference/World_Transportation/MapServer'});
            var dkGreyBasemap = new Basemap({
                layers: [dkGreyLayer, dkGreyLabelsLayer],
                id: 'dkGrey',
                title: 'Dark Grey',
                thumbnailUrl:'http://www.arcgis.com/sharing/rest/content/items/a284a9b99b3446a3910d4144a50990f6/info/thumbnail/ago_downloaded.jpg'
            });

            //light grey
            var ltGreyLayer = new BasemapLayer({url:'http://services.arcgisonline.com/arcgis/rest/services/Canvas/World_Light_Gray_Base/MapServer'});
            var ltGreyLabelsLayer = new BasemapLayer({url:'http://services.arcgisonline.com/arcgis/rest/services/Canvas/World_Light_Gray_Reference/MapServer'});
            var ltGreyBasemap = new Basemap({
                layers: [ltGreyLayer, ltGreyLabelsLayer],
                id: 'ltGrey',
                title: 'Light Grey',
                thumbnailUrl:'http://www.arcgis.com/sharing/rest/content/items/8b3d38c0819547faa83f7b7aca80bd76/info/thumbnail/light_canvas.jpg'
            });

            // Initialize BasemapGallery
            var basemapGallery = new BasemapGallery({
                showArcGISBasemaps: false,
                map: map,
                basemaps: [topoBasemap, dkGreyBasemap, ltGreyBasemap]
            }, 'basemapGallery');
            basemapGallery.startup();

            basemapGallery.on("error", function(msg) {
                console.log("basemap gallery error:  ", msg);
            });

            var mapGMapSat = new Basemap({
                layers: [new BasemapLayer({
                    type: "WebTiledLayer",
                    url : "https://mts1.google.com/vt/lyrs=s@186112443&hl=x-local&src=app&x={col}&y={row}&z={level}&s=Galile",
                    copyright: "Google Maps"
                })],
                id: "gmapsat",
                thumbnailUrl: "https://maps.ngdc.noaa.gov/viewers/dijits/agsjs/xbuild/agsjs/dijit/images/googlehybrid.png",
                title: "Google Карты"
            });
            basemapGallery.add(mapGMapSat)


            scalebar = new Scalebar({
            map: map,
            attachTo: "map",
            scalebarUnit: "dual"
            });

            map.on("layer-add-result", function (evt) {
                console.log("layer-add-result");
                var layerInfo = [];
                layerInfo.push({layer: evt.layer, title: evt.layer.name});
                if (layerInfo.length > 0) {
                    try {
                        layerLegend = new Legend({
                            map: map,
                            layerInfos: layerInfo
                        }, "legendDiv");
                        layerLegend.startup();
                    } catch (e) {
                        layerLegend.refresh(layerInfo);
                    }
                }
            });


            map.on("update-start", function (evt) {
                console.log("update-start");
            });

            var measurement = new Measurement({
                map: map
            }, dom.byId("measurementDiv"));
            measurement.startup();

            map.on('click', function(evt) {
                executeQueryTask(evt);
            });
        });
    </script>

    <script>
        function executeQueryTask(evt) {
            require([
                "esri/tasks/query",
                "esri/tasks/QueryTask",
                "dojo/dom",
                "dojo/on",
                "esri/geometry/Circle",
                "esri/layers/ArcGISDynamicMapServiceLayer",
                "dojo/domReady!"
            ], function (Query, QueryTask, dom, on, Circle) {

                var queryTask = new QueryTask('http://arcgis.lotsman.net:6080/arcgis/rest/services/Penzaenergo_end/' +
                    'penzaenergo_dump_work/MapServer/1');

                var query = new Query();
                query.returnGeometry = true;
                query.outFields = [
                    "*"
                ];

                var circle = new Circle({
                    center: evt.mapPoint,
                    geodesic: true,
                    radius: 2,
                    radiusUnit: "esriKilometers"
                });

                query.geometry = circle.getExtent();

                //query.text = document.getElementById("stateName").value;
                queryTask.execute(query, showResults);

                function showResults (results) {
                    var resultItems = [];
                    var resultCount = results.features.length;
                    for (var i = 0; i < resultCount; i++) {
                        var featureAttributes = results.features[i].attributes;
                        for (var attr in featureAttributes) {
                            resultItems.push("<b>" + attr + ":</b>  " + featureAttributes[attr] + "<br>");
                        }
                        resultItems.push("<br>");
                    }
                    dom.byId("sved").innerHTML = resultItems.join("");
                }
            });
        }

        $(document).ready(function(){
            $("#menu ul li").on("click","a", function (event) {
                //отменяем стандартную обработку нажатия по ссылке
                event.preventDefault();

                //забираем идентификатор бока с атрибута href
                var id  = $(this).attr('href'),

                //узнаем высоту от начала страницы до блока на который ссылается якорь
                top = $(id).offset().top - 50;

                //анимируем переход на расстояние - top за 800 мс
                $('body,html').animate({scrollTop: top}, 800);
            });
        });

        /*$(document).ready(function(){
            $("#map").on("click","#HomeButton", function (event) {
                //отменяем стандартную обработку нажатия по ссылке
                event.preventDefault();

                alert("Hi");
            });
        });*/

        function OnLoad() {
            var paramValue = location.search.substr(1);
            document.getElementById("log").innerHTML +=' ' + paramValue;
        }

        (function($) {
            $(document).ready(function() {
                var $header = $("header"),
                    $clone = $header.before($header.clone().addClass("clone"));

                $(window).on("scroll", function() {
                    var fromTop = $(document).scrollTop();
                    $("body").toggleClass("down", (fromTop > 50));
                });
            });
        })(jQuery);
        </script>

</head>
<body onload="OnLoad()">

<nav id="menu" class="two">
    <ul>
        <li id="log"><img src="http://mdbootstrap.com/images/avatars/img%20(3)" height="80" width="80" class="img-thumbnail"> Пользователь:</li>
        <li><a href="#map"><div class="glyphicon glyphicon-globe"></div> Карта</a></li>
        <li><a href="#sved"><div class="glyphicon glyphicon-question-sign"></div> Сведения</a></li>
        <li><a href="#info"><div class="glyphicon glyphicon-info-sign"></div> Информация</a></li>
        <li><a href="#footer"><div class="glyphicon glyphicon-earphone"></div> Контакты</a></li>
        <div id="accordion" class="panel-group" style="width: 100%">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a href="#collapse-1" data-parent="#accordion" data-toggle="collapse">Легенда<b class="caret"></b></a>
                    </h4>
                </div>
                <div id="collapse-1" class="panel-collapse collapse">
                    <div class="panel-body">
                        <div id="legendDiv"></div>
                    </div>
                </div>
            </div>

            <div class="panel panel-info">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a href="#collapse-2" data-parent="#accordion" data-toggle="collapse">Базовые карты<b class="caret"></b></a>
                    </h4>
                </div>
                <div id="collapse-2" class="panel-collapse collapse">
                    <div class="panel-body">
                        <div id="basemapGallery"></div>
                    </div>
                </div>
            </div>

            <div class="panel panel-info">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a href="#collapse-3" data-parent="#accordion" data-toggle="collapse">Измерения<b class="caret"></b></a>
                    </h4>
                </div>
                <div id="collapse-3" class="panel-collapse collapse">
                    <div class="panel-body">
                        <div id="measurementDiv"></div>
                    </div>
                </div>
            </div>

            <div class="panel panel-info">
                <div class="panel-heading">
                    <h4 class="panel-title">
                        <a href="#collapse-4" data-parent="#accordion" data-toggle="collapse">Пользовательские слои<b class="caret"></b></a>
                    </h4>
                </div>
                <div id="collapse-4" class="panel-collapse collapse">
                    <div class="panel-body">
                        <div id="layerList" style="width: 100%"></div>
                    </div>
                </div>
            </div>
        </div>
    </ul>

</nav >

<div style="margin-left: 20%">
    <header>
        <h2 align="left" style="margin-left: 20px;float: left">Map Potal</h2>
        <button type="button" class="btn btn-default" onclick="document.location.href='index.jsp'" style="width: auto; float: right; margin-top: 0.5em;margin-right: 1em">
            <div class="glyphicon glyphicon-log-out"></div>
            Выйти
        </button>
    </header>


        <div id="map">
            <div id="HomeButton"></div>
            <div id="LocateButton"></div>
        </div>

<p style="margin-top: 40px">Найденные эл. подстанции в радиусе 2-х километров от клика:</p>
<div id="sved" style="padding:5px; margin:5px; background-color:#eee;width: 30%;height: 490px;overflow: auto"></div>

<br>
<div id="info" style="height: 200px;background: lightgoldenrodyellow">Дополнительная информация</div>

<div id="footer" style="margin-top: 100px;background-color: lightsteelblue">
    <h2 align="center" style="margin-bottom: 0">This is FOOTER!!!</h2>
    <p align="center" style="font-family: monospace" class="col-md-4">Контакты:<br>8-800-555-35-35</p>
    <p align="center" style="font-family: monospace" class="col-md-4">Контакты:<br>8-800-555-35-35</p>
    <p align="center" style="font-family: monospace" class="col-md-4">Контакты:<br>8-800-555-35-35</p>
    <p align="center" style="font-family: monospace">All Rights Reserved (c)</p>
</div>

</div>

</body>
</html>