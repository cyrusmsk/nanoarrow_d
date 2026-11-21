project(
  'nanoarrow_d',
  ['c', 'd'],
  version: '0.9.0',
  license: 'Apache-2.0',
  meson_version: '>=1.0.0',
  default_options: ['c_std=c11', 'warning_level=1'],
)

nanoarrow_inc = include_directories('arrow_lib')
bindings_inc = include_directories('source')

nanoarrow_d = static_library(
  'nanoarrow_d',
  [
    'arrow_lib/nanoarrow.c',
    'source/nanoarrow_d/package.d',
    'source/nanoarrow_d/extra.d',
  ],
  include_directories: [nanoarrow_inc, bindings_inc],
  install: true,
)

nanoarrow_d_dep = declare_dependency(
  link_with: nanoarrow_d,
  include_directories: [nanoarrow_inc, bindings_inc],
)

install_headers(
  'arrow_lib/nanoarrow/nanoarrow.h',
  'arrow_lib/nanoarrow/nanoarrow.hpp',
  subdir: 'nanoarrow',
)

meson.override_dependency('nanoarrow_d', nanoarrow_d_dep)
