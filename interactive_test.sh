#!/bin/bash

# 设置 OpenAI API 密钥（如果尚未设置）
if [ -z "$OPENAI_API_KEY" ]; then
  echo "请设置 OPENAI_API_KEY 环境变量"
  echo "例如: export OPENAI_API_KEY='你的OpenAI API密钥'"
  exit 1
fi

# 创建日志目录
mkdir -p logs

# 获取当前时间戳
timestamp=$(date +"%Y%m%d_%H%M%S")
log_file="logs/interactive_${timestamp}.log"

echo "交互式 MCP 服务器测试" | tee -a "$log_file"
echo "日志文件: $log_file" | tee -a "$log_file"
echo "" | tee -a "$log_file"

# 初始化 MCP 服务器
echo "初始化 MCP 服务器..." | tee -a "$log_file"
initialize_request='{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "initialize",
  "params": {
    "protocolVersion": "2024-11-05",
    "clientInfo": {
      "name": "interactive-client",
      "version": "1.0.0"
    },
    "capabilities": {}
  }
}'

echo "$initialize_request" | ./bin/imagegen-go 2>> "$log_file" | tee -a "$log_file"
echo "" | tee -a "$log_file"

# 获取工具列表
echo "获取工具列表..." | tee -a "$log_file"
tools_list_request='{
  "jsonrpc": "2.0",
  "id": 2,
  "method": "tools/list"
}'

echo "$tools_list_request" | ./bin/imagegen-go 2>> "$log_file" | tee -a "$log_file"
echo "" | tee -a "$log_file"

# 交互式生成图像
while true; do
  echo "请输入图像提示词 (输入 'exit' 退出):"
  read prompt
  
  if [ "$prompt" = "exit" ]; then
    break
  fi
  
  echo "请输入图像宽度 (默认: 1792):"
  read width
  width=${width:-1792}
  
  echo "请输入图像高度 (默认: 1024):"
  read height
  height=${height:-1024}
  
  echo "生成图像: '$prompt' (${width}x${height})..." | tee -a "$log_file"
  
  # 构建请求
  generate_request=$(cat <<EOF
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
  
  echo "请求内容:" | tee -a "$log_file"
  echo "$generate_request" | tee -a "$log_file"
  echo "" | tee -a "$log_file"
  
  echo "响应内容:" | tee -a "$log_file"
  echo "$generate_request" | ./bin/imagegen-go 2>> "$log_file" | tee -a "$log_file"
  echo "----------------------------------------" | tee -a "$log_file"
  echo "" | tee -a "$log_file"
done

echo "测试结束" | tee -a "$log_file"
echo "完整日志已保存到: $log_file"