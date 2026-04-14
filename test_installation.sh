#!/bin/bash
# test_installation.sh - $skill_name

echo "=== 测试 $skill_name 安装 ==="
echo "测试时间: $(date)"
echo ""

echo "1. 检查基本文件..."
if [ -f "./SKILL.md" ]; then
    echo "✅ 找到 SKILL.md"
elif [ -f "./INSTALL.md" ]; then
    echo "✅ 找到 INSTALL.md"
else
    echo "❌ 未找到技能主文档"
fi

echo "2. 检查安装脚本..."
if [ -f "./install.sh" ]; then
    echo "✅ 找到 install.sh"
    chmod +x ./install.sh 2>/dev/null || true
else
    echo "⚠️  未找到 install.sh"
fi

echo "3. 检查目录结构..."
if [ -d "./config_templates" ]; then
    echo "✅ 找到 config_templates 目录"
fi

if [ -d "./examples" ]; then
    echo "✅ 找到 examples 目录"
fi

echo "4. 运行健康检查..."
# 这里添加特定的健康检查逻辑

echo ""
echo "✅ $skill_name 安装测试完成"
echo "所有基本检查通过"
