<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;sensor=true&amp;key={text value=$tctz_prefs.google_key allowEmpty=true}" type="text/javascript"></script>
<script type="text/javascript">
{literal}
var map = null;
function tctz_initialize() {
	if (GBrowserIsCompatible()) {
		map = new GMap2(EBID("map_canvas"));
		map.setCenter(new GLatLng(0, 0), 1);
		{/literal}{if !empty($tctz_coordinates)}
		cord = "{$tctz_coordinates}".split(', ');
		updatePosition(new GLatLng(cord[0], cord[1]), true);
		{/if}{literal}
		GEvent.addListener(map,"click", function(overlay, latlng) {
			if(latlng) {
				updatePosition(latlng);
			}
		});
		map.setUIToDefault();
	} else {
		alert('Browser not compatible');
	}
}
if(EBID('id_automatisch')) {
	EBID('id_automatisch').value = tctz_getDiffGMT();
}

function tctz_getDiffGMT() {
	var rightNow = new Date();
	var date1 = new Date(rightNow.getFullYear(), 0, 1, 0, 0, 0, 0);
	var temp = date1.toGMTString();
	var date2 = new Date(temp.substring(0, temp.lastIndexOf(" ")-1));
	var hoursDiffStdTime = (date1 - date2) / (1000 * 60 * 60);
	return hoursDiffStdTime*60*60;
}

function tctz_switchAuto(init) {
	if(!GBrowserIsCompatible()) {
		EBID('tctz_map').style.display = 'none';
		return;
	}
	if(EBID('id_automatisch').checked) {
		if(!init)
			EBID("tctz_ok").disabled = false;
		map.clearOverlays();
		EBID('tctz_map').style.display = 'none';
		MakeXMLRequest('start.php?action=tctz_ajax'
			+ '&offset=' + EBID("id_automatisch").value
			+ '&sid=' + currentSID,
		_updateTimezone);
	} else {
		if(!init) {
			EBID("tctz_ok").disabled = true;
			EBID('tctz_tz').value = '';
			EBID("tctz_coord").value = '';
		}
		EBID('tctz_map').style.display = '';
		map.checkResize();
		map.setCenter(new GLatLng(0, 0), 1);
	}
}

function lookup(event) {
	if(!event || event.keyCode == 13)  {
		var field = EBID('address');
		var address = field.value;
		if(address==''){
			alert("{/literal}{lng p='tctz_error_input'}{literal}");
			field.focus();
		}else{
			var geocoder;
			geocoder = new GClientGeocoder();
			geocoder.getLocations(address, addToMap);
		}
		return false;
	}
	return true;
}

function addToMap(response) {
	map.setCenter(new GLatLng(0,0), 1);
	if (!response || response.Status.code != 200) {
		updatePosition();
	} else {
		var place = response.Placemark[0];
		point = new GLatLng(place.Point.coordinates[1],place.Point.coordinates[0]);
		map.checkResize();
		map.setCenter(point, 6);
		updatePosition(point);
	}
}

function updatePosition(point, existing) {
	map.clearOverlays();
	if(!existing)
		EBID("tctz_tz").value = "";
	if(!point) {
		EBID("tctz_coord").value = "";
		if(EBID("tctz_ok"))
			EBID("tctz_ok").disabled = true;
	} else {
		var marker = new GMarker(point);
		map.addOverlay(marker);
		EBID("tctz_coord").value = Math.round(point.y * 100) / 100 + ", " + Math.round(point.x * 100) / 100;
		if(!existing && EBID("tctz_ok")) {
			EBID("tctz_ok").disabled = false;
			MakeXMLRequest('start.php?action=tctz_ajax'
					+ '&coordinates=' + EBID("tctz_coord").value
					+ '&sid=' 		+ currentSID,
				_updateTimezone);
		} else if(!existing) {
			MakeXMLRequest('{/literal}{$pageURL}{literal}'
					+ '&action=ajax'
					+ '&coordinates=' + EBID("tctz_coord").value
					+ '&sid=' 		+ currentSID,
				_updateTimezone);
		}
	}
}

function _updateTimezone(e) {
	if(e.readyState == 4) {
		if(e.responseText) {
			EBID('tctz_tz').value = e.responseText;
		} else {
			alert("{/literal}{lng p='tctz_error_not_found'}{literal}");
			map.clearOverlays();
		}
	}
}
tctz_initialize();
tctz_switchAuto(true);
</script>
{/literal}