var mqtt = require('mqtt');
//var client  = mqtt.connect('mqtt://localhost:1883/');
var client  = mqtt.connect('tcp://18.216.156.164:1883/');

client.on('connect', function () {
	console.log("connected");
    client.subscribe('mqtt');
    //client.subscribe('test');

});

client.on('message', function (topic, message) {
    // message is Buffer
    console.log(message.toString())
});
