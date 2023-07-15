#!/bin/bash

SCRIPT_NAME=$(basename "$0")

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "请提供足够的命令行参数"
  echo "用法: $SCRIPT_NAME SOURCE_BRANCH TARGET_BRANCH"
  exit 1
fi

SOURCE_BRANCH="$1"
TARGET_BRANCH="$2"

# 判断是否存在 SOURCE_BRANCH 分支
if ! git show-ref --quiet refs/heads/$SOURCE_BRANCH; then
    echo "$SOURCE_BRANCH 分支不存在，正在检出..."
    git checkout -b $SOURCE_BRANCH
    git branch -u origin/$SOURCE_BRANCH
fi

# 判断是否存在 TARGET_BRANCH 分支
if ! git show-ref --quiet refs/heads/$TARGET_BRANCH; then
    echo "$TARGET_BRANCH 分支不存在，正在检出..."
    git checkout -b $TARGET_BRANCH
    git branch -u origin/$TARGET_BRANCH
fi

git fetch

git checkout $SOURCE_BRANCH
git branch -u origin/$SOURCE_BRANCH
git pull
git push

git checkout $TARGET_BRANCH
git branch -u origin/$TARGET_BRANCH
git pull
git merge origin/$SOURCE_BRANCH
git push