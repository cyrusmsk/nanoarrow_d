# nanoarrow_d

D bindings for [Apache Arrow nanoarrow](https://arrow.apache.org/nanoarrow/), with the C library vendored under `arrow_lib/`. Provides the Arrow C Data and Arrow C Stream interfaces to D via ImportC, plus D ports of nanoarrow's `static inline` helpers (`source/nanoarrow_d/extra.d`).

```d
import nanoarrow_d;
```

Requires a D compiler with ImportC support (tested with LDC 1.43) and `dub`; Meson/Ninja and Xmake are optional.

## Build

```bash
# Dub (library + example)
dub build
dub run --root=examples/vendored_minimal

# Meson (static C+D library; headers install with `meson install -C build`)
meson setup build
meson compile -C build

# Xmake (static C+D library)
xmake                  # release: xmake f -m release
```

`arrow_lib/` contains the vendored nanoarrow sources with minor ImportC build-compatibility patches; only `source/` and the build files are project-specific.

## Arrow types covered

- **Null / boolean:** `NA`, `BOOL`
- **Integers:** `UINT8/16/32/64`, `INT8/16/32/64`
- **Floating point:** `HALF_FLOAT`, `FLOAT`, `DOUBLE`
- **Decimal:** `DECIMAL32/64/128/256`
- **Temporal:** `DATE32`, `DATE64`, `TIME32`, `TIME64`, `TIMESTAMP`, `DURATION`, `INTERVAL_MONTHS`, `INTERVAL_DAY_TIME`, `INTERVAL_MONTH_DAY_NANO`
- **String / binary:** `STRING`, `LARGE_STRING`, `BINARY`, `LARGE_BINARY`, `FIXED_SIZE_BINARY`, `STRING_VIEW`, `BINARY_VIEW`
- **Nested:** `LIST`, `LARGE_LIST`, `FIXED_SIZE_LIST`, `LIST_VIEW`, `LARGE_LIST_VIEW`, `STRUCT`, `MAP`, `SPARSE_UNION`, `DENSE_UNION`
- **Encoded:** `DICTIONARY`, `RUN_END_ENCODED`, `EXTENSION`

## License

The D bindings and the vendored nanoarrow sources under `arrow_lib/` are Apache-2.0 licensed.
