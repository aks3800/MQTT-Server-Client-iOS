var mqtt = require('mqtt');
//var client  = mqtt.connect('mqtt://localhost:1883/');
var client  = mqtt.connect('mqtt://18.216.156.164:1883/');
client.on('connect', function () {
    //client.subscribe('presence')
    client.publish('mqtt', 'Hello mqtt how are you')
});

client.on('message', function (topic, message) {
    // message is Buffer
    console.log(message.toString())
    //client.end()
});
