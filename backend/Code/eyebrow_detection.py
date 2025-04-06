from scipy.spatial import distance as dist
from imutils.video import VideoStream
from imutils import face_utils
import numpy as np
import imutils
import time
import dlib
import cv2
import matplotlib.pyplot as plt
from keras.preprocessing.image import img_to_array
from keras.models import load_model

# Initialize variables
points = []

# Load pre-trained models
detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor("shape_predictor_68_face_landmarks.dat")
emotion_classifier = load_model("_mini_XCEPTION.102-0.66.hdf5", compile=False)

def eye_brow_distance(leye, reye):
    distq = dist.euclidean(leye, reye)
    points.append(int(distq))
    return distq

def emotion_finder(faces, frame):
    EMOTIONS = ["angry", "disgust", "scared", "happy", "sad", "surprised", "neutral"]
    x, y, w, h = face_utils.rect_to_bb(faces)
    frame = frame[y:y + h, x:x + w]
    
    roi = cv2.resize(frame, (64, 64))
    roi = roi.astype("float") / 255.0
    roi = img_to_array(roi)
    roi = np.expand_dims(roi, axis=0)

    preds = emotion_classifier.predict(roi)[0]
    label = EMOTIONS[preds.argmax()]
    
    return "stressed" if label in ["scared", "sad"] else "not stressed"

def normalize_values(points, disp):
    normalized_value = abs(disp - np.min(points)) / abs(np.max(points) - np.min(points) + 1e-5)
    stress_value = np.exp(-normalized_value)

    return stress_value, "High Stress" if stress_value >= 0.75 else "Low Stress"

# Start video capture
cap = cv2.VideoCapture(0)
time.sleep(2.0)

while True:
    ret, frame = cap.read()
    if not ret:
        break

    frame = cv2.flip(frame, 1)
    frame = imutils.resize(frame, width=500, height=500)
    
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    detections = detector(gray, 0)

    for detection in detections:
        emotion = emotion_finder(detection, gray)
        shape = predictor(gray, detection)
        shape = face_utils.shape_to_np(shape)

        lBegin, lEnd = face_utils.FACIAL_LANDMARKS_IDXS["right_eyebrow"]
        rBegin, rEnd = face_utils.FACIAL_LANDMARKS_IDXS["left_eyebrow"]

        leyebrow = shape[lBegin:lEnd]
        reyebrow = shape[rBegin:rEnd]

        cv2.drawContours(frame, [cv2.convexHull(reyebrow)], -1, (0, 255, 0), 1)
        cv2.drawContours(frame, [cv2.convexHull(leyebrow)], -1, (0, 255, 0), 1)

        distq = eye_brow_distance(leyebrow[-1], reyebrow[0])
        stress_value, stress_label = normalize_values(points, distq)

        cv2.putText(frame, f"Emotion: {emotion}", (10, 20), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)
        cv2.putText(frame, f"Stress Level: {int(stress_value * 100)}%", (10, 40), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)

    cv2.imshow("Stress Detection", frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()

# Plot stress level variation
plt.plot(range(len(points)), points, 'ro')
plt.title("Stress Levels Over Time")
plt.xlabel("Time")
plt.ylabel("Eyebrow Distance")
plt.show()

