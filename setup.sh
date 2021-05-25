#!/bin/bash

AUTHOR=$(git config user.name)
EMAIL=$(git config user.email)
read -rp "Enter the name of the project: " CRATENAME

FILES=(Cargo.toml README.md src/main.rs)

if ! command -v sd >/dev/null 2>&1; then
	echo "Please install 'sd' which can be installed with"
	echo "cargo install sd"
	exit 176
fi
if ! command -v fzf >/dev/null 2>&1; then
	echo "Cannot find fzf, please make sure it is installed and is locatedd in the path, addtionally see following link for install instructions"
	echo "https://github.com/junegunn/fzf#installation"
	exit 177
fi

read -rp "Please choose the Rust toolchain for the project (stable/nightly): " TOOLCHAIN
[ "$TOOLCHAIN" = "stable" ] || [ "$TOOLCHAIN" = "nightly" ] && echo "$TOOLCHAIN" > rust-toolchain || echo "Not a valid Rust toolchain" && exit 178

echo '# $CRATENAME\n\n## Usage\n```toml\n$CRATENAME = 0.1.0\n```' > README.md

LICENSE=$(curl -s "https://raw.githubusercontent.com/spdx/license-list-data/master/licenses.md" | grep -oP "^\[\K[\w-.]+" | tr " " "\n" | fzf)
echo "Downloading $LICENSE License document from https://raw.githubusercontent.com/spdx/license-list/master/$LICENSE.txt"
curl -s "https://raw.githubusercontent.com/spdx/license-list/master/$LICENSE.txt" -o LICENSE

sd '$CRATENAME' "$CRATENAME" "{FILES[@]}"
sd '$AUTHOR' "$AUTHOR" "{FILES[@]}"
sd '$EMAIL' "$EMAIL" "{FILES[@]}"

echo "Self destructing..."
rm setup.sh
