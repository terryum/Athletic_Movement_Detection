# Athletic_Movement_Detection
These are the source codes for the paper, "An unsupervised approach to detecting and isolating athletic movements", EMBC2016. Please visit [my webpage](http://terryum.io/publications/#EMBC2016) for more papers, slides, etc.

## Instruction

1. Download [Human-Robot Motion Simulator](https://github.com/terryum/Human-Robot-Motion-Simulator-based-on-Lie-Group) from my GitHub repo. 
2. Set path the downloaded folders (including subfolders): <br/>
  *Home - Set path - Add with subfolders - choose the downloaded folders*
3. Open the [Main_AthleticMovemetDetection.m](https://github.com/terryum/Athletic_Movement_Detection/blob/master/Main_AthleticMovemetDetection.m) file and run it (F5)
4. You can change the options (e.g. exercises, threshold value) as described in the comments in the main file.

## Demo

![Code_Execution_Terry_EMBC2016](https://s3.amazonaws.com/www.terryum.io/images/EMBC2016_Code.gif)

## Files
* [Main_AthleticMovemetDetection.m](https://github.com/terryum/Athletic_Movement_Detection/blob/master/Main_AthleticMovemetDetection.m)        : Main file
* [GetFileNames.m](https://github.com/terryum/Athletic_Movement_Detection/blob/master/GetFileNames.m)     : Get filenames for loading exercise data
* [GetManipulability.m](https://github.com/terryum/Athletic_Movement_Detection/blob/master/GetManipulability.m) : Calculate manipulability for detecting pre-stretch poses
* [LieConvolution.m](https://github.com/terryum/Athletic_Movement_Detection/blob/master/LieConvolution.m) : Calculate kinematic synergys by using BCH formula
* [MyPCA.m](https://github.com/terryum/Athletic_Movement_Detection/blob/master/MyPCA.m) & [eigdec.m](https://github.com/terryum/Athletic_Movement_Detection/blob/master/eigdec.m) : Perform PCA (Imported from [Maaten's Dim. Reduction Library](https://lvdmaaten.github.io/drtoolbox/)
* [/MocapData](https://github.com/terryum/Athletic_Movement_Detection/tree/master/MocapData)       :  CMU motion capture data for example codes (You can experiment with other mocap data by downloading from [CMU Mocap Database](http://mocap.cs.cmu.edu/))

## Terms of Use & Citation
Feel free to reuse the codes for your own research with your own risk. If you feel being helped by the codes, please cite the below paper.

>Terry T. Um and Dana Kulić,  An unsupervised approach to detecting and isolating athletic movements,  In 38th Annual International Conference of the IEEE Engineering in Medicine and Biology Society,  2016. 

You can download my paper and slides from [my webpage](http://terryum.io/publications/#EMBC2016)
