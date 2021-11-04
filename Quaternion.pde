// Adapted from https://discourse.processing.org/t/3d-rotations-rotating-around-the-screen-axes/14239/26

class Quaternion {
  float x = 0.0;
  float y = 0.0;
  float z = 0.0;
  float w = 1.0;

  Quaternion() {
  }

  Quaternion(Quaternion q) {
    set(q);
  }

  Quaternion(float x, float y, float z, float w) {
    set(x, y, z, w);
  }

  Quaternion div(float scalar) {
    return mult(1.0 / scalar);
  }

  Quaternion mult(float scalar) {
    x *= scalar; 
    y *= scalar; 
    z *= scalar; 
    w *= scalar;
    return this;
  }

  Quaternion normalize() {
    float m = magSq();
    if (m != 0.0 && m != 1.0) {
      div(sqrt(m));
    }
    return this;
  }

  Quaternion mult(Quaternion b) {
    
    // Caveat: quaternion multiplication is not commutative.
    
    float tx = x;
    float ty = y;
    float tz = z;
    x = x * b.w + w * b.x + y * b.z - z * b.y;
    y = y * b.w + w * b.y + z * b.x - tx * b.z;
    z = z * b.w + w * b.z + tx * b.y - ty * b.x;
    w = w * b.w - tx * b.x - ty * b.y - tz * b.z;
    return this;
  }

  Quaternion set(float angle, PVector axis) {
    
    // Assumes that the axis is of unit length, i.e.,
    // has a magnitude of 1.
    
    float halfangle = 0.5 * angle;
    float sinhalf = sin(halfangle);
    x = axis.x * sinhalf; 
    y = axis.y * sinhalf;
    z = axis.z * sinhalf; 
    w = cos(halfangle);
    return this;
  }

  Quaternion set(Quaternion q) {
    return set(q.x, q.y, q.z, q.w);
  }

  Quaternion set(float x, float y, float z, float w) {
    this.x = x; 
    this.y = y; 
    this.z = z; 
    this.w = w;
    return this;
  }

  float magSq() {
    
    // The quaternion's dot product with itself, i.e., dot(q, q).
    
    return x * x + y * y + z * z + w * w;
  }

  PMatrix3D toMatrix() {
    PMatrix3D out = new PMatrix3D();
    
    float x2 = x + x; 
    float y2 = y + y; 
    float z2 = z + z;
    float xsq2 = x * x2; 
    float ysq2 = y * y2; 
    float zsq2 = z * z2;
    float xy2 = x * y2; 
    float xz2 = x * z2; 
    float yz2 = y * z2;
    float wx2 = w * x2; 
    float wy2 = w * y2; 
    float wz2 = w * z2;
    out.set(
      1.0 - ysq2 - zsq2, xy2 - wz2, xz2 + wy2, 0.0, 
      xy2 + wz2, 1.0 - xsq2 - zsq2, yz2 - wx2, 0.0, 
      xz2 - wy2, yz2 + wx2, 1.0 - xsq2 - ysq2, 0.0, 
      0.0, 0.0, 0.0, 1.0);
    return out;
  }

  Quaternion ease(Quaternion b, float t) {
    
    // This is a simplistic form of easing. For situations
    // where you need torque minimization, do not use this.
    // Use spherical linear interpolation instead.
    
    if (t <= 0.0) {
      return normalize();
    }

    if (t>=1.0) {
      return set(b).normalize();
    }

    float u = t * t * (3.0 - 2.0 * t);
    float v = 1.0 - u;
    x = v * x + u * b.x; 
    y = v * y + u * b.y; 
    z = v * z + u * b.z; 
    w = v * w + u * b.w;
    return normalize();
  }
}
