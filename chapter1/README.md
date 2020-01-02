# Chapter1

## Section1:Swap channels
Load an image and switch channels from RGB to BGR.  

※The following is an example using cv2.COLOR_BGR2RGB  
```python
im_rgb = cv2.cvtColor(im_cv, cv2.COLOR_BGR2RGB)
```

|Input|Output|
|:---:|:---:|
|![](lenna.png)|![](section1/section_1_output.png)|

## Section2:Grayscale
Convert a color image to a grayscale image.  

※The following is an example using cv2.COLOR_BGR2GRAY  
```python
img_gry = cv2.cvtColor(im_cv, cv2.COLOR_BGR2GRAY)
```

|Input|Output|
|:---:|:---:|
|![](lenna.png)|![](section1/section_2_output.png)|

## Section3:Binarization
Binarize color images (convert to black and white).  

※The following is an example using cv2.THRESH_BINARY  
```python
img_thresh = cv2.threshold(im_cv, 128, 255, cv2.THRESH_BINARY)
```

|Input|Output|
|:---:|:---:|
|![](lenna.png)|![](section1/section_3_output.png)|


