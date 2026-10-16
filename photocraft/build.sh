#!/bin/sh
# Builds the TypeR panel plug-in for PhotoCraft from this directory.
# Needs the wasm32-unknown-unknown target: `rustup target add wasm32-unknown-unknown`.
set -eu
cd "$(dirname "$0")"
cargo build --release --target wasm32-unknown-unknown
out=target/wasm32-unknown-unknown/release/photocraft_plugin_typer.wasm
cp "$out" typer.wasm
echo "built $out ($(wc -c < "$out") bytes)"
echo "copied to $(pwd)/typer.wasm"
echo "install it in PhotoCraft with: plugin.install {\"path\": \"$(pwd)/typer.wasm\"}"
