var mosca = require('mosca');
var MongoClient = require('mongodb').MongoClient;
var url1 = 'mongodb://localhost:27017/mqtt';

var ascoltatore = {
  //using ascoltatore
  type: 'mongo',
  url: 'mongodb://localhost:27017/mqtt',
  pubsubCollection: 'ascoltatori',
  mongo: {}
};

var settings = {
  port: 1883,
  backend: ascoltatore
};

var server = new mosca.Server(settings);

server.on('clientConnected', function(client) {
    console.log('client connected', client.id);
});

// fired when a message is received
server.on('published', function(packet, client) {
  console.log('Published', packet.payload);
  if(!(Buffer.isBuffer(packet.payload))){
      //console.log(packet.payload);
      var data = packet.payload.toString();
      //console.log(data);
      var indexOfClient =  data.indexOf('clientId');
      var indexOfComma = data.indexOf(',');
      //console.log(indexOfClient + " " + indexOfComma);
      var clientId = data.substring(indexOfClient+10 , indexOfComma);
      //console.log("client ID : " + clientId);
      var indexOfTopic = data.indexOf('topic');
      var len = data.length;
      //console.log(indexOfTopic + " " + len);
      var topic = data.substring(indexOfTopic+7,len-1);
      //console.log(topic);


      insertToDB(clientId, topic);



  }else{
      console.log(packet.payload.toString('utf-8'));
  }
  if(client!=null){
      console.log("from : " , client.id);
      console.log(client);
  }

});

server.on('ready', setup);

// fired when the mqtt server is ready
function setup() {
  console.log('Mosca server is up and running');
}



function insertToDB(clientID, topiC) {
  var myObj = {
      clientId : clientID,
      topic : topiC
  };

  MongoClient.connect('mongodb://localhost', function (err, client) {
  if (err) throw err;

  var db = client.db('mqtt');
  db.collection('client_topic').findOne({
      "clientId" : clientID,
      "topic" : topiC
  })
      .then(function(doc) {
          if(!doc){
              //console.log('data not present');
              db.collection("client_topic").insertOne(myObj, function(err, res) {
                  if (err) throw err;
                  //console.log("1 record inserted");
                  //db.close();
              });
          }
          else{
              //console.log('alredy present');
          }
      });
});




}
