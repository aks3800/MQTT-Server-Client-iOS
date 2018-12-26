//
//  ViewController.swift
//  MQTT
//
//  Created by Akshat on 09/04/18.
//  Copyright © 2018 Akshat. All rights reserved.
//

import UIKit
import CocoaMQTT

class ViewController: UIViewController, CocoaMQTTDelegate, UITextFieldDelegate {
    
    
    var clientID : String?
    // IP and port on which MQTT server is running
    let host = "h.o.s.t"
    let port : UInt16 = 1883
    
    var mqtt : CocoaMQTT?
    
    let connectButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Connect", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(connectButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let connectionSuccessfulLabel : UILabel = {
        let label = UILabel()
        label.text = "Not Connected to server Yet"
        label.textColor = UIColor.red
        label.backgroundColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let subscribeToTopicButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Subscribe", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(subscribeToTopicTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let topicTextField : UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.black
        textField.backgroundColor = UIColor.clear
        textField.placeholder = "Topic"
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let subscriptionSuccessfulLabel : UILabel = {
        let label = UILabel()
        label.text = "Not Subscribed to any topic Yet"
        label.textColor = UIColor.red
        label.backgroundColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let messageLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let publishTopicTextField : UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.black
        textField.backgroundColor = UIColor.clear
        textField.placeholder = "Publish Topic"
        textField.textAlignment = .left
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let publishMessageTextfield : UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.black
        textField.backgroundColor = UIColor.clear
        textField.placeholder = "Message"
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let publishLabel : UILabel = {
        let label = UILabel()
        label.text = "Pubish Section"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let publishToTopicButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Publish", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(publishTopicTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let publishSuccessfulLabel : UILabel = {
        let label = UILabel()
        label.text = "Not Published to any topic Yet"
        label.textColor = UIColor.red
        label.backgroundColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setUpView()
        
        clientID = "iOSClient-\(UUID().uuidString)"
        
        if let client = clientID {
            mqtt = CocoaMQTT(clientID: client, host: host, port: port)
        }
        mqtt?.delegate = self
        topicTextField.delegate = self
        publishMessageTextfield.delegate = self
        publishTopicTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func setUpView() {
        
        view.addSubview(connectButton)
        NSLayoutConstraint.activate([
            connectButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            connectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        view.addSubview(connectionSuccessfulLabel)
        NSLayoutConstraint.activate([
            connectionSuccessfulLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            connectionSuccessfulLabel.topAnchor.constraint(equalTo: connectButton.bottomAnchor, constant: 12)
            ])
        view.addSubview(topicTextField)
        NSLayoutConstraint.activate([
            topicTextField.topAnchor.constraint(equalTo: connectionSuccessfulLabel.bottomAnchor, constant: 20),
            topicTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
            topicTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            topicTextField.heightAnchor.constraint(equalToConstant: 30)
            ])
        view.addSubview(subscribeToTopicButton)
        NSLayoutConstraint.activate([
            subscribeToTopicButton.topAnchor.constraint(equalTo: topicTextField.bottomAnchor, constant: 12),
            subscribeToTopicButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        view.addSubview(subscriptionSuccessfulLabel)
        NSLayoutConstraint.activate([
            subscriptionSuccessfulLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subscriptionSuccessfulLabel.topAnchor.constraint(equalTo: subscribeToTopicButton.bottomAnchor, constant: 12)
            ])
        
        view.addSubview(publishLabel)
        NSLayoutConstraint.activate([
            publishLabel.topAnchor.constraint(equalTo: subscriptionSuccessfulLabel.bottomAnchor, constant: 30),
            publishLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12)
            ])

        view.addSubview(publishTopicTextField)
        NSLayoutConstraint.activate([
            publishTopicTextField.centerYAnchor.constraint(equalTo: publishLabel.centerYAnchor),
            publishTopicTextField.leadingAnchor.constraint(equalTo: publishLabel.trailingAnchor, constant: 12),
            publishTopicTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
            ])

        view.addSubview(publishMessageTextfield)
        NSLayoutConstraint.activate([
            publishMessageTextfield.leadingAnchor.constraint(equalTo: publishLabel.leadingAnchor),
            publishMessageTextfield.topAnchor.constraint(equalTo: publishLabel.bottomAnchor, constant: 18),
            publishMessageTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
            ])

        view.addSubview(publishToTopicButton)
        NSLayoutConstraint.activate([
            publishToTopicButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            publishToTopicButton.topAnchor.constraint(equalTo: publishMessageTextfield.bottomAnchor, constant: 12)
            ])

        view.addSubview(publishSuccessfulLabel)
        NSLayoutConstraint.activate([
            publishSuccessfulLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            publishSuccessfulLabel.topAnchor.constraint(equalTo: publishToTopicButton.bottomAnchor, constant: 8)
            ])
        
        view.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.heightAnchor.constraint(equalToConstant: 44)
            ])
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        if topicTextField.isEditing {
            topicTextField.resignFirstResponder()
        }
        else if publishTopicTextField.isEditing {
            publishTopicTextField.resignFirstResponder()
        }
        else if publishMessageTextfield.isEditing {
            publishMessageTextfield.resignFirstResponder()
        }
        else{
            view.endEditing(true)
        }
    }
    
    
    @objc func connectButtonTapped() {
        view.endEditing(true)
        if let mqtt = mqtt {
            mqtt.connect()
        }
    }
    
    @objc func subscribeToTopicTapped() {
        view.endEditing(true)
        if let topic = topicTextField.text{
            if topic != "" {
                if let mqtt = mqtt {
                    if mqtt.connState == .connected {
                        mqtt.subscribe(topic)
                    }
                    else{
                        presentAlert(title: "Error", message: "You are not connected buddy!")
                    }
                }
            }
            else{
                presentAlert(title: "Warning", message: "No Topic Entered!")
            }
        }
    }
    
    
    @objc func publishTopicTapped() {
        view.endEditing(true)
        if let publishTopic = publishTopicTextField.text, let publishMessage = publishMessageTextfield.text {
            if publishTopic != "" && publishMessage != "" {
                if let mqtt = mqtt {
                    if mqtt.connState == .connected {
                        mqtt.publish(publishTopic, withString: publishMessage)
                    }
                    else{
                        presentAlert(title: "Error", message: "You are not connected buddy!")
                    }
                }
            }
            else{
                presentAlert(title: "Error", message: "Enter both Publish topic and message")
            }
        }
    }
    
    //MARK:- TextField Delegate Function
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //MARK:- MQTT Delegate Functions
    
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("connection successful : \(ack.description)")
        DispatchQueue.main.async {
            self.connectionSuccessfulLabel.text = "Connection Successful."
            self.connectionSuccessfulLabel.textColor = UIColor.green
            self.connectButton.isEnabled = false
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("didSubscribeTopic \(topic)")
        DispatchQueue.main.async {
            self.subscriptionSuccessfulLabel.text = "Subscribed to \(topic)"
            self.subscriptionSuccessfulLabel.textColor = UIColor.green
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage")
        DispatchQueue.main.async {
            if let msgText = message.string {
                self.publishSuccessfulLabel.text = "Published \(msgText) to \(message.topic)"
                self.publishSuccessfulLabel.textColor = UIColor.green
                self.publishMessageTextfield.text = ""
            }
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck")
    }
    
    
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didReceiveMessage")
        DispatchQueue.main.async {
            if let messageText = message.string{
                self.messageLabel.text = "\(messageText)"
            }
        }
    }
    
    
    
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("didUnsubscribeTopic")
        DispatchQueue.main.async {
            self.subscriptionSuccessfulLabel.text = "UnSubscribed to \(topic)"
            self.subscriptionSuccessfulLabel.textColor = UIColor.green
            self.subscribeToTopicButton.setTitle("Subscribe", for: .normal)
        }
    }
    
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("mqttDidPing")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("mqttDidReceivePong")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("mqttDidDisconnect")
        DispatchQueue.main.async {
            self.connectionSuccessfulLabel.text = "Not Connected to server Yet"
            self.connectionSuccessfulLabel.textColor = UIColor.red
            self.connectButton.isEnabled = true
        }
    }
    
    
    //MARK:- present alert view
    
    func presentAlert(title : String, message : String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}

