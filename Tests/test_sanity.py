import os
import sys

base_dir = os.path.dirname(os.path.abspath(__file__))
if base_dir not in sys.path:
    sys.path.insert(0, base_dir)

import validate_store

def test_store_sanity():
    assert validate_store.test_toc_integrity(), "TOC integrity check failed"
    assert validate_store.test_lua_syntax(), "Lua syntax check failed"
    assert validate_store.test_retail_api_leak(), "Retail API leak check failed"

if __name__ == "__main__":
    test_store_sanity()
