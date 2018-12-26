# MQTT Server / Broker

*The counterpart of the MQTT client is the MQTT broker. The broker is at the heart of any publish/subscribe protocol. Depending on the implementation, a broker can handle up to thousands of concurrently connected MQTT clients. The broker is responsible for receiving all messages, filtering the messages, determining who is subscribed to each message, and sending the message to these subscribed clients. The broker also holds the sessions of all persisted clients, including subscriptions and missed messages (more details). Another responsibility of the broker is the authentication and authorization of clients. Usually, the broker is extensible, which facilitates custom authentication, authorization, and integration into backend systems. Integration is particularly important because the broker is frequently the component that is directly exposed on the internet, handles a lot of clients, and needs to pass messages to downstream analyzing and processing systems.*

**We are using a free and open source server/broker MOSCA.**

Requirements
>Mongo DB Server Up and Running
>Node

Before running the code, make sure Mongo Server is running. On whatever port its running, please change the code accordingly. In my case its running on default port of *27017*.

>Install Mosca and MongoDB
```
npm install mosca --save
npm install mongodb --save
```

Run the app.js file

```
node app.js
```
