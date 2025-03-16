package main

import "encoding/json"

// JSONRPCRequest 表示JSON-RPC请求的结构
//
//	2025/03/16 16:31:49 Received request: {
//		"id": 0,
//		"jsonrpc": "2.0",
//		"method": "initialize",
//		"params": {
//				"capabilities": {},
//				"clientInfo": {
//						"name": "claude-ai",
//						"version": "0.1.0"
//				},
//				"protocolVersion": "2024-11-05"
//		}
//	}
type JSONRPCRequest struct {
	ID      int         `json:"id"`
	JSONRPC string      `json:"jsonrpc"`
	Method  string      `json:"method"`
	Params  interface{} `json:"params,omitempty"`
}

//	2025/03/16 16:31:49 Sending response: {
//		"id": 0,
//		"jsonrpc": "2.0",
//		"result": {
//				"capabilities": {
//						"tools": {}
//				},
//				"protocolVersion": "2024-11-05",
//				"serverInfo": {
//						"name": "imagegen-go",
//						"version": "1.0.0"
//				}
//		}
//	}
//
// JSONRPCResponse 表示JSON-RPC响应的结构
//
//	{
//	  "id": 0,
//	  "jsonrpc": "2.0",
//	  "result": {
//	    "capabilities": {
//	      "tools": {}
//	    },
//	    "protocolVersion": "2024-11-05",
//	    "serverInfo": {
//	      "name": "imagegen-go",
//	      "version": "1.0.0"
//	    }
//	  }
//	}
type JSONRPCResponse struct {
	ID      int           `json:"id"`
	JSONRPC string        `json:"jsonrpc"`
	Result  interface{}   `json:"result"`
	Error   *JSONRPCError `json:"error,omitempty"`
}

//	{
//	  "jsonrpc": "2.0",
//	  "error": {
//	    "code": -32603,
//	    "message": "Internal error",
//	    "data": "Invalid username"
//	  },
//	  "id": "请求ID"
//	}
type JSONRPCError struct {
	Code    int         `json:"code"`
	Message string      `json:"message"`
	Data    interface{} `json:"data,omitempty"`
}

// InitializeResult 表示初始化响应的结果结构
type InitializeResult struct {
	Capabilities    Capabilities `json:"capabilities"`
	ProtocolVersion string       `json:"protocolVersion"`
	ServerInfo      ServerInfo   `json:"serverInfo"`
}

// Capabilities 表示服务器能力
type Capabilities struct {
	Tools map[string]interface{} `json:"tools"`
}

// ServerInfo 表示服务器信息
type ServerInfo struct {
	Name    string `json:"name"`
	Version string `json:"version"`
}

// Types for tools
type ListToolsResult struct {
	Tools []Tool `json:"tools"`
}

type Tool struct {
	Name        string          `json:"name"`
	Description string          `json:"description"`
	InputSchema json.RawMessage `json:"inputSchema"`
}

type CallToolResult struct {
	Content []ToolContent `json:"content"`
}

type ToolContent struct {
	Type string `json:"type"`
	Text string `json:"text"`
}

// Types for resources
type ListResourcesResult struct {
	Resources []Resource `json:"resources"`
}

type Resource struct {
	URI         string `json:"uri"`
	Name        string `json:"name"`
	Description string `json:"description,omitempty"`
	MimeType    string `json:"mimeType,omitempty"`
}

// Types for prompts
type ListPromptsResult struct {
	Prompts []Prompt `json:"prompts"`
}

type Prompt struct {
	Name        string           `json:"name"`
	Description string           `json:"description,omitempty"`
	Arguments   []PromptArgument `json:"arguments,omitempty"`
}

type PromptArgument struct {
	Name        string `json:"name"`
	Description string `json:"description,omitempty"`
	Required    bool   `json:"required,omitempty"`
}

// Code	Message	Description
// -32700	Parse error	Invalid JSON was received by the server.
// -32600	Invalid Request	The JSON sent is not a valid Request object.
// -32601	Method not found	The method does not exist or is not available.
// -32602	Invalid params	Invalid method parameter(s).
// -32603	Internal error	Internal error.

// Standard JSON-RPC error codes
const (
	ParseError     = -32700
	InvalidRequest = -32600
	MethodNotFound = -32601
	InvalidParams  = -32602
	InternalError  = -32603
)
