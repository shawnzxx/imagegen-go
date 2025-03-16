# imagegen-go MCP 服务器

这是一个基于 MCP (Model Control Protocol) 协议的图像生成服务器，使用 OpenAI 的 DALL-E API 生成图像。

## 环境要求

- Go 1.23.5 或更高版本
- OpenAI API 密钥

## 设置环境变量

在使用前，请设置 OpenAI API 密钥：

```bash
export OPENAI_API_KEY="你的OpenAI API密钥"
```

## 编译

如果需要重新编译项目：

```bash
go build -o bin/imagegen-go main/*.go
```

## 测试脚本

本项目提供了多个测试脚本，用于调试 MCP 服务器：

### 1. 基本测试

运行基本测试，包括初始化、获取工具列表和生成图像：

```bash
./test_mcp.sh
```

### 2. 详细调试

运行详细调试，将日志和响应保存到文件：

```bash
./debug_mcp.sh
```

### 3. 交互式测试

运行交互式测试，允许输入自定义的提示词：

```bash
./interactive_test.sh
```

### 4. 单独请求测试

测试单个请求：

```bash
# 初始化请求
./test_single_request.sh init

# 获取工具列表
./test_single_request.sh list

# 生成图像
./test_single_request.sh generate "一只可爱的猫咪" 1024 1024
```

## 日志

所有测试脚本都会将日志保存到 `logs` 目录中，方便查看和分析。

## MCP 协议

MCP 是一种基于 JSON-RPC 2.0 的协议，用于模型与工具之间的通信。本服务器实现了以下 MCP 方法：

- `initialize` - 初始化服务器
- `tools/list` - 获取可用工具列表
- `tools/call` - 调用工具（生成图像）
- `resources/list` - 获取可用资源列表
- `prompts/list` - 获取可用提示列表

## 生成图像工具

本服务器提供了一个名为 `generate-image` 的工具，用于生成图像。参数如下：

- `prompt` (必需) - 图像描述
- `width` (可选) - 图像宽度，默认为 1792
- `height` (可选) - 图像高度，默认为 1024
- `destination` (可选) - 保存图像的路径，默认为用户的 Downloads 目录

## 调试步骤

1. **设置环境变量**：

   ```bash
   export OPENAI_API_KEY="你的OpenAI API密钥"
   ```

2. **运行初始化请求**：

   ```bash
   ./test_single_request.sh init
   ```

3. **获取工具列表**：

   ```bash
   ./test_single_request.sh list
   ```

4. **生成图像**：

   ```bash
   ./test_single_request.sh generate "你的提示词" [宽度] [高度]
   ```

5. **查看日志**：
   ```bash
   cat logs/single_request_*.log
   ```

## 项目结构

```
imagegen-go/
├── bin/                # 编译后的二进制文件
│   └── imagegen-go     # 主程序
├── main/               # 主程序源代码
│   ├── main.go         # 主程序入口
│   ├── types.go        # 数据类型定义
│   ├── utils.go        # 工具函数
│   └── pretty-json.go  # JSON 格式化
├── pkg/                # 依赖包
│   └── openai/         # OpenAI API 客户端
│       └── client.go   # OpenAI API 交互
├── logs/               # 日志目录
├── test_mcp.sh         # 基本测试脚本
├── debug_mcp.sh        # 详细调试脚本
├── interactive_test.sh # 交互式测试脚本
├── test_single_request.sh # 单独请求测试脚本
└── README.md           # 本文档
```

## 注意事项

1. 确保 OpenAI API 密钥有效且有足够的额度
2. 生成的图像默认保存在用户的 Downloads 目录
3. 如果提供的目标路径无效，将使用默认路径
4. 服务器通过标准输入/输出与客户端通信，不是传统的 HTTP 服务器
