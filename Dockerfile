FROM ubuntu:latest
RUN apt-get update && apt-get install -y \
    software-properties-common \
    tzdata && \
    apt-add-repository -y ppa:git-core/ppa && \
    apt-get update && \
    apt-get install -y \
    sudo \
    wget \
    curl \
    git \
    vim \
    mecab \
    libmecab-dev \
    mecab-ipadic \
    mecab-ipadic-utf8 \
    libc6-dev \
    build-essential \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libglib2.0-0 && \
    sudo curl -sL https://deb.nodesource.com/setup_12.x | sudo bash - && \
    sudo apt-get install -y nodejs
# NEologd辞書のインストール
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git && \
    cd mecab-ipadic-neologd && \
    ./bin/install-mecab-ipadic-neologd -n -y && \
    sudo cp /etc/mecabrc /usr/local/etc/
WORKDIR /opt
# Anacondaのインストール
RUN wget https://repo.continuum.io/archive/Anaconda3-2020.07-Linux-x86_64.sh && \
    sh /opt/Anaconda3-2020.07-Linux-x86_64.sh -b -p /opt/anaconda3 && \
    rm -f Anaconda3-2020.07-Linux-x86_64.sh
ENV PATH /opt/anaconda3/bin:$PATH
# パッケージインストール
RUN pip install --upgrade pip && \
    conda update -n base -c defaults conda && \
    pip install \
    autopep8 \
    jupyterlab_code_formatter \
    jupyterlab-git \
    janome \
    mecab-python3 \
    opencv-python \
    nibabel && \
    conda install -y -c anaconda pymysql
# JupyterLabの拡張機能
RUN jupyter labextension install @lckr/jupyterlab_variableinspector && \
    jupyter labextension install @jupyterlab/toc && \
    jupyter labextension install @ryantam626/jupyterlab_code_formatter && \
    jupyter serverextension enable --py jupyterlab_code_formatter
# jupyter labextension install @jupyterlab/git && \
# jupyter serverextension enable --py jupyterlab_git && \
# pip install --upgrade jupyterlab-git
WORKDIR /
RUN mkdir /work
CMD ["jupyter","lab","--ip=0.0.0.0","--allow-root","--LabApp.token=''"]