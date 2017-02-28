<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="en">
<head>
  <script src="https://api-maps.yandex.ru/2.1/?lang=ru_RU" type="text/javascript"></script>
  <script src="https://code.jquery.com/jquery-3.1.1.js"
          integrity="sha256-16cdPddA6VdVInumRGo6IbivbERE8p7CQR3HzTBuELA="
          crossorigin="anonymous"></script>
  <link href="css/bootstrap.min.css"  rel="stylesheet">

  <link rel="stylesheet" href="https://openlayers.org/en/v3.20.1/css/ol.css" type="text/css">
  <style>
    .map {
      height: 100%;
      width: 100%;
    }

    #vienna {
      text-decoration: none;
      color: white;
      font-size: 11pt;
      font-weight: bold;
      text-shadow: black 0.1em 0.1em 0.2em;
    }

    .ol-popup {
      position: absolute;
      background-color: white;
      -webkit-filter: drop-shadow(0 1px 4px rgba(0,0,0,0.2));
      filter: drop-shadow(0 1px 4px rgba(0,0,0,0.2));
      padding: 15px;
      border-radius: 10px;
      border: 1px solid #cccccc;
      bottom: 12px;
      left: -50px;
      min-width: 280px;
    }
    .ol-popup:after, .ol-popup:before {
      top: 100%;
      border: solid transparent;
      content: " ";
      height: 0;
      width: 0;
      position: absolute;
      pointer-events: none;
    }
    .ol-popup:after {
      border-top-color: white;
      border-width: 10px;
      left: 48px;
      margin-left: -10px;
    }
    .ol-popup:before {
      border-top-color: #cccccc;
      border-width: 11px;
      left: 48px;
      margin-left: -11px;
    }
    .ol-popup-closer {
      text-decoration: none;
      position: absolute;
      top: 2px;
      right: 8px;
    }
    .ol-popup-closer:after {
      content: "✖";
    }

    .fullscreen:-moz-full-screen {
      height: 100%;
    }
    .fullscreen:-webkit-full-screen {
      height: 100%;
    }
    .fullscreen:-ms-fullscreen {
      height: 100%;
    }

    .fullscreen:fullscreen {
      height: 100%;
    }

    .fullscreen {
      margin-bottom: 10px;
      width: 100%;
      height: 350px;
    }

    .ol-rotate {
      top: 3em;
    }

    .ol-scale-line {
      left: auto;
      right: 1em;
      bottom: 3em;
    }

  </style>
  <script src="https://openlayers.org/en/v3.20.1/build/ol.js" type="text/javascript"></script>
  <title>OpenLayers 3</title>
</head>

<body>
<h2>My Map</h2>

<div id="popup" class="ol-popup">
  <a href="#" id="popup-closer" class="ol-popup-closer"></a>
  <div id="popup-content"></div>
</div>

<div id="fullscreen" class="fullscreen">
  <div id="map" class="map" tabindex="0"></div>
</div>
<input id="swipe" type="range" value="100" style="width: 100%">

<div style="display: none;">
  <!-- Clickable label for Vienna -->
  <a class="overlay" id="vienna" target="_blank" href="https://ru.wikipedia.org/wiki/%D0%9F%D0%B5%D0%BD%D0%B7%D0%B0">Penza</a>
</div>

<script type="text/javascript">

    var container = document.getElementById('popup');
    var content = document.getElementById('popup-content');
    var closer = document.getElementById('popup-closer');

    var arcgisImagery = new ol.layer.Tile({
        source: new ol.source.TileArcGISRest({
            url: 'http://server.arcgisonline.com/arcgis/rest/services/ESRI_Imagery_World_2D/MapServer'
        })
    });

    var osmLayer = new ol.layer.Tile({
        source: new ol.source.OSM()
    });

    var overlay = new ol.Overlay( ({
        element: container,
        autoPan: true,
        autoPanAnimation: {
            duration: 250
        }
    }));

    closer.onclick = function() {
        overlay.setPosition(undefined);
        closer.blur();
        return false;
    };

    var pos = ol.proj.fromLonLat([45.0, 53.12]);

    // Vienna label
    var penza = new ol.Overlay({
        position: pos,
        element: document.getElementById('vienna')
    });

    var map = new ol.Map({
        controls: ol.control.defaults().extend([
            new ol.control.ZoomSlider(),
            new ol.control.OverviewMap(),
            new ol.control.ScaleLine(),
            new ol.control.FullScreen({
                source: 'fullscreen'
            })
        ]),
        overlays: [overlay,penza],
        target: 'map',
        layers: [
            osmLayer,arcgisImagery
        ],
        view: new ol.View({
            center: ol.proj.fromLonLat([45.0, 53.12]),
            zoom: 7
        })
    });

    var swipe = document.getElementById('swipe');

    map.on('singleclick', function(evt) {
        var coordinate = evt.coordinate;
        var hdms = ol.coordinate.toStringHDMS(ol.proj.transform(
            coordinate, 'EPSG:3857', 'EPSG:4326'));

        content.innerHTML = '<p>Вы кликнули по координатам:</p><code>' + hdms +
            '</code>';
        overlay.setPosition(coordinate);
    });

    arcgisImagery.on('precompose', function(event) {
        var ctx = event.context;
        var width = ctx.canvas.width * (swipe.value / 100);

        ctx.save();
        ctx.beginPath();
        ctx.rect(width, 0, ctx.canvas.width - width, ctx.canvas.height);
        ctx.clip();
    });

    arcgisImagery.on('postcompose', function(event) {
        var ctx = event.context;
        ctx.restore();
    });

    swipe.addEventListener('input', function() {
        map.render();
    }, false);

</script>

<hr>

<script>
    function check(){
        var pass = "qwerty";
        var mpass = document.getElementById('password').value;
        var log = "user";
        var mlog = document.getElementById('login').value;


        if((mpass==pass)&&(mlog==log))
        {
            location.href="index2.jsp";
        }
        else
        {alert("Неправильные данные для входа")}
    }

    function auth() {
        var login = document.getElementById('login').value;
        var password = document.getElementById('password').value;

        $('#login').css("background","white");
        $('#password').css("background","white");

        if(login == "admin")
        {document.location.href="admin.html"}
        else {
            $.ajax({
                url: "MyServlet",
                type: "POST",
                dataType: "text",
                data: ("auth_login=" + login + "&auth_password=" + password),
                success: function (data) {
                    if (data[0] == "y")
                        document.location.href = "index2.jsp?" + login;
                    if (data[0] == "l") {
                        alert("Login is not founded.");
                        $('#login').css("background", "pink");
                        $('#password').css("background", "pink");
                    }
                    if (data[0] == "p") {
                        alert("Password is not correct.");
                        $('#login').css("background", "lightgreen");
                        $('#password').css("background", "pink");
                        document.getElementById('password').value = '';
                    }
                },
                error: function (e) {
                    alert("error");
                }
            })
        }
    }
</script>

<div class="col-sm-4" align="center">
  <p><img height="320px" src="https://cdn.avopix.com/photos/list/l_31038_penguin-seven.png" alt="Hello"></p>
</div>

<div style="margin-left: 40px">
<label class="col-offset-4 col-4 control-label">Login</label>
<div class="input-group" style="width: 30%" >
  <span class="input-group-addon"><span class="glyphicon glyphicon-user"></span></span>
    <input type="text" class="form-control" placeholder="Введите имя пользователя" id="login">
  </div>
</div>

<div style="margin-left: 40px">
<label style="margin-top: 30px" class="col-offset-4 col-4 control-label">Password</label>
<div class="input-group" style="width: 30%" >
  <span class="input-group-addon"><span class="glyphicon glyphicon-lock"></span></span>
    <input type="password" class="form-control" placeholder="Введите пароль" id="password">
  </div>
</div>

<div style="margin-top: 20px" class="form-group">
  <div class="col-offset-4 col-4" align="left" style="margin-left: 40px">
    <button type="button" class="btn btn-info" style="width: auto" onclick="auth();">
      <div class="glyphicon glyphicon-ok"></div>
      Войти
    </button>
    <button type="button" class="btn btn-default" style="width: auto" onclick="document.location.href='registration.html'">
      <div class="glyphicon glyphicon-pencil"></div>
      Регистрация
    </button>
  </div>
</div>

</body>

</html>
