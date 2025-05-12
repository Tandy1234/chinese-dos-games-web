# 使用轻量的 Python 官方镜像
FROM python:3.11-slim

# 设置工作目录
WORKDIR /app

# 拷贝所有项目文件
COPY . .

# 安装git
RUN apt-get update && apt-get install -y git

# 安装依赖
RUN pip install --upgrade pip && pip install -r requirements.txt

# 初始化子模块并下载数据
RUN git submodule update --init --recursive --remote && \
    python3 ./static/games/download_data.py

# 设置环境变量（可选）
ENV PORT=10000d

# 启动应用（绑定 Render 要求的端口）
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:10000"]