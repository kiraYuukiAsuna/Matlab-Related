%作者：王瑞龙
%学号：2019213336
%标题：医学图像处理作业1_2019213336_王瑞龙
%文件：main.m
%描述：不使用Matlab自带函数histeq，自己编程实现灰度图像的直方图均衡化算法

close all;%关闭所有figure窗口
clear;%清除所有变量
clc;%清除控制台内容

figure_window=figure("NumberTitle", "off", "Name","医学图像处理作业1_2019213336_王瑞龙：直方图均衡化");%创建figure窗口
set(figure_window,"Position",[128,128,1024,768]);%设置figure窗口大小

image_origin=imread("origin_picture3.jpg");%加载原始图片
image_grayscale=rgb2gray(image_origin);%将原始图片转换为灰度图
image_histogram=imhist(image_grayscale);%计算原始图像灰度直方图
image_histeq=histeq(image_grayscale);%用Matlab自带函数计算原始图像直方图均衡化后的图片

%subplot(3,2,1);imshow(image_origin);title("原始图像：");
subplot(3,2,1);imshow(image_grayscale);title("原始图像灰度图：");
subplot(3,2,2);imhist(image_grayscale);title('原始图像灰度直方图');
subplot(3,2,3);imshow(image_histeq);title('Matlab自带函数原始图像直方图均衡化后的图像：');
subplot(3,2,4);imhist(image_histeq);title('Matlab自带函数原始图像直方图均衡化：');
subplot(3,2,5);imshow(myhisteq(image_grayscale));title('自己实现的直方图均衡化后图像：');
subplot(3,2,6);imhist(myhisteq(image_grayscale));title('自己实现的直方图均衡化：');

%函数名称：myhisteq
%参数：grayscale_image 灰度图
%返回值：image_histogram_equalization_image 直方图均衡化后的图片
%描述：自己编程实现灰度图像的直方图均衡化算法的函数
function image_histogram_equalization_image=myhisteq(grayscale_image)

image_size=size(grayscale_image);%获取图像大小
image_height=image_size(1);%获取图像宽度
image_width=image_size(2);%获取图像高度
image_pixel_total=image_width*image_height;%获取图像总像素点个数

%创建返回值，返回均衡化后的图像，大小与输入图像相同
image_histogram_equalization_image=grayscale_image;

%创建一个256长的数组用于存放各个灰度值包含的像素点个数
%也就是求图像灰度直方图
pixel_count=zeros(1,256);

%创建一个256长的数组用于存放各个灰度值所包含像素点个数占总像素点个数的比例
%也就是求归一化直方图
pixel_proportion=zeros(1,256);

%创建一个256长的数组用于存放累积直方图
cumulative_histogram=zeros(1,256);

%循环遍历每一点计算各个灰度值中包含的像素点个数
%也就是计算灰度直方图
for i=1:image_height
    for j=1:image_width
           pixel_count(grayscale_image(i,j)+1)=pixel_count(grayscale_image(i,j)+1)+1;
    end
end

%求每个灰度级包含像素点个数占总像素点个数的比例
%也就是计算归一化直方图
for i=1:256
   pixel_proportion(i)= pixel_count(i)/image_pixel_total;
end

%计算累积直方图
for i=1:256
    if i==1
        cumulative_histogram(i)=pixel_proportion(i);
    else
        cumulative_histogram(i)=cumulative_histogram(i-1)+pixel_proportion(i);
    end
end

%累积直方图*(L-1)后取整得到变换函数（L-1=255，因为灰度级0-255为256级）
transfrom_function=uint8(255*cumulative_histogram);

%计算均衡化后图像灰度图
for i=1:image_height
    for j=1:image_width
           image_histogram_equalization_image(i,j)=transfrom_function(grayscale_image(i,j)+1);
    end
end

end
