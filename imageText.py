from imutils.object_detection import non_max_suppression
import numpy as np
import cv2
import pytesseract

def FlutterMobileVision():
    args = {"camera" : "OCR_camera",
      "east" : "frozen_east_text_detection.pb",
     "confidence" : 0.5,
     "width" : 320,
      "height" : 320,
     }
    pytesseract.pytesseract.tesseract_cmd = 'C:/Users/rishu/AppData/Local/Programs/Tesseract-OCR/tesseract.exe'

    vid = cv2.imread(args["image"])
    orig = vid.copy()
    (H, W) = vid.shape[:2]

    (newW, newH) = (args["width"], args["height"])
    rW = W / float(newW)
    rH = H / float(newH)

    image = cv2.resize(vid, (newW, newH))
    (H, W) = vid.shape[:2]

    layerNames = ["feature_fusion/Conv_7/Sigmoid",
              "feature_fusion/concat_3"]

    net = cv2.dnn.readNet(args["east"])

    blob = cv2.dnn.blobFromImage(vid, 1.0, (W, H),
    (123.68, 116.78, 103.94), swapRB=True, crop=False)

    net.setInput(blob)
    (scores, geometry) = net.forward(layerNames)

    (numRows, numCols) = scores.shape[2:4]
    rects = []
    confidences = []

    for y in range(0, numRows):
        scoresData = scores[0, 0, y]
        xData0 = geometry[0, 0, y]
        xData1 = geometry[0, 1, y]
        xData2 = geometry[0, 2, y]
        xData3 = geometry[0, 3, y]
        anglesData = geometry[0, 4, y]
    
        for x in range(0, numCols):
            if scoresData[x] < args["confidence"]:
                continue

            (offsetX, offsetY) = (4*x, 4*y)
            angle = anglesData[x]
            cos = np.cos(angle)
            sin = np.sin(angle)
            h = xData0[x] + xData2[x]
            w = xData1[x] + xData3[x]
            endX = int(offsetX + (cos * xData1[x]) + (sin * xData2[x]))
            endY = int(offsetY - (sin * xData1[x]) + (cos * xData2[x]))
            startX = int(endX - w)
            startY = int(endY - h)
            rects.append((startX, startY, endX, endY))
            confidences.append(scoresData[x])
        
    boxes = non_max_suppression(np.array(rects), probs=confidences)

    results = []

    for (startX, startY, endX, endY) in boxes:
        startX = int(startX * rW)
        startY = int(startY * rH)
        endX = int(endX * rW)
        endY = int(endY * rH)

        r = orig[startY:endY, startX:endX]

        configuration = ("-l eng --oem 1 --psm 11")
        text = pytesseract.image_to_string(r, config=configuration)
    
        results.append(((startX, startY, endX, endY), text))
    
    orig_vid = orig.copy()

    for ((start_X, start_Y, end_X, end_Y), text) in results:
        text = "".join([x if ord(x) < 128 else "" for x in text]).strip()
        cv2.rectangle(orig_vid, (start_X, start_Y), (end_X, end_Y),
        (0, 0, 255), 2)
        cv2.putText(orig_vid, text, (start_X, start_Y - 30),
        cv2.FONT_HERSHEY_SIMPLEX, 0.7,(0,0, 255), 2)

    return results
