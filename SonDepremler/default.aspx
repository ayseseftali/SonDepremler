<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="default.aspx.cs" Inherits="SonDepremler._default" %>
<%@ Import Namespace="SonDepremler" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Son Depremler</title>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <link href="Content/leaflet.css" rel="stylesheet" />

    <script src="Scripts/bootstrap.min.js"></script>
    <script src="Scripts/jquery-3.3.1.min.js"></script>
    <script src="Scripts/leaflet-src.js"></script>
    <script src="Scripts/leaflet.js"></script>
    <script src="Scripts/leaflet.ajax.min.js"></script>

    <script type="text/javascript"
            src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBUg4XPgUiPnUGNdgXf1bmdVpzKl72krW0">
    </script>

     <style>
        html, body, #map {
            width: 100%;
            height: 100%;
            margin: 0;
            padding: 0;
        }

        #map {
            z-index: 0;
        }
         
        #mousecoord {
            z-index: 1;
            position: absolute;
            left: 7px;
            bottom: 7px;
            background-color: rgba(61,61,61,0.7);
            border-width: 1px;
            width: 210px;
            height: 20px;
            text-align: center;
            line-height: 16px;
            border-style: solid;
            -moz-border-image: -moz-linear-gradient(left, rgb(110,110,110) 0%, rgb(170,170,170) 30%, rgb(170,170,170) 70%, rgb(110,110,110) 100%);
            -webkit-border-image: -webkit-linear-gradient(left, rgb(110,110,110) 0%,rgb(170,170,170) 30%,rgb(170,170,170) 70%,rgb(110,110,110) 100%);
            border-image: linear-gradient(to right, rgb(110,110,110) 0%,rgb(170,170,170) 30%,rgb(170,170,170) 70%,rgb(110,110,110) 100%);
            border-image-slice: 1;
        }

        #topmiddiv {
            position: absolute;
            top: 10px;
            width: 240px;
            height: 48px;
            background-color: rgba(61,61,61,0.8);
            z-index: 1;
            border-radius: 10px;
            border-color: gray;
            border-width: 1px;
            border-style: solid;
        }       
    </style>
</head>
<body>
     <div id="map"></div>
    <div id="mousecoord">
        <span style="color: white; font-size: 9px; font-family: Verdana">
            Enlem:
            <span style="color: white; font-size: 9px; font-family: Verdana" id="Enlem">24.453884</span> ° Boylam: <span style="color: white; font-size: 9px; font-family: Verdana" id="Boylam">54.377344</span>°
        </span>
    </div>

    <script>      
        var windowwidth = $(window).width() / 2 - 120;
        $("#topmiddiv").css("left", windowwidth.toString() + "px");

        var width = $(window).width();
        $(window).on('resize', function () {
            if ($(this).width() != width) {
                width = $(this).width();
                var windowwidth = width / 2 - 120;
                $("#topmiddiv").css("left", windowwidth.toString() + "px");        
            }
        });
   
        googleStreets = L.tileLayer('http://{s}.google.com/vt/lyrs=m&x={x}&y={y}&z={z}', {
            minZoom:6,
            maxZoom: 20,
            subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],          
            zIndex:10
        });
       
        googleSat = L.tileLayer('http://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}', {
            minZoom: 6,
            maxZoom: 20,
            subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],           
            zIndex: 11
        });

        googleHybrid = L.tileLayer('http://{s}.google.com/vt/lyrs=h&x={x}&y={y}&z={z}', {
            minZoom: 6,
            maxZoom: 20,
            subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],          
            zIndex: 12
        });

        googleTerrain = L.tileLayer('http://{s}.google.com/vt/lyrs=p&x={x}&y={y}&z={z}', {
            minZoom: 6,
            maxZoom: 20,
            subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],            
            zIndex: 13
        });
      
        var map = new L.Map('map', { center: new L.LatLng(39.9334, 32.8597), zoomControl: false, zoom: 6, layers: [googleStreets] });

        var baseMaps = {          
            "googleSat": googleSat,
            "googleHybrid": googleHybrid,
            "googleTerrain": googleTerrain,
            "googleStreets": googleStreets
        };
       
        L.control.layers(baseMaps).addTo(map);
        L.control.scale({ imperial: false, position: 'bottomright' }).addTo(map);
        L.control.zoom({ position: 'topright'}).addTo(map);
       
        map.on('mousemove', function (event) {
            displayCoordinates(event.latlng);
        });

        function displayCoordinates(pnt) {
            var lat = pnt.lat;
            lat = lat.toFixed(6);
            var lng = pnt.lng;
            lng = lng.toFixed(6);
            $("#Enlem").text(lat);
            $("#Boylam").text(lng);                     
        }

        $(document).ready(function () {
        var int = self.setInterval("data()", 360000);
        data();      
        });

        var customOptions =
            {
                'maxWidth': '400',
                'width': '200'                
            }

        var jData = {};
        function data() {
            $.ajax({
                type: 'POST',
                url: './RSSService.svc/RssGetir',
                data: JSON.stringify(jData),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: true,
                timeout: 3600000,
                success: function (data) {
                    $.each(data, function (key, value) {
                        if (key != 0) {
                            var lat = value.description.substring(29, 36);
                            var lng = value.description.substring(37, 44);
                            var circle = L.circle([lat, lng], {
                                color: 'red',
                                fillColor: '#f03',
                                fillOpacity: 0.5,
                                radius: 500
                            }).addTo(map);

                            circle.bindPopup("Title: " + value.title + "<br/>" + "Description: " + value.description, customOptions);
                        }
                    });
                }
            });
        }
    </script>
</body>
</html>
