#!/bin/bash

# 引数のチェック
if [ $# -ne 1 ]; then
    echo "Usage: $0 <destination_path>"
    exit 1
fi

# コピー元とコピー先のパス
SRC="./init_template/"
DEST="$1"

# `cp` を使ってフォルダの中身のみコピー (隠しファイルも含む)
cp -rf "$SRC"/* "$SRC"/.??* "$DEST" 2>/dev/null

echo "Copied contents of $SRC to $DEST (Overwritten if exists)"


# ベースディレクトリ
BASE_DIR="$DEST/feature/core"

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
    dart create -t package . --force
    cd - > /dev/null  # 元のディレクトリに戻る
    
    echo "✅ $PACKAGE_PATH にパッケージを作成しました。"
done

echo "🎉 機能 '$FEATURE_NAME' のパッケージ作成が完了しました！"

cd "${DEST}"
dart pub add melos
