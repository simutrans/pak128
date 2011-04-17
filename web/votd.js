// Vehicle of the day for Simutrans pak128 pages
// http://128.simutrans.com
// Vladimír Slávik, 2010
// use at your own risk
// public domain

//-------

function bodyScreenWidth() {
	var result = -1;
	if (typeof window.innerWidth != 'undefined') {
		result = window.innerWidth;
	} else if (typeof document.documentElement != 'undefined'
	&& typeof document.documentElement.clientWidth != 'undefined'
	&& document.documentElement.clientWidth != 0) {
		result = document.documentElement.clientWidth;
	} else {
		result = document.getElementsByTagName('body')[0].clientWidth;
	}
	return result;
}

//-------

function createRequestObj() {
	var result = null;
	try {
		// native
		result = new XMLHttpRequest();
	} catch(non_native) {
		try {
		// new MS
		result = new ActiveXObject("Msxml2.XMLHTTP");
	} catch(not_new_ms) {
		try {
			// old MS
			result = new ActiveXObject("Microsoft.XMLHTTP");
		} catch(all_failed) {
			// die
			return null;
		}
	}
	}
	return result;
}

//-------

function handleIncomingData() {
	if ((request.readyState == 4) && (connection_type == "data")) {
		content_data = request.responseText;
		connection_type = "none";
		Update();
		stepRequests();
	}
}

//-------

function handleIncomingIndex() {
	if ((request.readyState == 4) && (connection_type == "index")) {
		index_data = JSON.parse(request.responseText);
		generateNextIndex();
		connection_type = "none";
		stepRequests();
	}
}

//-------

function stepRequests() {
	if ((request.readyState == 4) || (request.readyState == 0)) { // prepared to send?
		if (content_visible) {
			if (!index_data) {
				connection_type = "index";
				request.onreadystatechange = handleIncomingIndex;
				request.open("GET", "votd_data/index.json", true);
				request.send();
			} else {
				if (new_content_index != content_index) {
					content_index = new_content_index;
					filename = index_data[content_index]["file"];
					connection_type = "data";
					request.onreadystatechange = handleIncomingData;
					request.open("GET", "votd_data/"+filename, true);
					request.send();
				}
			}
		}
	}
}

//-------

function Update() {
	var parent_block = document.body;
	var container = document.getElementById("votd-content");
	if (!parent_block || !container) return;
	
	if (content_visible) {
		parent_block.className = "wide";
	} else {
		parent_block.className = "";
	}
	
	if (content_data) {
		container.innerHTML = content_data;
	} else {
		container.innerHTML = "<p>LOADING...</p>";
	}
	
	if (votd_enabled && content_visible && !content_data) {
		stepRequests();
	}
}

//-------

function pageLoaded() {
	if (votd_enabled) {
		resizeInfo();
		Update();
		stepRequests();
	}
}

//-------

function resizeInfo() {
	content_visible = votd_enabled && (bodyScreenWidth() >= 1200);
}

//-------

function resizeHandler() {
	resizeInfo();
	Update();
}

//-------

function nextClick() {
	generateNextIndex();
	stepRequests();
}

//-------

function generateNextIndex() {
	if (index_data) {
		new_content_index = Math.floor(Math.random() * index_data.length);
	}
}

//-------

var votd_enabled = (typeof(JSON) === 'object') && (typeof(JSON.parse) === 'function');
// don't bother with browsers without native JSON, this is optional eye candy

var connection_type = "none"; // index | data | none
var content_visible = false;
var content_index = -1;
var new_content_index = -1;

var content_data = "";
var index_data = null;

var request = createRequestObj();

// EOF