# IDN-TensorFlow

---

## Introduction

This repository is TensorFlow implementation of IDN(CVPR16). 

You can see more details from paper and author's project repository

- Github : [[IDN-Caffe]](https://github.com/Zheng222/IDN-Caffe)

- Paper : ["Fast and Accurate Single Image Super-Resolution via Information Distillation Network"](<http://openaccess.thecvf.com/content_cvpr_2018/papers/Hui_Fast_and_Accurate_CVPR_2018_paper.pdf>)

---

## Network Structure

>  IDN-TensorFlow/model/network.py

![IDN Network Structure](./resources/figure/001-idn.png)

- **FBlock : Feqture extraction block**

  

![FBlock](./resources/figure/002-fblock.png)

- **DBlock : Information Distillation block**
  
  - Consists of **Enhancement unit** and **Compression unit**
  
    

![DBlock](./resources/figure/003-dblock.png)

- **RBlock : Reconstruction block**
  
  - De-convolution
  
    

![RBlock](./resources/figure/004-rblock.png)



- LR denotes Low Resolution image
- SR denotes reconstructed super resolution image

---

## Training

### Loss Function

> \_loss_function(self, reg_parameter) in IDN-TensorFlow/model/\_\__init\_\_.py

- Pre-training stage : L2 loss


$$
Loss(W)=\frac{1}{2}||y-f(x)||^{2}
$$


- Fine tuning stage : L1 loss

$$
Loss(W)=|r-f(x)|
$$

- Regularization

  - L2 regularization

  $$
  reg(W)=\frac{\lambda}{2}\sum_{w \in W} {||w||^{2}}
  $$

  

- Notations
  - $W$ : Weights in IDN
  - $y$ : ground truth (original high resolution image, HR)
  - $x$ : interpolated low resolution image (ILR)
  - $f(x)$ : reconstructed super resolution image
  - $r$ : residual between HR and ILR
    - $r = y-x$
  - $\lambda$ : regularization parameter
    -  $\lambda$ : 0.0001



### Optimization

> \_optimization_function(self, grad_clip, momentum_rate) in IDN-TensorFlow/model/\_\__init\_\_.py

- Optimization Method 

  - ADAM method [[paper]](<https://arxiv.org/pdf/1412.6980.pdf>)
  
- Weight Initialization

  - He initialization [[paper]](<https://www.cv-foundation.org/openaccess/content_iccv_2015/papers/He_Delving_Deep_into_ICCV_2015_paper.pdf>)

- **Learning Rate**

  - Initial Learning rate : 1e-4
  
- **Learning Rate Decay**

  - Learning rate decay is applied in tine tuning stage

  ![learning rage in training](./resources/figure/005-learning_rate.png)

  - Learning rate is decreased by factor of 10 for every 250 epochs

- Epochs 

  - Pre-training stage: 100
  - Fine tuning stage : 600

---

## Data Set

### Training Data


> IDN-TensorFlow/data/generate_dataset/train_data.m

- 291 images
  - Download from Author's Repository
- Data Augmentations (Rotation, flip) were used
- Scale Factor : $\times 2$, $\times 3$, $\times 4$
- Patch size 

| scale | Pre-Training (LR / GT) | Fine Tuning (LR / GT) |
| ----- | ---------------------- | --------------------- |
| 2     | 29 / 58                | 39 / 78               |
| 3     | 15 / 45                | 26 / 78               |
| 4     | 11 / 44                | 19 / 76               |

- Batch size : 64



### Testing Data

>  IDN-TensorFlow/data/generate_dataset/test_data.m

- Set5, Set14, B100, Urban100
  - Download from Author's page [[zip(test)]](https://cv.snu.ac.kr/research/VDSR/test_data.zip)
- Bicubic interpolation is used for LR data acquisition
- Scale Factor : $\times 2$, $\times 3$, $\times 4$

---

## Results

### Validation

PSNR performance plot on Set5

- Scale 2

  |              |             |
  | ------------ | ----------- |
  | Pre-training | Fine Tuning |

  

- Scale 3

  |              |             |
  | ------------ | ----------- |
  | Pre-training | Fine Tuning |

  

- Scale 4

  |              |             |
  | ------------ | ----------- |
  | Pre-training | Fine Tuning |

  

### Objective Quality Assessment

#### Methods

- Bicubic Interpolation 
  - imresize(..., ..., 'bicubic') in Matlab
- IDN(Original)
  - Author's Caffe implementation [[Code]](https://github.com/Zheng222/IDN-Caffe)
- IDN (TensorFlow)
  - TensorFlow implementation
  - Train Details for Comparison
    - Data Augmentation
      - Rotation : 90°, 180°, 270°
      - Flip : left / right
      - Down scale : 0.9, 0.8, 0.7, 0.6


#### Average PSNR/SSIM

- **Set5**
- Pre-Training

| scale      | Bicubic        | IDN (Original) | IDN (TensorFlow) |
| ---------- | -------------- | -------------- | ---------------- |
| $\times 2$ | 33.68 / 0.9304 |                |                  |
| $\times 3$ | 30.40 / 0.8682 |                |                  |
| $\times 4$ | 28.43 / 0.8104 |                |                  |



- Fine Tuning

| scale      | Bicubic        | IDN (Original) | IDN (TensorFlow) |
| ---------- | -------------- | -------------- | ---------------- |
| $\times 2$ | 33.68 / 0.9304 |                |                  |
| $\times 3$ | 30.40 / 0.8682 |                |                  |
| $\times 4$ | 28.43 / 0.8104 |                |                  |



- **Set14**
- Pre-Training

| scale      | Bicubic        | IDN (Original) | IDN (TensorFlow) |
| ---------- | -------------- | -------------- | ---------------- |
| $\times 2$ | 30.24 / 0.8693 |                |                  |
| $\times 3$ | 27.54 / 0.7746 |                |                  |
| $\times 4$ | 26.00 / 0.7029 |                |                  |



- Fine Tuning

| scale      | Bicubic        | IDN (Original) | IDN (TensorFlow) |
| ---------- | -------------- | -------------- | ---------------- |
| $\times 2$ | 30.24 / 0.8693 |                |                  |
| $\times 3$ | 27.54 / 0.7746 |                |                  |
| $\times 4$ | 26.00 / 0.7029 |                |                  |

- **B100**
- Pre-Training

| scale      | Bicubic        | IDN (Original) | IDN (TensorFlow) |
| ---------- | -------------- | -------------- | ---------------- |
| $\times 2$ | 29.56 / 0.8442 |                |                  |
| $\times 3$ | 27.21 / 0.7401 |                |                  |
| $\times 4$ | 25.96 / 0.6697 |                |                  |



- Fine Tuning

| scale      | Bicubic        | IDN (Original) | IDN (TensorFlow) |
| ---------- | -------------- | -------------- | ---------------- |
| $\times 2$ | 29.56 / 0.8442 |                |                  |
| $\times 3$ | 27.21 / 0.7401 |                |                  |
| $\times 4$ | 25.96 / 0.6697 |                |                  |

- **Urban100**
- Pre-Training

| scale      | Bicubic        | IDN (Original) | IDN (TensorFlow) |
| ---------- | -------------- | -------------- | ---------------- |
| $\times 2$ | 26.88 / 0.8410 |                |                  |
| $\times 3$ | 24.46 / 0.7358 |                |                  |
| $\times 4$ | 23.14 / 0.6588 |                |                  |



- Fine Tuning

| scale      | Bicubic        | IDN (Original) | IDN (TensorFlow) |
| ---------- | -------------- | -------------- | ---------------- |
| $\times 2$ | 26.88 / 0.8410 |                |                  |
| $\times 3$ | 24.46 / 0.7358 |                |                  |
| $\times 4$ | 23.14 / 0.6588 |                |                  |

---

### Visual Quality

- "img002" of Urban100 for scale factor $\times 2$

| Ground Truth | Bicubic | IDN (TensorFlow) Pre-train | IDN (Tensorflow) Fine Tuning |
| ------------ | ------- | -------------------------- | ---------------------------- |
|              |         |                            |                              |
|              |         |                            |                              |

- ???
- ???
- ???

---

## Difference with Authors Implementation

Image Size

Epochs and Learning rate decay step



---

## Usage

> **On Windows**
>
> - run.bat
>
> **On Linux** 
>
> - run.sh



### Training Command

Examples in scale 2

- in run.bat/sh
  
- Pre-training
    
  python main.py --model_name=idn_pre_x2 --is_train=True --scale=2 --pretrain=False --epochs=100 --data_path=data/train_data/idn_train_x2.h5
    
    
    
  - Fine Tuning
  
    python main.py --model_name=idn_x2 --is_train=True --scale=2 --pretrain=True --pretrained_model_name=idn_pre_x2 --learning_rate_decay=True --decay_step=250 --epochs=600 --data_path=data/train_data/idn_fine_tuning_x2.h5 

If you want to change other parameters for training, please see the file

> VDSR-TensorFlow/model/configurations.py 



### Testing Command

Examples in scale 2

in run.bat/sh

python main.py --model_name=idn_pre_x2 --is_train=False --scale=2



### Trained checkpoint in experiments

- checkpoint [[download]](https://drive.google.com/file/d/1wiej51wFY0oYsoKF7gGiWZT5_t5mFt0f/view?usp=sharing)

### Training dataset

- vdsr_train.h5 [[download]](https://drive.google.com/file/d/1wiej51wFY0oYsoKF7gGiWZT5_t5mFt0f/view?usp=sharing)
