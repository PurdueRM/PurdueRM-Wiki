---
layout: default
title: YoloV5 Annotation Forms
parent: archived
nav_order: 7
---

# Understanding the YoloV5 Annotation Format
### By Tom O'Donnell (tkodonne@purdue.edu)

To train YoloV5, we need both an image and an annotation file. The image is the original image, and the annotation file looks something like:

 Image.txt contents:

    5 0.209316 0.241667 0.116745 0.091667
    4 0.715802 0.295833 0.073113 0.091667

As such, the annotation file follows the format:

`class` `x_center` `y_center` `width` `height`

 Where box coordinates are normalized to the dimensions of the input image (meaning they take values between 0 and 1). For example, in a 416x416 image, the pixel `(0, 3)` would be normalized as `(0, 0.007212)`, where 0.007212 is simply `3/416`.

Using this knowledge, we can calculate translations to the image, which is a very common procedure in data augmentation and diversification. For example, let's say we want to shift the whole image right 15 pixels and down 25 pixels. First, NOTE THAT THE POSITIVE Y DIRECTION IS **DOWN**. This would imply that the original origin (0,0) is now (15, 25). 

As such, to apply this transformation, you'd add ([15/416], [25/416]) to the `x_center` and `y_center` parameters in the annotation file.

Personally, I think it's easiest to use a translation matrix and apply it via opencv:

    Trans_mat = np.float32([
        [1, 0, trans_x],
        [0, 1, trans_y]])

Using this knowledge, you should now understand the annotation file format used in YoloV5, and you should also know how to calculate simple translation operations for image augmentation  / data diversification purposes.
