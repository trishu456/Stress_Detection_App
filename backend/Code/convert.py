import tensorflow as tf
from tensorflow.keras.models import load_model

# Load your model
model = load_model('stress_detector_model.h5', compile=False)

# Convert the model to TensorFlow Lite format
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

# Save the .tflite model
with open('stress_detector_model.tflite', 'wb') as f:
    f.write(tflite_model)

print("Model has been successfully converted to TensorFlow Lite format!")
