#!/bin/bash

# 引数のチェック
if [ $# -ne 2 ]; then
    echo "Usage: $0 <destination_path>"
    exit 1
fi

DEST="$1"
FEATURE_NAME="$2"

# ベースディレクトリ
BASE_DIR="$DEST/feature/$FEATURE_NAME"

# 作成するサブディレクトリ
SUB_DIRS=("root" "widget" "io" "model")

# 各サブディレクトリを作成し `dart create -t package` を実行
for SUB_DIR in "${SUB_DIRS[@]}"; do
    PACKAGE_PATH="$BASE_DIR/$SUB_DIR"
    
    # ディレクトリが既に存在する場合はスキップ
    if [ -d "$PACKAGE_PATH" ]; then
        echo "⚠️  $PACKAGE_PATH は既に存在します。スキップします。"
        continue
    fi

    # ディレクトリを作成
    mkdir -p "$PACKAGE_PATH"

    # `dart create -t package` を実行
    cd "$PACKAGE_PATH" || exit
    dart create -t package ./ --force
    rm -rf example/
    rm -rf lib/*
    cd - > /dev/null  # 元のディレクトリに戻る
    
    echo "✅ $PACKAGE_PATH にパッケージを作成しました。"
done

CONFIG_FILE="./tmp_cookiecutter.yaml"

cat <<EOL > $CONFIG_FILE
default_context:
  feature_name: "$FEATURE_NAME"
EOL

ABSOLUTE_PATH=$(realpath ./)

cookiecutter "$ABSOLUTE_PATH/feature_template" --output-dir "$ABSOLUTE_PATH/$DEST/feature" --overwrite-if-exists --no-input --config-file "$ABSOLUTE_PATH/tmp_cookiecutter.yaml"
rm -f $CONFIG_FILE

echo "🎉 機能 '$FEATURE_NAME' のパッケージ作成が完了しました！"

cd "${DEST}"
dart pub add melos
