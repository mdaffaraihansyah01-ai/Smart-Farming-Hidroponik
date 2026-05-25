#include <ESP8266WiFi.h>
#include <PubSubClient.h>

// Konfigurasi WiFi
const char* ssid     = "Kopi Kenangan";
const char* password = "abcdefgh";

// Konfigurasi Broker EMQX
const char* mqtt_server   = "broker.emqx.io";
const int mqtt_port       = 1883;
const char* mqtt_user     = ""; 
const char* mqtt_pass     = "";

// Definisikan Topik MQTT
const char* topic_publish      = "smartfarming/sensor/data";
const char* topic_subscribe    = "smartfarming/kontrol/perintah";
const char* topic_pub_status   = "smartfarming/actuator/status";   // TOPIK BARU (Publish)
const char* topic_sub_settings = "smartfarming/sensor/threshold"; // TOPIK BARU (Subscribe)
const char* topic_lwt          = "smartfarming/system/status";    // Last Will (Online/Offline)

WiFiClient espClient;
PubSubClient client(espClient);

// Fungsi untuk menerima pesan masuk dari EMQX (Subscribe)
void callback(char* topic, byte* payload, unsigned int length) {
  String message = "";
  for (unsigned int i = 0; i < length; i++) {
    message += (char)payload[i];
  }
  
  String topicStr = String(topic);

  // Cek pesan datang dari topik mana
  if (topicStr == topic_subscribe) {
    // Meneruskan perintah kontrol langsung ke Arduino Mega
    Serial.print("CTRL:");
    Serial.println(message); 
    
    // Memberikan feedback ke MQTT bahwa perintah diterima
    client.publish(topic_pub_status, ("ACK: " + message).c_str());
  } 
  else if (topicStr == topic_sub_settings) {
    // Meneruskan pengaturan ambang batas ke Arduino Mega
    Serial.print("SET:");
    Serial.println(message);
  }
}

void setup_wifi() {
  delay(10);
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWiFi connected");
}

// Fungsi reconnect jika koneksi ke EMQX terputus
void reconnect() {
  while (!client.connected()) {
    String clientId = "ESP8266Client-SmartFarming-";
    clientId += String(random(0xffff), HEX);
    
    // Connect dengan Last Will and Testament (LWT)
    // Jika koneksi terputus tiba-tiba, broker akan mengirim "offline" ke topic_lwt
    if (client.connect(clientId.c_str(), mqtt_user, mqtt_pass, topic_lwt, 1, true, "offline")) {
      Serial.println("MQTT Connected");
      
      // Publish status online
      client.publish(topic_lwt, "online", true);

      // Daftarkan semua topik Subscribe
      client.subscribe(topic_subscribe);
      client.subscribe(topic_sub_settings); // Subscribe ke topik baru
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

void setup() {
  // Hubungkan ke Arduino Mega dengan baudrate 115200
  Serial.begin(115200); 
  
  setup_wifi();
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  // Membaca data kiriman dari Arduino Mega (Format CSV)
  if (Serial.available() > 0) {
    String dataMasuk = Serial.readStringUntil('\n');
    dataMasuk.trim();

    if (dataMasuk.length() == 0) return;

    // Jika data diawali dengan 'STAT:', ini adalah status aktuator dari Mega
    if (dataMasuk.startsWith("STAT:")) {
      String statusAktuator = dataMasuk.substring(5);
      client.publish(topic_pub_status, statusAktuator.c_str());
      return;
    }

    String dataSensor[7]; 
    int indeksSuku = 0;
    int posisiAwal = 0;

    // Parsing data CSV dari Mega
    for (int i = 0; i < dataMasuk.length() && indeksSuku < 7; i++) {
      if (dataMasuk.charAt(i) == ',') {
        dataSensor[indeksSuku] = dataMasuk.substring(posisiAwal, i);
        posisiAwal = i + 1;
        indeksSuku++;
      }
    }
    
    // Ambil suku terakhir
    if (indeksSuku < 7) {
      dataSensor[indeksSuku] = dataMasuk.substring(posisiAwal);
    }

    // Ambil data jika parsing lengkap (terdapat 7 kolom data: 0-6)
    if (indeksSuku == 6) {
      String sUdara    = dataSensor[0];
      String hUdara    = dataSensor[1];
      String sAir      = dataSensor[2];
      String lvlAir    = dataSensor[3];
      String sMoisture = dataSensor[4];
      String ph        = dataSensor[5];
      String lux       = dataSensor[6];

      // Membungkus data menjadi format JSON String
      String jsonPayload = "{";
      jsonPayload += "\"suhu_udara\":" + sUdara + ",";
      jsonPayload += "\"kelembapan_udara\":" + hUdara + ",";
      jsonPayload += "\"suhu_air\":" + sAir + ",";
      jsonPayload += "\"status_air\":" + lvlAir + ",";
      jsonPayload += "\"kelembapan_tanah\":" + sMoisture + ",";
      jsonPayload += "\"ph_air\":" + ph + ",";
      jsonPayload += "\"intensitas_cahaya\":" + lux;
      jsonPayload += "}";

      // Publish Payload JSON ke Broker EMQX
      client.publish(topic_publish, jsonPayload.c_str());
    }
  }
}
