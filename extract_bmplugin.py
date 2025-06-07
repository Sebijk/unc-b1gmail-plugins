#!/usr/bin/env python3
"""
extract_bmplugin.py

This script can be used to extract `.bmplugin` packages for b1gMail:
it verifies the MD5 signature, inflates the data, PHP-unserializes
the payload, and writes the plugin files into the current directory.
"""

import os
import sys
import argparse
import hashlib
import zlib

import phpserialize

MAGIC = b"B1GPLUGIN100!"
FILETYPE_DIRS = {
    b"plugins": "plugins/",
    b"templates": "plugins/templates/",
    b"images": "plugins/templates/images/",
    b"css": "plugins/css/",
    b"js": "plugins/js/",
}


def sanitize(name: str) -> str:
    # Remove any .. or separators
    return name.replace("..", "").replace("/", "").replace("\\", "")


def main():
    p = argparse.ArgumentParser(description="Extract a B1GPLUGIN100! archive")
    p.add_argument("infile", help="Path to the .bmplugin file")
    args = p.parse_args()

    with open(args.infile, "rb") as f:
        hdr = f.read(len(MAGIC))
        if hdr != MAGIC:
            print("✗ Invalid magic header (not a B1GPLUGIN100! archive).")
            sys.exit(1)

        raw_sig = f.read(32)
        try:
            expected_md5 = raw_sig.decode("ascii")
        except UnicodeDecodeError:
            print("✗ Signature block is not valid ASCII hex.")
            sys.exit(1)

        raw_data = f.read()
        got_md5 = hashlib.md5(raw_data).hexdigest()
        if got_md5 != expected_md5:
            print(f"✗ MD5 mismatch: computed {got_md5}, expected {expected_md5}")
            sys.exit(1)

        # Decompress raw DEFLATE (gzinflate in PHP)
        try:
            inflated = zlib.decompress(raw_data, -zlib.MAX_WBITS)
        except zlib.error as e:
            print("✗ Decompression failed:", e)
            sys.exit(1)

        # PHP-unserialize
        try:
            data = phpserialize.loads(inflated, decode_strings=False)
        except Exception as e:
            print("✗ PHP unserialize failed:", e)
            sys.exit(1)

    # Expect data to be a dict with b'meta' and b'files'
    if not (isinstance(data, dict) and b"files" in data and b"meta" in data):
        print("✗ Unexpected data format (missing 'meta' or 'files').")
        sys.exit(1)

    files = data[b"files"]
    for ftype, dir_prefix in FILETYPE_DIRS.items():
        if ftype not in files:
            continue
        items = files[ftype]
        # items should be a dict: filename => filecontents
        for raw_name, contents in items.items():
            # raw_name is bytes
            name = raw_name.decode("utf-8", "ignore")
            safe = sanitize(name)
            out_path = os.path.join(os.getcwd(), dir_prefix, safe)
            os.makedirs(os.path.dirname(out_path), exist_ok=True)
            # contents may be bytes or str
            mode = "wb" if isinstance(contents, (bytes, bytearray)) else "w"
            with open(out_path, mode) as outf:
                outf.write(contents)
            print(f"✓ Wrote {out_path}")

    print("Extraction complete.")


if __name__ == "__main__":
    main()
