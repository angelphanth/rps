## Playing Rock Paper Scissors against the Computer using a Webcam! 
Using deep learning (VGG16) to classify hand-gestures for a Rock Paper Scissors (RPS) game. 

![demo](demo.gif)

### Project Summary

I sought to create a RPS game where you could play against the computer using your webcam. 

In order to achieve this I first had to train a Convolutional Neural Network (CNN) to classify RPS hand-gestures from images and then evaluate the CNNs performance on new images (i.e., a test set of images, and images taken from a webcam). 

A VGG16 CNN was trained on a combined dataset of [CGI-generated images created by Laurence Moroney](http://www.laurencemoroney.com/rock-paper-scissors-dataset/) and [real-life images created by Kaggle user drgfreeman](https://www.kaggle.com/drgfreeman/rockpaperscissors#README_rpc-cv-images.txt). 

The real-life RPS images underwent preprocessing in `image_preprocessing.ipynb` to have similar formatting as the CGI-generated RPS images. The preprocessing included:

- Replacing the green with a white background, 

- Resizing the image from 300 pixels wide by 200 pixels high to 300 by 300 (while maintaining image aspect ratio), and

- Rotating the image 90 degrees clockwise. 

A test set of images of ~18% was then completed using the shell script `combined_test.sh`. 

In the notebook `rps_VGG16.ipynb` a VGG16 CNN was then configured and trained on the RPS images having undergone random augmentation (e.g., horizontal and vertical flipping, rotations, shearing, shifting height- and width-wise) using `keras.preprocessing.imageImageDataGenerator()` to improve the model's performance on new images. 

The VGG16 that achieved the highest accuracy score on the validation set of training images was selected as the `best_model` and its weights were saved to `best_weights_vgg16.h5`. 

The `best_model`'s performance was then tested on the test set of images and achieved an accuracy score of 99.3% and precision, recall and f1 scores of 96 - 100%. 

In notebook `real-time_test.ipynb`, the best VGG16 model was then tested on 120 (40 per class) new images taken in real-time from 640x480 webcam capture. On the new images (displayed in the notebook), the model achieved an accuracy score of 90% and precission, recall and f1 scores of 77 - 100%. 

Now equipped with a CNN model that could classify RPS hand-gestures from webcam images, the model was implemented in a RPS game created in the notebook `rps_against_cpu.ipynb`. 

This was accomplished by creating a series of functions responsible for: 

- Randomly choosing one of RPS to be the computer's move, 

- Implementing the trained CNN model to classify our chosen RPS move from webcam capture, 

- Determining the outcome of the match (win, loss, draw), 

- Returning the match outcome after every match, and 

- Summarizing the results of all matches in a series of plotly visualizations. 

**Please see the aforementioned notebooks for a thorough breakdown of the project and feel free to message me on [LinkedIn](https://www.linkedin.com/in/angelphanth/) if you had any questions!** 

Or if you were interested in re-creating the game to play on your own computer: 

- The datasets are linked above and in `image_preprocessing.ipynb`, and 

- I have included `keras_gpu.txt` and `keras_cpu.txt` that you can use to create a conda environment (e.g. `conda env create --file keras_gpu.txt`) where you can train a CNN using your GPU or CPU, respectively. The environments also include the usual python libraries, Open CV, plotly and should allow you to use Jupyter notebook (and all the aforementioned notebooks).  