const dgram = require('dgram');
const inputs = 9;

var client  = dgram.createSocket('udp4');

const chan = [
	{ color  : "#ffff00",
	  shaded : "#808000" },
	{ color  : "#00ffff",
	  shaded : "#008080" },
	{ color  : "#ff00ff",
	  shaded : "#800080" },
	{ color  : "#ffffff",
	  shaded : "#808080" },
	  ];

window.addEventListener("load", function() {

	function send (cmd, data, channel, edge) {
		var buffer = Buffer.alloc(3);
		var host = "kit";
		var port = 57001;

		if (typeof port === "undefined")
			port = 57001;
	
		buffer[1] = parseInt(data);
		
		if (typeof edge !== "undefined")
			if (edge != 0) 
				channel = parseInt(channel) + 128;
		buffer[2] = parseInt(channel);

		console.log("channel : ", channel, "command : ", cmd);
		switch(cmd) {
		case "unit":
			buffer[0] = 0;
			break;
		case "offset":
			buffer[0] = 1;
			break;
		case "level":
			buffer[0] = 2;
			break;
		case "time":
			buffer[0] = 3;
			break;
		}
		client.send(buffer, port, host , function(err, bytes) {
			if (err) throw err;
			console.log('UDP message sent to ' + host +':'+ "57001");
		});
	}

	function mouseWheelCb (e) {
		this.value = parseInt(this.value) + parseInt(((e.deltaY > 0) ? 1 : -1));
	}

	function chanSelect (ev) {
		for(i=0 ; i < inputs; i++) {
			var idTrigger = "chan" + i + "-trigger";
			var idScale   = "chan" + i + "-scale";

			if (this.id === idTrigger)
				for (j=0; j < inputs; j++) {
					idTrigger = "chan" + j + "-trigger";
					if (this.id === idTrigger) {
						this.style.color = chan[j].color;
						document.getElementById("chan" + j + "-slope").onchange(ev);
					} else
						document.getElementById(idTrigger).style.color =  chan[j].shaded;
				}
			else if (this.id === idScale)
				for (j=0; j < inputs; j++) {
					idScale = "chan" + j + "-scale";
					if (this.id === idScale) {
						this.style.color = chan[j % chan.length ].color;
						document.getElementById("chan" + j + "-offset").onchange(ev);
					} else
						document.getElementById(idScale).style.color = chan[j % chan.length ].shaded;
				}
		}
	}
	body = document.getElementsByTagName("body");
	for (i = 0; i < inputs; i++) {
		body[0].innerHTML = body[0].innerHTML + 
			'<div style="text-align:center;padding:2pt;display:inline-block;vertical-align:top;color:'+ chan[i % chan.length].color + ';border:solid #404040 1pt;">' +
				'<div id="chan' + i + '-scale" style="padding:2pt;display:inline-block;vertical-align:top;border:solid #404040 1pt;">' +
					'<div style="display:inline-block;vertical-align:top">' +
						'<input id="chan' + i + '-unit" type="range" class="vertical" value="0" min="0" max="15">' +
						'<label style="display:block;">Escala</label>' +
					'</div>' +
					'<div style="display:inline-block;vertical-align:top">' +
						'<input id="chan' + i + '-offset" type="range" class="vertical" value="0" min="-128" max="128"/>' +
						'<label style="display:block;">Position</label>' + 
					'</div>' + 
					'<label style="display:block;">Vertical</label>' + 
				'</div>' + 
				'<div id="chan' + i + '-trigger" style="padding:2pt;display:inline-block;vertical-align:top;border:solid #404040 1pt;">' +
					'<div style="display:inline-block;vertical-align:top">' +
						'<input id="chan' + i + '-level" type="range" class="vertical" value="0" min="-128" max="128"/>' +
						'<label style="display:block">Nivel</label>' +
					'</div>' +
					'<div style="display:inline-block;vertical-align:top">' +
						'<input id="chan' + i + '-slope" type="range" class="vertical" value="0" min="0" max="1"/>' +
						'<label style="display:block">Pendiente</label>' +
					'</div>' +
					'<label style="display:block;">Disparo</label>' +
				'</div>' +
			'</div>';
	}

	body[0].innerHTML = body[0].innerHTML + 
		'<div style="padding:2pt;text-align:center;padding:2pt;display:inline-block;vertical-align:top;border:solid #404040 1pt;color:#00ff00">' +
			'<div style="padding:2pt;display:inline-block;vertical-align:top;">' +
				'<div style="display:inline-block;vertical-align:top;padding:1pt">' +
					'<input id="time" type="range" class="vertical" value="0" min="0"    max="15"/>' +
					'<label style="display:block;">Escala</label>' +
				'</div>' +
				'<label style="display:block;">Horizontal</label>' +
			'</div>' +
		'</div>';

	for (i=0; i < inputs; i++) {
		document.getElementById("chan" + i + "-scale").onclick   = chanSelect;
		document.getElementById("chan" + i + "-trigger").onclick = chanSelect;

		if (i == 0)
			document.getElementById("chan0-unit").onfocus = function(ev) { this.parentElement.parentElement.onclick(ev); };
		else
			document.getElementById("chan" + i + "-unit").onfocus = document.getElementById("chan0-unit").onfocus;

		document.getElementById("chan" + i + "-offset").onfocus  = document.getElementById("chan0-unit").onfocus;
		document.getElementById("chan" + i + "-level").onfocus   = document.getElementById("chan0-unit").onfocus;
		document.getElementById("chan" + i + "-slope").onfocus   = document.getElementById("chan0-unit").onfocus;

		document.getElementById("chan" + i + "-unit"   ).addEventListener("wheel", mouseWheelCb, false);
		document.getElementById("chan" + i + "-offset" ).addEventListener("wheel", mouseWheelCb, false);
		document.getElementById("chan" + i + "-level"  ).addEventListener("wheel", mouseWheelCb, false);
		document.getElementById("chan" + i + "-slope"  ).addEventListener("wheel", mouseWheelCb, false);
		document.getElementById("chan" + i + "-scale"  ).addEventListener("wheel", chanSelect, false);
		document.getElementById("chan" + i + "-trigger").addEventListener("wheel", chanSelect, false);

		document.getElementById("chan" + i + "-unit").onchange = function(ev) {
			send ("unit", (parseInt(this.value)+16)%16, this.id.match(/\d+/)[0]);
		}

		document.getElementById("chan" + i + "-offset").onchange = function(ev) {
			send ("offset", (parseInt(this.value)+256)%256, this.id.match(/\d+/)[0] );
			document.getElementById("chan" + this.id.match(/\d+/)[0] + "-unit").onchange(ev);
		}

		document.getElementById("chan" + i + "-level").onchange = function(ev) {
			send ("level", (parseInt(this.value)+256)%256, this.id.match(/\d+/)[0], document.getElementById("chan" + this.id.match(/\d+/)[0] + "-slope").value);
		}

		document.getElementById("chan" + i + "-slope").onchange = function(ev) {
			document.getElementById("chan" + this.id.match(/\d+/)[0] + "-level").onchange(ev);
		}

	}

	document.getElementById("time").addEventListener("wheel",
		function (e) { 
			this.value = parseInt(this.value) + parseInt(((e.deltaY > 0) ? 1 : -1)); 
			this.onchange(e);
		},
		false);
	document.getElementById("time").onchange = function(ev) {
		console.log("pase por aca");
		send("time", parseInt(this.value));
	}



});
