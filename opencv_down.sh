echo ""
echo "[Note] Installing dependencies"
echo ""

sudo apt-get install -y cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev \
python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev \
build-essential mlocate libopenblas-dev liblapack-dev gfortran

cd ~
wget -O opencv.zip https://github.com/opencv/opencv/archive/4.5.0.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.5.0.zip
unzip opencv.zip
unzip opencv_contrib.zip
mv opencv-4.5.0 opencv
mv opencv_contrib-4.5.0 opencv_contrib

cd ~/opencv && mkdir build && cd build

# Jetson Nano 특화 설정을 추가
cmake -D CMAKE_BUILD_TYPE=Release \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
      -D WITH_CUDA=ON \
      -D ENABLE_FAST_MATH=1 \
      -D CUDA_FAST_MATH=1 \
      -D WITH_CUBLAS=1 ..

sudo make -j$(nproc)
sudo make install
sudo ldconfig

# Bash 설정을 갱신
sudo touch /etc/ld.so.conf.d/opencv.conf
sudo sh -c "echo \"/usr/local/lib\" >> /etc/ld.so.conf.d/opencv.conf"
sudo ldconfig
sudo sh -c "echo \"PKG_CONFIG_PATH=\$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig\" >> /etc/bash.bashrc"
sudo sh -c "echo \"export PKG_CONFIG_PATH\" >> /etc/bash.bashrc"
source /etc/bash.bashrc
sudo updatedb -y

echo ""
echo "[Note] OpenCV 4.5.0 installation complete"
echo ""
