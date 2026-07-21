#!/bin/sh
set -eu
. "$(cd "$(dirname "$0")" && pwd)/versions.sh"
cd "$WORK/go"
for n in 0001 0002 0003 0004 0005 0006 0007 0008 0009 0010; do
  p=$(ls "$REPO_ROOT"/patches/126/${n}-*.patch)
  echo "applying $(basename "$p")"
  patch -p0 < "$p"
done
# Toolchain's own CA path: @SSLDIR@ -> $CA_DIR (the native convention; bundle at .../certs/ca-certificates.crt).
# Same for native and cross so cross-built apps look where the native product populates.
sed -i '' "s#@SSLDIR@#$CA_DIR#g" src/crypto/x509/root_keychainunion_darwin.go
grep -q "$CA_DIR/certs/ca-certificates.crt" src/crypto/x509/root_keychainunion_darwin.go
echo "patches applied + @SSLDIR@ substituted"
