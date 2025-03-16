#!/bin/bash

# 设置 OpenAI API 密钥（如果尚未设置）
if [ -z "$OPENAI_API_KEY" ]; then
  echo "请设置 OPENAI_API_KEY 环境变量"
  echo "例如: export OPENAI_API_KEY='你的OpenAI API密钥'"
  exit 1
fi

# 检查参数
if [ "$#" -lt 1 ]; then
  echo "用法: $0 <请求类型> [参数]"
  echo "请求类型:"
  echo "  init        - 初始化请求"
  echo "  list        - 获取工具列表"
  echo "  generate    - 生成图像 (需要提供提示词)"
  echo ""
  echo "示例:"
  echo "  $0 init"
  echo "  $0 list"
  echo "  $0 generate \"一只可爱的猫咪\" 1024 1024"
  exit 1
fi

# 创建日志目录
mkdir -p logs

# 获取当前时间戳
timestamp=$(date +"%Y%m%d_%H%M%S")
log_file="logs/single_request_${timestamp}.log"

request_type=$1
shift

case "$request_type" in
  init)
    echo "发送初始化请求..." | tee -a "$log_file"
    request='{
      "jsonrpc": "2.0",
      "id": 1,
      "method": "initialize",
      "params": {
        "protocolVersion": "2024-11-05",
        "clientInfo": {
          "name": "single-request-client",
          "version": "1.0.0"
        },
        "capabilities": {}
      }
    }'
    ;;
    
  list)
    echo "发送工具列表请求..." | tee -a "$log_file"
    request='{
      "jsonrpc": "2.0",
      "id": 2,
      "method": "tools/list"
    }'
    ;;
    
  generate)
    if [ "$#" -lt 1 ]; then
      echo "错误: 生成图像需要提供提示词" | tee -a "$log_file"
      exit 1
    fi
    
    prompt="$1"
    width=${2:-1792}
    height=${3:-1024}
    
    echo "发送生成图像请求..." | tee -a "$log_file"
    echo "提示词: $prompt" | tee -a "$log_file"
    echo "尺寸: ${width}x${height}" | tee -a "$log_file"
    
    request=$(cat <<EOF
{
  "jsonrpc": "2.0",
  "id": 3,
  "method": "tools/call",
  "params": {
    "name": "generate-image",
    "arguments": {
      "prompt": "$prompt",
      "width": $width,
      "height": $height
    }
  }
}
EOF
)
    ;;
    
  *)
    echo "错误: 未知的请求类型 '$request_type'" | tee -a "$log_file"
    exit 1
    ;;
esac

echo "请求内容:" | tee -a "$log_file"
echo "$request" | tee -a "$log_file"
echo "" | tee -a "$log_file"

echo "响应内容:" | tee -a "$log_file"
echo "$request" | ./bin/imagegen-go 2>> "$log_file" | tee -a "$log_file"

echo "" | tee -a "$log_file"
echo "完整日志已保存到: $log_file"