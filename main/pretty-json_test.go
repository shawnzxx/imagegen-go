package main

import (
	"fmt"
	"strings"
	"testing"
)

func TestPrettyJSON(t *testing.T) {
	// 准备测试数据
	data := map[string]interface{}{
		"name": "张三",
		"age":  25,
		"address": map[string]string{
			"city":   "北京",
			"street": "朝阳区",
		},
	}

	// 执行格式化
	result := PrettyJSON(data)

	// 验证结果
	expected := `{
    "address": {
        "city": "北京",
        "street": "朝阳区"
    },
    "age": 25,
    "name": "张三"
}`

	// 标准化换行符
	result = strings.ReplaceAll(result, "\r\n", "\n")
	expected = strings.ReplaceAll(expected, "\r\n", "\n")

	fmt.Println(result)
	if result != expected {
		t.Errorf("PrettyJSON() 结果不符合预期。\n得到：\n%s\n期望：\n%s", result, expected)
	}
}
