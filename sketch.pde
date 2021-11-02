// This is an example sketch for using the Devices library
// Feel free to clear it and start from scratch!

// First open following website on your phone:
// https://generative-sensors.herokuapp.com/

// Put id of your device as an argument to te constructor
// or leave blank to obtain all devices
// Note: to make this example work, put your device ID here
Devices dev = new Devices(/* DEVICE ID */);

void setup() {
  size(1000, 1000);
  
  // Setup goes here
}

void draw() {
  // Note: You can remove everything from the draw function,
  // this is just an example of obtaining the data
  background(33);
  fill(33);
  stroke(200);
  strokeWeight(3);
  translate(width / 2, height / 2);
  
  // Get list of all devices you are fetching
  // (0-n if no ID was provided, 1 if an ID was provided)
  Device[] devices = dev.devices;
  
  // Check if we have at least one device
  if (devices.length > 0) {
    
    // For simplicity we will get the first one
    Device device = devices[0];

    
    // The device can provide following sensors:
    
    // Accelerometer
    // Provides the acceleration applied to the device along all three axes.
    PVector accel = device.Accelerometer;
    
    // Gyroscope
    // Provides the angular velocity of the device along all three axes.
    PVector gyro = device.Gyroscope;
    
    // LinearAccelerationSensor
    // Provides the acceleration applied to the device along all three axes,
    // but without the contribution of gravity.
    PVector linAcc = device.LinearAccelerationSensor;
    
    // AbsoluteOrientationSensor
    // Describes the device's physical orientation in relation to the
    // Earth's reference coordinate system.
    Quaternion absolute = device.AbsoluteOrientationSensor;
    
    // RelativeOrientationSensor
    // Describes the device's physical orientation without regard to
    // the Earth's reference coordinate system.
    Quaternion relative = device.RelativeOrientationSensor;
    
    // ID
    // Device unique identifier
    String id = device.id;
    
    
    // If the device does not have the given sensor, null is returned
    // instead, so we should check, if the sensor exists on the given device
    
    if (device.LinearAccelerationSensor != null) {
      
      // Now we can try to use it
      circle(device.LinearAccelerationSensor.x, device.LinearAccelerationSensor.y, 50);
      
      // If everything goes well, we should have a circle, that shakes
      // every time you shake your phone.
      
      // NOW IT'S YOUR TURN :D
    }
  }
}
