add_rules("mode.debug", "mode.release")

target("nanoarrow_d")
    set_kind("static")
    set_languages("c11")
    set_license("Apache-2.0")

    -- C implementation of the vendored nanoarrow library
    add_files("arrow_lib/nanoarrow.c")

    -- D bindings: `nanoarrow_d.extra` imports the ImportC module `nanoarrow`,
    -- which is resolved from `source/nanoarrow.c` via the include directory below.
    add_files("source/nanoarrow_d/*.d")

    add_includedirs("arrow_lib", "source", {public = true})
    add_installfiles("arrow_lib/nanoarrow/nanoarrow.h", {prefixdir = "include/nanoarrow"})
    add_installfiles("arrow_lib/nanoarrow/nanoarrow.hpp", {prefixdir = "include/nanoarrow"})
