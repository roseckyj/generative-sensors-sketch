import java.net.URLConnection;
import java.net.HttpURLConnection;
import java.net.URL;
import java.io.InputStreamReader;
import java.util.*;

static class SensorsPool {
  private static boolean running = false;
  
  private static ArrayList<Updatable> updatables = new ArrayList();
  
  public static void register(Updatable updatable) {
    SensorsPool.updatables.add(updatable);
    
    if (!SensorsPool.running) {
      new Timer().scheduleAtFixedRate(new TimerTask(){
        @Override
        public void run(){
           SensorsPool.fetch();
        }
      },0,10);
    }
  }
  
  private static void fetch() {
    for(int i = 0; i < updatables.size(); i++) {
      updatables.get(i).update();
    }
  }
}

abstract class Updatable {
  public abstract void update();
  
  protected JSONObject request(String url) throws IOException {
    URLConnection connection = new URL(url).openConnection();
    connection.setDoOutput(true);
    connection.setRequestProperty("Content-Type", "text/plain");     
    
    // Request is lazily fired whenever you need to obtain information about response.
    BufferedReader response = new BufferedReader(new InputStreamReader(((HttpURLConnection) connection).getInputStream()));
    String jsonString = response.readLine();
    return  parseJSONObject(jsonString);
  }
}

class Device {
  public Device(String id, JSONObject obj) {
    this.id = id;
     
    Accelerometer = JSONToVector(obj, "Accelerometer");
    Gyroscope = JSONToVector(obj, "Gyroscope");
    LinearAccelerationSensor = JSONToVector(obj, "LinearAccelerationSensor");
    AbsoluteOrientationSensor = JSONToQuaternion(obj, "AbsoluteOrientationSensor");
    RelativeOrientationSensor = JSONToQuaternion(obj, "RelativeOrientationSensor");
  }
    
  private PVector JSONToVector(JSONObject obj, String key) {
    try {
      JSONObject o = obj.getJSONObject(key);
      return new PVector(o.getFloat("x"),o.getFloat("y"),o.getFloat("z"));
    } catch(RuntimeException e) {
      return null;
    }
  }
  
  private Quaternion JSONToQuaternion(JSONObject obj, String key) {
    try {
      JSONObject o = obj.getJSONObject(key);
      return new Quaternion(o.getFloat("x"),o.getFloat("y"),o.getFloat("z"),o.getFloat("w"));
    } catch(RuntimeException e) {
      return null;
    }
  }
  
  public String id = null; 
  
  public PVector Accelerometer = null;
  public PVector Gyroscope = null;
  public PVector LinearAccelerationSensor = null;
  public Quaternion AbsoluteOrientationSensor = null;
  public Quaternion RelativeOrientationSensor = null;
}

class Devices extends Updatable {
  private String SENSORS_URL = "https://generative-sensors.herokuapp.com/";
  
  private String id;
  public Device[] devices = new Device[0];
  
  public Devices(String id) {
    this.id = id;
    SensorsPool.register(this);    
  }
  
  public Devices(int id) {
    this.id = String.format("%06d", id);
    SensorsPool.register(this);    
  }
  
  public Devices() {
    SensorsPool.register(this);    
  }
  
  public void update() {
    try {
      if (this.id == null) {
        String url = SENSORS_URL + "get-all";
        JSONObject res = request(url);
        
        Set keys = res.keys();
        Device[] devices = new Device[keys.size()];
        
        int i = 0;
        for (Object key : keys) {
          JSONObject obj = res.getJSONObject(key.toString());
          devices[i] = new Device(key.toString(), obj);
          
          i++;
        }
        
        this.devices = devices;
      } else {
        String url = SENSORS_URL + "get?id=" + this.id;
        JSONObject obj = request(url);
        
        Device[] devices = new Device[1];
        devices[0] = new Device(id, obj);
        
        this.devices = devices;
      }
    
    } catch (Exception e) {
      println(e);
    }
  }
}
