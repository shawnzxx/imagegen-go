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
log_file="logs/mcp_debug_${timestamp}.log"

# 测试函数
send_request() {
  local request=$1
  local description=$2
  local response_file="logs/response_${description// /_}_${timestamp}.json"
  
  echo "发送请求: $description"
  echo "请求内容:" | tee -a "$log_file"
  echo "$request" | tee -a "$log_file"
  echo "" | tee -a "$log_file"
  
  echo "响应内容:" | tee -a "$log_file"
  echo "$request" | ./bin/imagegen-go 2>> "$log_file" | tee "$response_file" | tee -a "$log_file"
  echo "----------------------------------------" | tee -a "$log_file"
  echo "响应已保存到: $response_file"
  echo "" | tee -a "$log_file"
}

# 初始化请求
initialize_request='{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "initialize",
  "params": {
    "protocolVersion": "2024-11-05",
    "clientInfo": {
      "name": "test-client",
      "version": "1.0.0"
    },
    "capabilities": {}
  }
}'

# 工具列表请求
tools_list_request='{
  "jsonrpc": "2.0",
  "id": 2,
  "method": "tools/list"
}'

# 生成图像请求
generate_image_request='{
  "jsonrpc": "2.0",
  "id": 3,
  "method": "tools/call",
  "params": {
    "name": "generate-image",
    "arguments": {
      "prompt": "一只可爱的猫咪在阳光下玩耍",
      "width": 1024,
      "height": 1024
    }
  }
}'

# 执行测试
echo "开始测试 MCP 服务器..." | tee -a "$log_file"
echo "日志文件: $log_file" | tee -a "$log_file"
echo "" | tee -a "$log_file"

send_request "$initialize_request" "初始化"
send_request "$tools_list_request" "获取工具列表"
send_request "$generate_image_request" "生成图像"

echo "测试完成" | tee -a "$log_file"
echo "完整日志已保存到: $log_file"