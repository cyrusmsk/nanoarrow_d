module nanoarrow_d.extra;

public import nanoarrow;

public import core.stdc.errno;
public import core.stdc.stdint;
public import core.stdc.string : strlen;
import core.stdc.config : c_long, c_ulong;

auto returnNotOk(T)(T status)
{
    if (status != NANOARROW_OK)
        return status;
    return status;
}

extern (C):

pragma(inline, true) void ArrowErrorInit(ArrowError* error)
{
    if (error != null)
    {
        error.message[0] = '\0';
    }
}

pragma(inline, true) const(char)* ArrowErrorMessage(ArrowError* error)
{
    if (error == null)
    {
        return "";
    }
    else
    {
        return error.message.ptr;
    }
}

pragma(inline, true) void ArrowErrorSetString(ArrowError* error, const(char)* src)
{
    if (error == null)
    {
        return;
    }

    long src_len = strlen(src);
    if (src_len >= (cast(long) typeof(error.message).sizeof))
    {
        memcpy(error.message.ptr, src, error.message.sizeof - 1);
        error.message[error.message.sizeof - 1] = '\0';
    }
    else
    {
        memcpy(error.message.ptr, src, src_len);
        error.message[src_len] = '\0';
    }
}

pragma(inline, true) void ArrowSchemaMove(ArrowSchema* src, ArrowSchema* dst)
{
    assert(src != null);
    assert(dst != null);

    memcpy(dst, src, ArrowSchema.sizeof);
    src.release = null;
}

pragma(inline, true) void ArrowSchemaRelease(ArrowSchema* schema)
{
    assert(schema != null);
    schema.release(schema);
    assert(schema.release == null);
}

pragma(inline, true) void ArrowArrayMove(ArrowArray* src, ArrowArray* dst)
{
    assert(src != null);
    assert(dst != null);

    memcpy(dst, src, ArrowArray.sizeof);
    src.release = null;
}

pragma(inline, true) void ArrowArrayRelease(ArrowArray* array)
{
    assert(array != null);
    array.release(array);
    assert(array.release == null);
}

pragma(inline, true) void ArrowArrayStreamMove(ArrowArrayStream* src, ArrowArrayStream* dst)
{
    assert(src != null);
    assert(dst != null);

    memcpy(dst, src, ArrowArrayStream.sizeof);
    src.release = null;
}

pragma(inline, true) const(char)* ArrowArrayStreamGetLastError(
    ArrowArrayStream* array_stream)
{
    assert(array_stream != null);

    const(char)* value = array_stream.get_last_error(array_stream);
    if (value == null)
    {
        return "";
    }
    else
    {
        return value;
    }
}

pragma(inline, true) ArrowErrorCode ArrowArrayStreamGetSchema(
    ArrowArrayStream* array_stream, ArrowSchema* out_, ArrowError* error)
{
    assert(array_stream != null);

    int result = array_stream.get_schema(array_stream, out_);
    if (result != NANOARROW_OK && error != null)
    {
        ArrowErrorSetString(error, ArrowArrayStreamGetLastError(array_stream));
    }

    return result;
}

pragma(inline, true) ArrowErrorCode ArrowArrayStreamGetNext(
    ArrowArrayStream* array_stream, ArrowArray* out_, ArrowError* error)
{
    assert(array_stream != null);

    int result = array_stream.get_next(array_stream, out_);
    if (result != NANOARROW_OK && error != null)
    {
        ArrowErrorSetString(error, ArrowArrayStreamGetLastError(array_stream));
    }

    return result;
}

pragma(inline, true) void ArrowArrayStreamRelease(ArrowArrayStream* array_stream)
{
    assert(array_stream != null);
    array_stream.release(array_stream);
    assert(array_stream.release == null);
}

pragma(inline, true) const(char)* ArrowTypeString(ArrowType type);

pragma(inline, true) const(char)* ArrowTypeString(ArrowType type)
{
    switch (type)
    {
    case NANOARROW_TYPE_NA:
        return "na";
    case NANOARROW_TYPE_BOOL:
        return "bool";
    case NANOARROW_TYPE_UINT8:
        return "uint8";
    case NANOARROW_TYPE_INT8:
        return "int8";
    case NANOARROW_TYPE_UINT16:
        return "uint16";
    case NANOARROW_TYPE_INT16:
        return "int16";
    case NANOARROW_TYPE_UINT32:
        return "uint32";
    case NANOARROW_TYPE_INT32:
        return "int32";
    case NANOARROW_TYPE_UINT64:
        return "uint64";
    case NANOARROW_TYPE_INT64:
        return "int64";
    case NANOARROW_TYPE_HALF_FLOAT:
        return "half_float";
    case NANOARROW_TYPE_FLOAT:
        return "float";
    case NANOARROW_TYPE_DOUBLE:
        return "double";
    case NANOARROW_TYPE_STRING:
        return "string";
    case NANOARROW_TYPE_BINARY:
        return "binary";
    case NANOARROW_TYPE_FIXED_SIZE_BINARY:
        return "fixed_size_binary";
    case NANOARROW_TYPE_DATE32:
        return "date32";
    case NANOARROW_TYPE_DATE64:
        return "date64";
    case NANOARROW_TYPE_TIMESTAMP:
        return "timestamp";
    case NANOARROW_TYPE_TIME32:
        return "time32";
    case NANOARROW_TYPE_TIME64:
        return "time64";
    case NANOARROW_TYPE_INTERVAL_MONTHS:
        return "interval_months";
    case NANOARROW_TYPE_INTERVAL_DAY_TIME:
        return "interval_day_time";
    case NANOARROW_TYPE_DECIMAL32:
        return "decimal32";
    case NANOARROW_TYPE_DECIMAL64:
        return "decimal64";
    case NANOARROW_TYPE_DECIMAL128:
        return "decimal128";
    case NANOARROW_TYPE_DECIMAL256:
        return "decimal256";
    case NANOARROW_TYPE_LIST:
        return "list";
    case NANOARROW_TYPE_STRUCT:
        return "struct";
    case NANOARROW_TYPE_SPARSE_UNION:
        return "sparse_union";
    case NANOARROW_TYPE_DENSE_UNION:
        return "dense_union";
    case NANOARROW_TYPE_DICTIONARY:
        return "dictionary";
    case NANOARROW_TYPE_MAP:
        return "map";
    case NANOARROW_TYPE_EXTENSION:
        return "extension";
    case NANOARROW_TYPE_FIXED_SIZE_LIST:
        return "fixed_size_list";
    case NANOARROW_TYPE_DURATION:
        return "duration";
    case NANOARROW_TYPE_LARGE_STRING:
        return "large_string";
    case NANOARROW_TYPE_LARGE_BINARY:
        return "large_binary";
    case NANOARROW_TYPE_LARGE_LIST:
        return "large_list";
    case NANOARROW_TYPE_INTERVAL_MONTH_DAY_NANO:
        return "interval_month_day_nano";
    case NANOARROW_TYPE_RUN_END_ENCODED:
        return "run_end_encoded";
    case NANOARROW_TYPE_BINARY_VIEW:
        return "binary_view";
    case NANOARROW_TYPE_STRING_VIEW:
        return "string_view";
    case NANOARROW_TYPE_LIST_VIEW:
        return "list_view";
    case NANOARROW_TYPE_LARGE_LIST_VIEW:
        return "large_list_view";
    default:
        return null;
    }
}

pragma(inline, true) const(char)* ArrowTimeUnitString(ArrowTimeUnit time_unit);

pragma(inline, true) const(char)* ArrowTimeUnitString(ArrowTimeUnit time_unit)
{
    switch (time_unit)
    {
    case NANOARROW_TIME_UNIT_SECOND:
        return "s";
    case NANOARROW_TIME_UNIT_MILLI:
        return "ms";
    case NANOARROW_TIME_UNIT_MICRO:
        return "us";
    case NANOARROW_TIME_UNIT_NANO:
        return "ns";
    default:
        return null;
    }
}

pragma(inline, true) ArrowStringView ArrowCharView(const(char)* value);

pragma(inline, true) ArrowStringView ArrowCharView(const(char)* value)
{
    ArrowStringView out_ = void;

    out_.data = value;
    if (value)
    {
        out_.size_bytes = cast(long) strlen(value);
    }
    else
    {
        out_.size_bytes = 0;
    }

    return out_;
}

pragma(inline, true) void ArrowIntervalInit(ArrowInterval* interval, ArrowType type)
{
    memset(interval, 0, ArrowInterval.sizeof);
    interval.type = type;
}

pragma(inline, true) void ArrowDecimalInit(ArrowDecimal* decimal, int bitwidth, int precision, int scale)
{
    memset(cast(void*) decimal.words, 0, typeof(decimal.words).sizeof);
    decimal.precision = precision;
    decimal.scale = scale;
    // n_words will be 0 for bitwidth == 32
    decimal.n_words = cast(int)(bitwidth / 8 / ulong.sizeof);

    if (_ArrowIsLittleEndian())
    {
        decimal.low_word_index = 0;
        decimal.high_word_index = decimal.n_words > 0 ? decimal.n_words - 1 : 0;
    }
    else
    {
        decimal.low_word_index = decimal.n_words > 0 ? decimal.n_words - 1 : 0;
        decimal.high_word_index = 0;
    }
}

pragma(inline, true) long ArrowDecimalGetIntUnsafe(const(ArrowDecimal)* decimal)
{
    if (decimal.n_words == 0)
    {
        int value = void;
        memcpy(&value, cast(void*) decimal.words, int.sizeof);
        return value;
    }

    return cast(long) decimal.words[decimal.low_word_index];
}

pragma(inline, true) void ArrowDecimalGetBytes(const(ArrowDecimal)* decimal, ubyte* out_)
{
    if (decimal.n_words == 0)
    {
        memcpy(out_, cast(void*) decimal.words, int.sizeof);
    }
    else
    {
        memcpy(out_, cast(void*) decimal.words, decimal.n_words * ulong.sizeof);
    }
}

pragma(inline, true) long ArrowDecimalSign(const(ArrowDecimal)* decimal)
{
    if (decimal.n_words == 0)
    {
        return ArrowDecimalGetIntUnsafe(decimal) >= 0 ? 1 : -1;
    }
    else
    {
        return 1 | (cast(long)(decimal.words[decimal.high_word_index]) >> 63);
    }
}

pragma(inline, true) void ArrowDecimalSetInt(ArrowDecimal* decimal, long value)
{
    if (decimal.n_words == 0)
    {
        int value32 = cast(int) value;
        memcpy(cast(void*) decimal.words, &value32, int.sizeof);
        return;
    }

    if (value < 0)
    {
        memset(cast(void*) decimal.words, 0xff, decimal.n_words * ulong.sizeof);
    }
    else
    {
        memset(cast(void*) decimal.words, 0, decimal.n_words * ulong.sizeof);
    }

    decimal.words[decimal.low_word_index] = value;
}

pragma(inline, true) void ArrowDecimalNegate(ArrowDecimal* decimal)
{
    if (decimal.n_words == 0)
    {
        int value = void;
        memcpy(&value, cast(void*) decimal.words, int.sizeof);
        value = -value;
        memcpy(cast(void*) decimal.words, &value, int.sizeof);
        return;
    }

    ulong carry = 1;

    if (decimal.low_word_index == 0)
    {
        for (int i = 0; i < decimal.n_words; i++)
        {
            ulong elem = decimal.words[i];
            elem = ~elem + carry;
            carry &= (elem == 0);
            decimal.words[i] = elem;
        }
    }
    else
    {
        for (int i = decimal.low_word_index; i >= 0; i--)
        {
            ulong elem = decimal.words[i];
            elem = ~elem + carry;
            carry &= (elem == 0);
            decimal.words[i] = elem;
        }
    }
}

pragma(inline, true) void ArrowDecimalSetBytes(ArrowDecimal* decimal, const(ubyte)* value)
{
    if (decimal.n_words == 0)
    {
        memcpy(cast(void*) decimal.words, value, int.sizeof);
    }
    else
    {
        memcpy(cast(void*) decimal.words, value, decimal.n_words * ulong.sizeof);
    }
}

pragma(inline, true) void ArrowSchemaMove(ArrowSchema* src, ArrowSchema* dst);

/// \brief Call the release callback of an ArrowSchema
/// \ingroup nanoarrow-arrow-cdata
pragma(inline, true) void ArrowSchemaRelease(ArrowSchema* schema);

/// \brief Move the contents of an src ArrowArray into dst and set src->release to NULL
/// \ingroup nanoarrow-arrow-cdata
pragma(inline, true) void ArrowArrayMove(ArrowArray* src, ArrowArray* dst);

/// \brief Call the release callback of an ArrowArray
pragma(inline, true) void ArrowArrayRelease(ArrowArray* array);

/// \brief Move the contents of an src ArrowArrayStream into dst and set src->release to
/// NULL \ingroup nanoarrow-arrow-cdata
pragma(inline, true) void ArrowArrayStreamMove(ArrowArrayStream* src, ArrowArrayStream* dst);

/// \brief Call the get_schema callback of an ArrowArrayStream
/// \ingroup nanoarrow-arrow-cdata
///
/// Unlike the get_schema callback, this wrapper checks the return code
/// and propagates the error reported by get_last_error into error. This
/// makes it significantly less verbose to iterate over array streams
/// using auto s = returnNotOk()-style error handling.
pragma(inline, true) ArrowErrorCode ArrowArrayStreamGetSchema(
    ArrowArrayStream* array_stream, ArrowSchema* out_, ArrowError* error);

/// \brief Call the get_schema callback of an ArrowArrayStream
/// \ingroup nanoarrow-arrow-cdata
///
/// Unlike the get_next callback, this wrapper checks the return code
/// and propagates the error reported by get_last_error into error. This
/// makes it significantly less verbose to iterate over array streams
/// using auto s = returnNotOk()-style error handling.
pragma(inline, true) ArrowErrorCode ArrowArrayStreamGetNext(
    ArrowArrayStream* array_stream, ArrowArray* out_, ArrowError* error);

/// \brief Call the get_next callback of an ArrowArrayStream
/// \ingroup nanoarrow-arrow-cdata
///
/// Unlike the get_next callback, this function never returns NULL (i.e., its
/// result is safe to use in printf-style error formatters). Null values from the
/// original callback are reported as "<get_last_error() returned NULL>".
pragma(inline, true) const(char)* ArrowArrayStreamGetLastError(
    ArrowArrayStream* array_stream);

/// \brief Call the release callback of an ArrowArrayStream
pragma(inline, true) void ArrowArrayStreamRelease(ArrowArrayStream* array_stream);

/// \defgroup nanoarrow-errors Error handling
///
/// Functions generally return an errno-compatible error code; functions that
/// need to communicate more verbose error information accept a pointer
/// to an ArrowError. This can be stack or statically allocated. The
/// content of the message is undefined unless an error code has been
/// returned. If a nanoarrow function is passed a non-null ArrowError pointer, the
/// ArrowError pointed to by the argument will be propagated with a
/// null-terminated error message. It is safe to pass a NULL ArrowError anywhere
/// in the nanoarrow API.
///
/// Except where documented, it is generally not safe to continue after a
/// function has returned a non-zero ArrowErrorCode. The NANOARROW_RETURN_NOT_OK and
/// NANOARROW_ASSERT_OK macros are provided to help propagate errors. C++ clients can use
/// the helpers provided in the nanoarrow.hpp header to facilitate using C++ idioms
/// for memory management and error propgagtion.
///
/// @{

/// \brief Set the contents of an error using printf syntax.
///
/// If error is NULL, this function does nothing and returns NANOARROW_OK.
int ArrowErrorSet(ArrowError* error, const(char)* fmt, ...);

/// @}

/// \defgroup nanoarrow-utils Utility data structures
///
/// @{

/// \brief Return a version string in the form "major.minor.patch"
const(char)* ArrowNanoarrowVersion();

/// \brief Return an integer that can be used to compare versions sequentially
int ArrowNanoarrowVersionInt();

/// \brief Initialize a description of buffer arrangements from a storage type
void ArrowLayoutInit(ArrowLayout* layout, ArrowType storage_type);

/// \brief Create a string view from a null-terminated string
pragma(inline, true) ArrowStringView ArrowCharView(const(char)* value);

/// \brief Sets the integer value of an ArrowDecimal from a string
ArrowErrorCode ArrowDecimalSetDigits(ArrowDecimal* decimal, ArrowStringView value);

/// \brief Get the integer value of an ArrowDecimal as string
ArrowErrorCode ArrowDecimalAppendDigitsToBuffer(const(ArrowDecimal)* decimal, ArrowBuffer* buffer);

/// \brief Get the decimal value of an ArrowDecimal as a string
ArrowErrorCode ArrowDecimalAppendStringToBuffer(const(ArrowDecimal)* decimal, ArrowBuffer* buffer);

/// \brief Get the half float value of a float
pragma(inline, true) ushort ArrowFloatToHalfFloat(float value);

/// \brief Get the float value of a half float
pragma(inline, true) float ArrowHalfFloatToFloat(ushort value);

/// \brief Resolve a chunk index from increasing long offsets
///
/// Given a buffer of increasing long offsets that begin with 0 (e.g., offset buffer
/// of a large type, run ends of a chunked array implementation), resolve a value v
/// where lo <= v < hi such that offsets[v] <= index < offsets[v + 1].
pragma(inline, true) long ArrowResolveChunk64(long index, const(long)* offsets, long lo, long hi);

/// @}

/// \defgroup nanoarrow-schema Creating schemas
///
/// These functions allocate, copy, and destroy ArrowSchema structures
///
/// @{

/// \brief Initialize an ArrowSchema
///
/// Initializes the fields and release callback of schema_out. Caller
/// is responsible for calling the schema->release callback if
/// NANOARROW_OK is returned.
void ArrowSchemaInit(ArrowSchema* schema);

/// \brief Initialize an ArrowSchema from an ArrowType
///
/// A convenience constructor for that calls ArrowSchemaInit() and
/// ArrowSchemaSetType() for the common case of constructing an
/// unparameterized type. The caller is responsible for calling the schema->release
/// callback if NANOARROW_OK is returned.
ArrowErrorCode ArrowSchemaInitFromType(ArrowSchema* schema, ArrowType type);

/// \brief Get a human-readable summary of a Schema
///
/// Writes a summary of an ArrowSchema to out (up to n - 1 characters)
/// and returns the number of characters required for the output if
/// n were sufficiently large. If recursive is non-zero, the result will
/// also include children.
long ArrowSchemaToString(const(ArrowSchema)* schema, char* out_, long n, char recursive);

/// \brief Set the format field of a schema from an ArrowType
///
/// Initializes the fields and release callback of schema_out. For
/// NANOARROW_TYPE_LIST, NANOARROW_TYPE_LARGE_LIST, and
/// NANOARROW_TYPE_MAP, the appropriate number of children are
/// allocated, initialized, and named; however, the caller must
/// ArrowSchemaSetType() on the preinitialized children. Schema must have been initialized
/// using ArrowSchemaInit() or ArrowSchemaDeepCopy().
ArrowErrorCode ArrowSchemaSetType(ArrowSchema* schema, ArrowType type);

/// \brief Set the format field and initialize children of a struct schema
///
/// The specified number of children are initialized; however, the caller is responsible
/// for calling ArrowSchemaSetType() and ArrowSchemaSetName() on each child.
/// Schema must have been initialized using ArrowSchemaInit() or ArrowSchemaDeepCopy().
ArrowErrorCode ArrowSchemaSetTypeStruct(ArrowSchema* schema, long n_children);

/// \brief Set the format field of a fixed-size schema
///
/// Returns nanoarrow.EINVAL for fixed_size <= 0 or for type that is not
/// NANOARROW_TYPE_FIXED_SIZE_BINARY or NANOARROW_TYPE_FIXED_SIZE_LIST.
/// For NANOARROW_TYPE_FIXED_SIZE_LIST, the appropriate number of children are
/// allocated, initialized, and named; however, the caller must
/// ArrowSchemaSetType() the first child. Schema must have been initialized using
/// ArrowSchemaInit() or ArrowSchemaDeepCopy().
ArrowErrorCode ArrowSchemaSetTypeFixedSize(ArrowSchema* schema, ArrowType type, int fixed_size);

/// \brief Set the format field of a decimal schema
///
/// Returns nanoarrow.EINVAL for scale <= 0 or for type that is not
/// NANOARROW_TYPE_DECIMAL32, NANOARROW_TYPE_DECIMAL64, NANOARROW_TYPE_DECIMAL128 or
/// NANOARROW_TYPE_DECIMAL256. Schema must have been initialized using
/// ArrowSchemaInit() or ArrowSchemaDeepCopy().
ArrowErrorCode ArrowSchemaSetTypeDecimal(ArrowSchema* schema, ArrowType type, int decimal_precision, int decimal_scale);

/// \brief Set the format field of a run-end encoded schema
///
/// Returns nanoarrow.EINVAL for run_end_type that is not
/// NANOARROW_TYPE_INT16, NANOARROW_TYPE_INT32 or NANOARROW_TYPE_.
/// Schema must have been initialized using ArrowSchemaInit() or ArrowSchemaDeepCopy().
/// The caller must call `ArrowSchemaSetTypeXXX(schema->children[1])` to
/// set the value type. Note that when building arrays using the `ArrowArrayAppendXXX()`
/// functions, the run-end encoded array's logical length must be updated manually.
ArrowErrorCode ArrowSchemaSetTypeRunEndEncoded(ArrowSchema* schema, ArrowType run_end_type);

/// \brief Set the format field of a time, timestamp, or duration schema
///
/// Returns nanoarrow.EINVAL for type that is not
/// NANOARROW_TYPE_TIME32, NANOARROW_TYPE_TIME64,
/// NANOARROW_TYPE_TIMESTAMP, or NANOARROW_TYPE_DURATION. The
/// timezone parameter must be NULL for a non-timestamp type. Schema must have been
/// initialized using ArrowSchemaInit() or ArrowSchemaDeepCopy().
ArrowErrorCode ArrowSchemaSetTypeDateTime(ArrowSchema* schema, ArrowType type, ArrowTimeUnit time_unit, const(
        char)* timezone);

/// \brief Set the format field of a union schema
///
/// Returns nanoarrow.EINVAL for a type that is not NANOARROW_TYPE_DENSE_UNION
/// or NANOARROW_TYPE_SPARSE_UNION. The specified number of children are
/// allocated, and initialized.
ArrowErrorCode ArrowSchemaSetTypeUnion(ArrowSchema* schema, ArrowType type, long n_children);

/// \brief Make a (recursive) copy of a schema
///
/// Allocates and copies fields of schema into schema_out.
ArrowErrorCode ArrowSchemaDeepCopy(const(ArrowSchema)* schema, ArrowSchema* schema_out);

/// \brief Copy format into schema->format
///
/// schema must have been allocated using ArrowSchemaInitFromType() or
/// ArrowSchemaDeepCopy().
ArrowErrorCode ArrowSchemaSetFormat(ArrowSchema* schema, const(char)* format);

/// \brief Copy name into schema->name
///
/// schema must have been allocated using ArrowSchemaInitFromType() or
/// ArrowSchemaDeepCopy().
ArrowErrorCode ArrowSchemaSetName(ArrowSchema* schema, const(char)* name);

/// \brief Copy metadata into schema->metadata
///
/// schema must have been allocated using ArrowSchemaInitFromType() or
/// ArrowSchemaDeepCopy.
ArrowErrorCode ArrowSchemaSetMetadata(ArrowSchema* schema, const(char)* metadata);

/// \brief Allocate the schema->children array
///
/// Includes the memory for each child struct ArrowSchema.
/// schema must have been allocated using ArrowSchemaInitFromType() or
/// ArrowSchemaDeepCopy().
ArrowErrorCode ArrowSchemaAllocateChildren(ArrowSchema* schema, long n_children);

/// \brief Allocate the schema->dictionary member
///
/// schema must have been allocated using ArrowSchemaInitFromType() or
/// ArrowSchemaDeepCopy().
ArrowErrorCode ArrowSchemaAllocateDictionary(ArrowSchema* schema);

/// @}

/// \defgroup nanoarrow-metadata Create, read, and modify schema metadata
///
/// @{

/// \brief Reader for key/value pairs in schema metadata
///
/// The ArrowMetadataReader does not own any data and is only valid
/// for the lifetime of the underlying metadata pointer.
struct ArrowMetadataReader
{
    /// \brief A metadata string from a schema->metadata field.
    const(char)* metadata;

    /// \brief The current offset into the metadata string
    long offset;

    /// \brief The number of remaining keys
    int remaining_keys;
}

/// \brief Initialize an ArrowMetadataReader
ArrowErrorCode ArrowMetadataReaderInit(ArrowMetadataReader* reader, const(char)* metadata);

/// \brief Read the next key/value pair from an ArrowMetadataReader
ArrowErrorCode ArrowMetadataReaderRead(ArrowMetadataReader* reader, ArrowStringView* key_out, ArrowStringView* value_out);

/// \brief The number of bytes in in a key/value metadata string
long ArrowMetadataSizeOf(const(char)* metadata);

/// \brief Check for a key in schema metadata
char ArrowMetadataHasKey(const(char)* metadata, ArrowStringView key);

/// \brief Extract a value from schema metadata
///
/// If key does not exist in metadata, value_out is unmodified
ArrowErrorCode ArrowMetadataGetValue(const(char)* metadata, ArrowStringView key, ArrowStringView* value_out);

/// \brief Initialize a builder for schema metadata from key/value pairs
///
/// metadata can be an existing metadata string or NULL to initialize
/// an empty metadata string.
ArrowErrorCode ArrowMetadataBuilderInit(ArrowBuffer* buffer, const(char)* metadata);

/// \brief Append a key/value pair to a buffer containing serialized metadata
ArrowErrorCode ArrowMetadataBuilderAppend(ArrowBuffer* buffer, ArrowStringView key, ArrowStringView value);

/// \brief Set a key/value pair to a buffer containing serialized metadata
///
/// Ensures that the only entry for key in the metadata is set to value.
/// This function maintains the existing position of (the first instance of)
/// key if present in the data.
ArrowErrorCode ArrowMetadataBuilderSet(ArrowBuffer* buffer, ArrowStringView key, ArrowStringView value);

/// \brief Remove a key from a buffer containing serialized metadata
ArrowErrorCode ArrowMetadataBuilderRemove(ArrowBuffer* buffer, ArrowStringView key);

/// @}

/// \defgroup nanoarrow-schema-view Reading schemas
///
/// @{

/// \brief A non-owning view of a parsed ArrowSchema
///
/// Contains more readily extractable values than a raw ArrowSchema.
/// Clients can stack or statically allocate this structure but are
/// encouraged to use the provided getters to ensure forward
/// compatibility.
struct ArrowSchemaView
{
    /// \brief A pointer to the schema represented by this view
    const(ArrowSchema)* schema;

    /// \brief The data type represented by the schema
    ///
    /// This value may be NANOARROW_TYPE_DICTIONARY if the schema has a
    /// non-null dictionary member; datetime types are valid values.
    /// This value will never be NANOARROW_TYPE_EXTENSION (see
    /// extension_name and/or extension_metadata to check for
    /// an extension type).
    ArrowType type;

    /// \brief The storage data type represented by the schema
    ///
    /// This value will never be NANOARROW_TYPE_DICTIONARY, NANOARROW_TYPE_EXTENSION
    /// or any datetime type. This value represents only the type required to
    /// interpret the buffers in the array.
    ArrowType storage_type;

    /// \brief The storage layout represented by the schema
    ArrowLayout layout;

    /// \brief The extension type name if it exists
    ///
    /// If the ARROW:extension:name key is present in schema.metadata,
    /// extension_name.data will be non-NULL.
    ArrowStringView extension_name;

    /// \brief The extension type metadata if it exists
    ///
    /// If the ARROW:extension:metadata key is present in schema.metadata,
    /// extension_metadata.data will be non-NULL.
    ArrowStringView extension_metadata;

    /// \brief Format fixed size parameter
    ///
    /// This value is set when parsing a fixed-size binary or fixed-size
    /// list schema; this value is undefined for other types. For a
    /// fixed-size binary schema this value is in bytes; for a fixed-size
    /// list schema this value refers to the number of child elements for
    /// each element of the parent.
    int fixed_size;

    /// \brief Decimal bitwidth
    ///
    /// This value is set when parsing a decimal type schema;
    /// this value is undefined for other types.
    int decimal_bitwidth;

    /// \brief Decimal precision
    ///
    /// This value is set when parsing a decimal type schema;
    /// this value is undefined for other types.
    int decimal_precision;

    /// \brief Decimal scale
    ///
    /// This value is set when parsing a decimal type schema;
    /// this value is undefined for other types.
    int decimal_scale;

    /// \brief Format time unit parameter
    ///
    /// This value is set when parsing a date/time type. The value is
    /// undefined for other types.
    ArrowTimeUnit time_unit;

    /// \brief Format timezone parameter
    ///
    /// This value is set when parsing a timestamp type and represents
    /// the timezone format parameter. This value points to
    /// data within the schema and is undefined for other types.
    const(char)* timezone;

    /// \brief Union type ids parameter
    ///
    /// This value is set when parsing a union type and represents
    /// type ids parameter. This value points to
    /// data within the schema and is undefined for other types.
    const(char)* union_type_ids;
}

/// \brief Initialize an ArrowSchemaView
ArrowErrorCode ArrowSchemaViewInit(ArrowSchemaView* schema_view, const(ArrowSchema)* schema, ArrowError* error);

/// @}

/// \defgroup nanoarrow-bitmap Bitmap utilities
///
/// @{

/// \brief Extract a boolean value from a bitmap
pragma(inline, true) byte ArrowBitGet(const(ubyte)* bits, long i);

/// \brief Set a boolean value to a bitmap to true
pragma(inline, true) void ArrowBitSet(ubyte* bits, long i);

/// \brief Set a boolean value to a bitmap to false
pragma(inline, true) void ArrowBitClear(ubyte* bits, long i);

/// \brief Set a boolean value to a bitmap
pragma(inline, true) void ArrowBitSetTo(ubyte* bits, long i, ubyte value);

/// \brief Set a boolean value to a range in a bitmap
pragma(inline, true) void ArrowBitsSetTo(ubyte* bits, long start_offset, long length, ubyte bits_are_set);

/// \brief Count true values in a bitmap
pragma(inline, true) long ArrowBitCountSet(const(ubyte)* bits, long i_from, long i_to);

/// \brief Extract int8 boolean values from a range in a bitmap
pragma(inline, true) void ArrowBitsUnpackInt8(const(ubyte)* bits, long start_offset, long length, byte* out_);

/// \brief Extract int32 boolean values from a range in a bitmap
pragma(inline, true) void ArrowBitsUnpackInt32(const(ubyte)* bits, long start_offset, long length, int* out_);

/// \brief Initialize an ArrowBitmap
///
/// Initialize the builder's buffer, empty its cache, and reset the size to zero
pragma(inline, true) void ArrowBitmapInit(ArrowBitmap* bitmap);

/// \brief Move an ArrowBitmap
///
/// Transfers the underlying buffer data and lifecycle management to another
/// address and resets the bitmap.
pragma(inline, true) void ArrowBitmapMove(ArrowBitmap* src, ArrowBitmap* dst);

/// \brief Ensure a bitmap builder has at least a given additional capacity
///
/// Ensures that the buffer has space to append at least
/// additional_size_bits, overallocating when required.
pragma(inline, true) ArrowErrorCode ArrowBitmapReserve(ArrowBitmap* bitmap, long additional_size_bits);

/// \brief Grow or shrink a bitmap to a given size
///
/// When shrinking the size of the bitmap, the bitmap is only reallocated
/// if shrink_to_fit is non-zero.
pragma(inline, true) ArrowErrorCode ArrowBitmapResize(ArrowBitmap* bitmap, long new_size_bits, char shrink_to_fit);

/// \brief Reserve space for and append zero or more of the same boolean value to a bitmap
pragma(inline, true) ArrowErrorCode ArrowBitmapAppend(ArrowBitmap* bitmap, ubyte bits_are_set, long length);

/// \brief Append zero or more of the same boolean value to a bitmap
pragma(inline, true) void ArrowBitmapAppendUnsafe(ArrowBitmap* bitmap, ubyte bits_are_set, long length);

/// \brief Append boolean values encoded as int8_t to a bitmap
///
/// The values must all be 0 or 1.
pragma(inline, true) void ArrowBitmapAppendInt8Unsafe(ArrowBitmap* bitmap, const(byte)* values, long n_values);

/// \brief Append boolean values encoded as int32_t to a bitmap
///
/// The values must all be 0 or 1.
pragma(inline, true) void ArrowBitmapAppendInt32Unsafe(ArrowBitmap* bitmap, const(int)* values, long n_values);

/// \brief Reset a bitmap builder
///
/// Releases any memory held by buffer, empties the cache, and resets the size to zero
pragma(inline, true) void ArrowBitmapReset(ArrowBitmap* bitmap);

/// @}

/// \defgroup nanoarrow-array Creating arrays
///
/// These functions allocate, copy, and destroy ArrowArray structures.
/// Once an ArrowArray has been initialized via ArrowArrayInitFromType()
/// or ArrowArrayInitFromSchema(), the caller is responsible for releasing
/// it using the embedded release callback.
///
/// @{

/// \brief Initialize the fields of an array
///
/// Initializes the fields and release callback of array. Caller
/// is responsible for calling the array->release callback if
/// NANOARROW_OK is returned.
ArrowErrorCode ArrowArrayInitFromType(ArrowArray* array, ArrowType storage_type);

/// \brief Initialize the contents of an ArrowArray from an ArrowSchema
///
/// Caller is responsible for calling the array->release callback if
/// NANOARROW_OK is returned.
ArrowErrorCode ArrowArrayInitFromSchema(ArrowArray* array, const(ArrowSchema)* schema, ArrowError* error);

/// \brief Initialize the contents of an ArrowArray from an ArrowArrayView
///
/// Caller is responsible for calling the array->release callback if
/// NANOARROW_OK is returned.
ArrowErrorCode ArrowArrayInitFromArrayView(ArrowArray* array, const(ArrowArrayView)* array_view, ArrowError* error);

/// \brief Allocate the array->children array
///
/// Includes the memory for each child struct ArrowArray,
/// whose members are marked as released and may be subsequently initialized
/// with ArrowArrayInitFromType() or moved from an existing ArrowArray.
/// schema must have been allocated using ArrowArrayInitFromType().
ArrowErrorCode ArrowArrayAllocateChildren(ArrowArray* array, long n_children);

/// \brief Allocate the array->dictionary member
///
/// Includes the memory for the struct ArrowArray, whose contents
/// is marked as released and may be subsequently initialized
/// with ArrowArrayInitFromType() or moved from an existing ArrowArray.
/// array must have been allocated using ArrowArrayInitFromType()
ArrowErrorCode ArrowArrayAllocateDictionary(ArrowArray* array);

/// \brief Set the validity bitmap of an ArrowArray
///
/// array must have been allocated using ArrowArrayInitFromType()
void ArrowArraySetValidityBitmap(ArrowArray* array, ArrowBitmap* bitmap);

/// \brief Set a buffer of an ArrowArray
///
/// array must have been allocated using ArrowArrayInitFromType()
ArrowErrorCode ArrowArraySetBuffer(ArrowArray* array, long i, ArrowBuffer* buffer);

/// \brief Get the validity bitmap of an ArrowArray
///
/// array must have been allocated using ArrowArrayInitFromType()
pragma(inline, true) ArrowBitmap* ArrowArrayValidityBitmap(ArrowArray* array);

/// \brief Get a buffer of an ArrowArray
///
/// array must have been allocated using ArrowArrayInitFromType()
pragma(inline, true) ArrowBuffer* ArrowArrayBuffer(ArrowArray* array, long i);

/// \brief Start element-wise appending to an ArrowArray
///
/// Initializes any values needed to use ArrowArrayAppend*() functions.
/// All element-wise appenders append by value and return nanoarrow.EINVAL if the exact value
/// cannot be represented by the underlying storage type.
/// array must have been allocated using ArrowArrayInitFromType()
pragma(inline, true) ArrowErrorCode ArrowArrayStartAppending(ArrowArray* array);

/// \brief Reserve space for future appends
///
/// For buffer sizes that can be calculated (i.e., not string data buffers or
/// child array sizes for non-fixed-size arrays), recursively reserve space for
/// additional elements. This is useful for reducing the number of reallocations
/// that occur using the item-wise appenders.
ArrowErrorCode ArrowArrayReserve(ArrowArray* array, long additional_size_elements);

/// \brief Append a null value to an array
pragma(inline, true) ArrowErrorCode ArrowArrayAppendNull(ArrowArray* array, long n);

/// \brief Append an empty, non-null value to an array
pragma(inline, true) ArrowErrorCode ArrowArrayAppendEmpty(ArrowArray* array, long n);

/// \brief Append a signed integer value to an array
///
/// Returns NANOARROW_OK if value can be exactly represented by
/// the underlying storage type or nanoarrow.EINVAL otherwise (e.g., value
/// is outside the valid array range).
pragma(inline, true) ArrowErrorCode ArrowArrayAppendInt(ArrowArray* array, long value);

/// \brief Append an unsigned integer value to an array
///
/// Returns NANOARROW_OK if value can be exactly represented by
/// the underlying storage type or nanoarrow.EINVAL otherwise (e.g., value
/// is outside the valid array range).
pragma(inline, true) ArrowErrorCode ArrowArrayAppendUInt(ArrowArray* array, ulong value);

/// \brief Append a double value to an array
///
/// Returns NANOARROW_OK if value can be exactly represented by
/// the underlying storage type or nanoarrow.EINVAL otherwise (e.g., value
/// is outside the valid array range or there is an attempt to append
/// a non-integer to an array with an integer storage type).
pragma(inline, true) ArrowErrorCode ArrowArrayAppendDouble(ArrowArray* array, double value);

/// \brief Append a string of bytes to an array
///
/// Returns NANOARROW_OK if value can be exactly represented by
/// the underlying storage type, nanoarrow.EOVERFLOW if appending value would overflow
/// the offset type (e.g., if the data buffer would be larger than 2 GB for a
/// non-large string type), or nanoarrow.EINVAL otherwise (e.g., the underlying array is not a
/// binary, string, large binary, large string, or fixed-size binary array, or value is
/// the wrong size for a fixed-size binary array).
pragma(inline, true) ArrowErrorCode ArrowArrayAppendBytes(
    ArrowArray* array, ArrowBufferView value);

/// \brief Append a string value to an array
///
/// Returns NANOARROW_OK if value can be exactly represented by
/// the underlying storage type, nanoarrow.EOVERFLOW if appending value would overflow
/// the offset type (e.g., if the data buffer would be larger than 2 GB for a
/// non-large string type), or nanoarrow.EINVAL otherwise (e.g., the underlying array is not a
/// string or large string array).
pragma(inline, true) ArrowErrorCode ArrowArrayAppendString(
    ArrowArray* array, ArrowStringView value);

/// \brief Append a Interval to an array
///
/// Returns NANOARROW_OK if value can be exactly represented by
/// the underlying storage type or nanoarrow.EINVAL otherwise.
pragma(inline, true) ArrowErrorCode ArrowArrayAppendInterval(
    ArrowArray* array, const(ArrowInterval)* value);

/// \brief Append a decimal value to an array
///
/// Returns NANOARROW_OK if array is a decimal array with the appropriate
/// bitwidth or nanoarrow.EINVAL otherwise.
pragma(inline, true) ArrowErrorCode ArrowArrayAppendDecimal(
    ArrowArray* array, const(ArrowDecimal)* value);

/// \brief Finish a nested array element
///
/// Appends a non-null element to the array based on the first child's current
/// length. Returns NANOARROW_OK if the item was successfully added, nanoarrow.EOVERFLOW
/// if the child of a list or map array would exceed INT_MAX elements, or nanoarrow.EINVAL
/// if the underlying storage type is not a struct, list, large list, or fixed-size
/// list, or if there was an attempt to add a struct or fixed-size list element where the
/// length of the child array(s) did not match the expected length.
pragma(inline, true) ArrowErrorCode ArrowArrayFinishElement(ArrowArray* array);

/// \brief Finish a union array element
///
/// Appends an element to the union type ids buffer and increments array->length.
/// For sparse unions, up to one element is added to non type-id children. Returns
/// nanoarrow.EINVAL if the underlying storage type is not a union, if type_id is not valid,
/// or if child sizes after appending are inconsistent.
pragma(inline, true) ArrowErrorCode ArrowArrayFinishUnionElement(
    ArrowArray* array, byte type_id);

/// \brief Shrink buffer capacity to the size required
///
/// Also applies shrinking to any child arrays. array must have been allocated using
/// ArrowArrayInitFromType
pragma(inline, true) ArrowErrorCode ArrowArrayShrinkToFit(ArrowArray* array);

/// \brief Finish building an ArrowArray
///
/// Flushes any pointers from internal buffers that may have been reallocated
/// into array->buffers and checks the actual size of the buffers
/// against the expected size based on the final length.
/// array must have been allocated using ArrowArrayInitFromType()
ArrowErrorCode ArrowArrayFinishBuildingDefault(ArrowArray* array, ArrowError* error);

/// \brief Finish building an ArrowArray with explicit validation
///
/// Finish building with an explicit validation level. This could perform less validation
/// (i.e. NANOARROW_VALIDATION_LEVEL_NONE or NANOARROW_VALIDATION_LEVEL_MINIMAL) if CPU
/// buffer data access is not possible or more validation (i.e.,
/// NANOARROW_VALIDATION_LEVEL_FULL) if buffer content was obtained from an untrusted or
/// corruptible source.
ArrowErrorCode ArrowArrayFinishBuilding(ArrowArray* array, ArrowValidationLevel validation_level, ArrowError* error);

/// @}

/// \defgroup nanoarrow-array-view Reading arrays
///
/// These functions read and validate the contents ArrowArray structures.
///
/// @{

/// \brief Initialize the contents of an ArrowArrayView
void ArrowArrayViewInitFromType(ArrowArrayView* array_view, ArrowType storage_type);

/// \brief Move an ArrowArrayView
///
/// Transfers the ArrowArrayView data and lifecycle management to another
/// address and resets the contents of src.
pragma(inline, true) void ArrowArrayViewMove(ArrowArrayView* src, ArrowArrayView* dst);

/// \brief Initialize the contents of an ArrowArrayView from an ArrowSchema
ArrowErrorCode ArrowArrayViewInitFromSchema(ArrowArrayView* array_view, const(ArrowSchema)* schema, ArrowError* error);

/// \brief Allocate the array_view->children array
///
/// Includes the memory for each child struct ArrowArrayView
ArrowErrorCode ArrowArrayViewAllocateChildren(ArrowArrayView* array_view, long n_children);

/// \brief Allocate array_view->dictionary
ArrowErrorCode ArrowArrayViewAllocateDictionary(ArrowArrayView* array_view);

/// \brief Set data-independent buffer sizes from length
void ArrowArrayViewSetLength(ArrowArrayView* array_view, long length);

/// \brief Set buffer sizes and data pointers from an ArrowArray
ArrowErrorCode ArrowArrayViewSetArray(ArrowArrayView* array_view, const(ArrowArray)* array, ArrowError* error);

/// \brief Set buffer sizes and data pointers from an ArrowArray except for those
/// that require dereferencing buffer content.
ArrowErrorCode ArrowArrayViewSetArrayMinimal(ArrowArrayView* array_view, const(ArrowArray)* array, ArrowError* error);

/// \brief Get the number of buffers
///
/// The number of buffers referred to by this ArrowArrayView.  In may cases this can also
/// be calculated from the ArrowLayout member of the ArrowArrayView or ArrowSchemaView;
/// however, for binary view and string view types, the number of total buffers depends on
/// the number of variadic buffers.
pragma(inline, true) long ArrowArrayViewGetNumBuffers(ArrowArrayView* array_view);

/// \brief Get a view of a specific buffer from an ArrowArrayView
///
/// This is the ArrowArrayView equivalent of ArrowArray::buffers[i] that includes
/// size information (if known).
pragma(inline, true) ArrowBufferView ArrowArrayViewGetBufferView(
    ArrowArrayView* array_view, long i);

/// \brief Get the function of a specific buffer in an ArrowArrayView
///
/// In may cases this can also be obtained from the ArrowLayout member of the
/// ArrowArrayView or ArrowSchemaView; however, for binary view and string view types,
/// the function of each buffer may be different between two arrays of the same type
/// depending on the number of variadic buffers.
pragma(inline, true) ArrowBufferType ArrowArrayViewGetBufferType(
    ArrowArrayView* array_view, long i);

/// \brief Get the data type of a specific buffer in an ArrowArrayView
///
/// In may cases this can also be obtained from the ArrowLayout member of the
/// ArrowArrayView or ArrowSchemaView; however, for binary view and string view types,
/// the data type of each buffer may be different between two arrays of the same type
/// depending on the number of variadic buffers.
pragma(inline, true) ArrowType ArrowArrayViewGetBufferDataType(
    ArrowArrayView* array_view, long i);

/// \brief Get the element size (in bits) of a specific buffer in an ArrowArrayView
///
/// In may cases this can also be obtained from the ArrowLayout member of the
/// ArrowArrayView or ArrowSchemaView; however, for binary view and string view types,
/// the element width of each buffer may be different between two arrays of the same type
/// depending on the number of variadic buffers.
pragma(inline, true) long ArrowArrayViewGetBufferElementSizeBits(
    ArrowArrayView* array_view, long i);

/// \brief Performs checks on the content of an ArrowArrayView
///
/// If using ArrowArrayViewSetArray() to back array_view with an ArrowArray,
/// the buffer sizes and some content (fist and last offset) have already
/// been validated at the "default" level. If setting the buffer pointers
/// and sizes otherwise, you may wish to perform checks at a different level. See
/// documentation for ArrowValidationLevel for the details of checks performed
/// at each level.
ArrowErrorCode ArrowArrayViewValidate(ArrowArrayView* array_view, ArrowValidationLevel validation_level, ArrowError* error);

/// \brief Compare two ArrowArrayView objects for equality
///
/// Given two ArrowArrayView instances, place either 0 (not equal) and
/// 1 (equal) at the address pointed to by out. If the comparison determines
/// that actual and expected are not equal, a reason will be communicated via
/// error if error is non-NULL.
///
/// Returns NANOARROW_OK if the comparison completed successfully.
ArrowErrorCode ArrowArrayViewCompare(const(ArrowArrayView)* actual, const(ArrowArrayView)* expected, ArrowCompareLevel level, int* out_, ArrowError* reason);

/// \brief Reset the contents of an ArrowArrayView and frees resources
void ArrowArrayViewReset(ArrowArrayView* array_view);

/// \brief Check for a null element in an ArrowArrayView
pragma(inline, true) byte ArrowArrayViewIsNull(const(ArrowArrayView)* array_view, long i);

/// \brief Compute null count for an ArrowArrayView
pragma(inline, true) long ArrowArrayViewComputeNullCount(const(ArrowArrayView)* array_view);

/// \brief Get the type id of a union array element
pragma(inline, true) byte ArrowArrayViewUnionTypeId(
    const(ArrowArrayView)* array_view, long i);

/// \brief Get the child index of a union array element
pragma(inline, true) byte ArrowArrayViewUnionChildIndex(
    const(ArrowArrayView)* array_view, long i);

/// \brief Get the index to use into the relevant union child array
pragma(inline, true) long ArrowArrayViewUnionChildOffset(
    const(ArrowArrayView)* array_view, long i);

/// \brief Get an element in an ArrowArrayView as an integer
///
/// This function does not check for null values, that values are actually integers, or
/// that values are within a valid range for an .
pragma(inline, true) long ArrowArrayViewGetIntUnsafe(
    const(ArrowArrayView)* array_view, long i);

/// \brief Get an element in an ArrowArrayView as an unsigned integer
///
/// This function does not check for null values, that values are actually integers, or
/// that values are within a valid range for a u.
pragma(inline, true) ulong ArrowArrayViewGetUIntUnsafe(
    const(ArrowArrayView)* array_view, long i);

/// \brief Get an element in an ArrowArrayView as a double
///
/// This function does not check for null values, or
/// that values are within a valid range for a double.
pragma(inline, true) double ArrowArrayViewGetDoubleUnsafe(
    const(ArrowArrayView)* array_view, long i);

/// \brief Get an element in an ArrowArrayView as an ArrowStringView
///
/// This function does not check for null values.
pragma(inline, true) ArrowStringView ArrowArrayViewGetStringUnsafe(
    const(ArrowArrayView)* array_view, long i);

/// \brief Get an element in an ArrowArrayView as an ArrowBufferView
///
/// This function does not check for null values.
pragma(inline, true) ArrowBufferView ArrowArrayViewGetBytesUnsafe(
    const(ArrowArrayView)* array_view, long i);

/// \brief Get an element in an ArrowArrayView as an ArrowDecimal
///
/// This function does not check for null values. The out parameter must
/// be initialized with ArrowDecimalInit() with the proper parameters for this
/// type before calling this for the first time.
pragma(inline, true) void ArrowArrayViewGetDecimalUnsafe(
    const(ArrowArrayView)* array_view, long i, ArrowDecimal* out_);

/// @}

/// \defgroup nanoarrow-basic-array-stream Basic ArrowArrayStream implementation
///
/// An implementation of an ArrowArrayStream based on a collection of
/// zero or more previously-existing ArrowArray objects. Users should
/// initialize and/or validate the contents before transferring the
/// responsibility of the ArrowArrayStream elsewhere.
///
/// @{

/// \brief Initialize an ArrowArrayStream backed by this implementation
///
/// This function moves the ownership of schema to the array_stream. If
/// this function returns NANOARROW_OK, the caller is responsible for
/// releasing the ArrowArrayStream.
ArrowErrorCode ArrowBasicArrayStreamInit(ArrowArrayStream* array_stream, ArrowSchema* schema, long n_arrays);

/// \brief Set the ith ArrowArray in this ArrowArrayStream.
///
/// array_stream must have been initialized with ArrowBasicArrayStreamInit().
/// This function move the ownership of array to the array_stream. i must
/// be greater than zero and less than the value of n_arrays passed in
/// ArrowBasicArrayStreamInit(). Callers are not required to fill all
/// n_arrays members (i.e., n_arrays is a maximum bound).
void ArrowBasicArrayStreamSetArray(ArrowArrayStream* array_stream, long i, ArrowArray* array);

/// \brief Validate the contents of this ArrowArrayStream
///
/// array_stream must have been initialized with ArrowBasicArrayStreamInita).
/// This function uses ArrowArrayStreamInitFromSchema() and ArrowArrayStreamSetArray()
/// to validate the contents of the arrays.
ArrowErrorCode ArrowBasicArrayStreamValidate(const(ArrowArrayStream)* array_stream, ArrowError* error);

/// @}

// Undefine ArrowErrorCode, which may have been defined to annotate functions that return
// it to warn for an unused result.

// Inline function definitions

//! #endif
// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

// Modified from Arrow C++ (1eb46f76) cpp/src/arrow/chunk_resolver.h#L133-L162
pragma(inline, true) long ArrowResolveChunk64(long index, const(long)* offsets, long lo, long hi)
{
    // Similar to std::upper_bound(), but slightly different as our offsets
    // array always starts with 0.
    long n = hi - lo;
    // First iteration does not need to check for n > 1
    // (lo < hi is guaranteed by the precondition).
    assert(n > 1);
    do
    {
        const(long) m = n >> 1;
        const(long) mid = lo + m;
        if (index >= offsets[mid])
        {
            lo = mid;
            n -= m;
        }
        else
        {
            n = m;
        }
    }
    while (n > 1);
    return lo;
}

pragma(inline, true) long ArrowResolveChunk32(int index, const(int)* offsets, int lo, int hi)
{
    // Similar to std::upper_bound(), but slightly different as our offsets
    // array always starts with 0.
    int n = hi - lo;
    // First iteration does not need to check for n > 1
    // (lo < hi is guaranteed by the precondition).
    assert(n > 1);
    do
    {
        const(int) m = n >> 1;
        const(int) mid = lo + m;
        if (index >= offsets[mid])
        {
            lo = mid;
            n -= m;
        }
        else
        {
            n = m;
        }
    }
    while (n > 1);
    return lo;
}

pragma(inline, true) long _ArrowGrowByFactor(long current_capacity, long new_capacity)
{
    long doubled_capacity = current_capacity * 2;
    if (doubled_capacity > new_capacity)
    {
        return doubled_capacity;
    }
    else
    {
        return new_capacity;
    }
}

pragma(inline, true) ushort ArrowFloatToHalfFloat(float value)
{
    union _U
    {
        float f = void;
        uint b = void;
    }

    _U u = void;
    u.f = value;

    ushort sn = cast(ushort)((u.b >> 31) & 0x1);
    ushort exp = (u.b >> 23) & 0xff;
    short res = cast(short)(exp - 127 + 15);
    ushort fc = cast(ushort)(u.b >> 13) & 0x3ff;

    if (exp == 0)
    {
        res = 0;
    }
    else if (exp == 0xff)
    {
        res = 0x1f;
    }
    else if (res > 0x1e)
    {
        res = 0x1f;
        fc = 0;
    }
    else if (res < 0x01)
    {
        res = 0;
        fc = 0;
    }

    return cast(ushort)((sn << 15) | cast(ushort)(res << 10) | fc);
}

pragma(inline, true) float ArrowHalfFloatToFloat(ushort value)
{
    uint sn = cast(uint)((value >> 15) & 0x1);
    uint exp = (value >> 10) & 0x1f;
    uint res = exp + 127 - 15;
    uint fc = value & 0x3ff;

    if (exp == 0)
    {
        res = 0;
    }
    else if (exp == 0x1f)
    {
        res = 0xff;
    }

    union _U
    {
        float f = void;
        uint b = void;
    }

    _U u = void;
    u.b = cast(uint)(sn << 31) | cast(uint)(res << 23) | cast(uint)(fc << 13);
    return u.f;
}

pragma(inline, true) void ArrowBufferInit(ArrowBuffer* buffer)
{
    buffer.data = null;
    buffer.size_bytes = 0;
    buffer.capacity_bytes = 0;
    buffer.allocator = ArrowBufferAllocatorDefault();
}

pragma(inline, true) ArrowErrorCode ArrowBufferSetAllocator(
    ArrowBuffer* buffer, ArrowBufferAllocator allocator)
{
    // This is not a perfect test for "has a buffer already been allocated"
    // but is likely to catch most cases.
    if (buffer.data == null)
    {
        buffer.allocator = allocator;
        return NANOARROW_OK;
    }
    else
    {
        return nanoarrow.EINVAL;
    }
}

pragma(inline, true) void ArrowBufferReset(ArrowBuffer* buffer)
{
    buffer.allocator.free(&buffer.allocator, cast(ubyte*) buffer.data,
        buffer.capacity_bytes);
    ArrowBufferInit(buffer);
}

pragma(inline, true) void ArrowBufferMove(ArrowBuffer* src, ArrowBuffer* dst)
{
    memcpy(dst, src, ArrowBuffer.sizeof);
    src.data = null;
    ArrowBufferInit(src);
}

pragma(inline, true) ArrowErrorCode ArrowBufferResize(ArrowBuffer* buffer, long new_size_bytes, char shrink_to_fit)
{
    if (new_size_bytes < 0)
    {
        return nanoarrow.EINVAL;
    }

    int needs_reallocation = new_size_bytes > buffer.capacity_bytes ||
        (shrink_to_fit && new_size_bytes < buffer.capacity_bytes);

    if (needs_reallocation)
    {
        buffer.data = buffer.allocator.reallocate(&buffer.allocator, buffer.data,
            buffer.capacity_bytes, new_size_bytes);

        if (buffer.data == null && new_size_bytes > 0)
        {
            buffer.capacity_bytes = 0;
            buffer.size_bytes = 0;
            return nanoarrow.ENOMEM;
        }

        buffer.capacity_bytes = new_size_bytes;
    }

    buffer.size_bytes = new_size_bytes;
    return NANOARROW_OK;
}

pragma(inline, true) ArrowErrorCode ArrowBufferReserve(ArrowBuffer* buffer, long additional_size_bytes)
{
    long min_capacity_bytes = buffer.size_bytes + additional_size_bytes;
    if (min_capacity_bytes <= buffer.capacity_bytes)
    {
        return NANOARROW_OK;
    }

    long new_capacity_bytes = _ArrowGrowByFactor(buffer.capacity_bytes, min_capacity_bytes);
    buffer.data = buffer.allocator.reallocate(&buffer.allocator, buffer.data,
        buffer.capacity_bytes, new_capacity_bytes);

    if (buffer.data == null && new_capacity_bytes > 0)
    {
        buffer.capacity_bytes = 0;
        buffer.size_bytes = 0;
        return nanoarrow.ENOMEM;
    }

    buffer.capacity_bytes = new_capacity_bytes;
    return NANOARROW_OK;
}

pragma(inline, true) void ArrowBufferAppendUnsafe(ArrowBuffer* buffer, const(void)* data, long size_bytes)
{
    if (size_bytes > 0)
    {
        assert(buffer.data != null);
        memcpy(buffer.data + buffer.size_bytes, data, size_bytes);
        buffer.size_bytes += size_bytes;
    }
}

pragma(inline, true) ArrowErrorCode ArrowBufferAppend(ArrowBuffer* buffer, const(void)* data, long size_bytes)
{
    auto s = returnNotOk(ArrowBufferReserve(buffer, size_bytes));
    if (s != NANOARROW_OK)
        return s;

    ArrowBufferAppendUnsafe(buffer, data, size_bytes);
    return NANOARROW_OK;
}

pragma(inline, true) ArrowErrorCode ArrowBufferAppendInt8(
    ArrowBuffer* buffer, byte value)
{
    return ArrowBufferAppend(buffer, &value, byte.sizeof);
}

pragma(inline, true) ArrowErrorCode ArrowBufferAppendUInt8(
    ArrowBuffer* buffer, ubyte value)
{
    return ArrowBufferAppend(buffer, &value, ubyte.sizeof);
}

pragma(inline, true) ArrowErrorCode ArrowBufferAppendInt16(
    ArrowBuffer* buffer, short value)
{
    return ArrowBufferAppend(buffer, &value, short.sizeof);
}

pragma(inline, true) ArrowErrorCode ArrowBufferAppendUInt16(
    ArrowBuffer* buffer, ushort value)
{
    return ArrowBufferAppend(buffer, &value, ushort.sizeof);
}

pragma(inline, true) ArrowErrorCode ArrowBufferAppendInt32(
    ArrowBuffer* buffer, int value)
{
    return ArrowBufferAppend(buffer, &value, int.sizeof);
}

pragma(inline, true) ArrowErrorCode ArrowBufferAppendUInt32(
    ArrowBuffer* buffer, uint value)
{
    return ArrowBufferAppend(buffer, &value, uint.sizeof);
}

pragma(inline, true) private ArrowErrorCode ArrowBufferAppendInt64(ArrowBuffer* buffer, long value)
{
    return ArrowBufferAppend(buffer, &value, long.sizeof);
}

pragma(inline, true) private ArrowErrorCode ArrowBufferAppendUInt64(ArrowBuffer* buffer, ulong value)
{
    return ArrowBufferAppend(buffer, &value, ulong.sizeof);
}

pragma(inline, true) ArrowErrorCode ArrowBufferAppendDouble(
    ArrowBuffer* buffer, double value)
{
    return ArrowBufferAppend(buffer, &value, double.sizeof);
}

pragma(inline, true) ArrowErrorCode ArrowBufferAppendFloat(
    ArrowBuffer* buffer, float value)
{
    return ArrowBufferAppend(buffer, &value, float.sizeof);
}

pragma(inline, true) ArrowErrorCode ArrowBufferAppendStringView(
    ArrowBuffer* buffer, ArrowStringView value)
{
    return ArrowBufferAppend(buffer, value.data, value.size_bytes);
}

pragma(inline, true) ArrowErrorCode ArrowBufferAppendBufferView(
    ArrowBuffer* buffer, ArrowBufferView value)
{
    return ArrowBufferAppend(buffer, value.data.data, value.size_bytes);
}

pragma(inline, true) ArrowErrorCode ArrowBufferAppendFill(
    ArrowBuffer* buffer, ubyte value, long size_bytes)
{
    if (size_bytes == 0)
    {
        return NANOARROW_OK;
    }

    auto s = returnNotOk(ArrowBufferReserve(buffer, size_bytes));
    if (s != NANOARROW_OK)
        return s;

    assert(buffer.data != null); // To help clang-tidy
    memset(buffer.data + buffer.size_bytes, value, size_bytes);
    buffer.size_bytes += size_bytes;

    return NANOARROW_OK;
}

pragma(inline, true) long _ArrowRoundUpToMultipleOf8(long value)
{
    return (value + 7) & ~(cast(long) 7);
}

pragma(inline, true) long _ArrowRoundDownToMultipleOf8(long value)
{
    return (value / 8) * 8;
}

pragma(inline, true) long _ArrowBytesForBits(long bits)
{
    return (bits >> 3) + ((bits & 7) != 0);
}

pragma(inline, true) void _ArrowBitsUnpackInt8(const(ubyte) word, byte* out_)
{
    out_[0] = (word & 0x1) != 0;
    out_[1] = (word & 0x2) != 0;
    out_[2] = (word & 0x4) != 0;
    out_[3] = (word & 0x8) != 0;
    out_[4] = (word & 0x10) != 0;
    out_[5] = (word & 0x20) != 0;
    out_[6] = (word & 0x40) != 0;
    out_[7] = (word & 0x80) != 0;
}

pragma(inline, true) void _ArrowBitsUnpackInt32(const(ubyte) word, int* out_)
{
    out_[0] = (word & 0x1) != 0;
    out_[1] = (word & 0x2) != 0;
    out_[2] = (word & 0x4) != 0;
    out_[3] = (word & 0x8) != 0;
    out_[4] = (word & 0x10) != 0;
    out_[5] = (word & 0x20) != 0;
    out_[6] = (word & 0x40) != 0;
    out_[7] = (word & 0x80) != 0;
}

pragma(inline, true) void _ArrowBitmapPackInt8(const(byte)* values, ubyte* out_)
{

    *out_ = cast(ubyte)(values[0] | ((values[1] + 0x1) & 0x2) | (
            (values[2] + 0x3) & 0x4) |
            ((values[3] + 0x7) & 0x8) | (
                (values[4] + 0xf) & 0x10) |
            (
                (values[5] + 0x1f) & 0x20) | (
                (values[6] + 0x3f) & 0x40) |
            ((values[7] + 0x7f) & 0x80));
}

pragma(inline, true) void _ArrowBitmapPackInt32(const(int)* values, ubyte* out_)
{

    *out_ = cast(ubyte)(values[0] | ((values[1] + 0x1) & 0x2) | (
            (values[2] + 0x3) & 0x4) |
            ((values[3] + 0x7) & 0x8) | (
                (values[4] + 0xf) & 0x10) |
            (
                (values[5] + 0x1f) & 0x20) | (
                (values[6] + 0x3f) & 0x40) |
            ((values[7] + 0x7f) & 0x80));
}

pragma(inline, true) byte ArrowBitGet(const(ubyte)* bits, long i)
{
    return (bits[i >> 3] >> (i & 0x07)) & 1;
}

pragma(inline, true) void ArrowBitsUnpackInt8(const(ubyte)* bits, long start_offset, long length, byte* out_)
{
    if (length == 0)
    {
        return;
    }

    const(long) i_begin = start_offset;
    const(long) i_end = start_offset + length;
    const(long) i_last_valid = i_end - 1;

    const(long) bytes_begin = i_begin / 8;
    const(long) bytes_last_valid = i_last_valid / 8;

    if (bytes_begin == bytes_last_valid)
    {
        for (int i = 0; i < length; i++)
        {
            out_[i] = ArrowBitGet(&bits[bytes_begin], i + i_begin % 8);
        }

        return;
    }

    // first byte
    for (int i = 0; i < 8 - (i_begin % 8); i++)
    {

        *out_++ = ArrowBitGet(&bits[bytes_begin], i + i_begin % 8);
    }

    // middle bytes
    for (long i = bytes_begin + 1; i < bytes_last_valid; i++)
    {
        _ArrowBitsUnpackInt8(bits[i], out_);
        out_ += 8;
    }

    // last byte
    const(int) bits_remaining = cast(int)(i_end % 8 == 0 ? 8 : i_end % 8);
    for (int i = 0; i < bits_remaining; i++)
    {

        *out_++ = ArrowBitGet(&bits[bytes_last_valid], i);
    }
}

pragma(inline, true) void ArrowBitsUnpackInt32(const(ubyte)* bits, long start_offset, long length, int* out_)
{
    if (length == 0)
    {
        return;
    }

    assert(bits != null && out_ != null);

    const(long) i_begin = start_offset;
    const(long) i_end = start_offset + length;
    const(long) i_last_valid = i_end - 1;

    const(long) bytes_begin = i_begin / 8;
    const(long) bytes_last_valid = i_last_valid / 8;

    if (bytes_begin == bytes_last_valid)
    {
        for (int i = 0; i < length; i++)
        {
            out_[i] = ArrowBitGet(&bits[bytes_begin], i + i_begin % 8);
        }

        return;
    }

    // first byte
    for (int i = 0; i < 8 - (i_begin % 8); i++)
    {

        *out_++ = ArrowBitGet(&bits[bytes_begin], i + i_begin % 8);
    }

    // middle bytes
    for (long i = bytes_begin + 1; i < bytes_last_valid; i++)
    {
        _ArrowBitsUnpackInt32(bits[i], out_);
        out_ += 8;
    }

    // last byte
    const(int) bits_remaining = cast(int)(i_end % 8 == 0 ? 8 : i_end % 8);
    for (int i = 0; i < bits_remaining; i++)
    {

        *out_++ = ArrowBitGet(&bits[bytes_last_valid], i);
    }
}

pragma(inline, true) void ArrowBitSet(ubyte* bits, long i)
{
    bits[i / 8] |= _ArrowkBitmask[i % 8];
}

pragma(inline, true) void ArrowBitClear(ubyte* bits, long i)
{
    bits[i / 8] &= _ArrowkFlippedBitmask[i % 8];
}

pragma(inline, true) void ArrowBitSetTo(ubyte* bits, long i, ubyte bit_is_set)
{
    bits[i / 8] ^= cast(ubyte)(
        (cast(ubyte)(-(cast(ubyte)(bit_is_set != 0)) ^ bits[i / 8])) &
            _ArrowkBitmask[i % 8]);
}

pragma(inline, true) void ArrowBitsSetTo(ubyte* bits, long start_offset, long length, ubyte bits_are_set)
{
    if (length == 0)
    {
        return;
    }

    assert(bits != null);

    const(long) i_begin = start_offset;
    const(long) i_end = start_offset + length;
    const(ubyte) fill_byte = cast(ubyte)(-bits_are_set);

    const(long) bytes_begin = i_begin / 8;
    const(long) bytes_end = i_end / 8 + 1;

    const(ubyte) first_byte_mask = _ArrowkPrecedingBitmask[i_begin % 8];
    const(ubyte) last_byte_mask = _ArrowkTrailingBitmask[i_end % 8];

    if (bytes_end == bytes_begin + 1)
    {
        // set bits within a single byte
        const(ubyte) only_byte_mask = i_end % 8 == 0 ? first_byte_mask : cast(
            ubyte)(first_byte_mask | last_byte_mask);
        bits[bytes_begin] &= only_byte_mask;
        bits[bytes_begin] |= cast(ubyte)(fill_byte & ~only_byte_mask);
        return;
    }

    // set/clear trailing bits of first byte
    bits[bytes_begin] &= first_byte_mask;
    bits[bytes_begin] |= cast(ubyte)(fill_byte & ~first_byte_mask);

    if (bytes_end - bytes_begin > 2)
    {
        // set/clear whole bytes
        memset(bits + bytes_begin + 1, fill_byte, cast(size_t)(bytes_end - bytes_begin - 2));
    }

    if (i_end % 8 == 0)
    {
        return;
    }

    // set/clear leading bits of last byte
    bits[bytes_end - 1] &= last_byte_mask;
    bits[bytes_end - 1] |= cast(ubyte)(fill_byte & ~last_byte_mask);
}

pragma(inline, true) long ArrowBitCountSet(const(ubyte)* bits, long start_offset, long length)
{
    if (length == 0)
    {
        return 0;
    }

    assert(bits != null);

    const(long) i_begin = start_offset;
    const(long) i_end = start_offset + length;
    const(long) i_last_valid = i_end - 1;

    const(long) bytes_begin = i_begin / 8;
    const(long) bytes_last_valid = i_last_valid / 8;

    if (bytes_begin == bytes_last_valid)
    {
        // count bits within a single byte
        const(ubyte) first_byte_mask = _ArrowkPrecedingBitmask[i_end % 8];
        const(ubyte) last_byte_mask = _ArrowkTrailingBitmask[i_begin % 8];

        const(ubyte) only_byte_mask = i_end % 8 == 0 ? last_byte_mask : cast(
            ubyte)(first_byte_mask & last_byte_mask);

        const(ubyte) byte_masked = bits[bytes_begin] & only_byte_mask;
        return _ArrowkBytePopcount[byte_masked];
    }

    const(ubyte) first_byte_mask = _ArrowkPrecedingBitmask[i_begin % 8];
    const(ubyte) last_byte_mask = i_end % 8 == 0 ? 0 : _ArrowkTrailingBitmask[i_end % 8];
    long count = 0;

    // first byte
    count += _ArrowkBytePopcount[bits[bytes_begin] & ~first_byte_mask];

    // middle bytes
    for (long i = bytes_begin + 1; i < bytes_last_valid; i++)
    {
        count += _ArrowkBytePopcount[bits[i]];
    }

    // last byte
    count += _ArrowkBytePopcount[bits[bytes_last_valid] & ~last_byte_mask];

    return count;
}

pragma(inline, true) void ArrowBitmapInit(ArrowBitmap* bitmap)
{
    ArrowBufferInit(&bitmap.buffer);
    bitmap.size_bits = 0;
}

pragma(inline, true) void ArrowBitmapMove(ArrowBitmap* src, ArrowBitmap* dst)
{
    ArrowBufferMove(&src.buffer, &dst.buffer);
    dst.size_bits = src.size_bits;
    src.size_bits = 0;
}

pragma(inline, true) ArrowErrorCode ArrowBitmapReserve(ArrowBitmap* bitmap, long additional_size_bits)
{
    long min_capacity_bits = bitmap.size_bits + additional_size_bits;
    long min_capacity_bytes = _ArrowBytesForBits(min_capacity_bits);
    long current_size_bytes = bitmap.buffer.size_bytes;
    long current_capacity_bytes = bitmap.buffer.capacity_bytes;

    if (min_capacity_bytes <= current_capacity_bytes)
    {
        return NANOARROW_OK;
    }

    long additional_capacity_bytes = min_capacity_bytes - current_size_bytes;
    auto s = returnNotOk(ArrowBufferReserve(&bitmap.buffer, additional_capacity_bytes));
    if (s != NANOARROW_OK)
        return s;

    // Zero out the last byte for deterministic output in the common case
    // of reserving a known remaining size. We should have returned above
    // if there was not at least one additional byte to allocate; however,
    // DCHECK() just to be sure.
    assert(bitmap.buffer.capacity_bytes > current_capacity_bytes);
    bitmap.buffer.data[bitmap.buffer.capacity_bytes - 1] = 0;
    return NANOARROW_OK;
}

pragma(inline, true) ArrowErrorCode ArrowBitmapResize(ArrowBitmap* bitmap, long new_size_bits, char shrink_to_fit)
{
    if (new_size_bits < 0)
    {
        return nanoarrow.EINVAL;
    }

    long new_size_bytes = _ArrowBytesForBits(new_size_bits);
    auto s = returnNotOk(
        ArrowBufferResize(&bitmap.buffer, new_size_bytes, shrink_to_fit));
    if (s != NANOARROW_OK)
        return s;

    bitmap.size_bits = new_size_bits;
    return NANOARROW_OK;
}

pragma(inline, true) ArrowErrorCode ArrowBitmapAppend(ArrowBitmap* bitmap, ubyte bits_are_set, long length)
{
    auto s = returnNotOk(ArrowBitmapReserve(bitmap, length));
    if (s != NANOARROW_OK)
        return s;

    ArrowBitmapAppendUnsafe(bitmap, bits_are_set, length);
    return NANOARROW_OK;
}

pragma(inline, true) void ArrowBitmapAppendUnsafe(ArrowBitmap* bitmap, ubyte bits_are_set, long length)
{
    ArrowBitsSetTo(bitmap.buffer.data, bitmap.size_bits, length, bits_are_set);
    bitmap.size_bits += length;
    bitmap.buffer.size_bytes = _ArrowBytesForBits(bitmap.size_bits);
}

pragma(inline, true) void ArrowBitmapAppendInt8Unsafe(ArrowBitmap* bitmap, const(byte)* values, long n_values)
{
    if (n_values == 0)
    {
        return;
    }

    assert(bitmap.buffer.data != null);
    assert(values != null);

    const(byte)* values_cursor = values;
    long n_remaining = n_values;
    long out_i_cursor = bitmap.size_bits;
    ubyte* out_cursor = bitmap.buffer.data + bitmap.size_bits / 8;

    // First byte
    if ((out_i_cursor % 8) != 0)
    {
        long n_partial_bits = _ArrowRoundUpToMultipleOf8(out_i_cursor) - out_i_cursor;
        for (int i = 0; i < n_partial_bits; i++)
        {
            ArrowBitSetTo(bitmap.buffer.data, out_i_cursor++, values[i]);
        }

        out_cursor++;
        values_cursor += n_partial_bits;
        n_remaining -= n_partial_bits;
    }

    // Middle bytes
    long n_full_bytes = n_remaining / 8;
    for (long i = 0; i < n_full_bytes; i++)
    {
        _ArrowBitmapPackInt8(values_cursor, out_cursor);
        values_cursor += 8;
        out_cursor++;
    }

    // Last byte
    out_i_cursor += n_full_bytes * 8;
    n_remaining -= n_full_bytes * 8;
    if (n_remaining > 0)
    {
        // Zero out the last byte
        *out_cursor = 0x00;
        for (int i = 0; i < n_remaining; i++)
        {
            ArrowBitSetTo(bitmap.buffer.data, out_i_cursor++, values_cursor[i]);
        }
        out_cursor++;
    }

    bitmap.size_bits += n_values;
    bitmap.buffer.size_bytes = out_cursor - bitmap.buffer.data;
}

pragma(inline, true) void ArrowBitmapAppendInt32Unsafe(ArrowBitmap* bitmap, const(int)* values, long n_values)
{
    if (n_values == 0)
    {
        return;
    }

    assert(bitmap.buffer.data != null);
    assert(values != null);

    const(int)* values_cursor = values;
    long n_remaining = n_values;
    long out_i_cursor = bitmap.size_bits;
    ubyte* out_cursor = bitmap.buffer.data + bitmap.size_bits / 8;

    // First byte
    if ((out_i_cursor % 8) != 0)
    {
        long n_partial_bits = _ArrowRoundUpToMultipleOf8(out_i_cursor) - out_i_cursor;
        for (int i = 0; i < n_partial_bits; i++)
        {
            ArrowBitSetTo(bitmap.buffer.data, out_i_cursor++, cast(ubyte) values[i]);
        }

        out_cursor++;
        values_cursor += n_partial_bits;
        n_remaining -= n_partial_bits;
    }

    // Middle bytes
    long n_full_bytes = n_remaining / 8;
    for (long i = 0; i < n_full_bytes; i++)
    {
        _ArrowBitmapPackInt32(values_cursor, out_cursor);
        values_cursor += 8;
        out_cursor++;
    }

    // Last byte
    out_i_cursor += n_full_bytes * 8;
    n_remaining -= n_full_bytes * 8;
    if (n_remaining > 0)
    {
        // Zero out the last byte
        *out_cursor = 0x00;
        for (int i = 0; i < n_remaining; i++)
        {
            ArrowBitSetTo(bitmap.buffer.data, out_i_cursor++, cast(ubyte) values_cursor[i]);
        }
        out_cursor++;
    }

    bitmap.size_bits += n_values;
    bitmap.buffer.size_bytes = out_cursor - bitmap.buffer.data;
}

pragma(inline, true) void ArrowBitmapReset(ArrowBitmap* bitmap)
{
    ArrowBufferReset(&bitmap.buffer);
    bitmap.size_bits = 0;
}

pragma(inline, true) ArrowBitmap* ArrowArrayValidityBitmap(ArrowArray* array)
{
    ArrowArrayPrivateData* private_data = cast(ArrowArrayPrivateData*) array.private_data;
    return &private_data.bitmap;
}

pragma(inline, true) ArrowBuffer* ArrowArrayBuffer(ArrowArray* array, long i)
{
    ArrowArrayPrivateData* private_data = cast(ArrowArrayPrivateData*) array.private_data;
    switch (i)
    {
    case 0:
        return &private_data.bitmap.buffer;
    default:
        return private_data.buffers.ptr + i - 1;
    }
}

pragma(inline, true) byte _ArrowArrayUnionChildIndex(ArrowArray* array, byte type_id)
{
    NANOARROW_UNUSED(array);
    return type_id;
}

pragma(inline, true) byte _ArrowArrayUnionTypeId(ArrowArray* array, byte child_index)
{
    NANOARROW_UNUSED(array);
    return child_index;
}

pragma(inline, true) int _ArrowParseUnionTypeIds(const(char)* type_ids, byte* out_)
{
    if (*type_ids == '\0')
    {
        return 0;
    }

    int i = 0;
    c_long type_id = void;
    char* end_ptr = void;
    do
    {
        type_id = strtol(type_ids, &end_ptr, 10);
        if (end_ptr == type_ids || type_id < 0 || type_id > 127)
        {
            return -1;
        }

        if (out_ != null)
        {
            out_[i] = cast(byte) type_id;
        }

        i++;

        type_ids = end_ptr;
        if (*type_ids == '\0')
        {
            return i;
        }
        else if (*type_ids != ',')
        {
            return -1;
        }
        else
        {
            type_ids++;
        }
    }
    while (1);

    return -1;
}

pragma(inline, true) byte _ArrowParsedUnionTypeIdsWillEqualChildIndices(
    const(byte)* type_ids, long n_type_ids, long n_children)
{
    if (n_type_ids != n_children)
    {
        return 0;
    }

    for (byte i = 0; i < n_type_ids; i++)
    {
        if (type_ids[i] != i)
        {
            return 0;
        }
    }

    return 1;
}

pragma(inline, true) byte _ArrowUnionTypeIdsWillEqualChildIndices(
    const(char)* type_id_str, long n_children)
{
    byte[128] type_ids = void;
    int n_type_ids = _ArrowParseUnionTypeIds(type_id_str, type_ids.ptr);
    return _ArrowParsedUnionTypeIdsWillEqualChildIndices(type_ids.ptr, n_type_ids, n_children);
}

pragma(inline, true) ArrowErrorCode ArrowArrayStartAppending(ArrowArray* array)
{
    ArrowArrayPrivateData* private_data = cast(ArrowArrayPrivateData*) array.private_data;

    switch (private_data.storage_type)
    {
    case NANOARROW_TYPE_UNINITIALIZED:
        return nanoarrow.EINVAL;
    case NANOARROW_TYPE_SPARSE_UNION:
    case NANOARROW_TYPE_DENSE_UNION: // Note that this value could be -1 if the type_ids string was invalid
        if (private_data.union_type_id_is_child_index != 1)
        {
            return nanoarrow.EINVAL;
        }
        else
        {
            break;
        }
    default:
        break;
    }
    if (private_data.storage_type == NANOARROW_TYPE_UNINITIALIZED)
    {
        return nanoarrow.EINVAL;
    }

    // Initialize any data offset buffer with a single zero
    for (int i = 0; i < NANOARROW_MAX_FIXED_BUFFERS; i++)
    {
        if (private_data.layout.buffer_type[i] == NANOARROW_BUFFER_TYPE_DATA_OFFSET &&
            private_data.layout.element_size_bits[i] == 64)
        {
            auto s = returnNotOk(ArrowBufferAppendInt64(ArrowArrayBuffer(array, i), 0));
            if (s != NANOARROW_OK)
                return s;
        }
        else if (private_data.layout.buffer_type[i] == NANOARROW_BUFFER_TYPE_DATA_OFFSET &&
            private_data.layout.element_size_bits[i] == 32)
        {
            auto s = returnNotOk(ArrowBufferAppendInt32(ArrowArrayBuffer(array, i), 0));
            if (s != NANOARROW_OK)
                return s;
        }
    }

    // Start building any child arrays or dictionaries
    for (long i = 0; i < array.n_children; i++)
    {
        auto s = returnNotOk(ArrowArrayStartAppending(array.children[i]));
        if (s != NANOARROW_OK)
            return s;
    }

    if (array.dictionary != null)
    {
        auto s = returnNotOk(ArrowArrayStartAppending(array.dictionary));
        if (s != NANOARROW_OK)
            return s;
    }

    return NANOARROW_OK;
}

pragma(inline, true) ArrowErrorCode ArrowArrayShrinkToFit(ArrowArray* array)
{
    for (long i = 0; i < NANOARROW_MAX_FIXED_BUFFERS; i++)
    {
        ArrowBuffer* buffer = ArrowArrayBuffer(array, i);
        auto s = returnNotOk(ArrowBufferResize(buffer, buffer.size_bytes, 1));
        if (s != NANOARROW_OK)
            return s;
    }

    for (long i = 0; i < array.n_children; i++)
    {
        auto s = returnNotOk(ArrowArrayShrinkToFit(array.children[i]));
        if (s != NANOARROW_OK)
            return s;
    }

    if (array.dictionary != null)
    {
        auto s = returnNotOk(ArrowArrayShrinkToFit(array.dictionary));
        if (s != NANOARROW_OK)
            return s;
    }

    return NANOARROW_OK;
}

pragma(inline, true) ArrowErrorCode _ArrowArrayAppendBits(
    ArrowArray* array, long buffer_i, ubyte value, long n)
{
    ArrowArrayPrivateData* private_data = cast(ArrowArrayPrivateData*) array.private_data;
    ArrowBuffer* buffer = ArrowArrayBuffer(array, buffer_i);
    long bytes_required = _ArrowRoundUpToMultipleOf8(
        private_data.layout.element_size_bits[buffer_i] *
            (array.length + 1)) /
        8;
    if (bytes_required > buffer.size_bytes)
    {
        auto s = returnNotOk(
            ArrowBufferAppendFill(buffer, 0, bytes_required - buffer.size_bytes));
        if (s != NANOARROW_OK)
            return s;
    }

    ArrowBitsSetTo(buffer.data, array.length, n, value);
    return NANOARROW_OK;
}

pragma(inline, true) ArrowErrorCode _ArrowArrayAppendEmptyInternal(
    ArrowArray* array, long n, ubyte is_valid)
{
    ArrowArrayPrivateData* private_data = cast(ArrowArrayPrivateData*) array.private_data;

    if (n == 0)
    {
        return NANOARROW_OK;
    }

    // Some type-specific handling
    switch (private_data.storage_type)
    {
    case NANOARROW_TYPE_NA: // (An empty value for a null array *is* a null)
        array.null_count += n;
        array.length += n;
        return NANOARROW_OK;

    case NANOARROW_TYPE_DENSE_UNION:
        {
            // Add one null to the first child and append n references to that child
            byte type_id = _ArrowArrayUnionTypeId(array, 0);
            auto s = returnNotOk(
                _ArrowArrayAppendEmptyInternal(array.children[0], 1, is_valid));
            if (s != NANOARROW_OK)
                return s;
            s = returnNotOk(
                ArrowBufferAppendFill(ArrowArrayBuffer(array, 0), type_id, n));
            if (s != NANOARROW_OK)
                return s;
            for (long i = 0; i < n; i++)
            {
                s = returnNotOk(ArrowBufferAppendInt32(
                        ArrowArrayBuffer(array, 1), cast(int) array.children[0].length - 1));
                if (s != NANOARROW_OK)
                    return s;
            }
            // For the purposes of array->null_count, union elements are never considered "null"
            // even if some children contain nulls.
            array.length += n;
            return NANOARROW_OK;
        }

    case NANOARROW_TYPE_SPARSE_UNION:
        {
            // Add n nulls to the first child and append n references to that child
            byte type_id = _ArrowArrayUnionTypeId(array, 0);
            auto s = returnNotOk(
                _ArrowArrayAppendEmptyInternal(array.children[0], n, is_valid));
            if (s != NANOARROW_OK)
                return s;
            for (long i = 1; i < array.n_children; i++)
            {
                s = returnNotOk(ArrowArrayAppendEmpty(array.children[i], n));
                if (s != NANOARROW_OK)
                    return s;
            }

            s = returnNotOk(
                ArrowBufferAppendFill(ArrowArrayBuffer(array, 0), type_id, n));
            if (s != NANOARROW_OK)
                return s;
            // For the purposes of array->null_count, union elements are never considered "null"
            // even if some children contain nulls.
            array.length += n;
            return NANOARROW_OK;
        }

    case NANOARROW_TYPE_FIXED_SIZE_LIST:
        auto s = returnNotOk(ArrowArrayAppendEmpty(
                array.children[0], n * private_data.layout.child_size_elements));
        if (s != NANOARROW_OK)
            return s;
        break;
    case NANOARROW_TYPE_STRUCT:
        for (long i = 0; i < array.n_children; i++)
        {
            auto s = returnNotOk(ArrowArrayAppendEmpty(array.children[i], n));
            if (s != NANOARROW_OK)
                return s;
        }
        break;

    default:
        break;
    }

    // Append n is_valid bits to the validity bitmap. If we haven't allocated a bitmap yet
    // and we need to append nulls, do it now.
    if (!is_valid && private_data.bitmap.buffer.data == null)
    {
        auto s = returnNotOk(ArrowBitmapReserve(&private_data.bitmap, array.length + n));
        if (s != NANOARROW_OK)
            return s;
        ArrowBitmapAppendUnsafe(&private_data.bitmap, 1, array.length);
        ArrowBitmapAppendUnsafe(&private_data.bitmap, is_valid, n);
    }
    else if (private_data.bitmap.buffer.data != null)
    {
        auto s = returnNotOk(ArrowBitmapReserve(&private_data.bitmap, n));
        if (s != NANOARROW_OK)
            return s;
        ArrowBitmapAppendUnsafe(&private_data.bitmap, is_valid, n);
    }

    // Add appropriate buffer fill
    ArrowBuffer* buffer = void;
    long size_bytes = void;

    for (int i = 0; i < NANOARROW_MAX_FIXED_BUFFERS; i++)
    {
        buffer = ArrowArrayBuffer(array, i);
        size_bytes = private_data.layout.element_size_bits[i] / 8;

        switch (private_data.layout.buffer_type[i])
        {
        case NANOARROW_BUFFER_TYPE_NONE:
        case NANOARROW_BUFFER_TYPE_VARIADIC_DATA:
        case NANOARROW_BUFFER_TYPE_VARIADIC_SIZE:
        case NANOARROW_BUFFER_TYPE_VALIDITY:
            continue;
        case NANOARROW_BUFFER_TYPE_SIZE:
            auto s = returnNotOk(ArrowBufferAppendFill(buffer, 0, size_bytes * n));
            if (s != NANOARROW_OK)
                return s;
            continue;
        case NANOARROW_BUFFER_TYPE_DATA_OFFSET: // Append the current value at the end of the offset buffer for each element
            auto s = returnNotOk(ArrowBufferReserve(buffer, size_bytes * n));
            if (s != NANOARROW_OK)
                return s;

            for (long j = 0; j < n; j++)
            {
                ArrowBufferAppendUnsafe(buffer, buffer.data + size_bytes * (array.length + j),
                    size_bytes);
            }

            // Skip the data buffer
            i++;
            continue;
        case NANOARROW_BUFFER_TYPE_DATA: // Zero out the next bit of memory
            if (private_data.layout.element_size_bits[i] % 8 == 0)
            {
                auto s = returnNotOk(ArrowBufferAppendFill(buffer, 0, size_bytes * n));
                if (s != NANOARROW_OK)
                    return s;
            }
            else
            {
                auto s = returnNotOk(_ArrowArrayAppendBits(array, i, 0, n));
                if (s != NANOARROW_OK)
                    return s;
            }
            continue;
        case NANOARROW_BUFFER_TYPE_VIEW_OFFSET:
            auto s = returnNotOk(ArrowBufferReserve(buffer, size_bytes * n));
            if (s != NANOARROW_OK)
                return s;
            s = returnNotOk(ArrowBufferAppendFill(buffer, 0, size_bytes * n));
            if (s != NANOARROW_OK)
                return s;
            continue;
        case NANOARROW_BUFFER_TYPE_TYPE_ID:
        case NANOARROW_BUFFER_TYPE_UNION_OFFSET: // These cases return above
            return nanoarrow.EINVAL;
        default:
            break;
        }
    }

    array.length += n;
    array.null_count += n * !is_valid;
    return NANOARROW_OK;
}

pragma(inline, true) ArrowErrorCode ArrowArrayAppendNull(ArrowArray* array, long n)
{
    return _ArrowArrayAppendEmptyInternal(array, n, 0);
}

pragma(inline, true) ArrowErrorCode ArrowArrayAppendEmpty(ArrowArray* array, long n)
{
    return _ArrowArrayAppendEmptyInternal(array, n, 1);
}

pragma(inline, true) ArrowErrorCode ArrowArrayAppendInt(ArrowArray* array, long value)
{
    ArrowArrayPrivateData* private_data = cast(ArrowArrayPrivateData*) array.private_data;

    ArrowBuffer* data_buffer = ArrowArrayBuffer(array, 1);

    switch (private_data.storage_type)
    {
    case NANOARROW_TYPE_INT64:
        auto s = returnNotOk(ArrowBufferAppend(data_buffer, &value, long
                .sizeof));
        if (s != NANOARROW_OK)
            return s;
        break;
    case NANOARROW_TYPE_INT32:
        auto s = returnNotOk(ArrowBufferAppendInt32(data_buffer, cast(int) value));
        if (s != NANOARROW_OK)
            return s;
        break;
    case NANOARROW_TYPE_INT16:
        auto s = returnNotOk(ArrowBufferAppendInt16(data_buffer, cast(short) value));
        if (s != NANOARROW_OK)
            return s;
        break;
    case NANOARROW_TYPE_INT8:
        auto s = returnNotOk(ArrowBufferAppendInt8(data_buffer, cast(byte) value));
        if (s != NANOARROW_OK)
            return s;
        break;
    case NANOARROW_TYPE_UINT64:
    case NANOARROW_TYPE_UINT32:
    case NANOARROW_TYPE_UINT16:
    case NANOARROW_TYPE_UINT8:
        return ArrowArrayAppendUInt(array, value);
    case NANOARROW_TYPE_DOUBLE:
        auto s = returnNotOk(ArrowBufferAppendDouble(data_buffer, cast(
                double) value));
        if (s != NANOARROW_OK)
            return s;
        break;
    case NANOARROW_TYPE_FLOAT:
        auto s = returnNotOk(ArrowBufferAppendFloat(data_buffer, cast(
                float) value));
        if (s != NANOARROW_OK)
            return s;
        break;
    case NANOARROW_TYPE_HALF_FLOAT:
        auto s = returnNotOk(
            ArrowBufferAppendUInt16(data_buffer, ArrowFloatToHalfFloat(cast(float) value)));
        if (s != NANOARROW_OK)
            return s;
        break;
    case NANOARROW_TYPE_BOOL:
        auto s = returnNotOk(_ArrowArrayAppendBits(array, 1, value != 0, 1));
        if (s != NANOARROW_OK)
            return s;
        break;
    default:
        return nanoarrow.EINVAL;
    }

    if (private_data.bitmap.buffer.data != null)
    {
        auto s = returnNotOk(ArrowBitmapAppend(ArrowArrayValidityBitmap(array), 1, 1));
        if (s != NANOARROW_OK)
            return s;
    }

    array.length++;
    return NANOARROW_OK;
}

pragma(inline, true) ArrowErrorCode ArrowArrayAppendUInt(ArrowArray* array, ulong value)
{
    ArrowArrayPrivateData* private_data = cast(ArrowArrayPrivateData*) array.private_data;

    ArrowBuffer* data_buffer = ArrowArrayBuffer(array, 1);

    switch (private_data.storage_type)
    {
    case NANOARROW_TYPE_UINT64:
        auto s = returnNotOk(ArrowBufferAppend(data_buffer, &value, ulong
                .sizeof));
        if (s != NANOARROW_OK)
            return s;
        break;
    case NANOARROW_TYPE_UINT32:
        auto s = returnNotOk(ArrowBufferAppendUInt32(data_buffer, cast(uint) value));
        if (s != NANOARROW_OK)
            return s;
        break;
    case NANOARROW_TYPE_UINT16:
        auto s = returnNotOk(ArrowBufferAppendUInt16(data_buffer, cast(ushort) value));
        if (s != NANOARROW_OK)
            return s;
        break;
    case NANOARROW_TYPE_UINT8:
        auto s = returnNotOk(ArrowBufferAppendUInt8(data_buffer, cast(ubyte) value));
        if (s != NANOARROW_OK)
            return s;
        break;
    case NANOARROW_TYPE_INT64:
    case NANOARROW_TYPE_INT32:
    case NANOARROW_TYPE_INT16:
    case NANOARROW_TYPE_INT8:
        return ArrowArrayAppendInt(array, value);
    case NANOARROW_TYPE_DOUBLE:
        auto s = returnNotOk(ArrowBufferAppendDouble(data_buffer, cast(
                double) value));
        if (s != NANOARROW_OK)
            return s;
        break;
    case NANOARROW_TYPE_FLOAT:
        auto s = returnNotOk(ArrowBufferAppendFloat(data_buffer, cast(
                float) value));
        if (s != NANOARROW_OK)
            return s;
        break;
    case NANOARROW_TYPE_HALF_FLOAT:
        auto s = returnNotOk(
            ArrowBufferAppendUInt16(data_buffer, ArrowFloatToHalfFloat(cast(float) value)));
        if (s != NANOARROW_OK)
            return s;
        break;
    case NANOARROW_TYPE_BOOL:
        auto s = returnNotOk(_ArrowArrayAppendBits(array, 1, value != 0, 1));
        if (s != NANOARROW_OK)
            return s;
        break;
    default:
        return nanoarrow.EINVAL;
    }

    if (private_data.bitmap.buffer.data != null)
    {
        auto s = returnNotOk(ArrowBitmapAppend(ArrowArrayValidityBitmap(array), 1, 1));
        if (s != NANOARROW_OK)
            return s;
    }

    array.length++;
    return NANOARROW_OK;
}

pragma(inline, true) ArrowErrorCode ArrowArrayAppendDouble(
    ArrowArray* array, double value)
{
    ArrowArrayPrivateData* private_data = cast(ArrowArrayPrivateData*) array.private_data;

    ArrowBuffer* data_buffer = ArrowArrayBuffer(array, 1);

    switch (private_data.storage_type)
    {
    case NANOARROW_TYPE_DOUBLE:
        auto s = returnNotOk(ArrowBufferAppend(data_buffer, &value, double
                .sizeof));
        if (s != NANOARROW_OK)
            return s;
        break;
    case NANOARROW_TYPE_FLOAT:
        auto s = returnNotOk(ArrowBufferAppendFloat(data_buffer, cast(
                float) value));
        if (s != NANOARROW_OK)
            return s;
        break;
    case NANOARROW_TYPE_HALF_FLOAT:
        auto s = returnNotOk(
            ArrowBufferAppendUInt16(data_buffer, ArrowFloatToHalfFloat(cast(float) value)));
        if (s != NANOARROW_OK)
            return s;
        break;
    default:
        return nanoarrow.EINVAL;
    }

    if (private_data.bitmap.buffer.data != null)
    {
        auto s = returnNotOk(ArrowBitmapAppend(ArrowArrayValidityBitmap(array), 1, 1));
        if (s != NANOARROW_OK)
            return s;
    }

    array.length++;
    return NANOARROW_OK;
}

pragma(inline, true) int ArrowArrayVariadicBufferCount(ArrowArray* array)
{
    ArrowArrayPrivateData* private_data = cast(ArrowArrayPrivateData*) array.private_data;

    return private_data.n_variadic_buffers;
}

pragma(inline, true) ArrowErrorCode ArrowArrayAddVariadicBuffers(
    ArrowArray* array, int nbuffers)
{
    const(int) n_current_bufs = ArrowArrayVariadicBufferCount(array);
    const(int) nvariadic_bufs_needed = n_current_bufs + nbuffers;

    ArrowArrayPrivateData* private_data = cast(ArrowArrayPrivateData*) array.private_data;

    private_data.variadic_buffers = cast(ArrowBuffer*) ArrowRealloc(
        private_data.variadic_buffers, ArrowBuffer.sizeof * nvariadic_bufs_needed);
    if (private_data.variadic_buffers == null)
    {
        return nanoarrow.ENOMEM;
    }
    private_data.variadic_buffer_sizes = cast(long*) ArrowRealloc(
        private_data.variadic_buffer_sizes, long.sizeof * nvariadic_bufs_needed);
    if (private_data.variadic_buffer_sizes == null)
    {
        return nanoarrow.ENOMEM;
    }

    for (int i = n_current_bufs; i < nvariadic_bufs_needed; i++)
    {
        ArrowBufferInit(&private_data.variadic_buffers[i]);
        private_data.variadic_buffer_sizes[i] = 0;
    }
    private_data.n_variadic_buffers = nvariadic_bufs_needed;
    array.n_buffers = NANOARROW_BINARY_VIEW_FIXED_BUFFERS + 1 + nvariadic_bufs_needed;

    return NANOARROW_OK;
}

pragma(inline, true) ArrowErrorCode ArrowArrayAppendString(
    ArrowArray* array, ArrowStringView value)
{
    ArrowArrayPrivateData* private_data = cast(ArrowArrayPrivateData*) array.private_data;

    ArrowBufferView buffer_view = void;
    buffer_view.data.data = value.data;
    buffer_view.size_bytes = value.size_bytes;

    switch (private_data.storage_type)
    {
    case NANOARROW_TYPE_STRING:
    case NANOARROW_TYPE_LARGE_STRING:
    case NANOARROW_TYPE_STRING_VIEW:
    case NANOARROW_TYPE_BINARY:
    case NANOARROW_TYPE_LARGE_BINARY:
    case NANOARROW_TYPE_BINARY_VIEW:
        return ArrowArrayAppendBytes(array, buffer_view);
    default:
        return nanoarrow.EINVAL;
    }
}

pragma(inline, true) ArrowErrorCode ArrowArrayAppendInterval(
    ArrowArray* array, const(ArrowInterval)* value)
{
    ArrowArrayPrivateData* private_data = cast(ArrowArrayPrivateData*) array.private_data;

    ArrowBuffer* data_buffer = ArrowArrayBuffer(array, 1);

    switch (private_data.storage_type)
    {
    case NANOARROW_TYPE_INTERVAL_MONTHS:
        {
            if (value.type != NANOARROW_TYPE_INTERVAL_MONTHS)
            {
                return nanoarrow.EINVAL;
            }

            auto s = returnNotOk(ArrowBufferAppendInt32(data_buffer, value.months));
            if (s != NANOARROW_OK)
                return s;
            break;
        }
    case NANOARROW_TYPE_INTERVAL_DAY_TIME:
        {
            if (value.type != NANOARROW_TYPE_INTERVAL_DAY_TIME)
            {
                return nanoarrow.EINVAL;
            }

            auto s = returnNotOk(ArrowBufferAppendInt32(data_buffer, value.days));
            if (s != NANOARROW_OK)
                return s;
            s = returnNotOk(ArrowBufferAppendInt32(data_buffer, value.ms));
            if (s != NANOARROW_OK)
                return s;
            break;
        }
    case NANOARROW_TYPE_INTERVAL_MONTH_DAY_NANO:
        {
            if (value.type != NANOARROW_TYPE_INTERVAL_MONTH_DAY_NANO)
            {
                return nanoarrow.EINVAL;
            }

            auto s = returnNotOk(ArrowBufferAppendInt32(data_buffer, value.months));
            if (s != NANOARROW_OK)
                return s;
            s = returnNotOk(ArrowBufferAppendInt32(data_buffer, value.days));
            if (s != NANOARROW_OK)
                return s;
            s = returnNotOk(ArrowBufferAppendInt64(data_buffer, value.ns));
            if (s != NANOARROW_OK)
                return s;
            break;
        }
    default:
        return nanoarrow.EINVAL;
    }

    if (private_data.bitmap.buffer.data != null)
    {
        auto s = returnNotOk(ArrowBitmapAppend(ArrowArrayValidityBitmap(array), 1, 1));
        if (s != NANOARROW_OK)
            return s;
    }

    array.length++;
    return NANOARROW_OK;
}

pragma(inline, true) ArrowErrorCode ArrowArrayAppendDecimal(
    ArrowArray* array, const(ArrowDecimal)* value)
{
    ArrowArrayPrivateData* private_data = cast(ArrowArrayPrivateData*) array.private_data;
    ArrowBuffer* data_buffer = ArrowArrayBuffer(array, 1);

    switch (private_data.storage_type)
    {
    case NANOARROW_TYPE_DECIMAL32:
        if (value.n_words != 0)
        {
            return nanoarrow.EINVAL;
        }
        else
        {
            auto s = returnNotOk(
                ArrowBufferAppend(data_buffer, cast(void*) value.words, uint.sizeof));
            if (s != NANOARROW_OK)
                return s;
            break;
        }
    case NANOARROW_TYPE_DECIMAL64:
        if (value.n_words != 1)
        {
            return nanoarrow.EINVAL;
        }
        else
        {
            auto s = returnNotOk(
                ArrowBufferAppend(data_buffer, cast(void*) value.words, ulong.sizeof));
            if (s != NANOARROW_OK)
                return s;
            break;
        }
    case NANOARROW_TYPE_DECIMAL128:
        if (value.n_words != 2)
        {
            return nanoarrow.EINVAL;
        }
        else
        {
            auto s = returnNotOk(
                ArrowBufferAppend(data_buffer, cast(void*) value.words, 2 * ulong.sizeof));
            if (s != NANOARROW_OK)
                return s;
            break;
        }
    case NANOARROW_TYPE_DECIMAL256:
        if (value.n_words != 4)
        {
            return nanoarrow.EINVAL;
        }
        else
        {
            auto s = returnNotOk(
                ArrowBufferAppend(data_buffer, cast(void*) value.words, 4 * ulong.sizeof));
            if (s != NANOARROW_OK)
                return s;
            break;
        }
    default:
        return nanoarrow.EINVAL;
    }

    if (private_data.bitmap.buffer.data != null)
    {
        auto s = returnNotOk(ArrowBitmapAppend(ArrowArrayValidityBitmap(array), 1, 1));
        if (s != NANOARROW_OK)
            return s;
    }

    array.length++;
    return NANOARROW_OK;
}

pragma(inline, true) ArrowErrorCode ArrowArrayFinishElement(ArrowArray* array)
{
    ArrowArrayPrivateData* private_data = cast(ArrowArrayPrivateData*) array.private_data;

    long child_length = void;

    switch (private_data.storage_type)
    {
    case NANOARROW_TYPE_LIST:
    case NANOARROW_TYPE_MAP:
        child_length = array
            .children[0].length;
        if (child_length > int.max)
        {
            return nanoarrow.EOVERFLOW;
        }

        auto s = returnNotOk(
            ArrowBufferAppendInt32(ArrowArrayBuffer(array, 1), cast(int) child_length));
        if (s != NANOARROW_OK)
            return s;
        break;
    case NANOARROW_TYPE_LARGE_LIST:
        child_length = array.children[0].length;
        auto s = returnNotOk(
            ArrowBufferAppendInt64(ArrowArrayBuffer(array, 1), child_length));
        if (s != NANOARROW_OK)
            return s;
        break;
    case NANOARROW_TYPE_FIXED_SIZE_LIST:
        child_length = array.children[0].length;
        if (child_length !=
            ((array.length + 1) * private_data.layout.child_size_elements))
        {
            return nanoarrow.EINVAL;
        }
        break;
    case NANOARROW_TYPE_LIST_VIEW:
        {
            child_length = array.children[0].length;
            if (child_length > int.max)
            {
                return nanoarrow.EOVERFLOW;
            }

            const(int) last_valid_offset = cast(int) private_data.list_view_offset;
            auto s = returnNotOk(
                ArrowBufferAppendInt32(ArrowArrayBuffer(array, 1), last_valid_offset));
            if (s != NANOARROW_OK)
                return s;
            s = returnNotOk(ArrowBufferAppendInt32(
                    ArrowArrayBuffer(array, 2), cast(int) child_length - last_valid_offset));
            if (s != NANOARROW_OK)
                return s;
            private_data.list_view_offset = child_length;
            break;
        }
    case NANOARROW_TYPE_LARGE_LIST_VIEW:
        {
            child_length = array.children[0].length;
            const(long) last_valid_offset = private_data.list_view_offset;
            auto s = returnNotOk(
                ArrowBufferAppendInt64(ArrowArrayBuffer(array, 1), last_valid_offset));
            if (s != NANOARROW_OK)
                return s;
            s = returnNotOk(ArrowBufferAppendInt64(ArrowArrayBuffer(array, 2),
                    child_length - last_valid_offset));
            if (s != NANOARROW_OK)
                return s;
            private_data.list_view_offset = child_length;
            break;
        }

    case NANOARROW_TYPE_STRUCT:
        for (long i = 0; i < array.n_children; i++)
        {
            child_length = array.children[i].length;
            if (child_length != (array.length + 1))
            {
                return nanoarrow.EINVAL;
            }
        }
        break;
    default:
        return nanoarrow.EINVAL;
    }

    if (private_data.bitmap.buffer.data != null)
    {
        auto s = returnNotOk(ArrowBitmapAppend(ArrowArrayValidityBitmap(array), 1, 1));
        if (s != NANOARROW_OK)
            return s;
    }

    array.length++;
    return NANOARROW_OK;
}

pragma(inline, true) ArrowErrorCode ArrowArrayFinishUnionElement(
    ArrowArray* array, byte type_id)
{
    ArrowArrayPrivateData* private_data = cast(ArrowArrayPrivateData*) array.private_data;

    long child_index = _ArrowArrayUnionChildIndex(array, type_id);
    if (child_index < 0 || child_index >= array.n_children)
    {
        return nanoarrow.EINVAL;
    }

    switch (private_data.storage_type)
    {
    case NANOARROW_TYPE_DENSE_UNION: // Append the target child length to the union offsets buffer
        auto s = returnNotOk(ArrowBufferAppendInt32(
                ArrowArrayBuffer(array, 1), cast(int) array.children[child_index].length - 1));
        if (s != NANOARROW_OK)
            return s;
        break;
    case NANOARROW_TYPE_SPARSE_UNION: // Append one empty to any non-target column that isn't already the right length
        // or abort if appending a null will result in a column with invalid length
        for (long i = 0; i < array.n_children; i++)
        {
            if (i == child_index || array.children[i].length == (array.length + 1))
            {
                continue;
            }

            if (array.children[i].length != array.length)
            {
                return nanoarrow.EINVAL;
            }

            auto s = returnNotOk(ArrowArrayAppendEmpty(array.children[i], 1));
            if (s != NANOARROW_OK)
                return s;
        }

        break;
    default:
        return nanoarrow.EINVAL;
    }

    // Write to the type_ids buffer
    auto s = returnNotOk(
        ArrowBufferAppendInt8(ArrowArrayBuffer(array, 0), cast(byte) type_id));
    if (s != NANOARROW_OK)
        return s;
    array.length++;
    return NANOARROW_OK;
}

pragma(inline, true) void ArrowArrayViewMove(ArrowArrayView* src, ArrowArrayView* dst)
{
    memcpy(dst, src, ArrowArrayView.sizeof);
    ArrowArrayViewInitFromType(src, NANOARROW_TYPE_UNINITIALIZED);
}

pragma(inline, true) long ArrowArrayViewGetNumBuffers(ArrowArrayView* array_view)
{
    switch (array_view.storage_type)
    {
    case NANOARROW_TYPE_BINARY_VIEW:
    case NANOARROW_TYPE_STRING_VIEW:
        return NANOARROW_BINARY_VIEW_FIXED_BUFFERS + array_view.n_variadic_buffers + 1;
    default:
        break;
    }

    long n_buffers = 0;
    for (int i = 0; i < NANOARROW_MAX_FIXED_BUFFERS; i++)
    {
        if (array_view.layout.buffer_type[i] == NANOARROW_BUFFER_TYPE_NONE)
        {
            break;
        }

        n_buffers++;
    }

    return n_buffers;
}

pragma(inline, true) ArrowBufferView ArrowArrayViewGetBufferView(
    ArrowArrayView* array_view, long i)
{
    switch (array_view.storage_type)
    {
    case NANOARROW_TYPE_BINARY_VIEW:
    case NANOARROW_TYPE_STRING_VIEW:
        if (i < NANOARROW_BINARY_VIEW_FIXED_BUFFERS)
        {
            return array_view.buffer_views[i];
        }
        else if (i >=
            (array_view.n_variadic_buffers + NANOARROW_BINARY_VIEW_FIXED_BUFFERS))
        {
            ArrowBufferView view = void;
            view.data.as_int64 = array_view.variadic_buffer_sizes;
            view.size_bytes = array_view.n_variadic_buffers * double.sizeof;
            return view;
        }
        else
        {
            ArrowBufferView view = void;
            view.data.data =
                array_view.variadic_buffers[i - NANOARROW_BINARY_VIEW_FIXED_BUFFERS];
            view.size_bytes =
                array_view.variadic_buffer_sizes[i - NANOARROW_BINARY_VIEW_FIXED_BUFFERS];
            return view;
        }
    default: // We need this check to avoid -Warray-bounds from complaining
        if (i >= NANOARROW_MAX_FIXED_BUFFERS)
        {
            ArrowBufferView view = void;
            view.data.data = null;
            view.size_bytes = 0;
            return view;
        }
        else
        {
            return array_view.buffer_views[i];
        }
    }
}

pragma(inline, true) ArrowType ArrowArrayViewGetBufferDataType(
    ArrowArrayView* array_view, long i)
{
    switch (array_view.storage_type)
    {
    case NANOARROW_TYPE_BINARY_VIEW:
    case NANOARROW_TYPE_STRING_VIEW:
        if (i < NANOARROW_BINARY_VIEW_FIXED_BUFFERS)
        {
            return array_view.layout.buffer_data_type[i];
        }
        else if (i >=
            (array_view.n_variadic_buffers + NANOARROW_BINARY_VIEW_FIXED_BUFFERS))
        {
            return NANOARROW_TYPE_INT64;
        }
        else if (array_view.storage_type == NANOARROW_TYPE_BINARY_VIEW)
        {
            return NANOARROW_TYPE_BINARY;
        }
        else
        {
            return NANOARROW_TYPE_STRING;
        }
    default: // We need this check to avoid -Warray-bounds from complaining
        if (i >= NANOARROW_MAX_FIXED_BUFFERS)
        {
            return NANOARROW_TYPE_UNINITIALIZED;
        }
        else
        {
            return array_view.layout.buffer_data_type[i];
        }
    }
}

pragma(inline, true) long ArrowArrayViewGetBufferElementSizeBits(
    ArrowArrayView* array_view, long i)
{
    switch (array_view.storage_type)
    {
    case NANOARROW_TYPE_BINARY_VIEW:
    case NANOARROW_TYPE_STRING_VIEW:
        if (i < NANOARROW_BINARY_VIEW_FIXED_BUFFERS)
        {
            return array_view.layout.element_size_bits[i];
        }
        else if (i >=
            (array_view.n_variadic_buffers + NANOARROW_BINARY_VIEW_FIXED_BUFFERS))
        {
            return long.sizeof * 8;
        }
        else
        {
            return 0;
        }
    default: // We need this check to avoid -Warray-bounds from complaining
        if (i >= NANOARROW_MAX_FIXED_BUFFERS)
        {
            return 0;
        }
        else
        {
            return array_view.layout.element_size_bits[i];
        }
    }
}

pragma(inline, true) byte ArrowArrayViewIsNull(const(ArrowArrayView)* array_view, long i)
{
    const(ubyte)* validity_buffer = array_view.buffer_views[0].data.as_uint8;
    i += array_view.offset;
    switch (array_view.storage_type)
    {
    case NANOARROW_TYPE_NA:
        return 0x01;
    case NANOARROW_TYPE_DENSE_UNION:
    case NANOARROW_TYPE_SPARSE_UNION: // Unions are "never null" in Arrow land
        return 0x00;
    default:
        return validity_buffer != null && !ArrowBitGet(validity_buffer, i);
    }
}

pragma(inline, true) long ArrowArrayViewComputeNullCount(
    const(ArrowArrayView)* array_view)
{
    if (array_view.length == 0)
    {
        return 0;
    }

    switch (array_view.storage_type)
    {
    case NANOARROW_TYPE_NA:
        return array_view.length;
    case NANOARROW_TYPE_DENSE_UNION:
    case NANOARROW_TYPE_SPARSE_UNION: // Unions are "never null" in Arrow land
        return 0;
    default:
        break;
    }

    const(ubyte)* validity_buffer = array_view.buffer_views[0].data.as_uint8;
    if (validity_buffer == null)
    {
        return 0;
    }
    return array_view.length -
        ArrowBitCountSet(validity_buffer, array_view.offset, array_view.length);
}

pragma(inline, true) byte ArrowArrayViewUnionTypeId(
    const(ArrowArrayView)* array_view, long i)
{
    switch (array_view.storage_type)
    {
    case NANOARROW_TYPE_DENSE_UNION:
    case NANOARROW_TYPE_SPARSE_UNION:
        return array_view.buffer_views[0].data.as_int8[array_view.offset + i];
    default:
        return -1;
    }
}

pragma(inline, true) byte ArrowArrayViewUnionChildIndex(
    const(ArrowArrayView)* array_view, long i)
{
    byte type_id = ArrowArrayViewUnionTypeId(array_view, i);
    if (array_view.union_type_id_map == null)
    {
        return type_id;
    }
    else
    {
        return array_view.union_type_id_map[type_id];
    }
}

pragma(inline, true) long ArrowArrayViewUnionChildOffset(
    const(ArrowArrayView)* array_view, long i)
{
    switch (array_view.storage_type)
    {
    case NANOARROW_TYPE_DENSE_UNION:
        return array_view.buffer_views[1].data
            .as_int32[array_view.offset + i];
    case NANOARROW_TYPE_SPARSE_UNION:
        return array_view.offset + i;
    default:
        return -1;
    }
}

pragma(inline, true) long ArrowArrayViewListChildOffset(
    const(ArrowArrayView)* array_view, long i)
{
    switch (array_view.storage_type)
    {
    case NANOARROW_TYPE_LIST:
    case NANOARROW_TYPE_LIST_VIEW:
        return array_view.buffer_views[1].data.as_int32[i];
    case NANOARROW_TYPE_LARGE_LIST:
    case NANOARROW_TYPE_LARGE_LIST_VIEW:
        return array_view.buffer_views[1].data.as_int64[i];
    default:
        return -1;
    }
}

pragma(inline, true) long ArrowArrayViewGetIntUnsafe(
    const(ArrowArrayView)* array_view, long i)
{
    const(ArrowBufferView)* data_view = &array_view.buffer_views[1];
    i += array_view.offset;
    switch (array_view.storage_type)
    {
    case NANOARROW_TYPE_INT64:
        return data_view.data.as_int64[i];
    case NANOARROW_TYPE_UINT64:
        return data_view.data.as_uint64[i];
    case NANOARROW_TYPE_INTERVAL_MONTHS:
    case NANOARROW_TYPE_INT32:
        return data_view.data.as_int32[i];
    case NANOARROW_TYPE_UINT32:
        return data_view.data.as_uint32[i];
    case NANOARROW_TYPE_INT16:
        return data_view.data.as_int16[i];
    case NANOARROW_TYPE_UINT16:
        return data_view.data.as_uint16[i];
    case NANOARROW_TYPE_INT8:
        return data_view.data.as_int8[i];
    case NANOARROW_TYPE_UINT8:
        return data_view.data.as_uint8[i];
    case NANOARROW_TYPE_DOUBLE:
        return cast(long) data_view.data.as_double[i];
    case NANOARROW_TYPE_FLOAT:
        return cast(long) data_view.data.as_float[i];
    case NANOARROW_TYPE_HALF_FLOAT:
        return cast(long) ArrowHalfFloatToFloat(
            data_view.data.as_uint16[i]);
    case NANOARROW_TYPE_BOOL:
        return ArrowBitGet(data_view.data.as_uint8, i);
    default:
        return long.max;
    }
}

pragma(inline, true) ulong ArrowArrayViewGetUIntUnsafe(
    const(ArrowArrayView)* array_view, long i)
{
    i += array_view.offset;
    const(ArrowBufferView)* data_view = &array_view.buffer_views[1];
    switch (array_view.storage_type)
    {
    case NANOARROW_TYPE_INT64:
        return data_view.data.as_int64[i];
    case NANOARROW_TYPE_UINT64:
        return data_view.data.as_uint64[i];
    case NANOARROW_TYPE_INTERVAL_MONTHS:
    case NANOARROW_TYPE_INT32:
        return data_view.data.as_int32[i];
    case NANOARROW_TYPE_UINT32:
        return data_view.data.as_uint32[i];
    case NANOARROW_TYPE_INT16:
        return data_view.data.as_int16[i];
    case NANOARROW_TYPE_UINT16:
        return data_view.data.as_uint16[i];
    case NANOARROW_TYPE_INT8:
        return data_view.data.as_int8[i];
    case NANOARROW_TYPE_UINT8:
        return data_view.data.as_uint8[i];
    case NANOARROW_TYPE_DOUBLE:
        return cast(ulong) data_view.data.as_double[i];
    case NANOARROW_TYPE_FLOAT:
        return cast(ulong) data_view.data.as_float[i];
    case NANOARROW_TYPE_HALF_FLOAT:
        return cast(ulong) ArrowHalfFloatToFloat(
            data_view.data.as_uint16[i]);
    case NANOARROW_TYPE_BOOL:
        return ArrowBitGet(data_view.data.as_uint8, i);
    default:
        return ulong.max;
    }
}

pragma(inline, true) double ArrowArrayViewGetDoubleUnsafe(
    const(ArrowArrayView)* array_view, long i)
{
    i += array_view.offset;
    const(ArrowBufferView)* data_view = &array_view.buffer_views[1];
    switch (array_view.storage_type)
    {
    case NANOARROW_TYPE_INT64:
        return cast(double) data_view.data.as_int64[i];
    case NANOARROW_TYPE_UINT64:
        return cast(double) data_view.data.as_uint64[i];
    case NANOARROW_TYPE_INT32:
        return data_view.data.as_int32[i];
    case NANOARROW_TYPE_UINT32:
        return data_view.data.as_uint32[i];
    case NANOARROW_TYPE_INT16:
        return data_view.data.as_int16[i];
    case NANOARROW_TYPE_UINT16:
        return data_view.data.as_uint16[i];
    case NANOARROW_TYPE_INT8:
        return data_view.data.as_int8[i];
    case NANOARROW_TYPE_UINT8:
        return data_view.data.as_uint8[i];
    case NANOARROW_TYPE_DOUBLE:
        return data_view.data.as_double[i];
    case NANOARROW_TYPE_FLOAT:
        return data_view.data.as_float[i];
    case NANOARROW_TYPE_HALF_FLOAT:
        return ArrowHalfFloatToFloat(data_view.data.as_uint16[i]);
    case NANOARROW_TYPE_BOOL:
        return ArrowBitGet(data_view.data.as_uint8, i);
    default:
        return double.max;
    }
}

pragma(inline, true) ArrowStringView ArrowArrayViewGetStringUnsafe(
    ArrowArrayView* array_view, long i)
{
    i += array_view.offset;
    const(ArrowBufferView)* offsets_view = &array_view.buffer_views[1];
    const(char)* data_view = array_view.buffer_views[2].data.as_char;

    ArrowStringView view = void;
    switch (array_view.storage_type)
    {
    case NANOARROW_TYPE_STRING:
    case NANOARROW_TYPE_BINARY:
        view.data = data_view + offsets_view.data.as_int32[i];
        view.size_bytes =
            cast(
                long) offsets_view.data.as_int32[i + 1] - offsets_view.data.as_int32[i];
        break;
    case NANOARROW_TYPE_LARGE_STRING:
    case NANOARROW_TYPE_LARGE_BINARY:
        view.data = data_view + offsets_view.data.as_int64[i];
        view.size_bytes =
            offsets_view.data.as_int64[i + 1] - offsets_view.data.as_int64[i];
        break;
    case NANOARROW_TYPE_FIXED_SIZE_BINARY:
        view.size_bytes = array_view
            .layout.element_size_bits[1] / 8;
        view.data = array_view.buffer_views[1].data.as_char + (i * view.size_bytes);
        break;
    case NANOARROW_TYPE_STRING_VIEW:
    case NANOARROW_TYPE_BINARY_VIEW:
        {
            ArrowBufferView buf_view = ArrowArrayViewGetBytesFromViewArrayUnsafe(array_view, i);
            view.data = buf_view.data.as_char;
            view.size_bytes = buf_view.size_bytes;
            break;
        }
    default:
        view.data = null;
        view.size_bytes = 0;
        break;
    }

    return view;
}

pragma(inline, true) ArrowBufferView ArrowArrayViewGetBytesUnsafe(
    ArrowArrayView* array_view, long i)
{
    i += array_view.offset;
    const(ArrowBufferView)* offsets_view = &array_view.buffer_views[1];
    const(ubyte)* data_view = array_view.buffer_views[2].data.as_uint8;

    ArrowBufferView view = void;
    switch (array_view.storage_type)
    {
    case NANOARROW_TYPE_STRING:
    case NANOARROW_TYPE_BINARY:
        view.size_bytes =
            cast(
                long) offsets_view.data.as_int32[i + 1] - offsets_view.data.as_int32[i];
        view.data.as_uint8 = data_view + offsets_view.data.as_int32[i];
        break;
    case NANOARROW_TYPE_LARGE_STRING:
    case NANOARROW_TYPE_LARGE_BINARY:
        view.size_bytes =
            offsets_view.data.as_int64[i + 1] - offsets_view.data.as_int64[i];
        view.data.as_uint8 = data_view + offsets_view.data.as_int64[i];
        break;
    case NANOARROW_TYPE_FIXED_SIZE_BINARY:
        view.size_bytes = array_view
            .layout.element_size_bits[1] / 8;
        view.data.as_uint8 =
            array_view.buffer_views[1].data.as_uint8 + (i * view.size_bytes);
        break;
    case NANOARROW_TYPE_STRING_VIEW:
    case NANOARROW_TYPE_BINARY_VIEW:
        view = ArrowArrayViewGetBytesFromViewArrayUnsafe(array_view, i);
        break;
    default:
        view.data.data = null;
        view.size_bytes = 0;
        break;
    }

    return view;
}

pragma(inline, true) void ArrowArrayViewGetIntervalUnsafe(
    const(ArrowArrayView)* array_view, long i, ArrowInterval* out_)
{
    const(ubyte)* data_view = array_view.buffer_views[1].data.as_uint8;
    const(long) offset = array_view.offset;
    const(long) index = offset + i;
    switch (array_view.storage_type)
    {
    case NANOARROW_TYPE_INTERVAL_MONTHS:
        {
            const(size_t) size = int.sizeof;
            memcpy(&out_.months, data_view + index * size, int.sizeof);
            break;
        }
    case NANOARROW_TYPE_INTERVAL_DAY_TIME:
        {
            const(size_t) size = int.sizeof + int.sizeof;
            memcpy(&out_.days, data_view + index * size, int.sizeof);
            memcpy(&out_.ms, data_view + index * size + 4, int.sizeof);
            break;
        }
    case NANOARROW_TYPE_INTERVAL_MONTH_DAY_NANO:
        {
            const(size_t) size = int.sizeof + int.sizeof + long.sizeof;
            memcpy(&out_.months, data_view + index * size, int.sizeof);
            memcpy(&out_.days, data_view + index * size + 4, int.sizeof);
            memcpy(&out_.ns, data_view + index * size + 8, long.sizeof);
            break;
        }
    default:
        break;
    }
}

pragma(inline, true) void ArrowArrayViewGetDecimalUnsafe(
    const(ArrowArrayView)* array_view, long i, ArrowDecimal* out_)
{
    i += array_view.offset;
    const(ubyte)* data_view = array_view.buffer_views[1].data.as_uint8;
    switch (array_view.storage_type)
    {
    case NANOARROW_TYPE_DECIMAL32:
        ArrowDecimalSetBytes(out_, data_view + (i * 4));
        break;
    case NANOARROW_TYPE_DECIMAL64:
        ArrowDecimalSetBytes(out_, data_view + (i * 8));
        break;
    case NANOARROW_TYPE_DECIMAL128:
        ArrowDecimalSetBytes(out_, data_view + (i * 16));
        break;
    case NANOARROW_TYPE_DECIMAL256:
        ArrowDecimalSetBytes(out_, data_view + (i * 32));
        break;
    default:
        memset(cast(void*) out_.words, 0, typeof(out_.words).sizeof);
        break;
    }
}

const(ubyte)[8] _ArrowkBitmask = [1, 2, 4, 8, 16, 32, 64, 128];

const(ubyte)[8] _ArrowkFlippedBitmask = [
    254, 253, 251, 247, 239, 223, 191, 127
];

const(ubyte)[8] _ArrowkPrecedingBitmask = [
    0, 1, 3, 7, 15, 31, 63, 127
];

const(ubyte)[8] _ArrowkTrailingBitmask = [
    255, 254, 252, 248, 240, 224, 192, 128
];

const(ubyte)[256] _ArrowkBytePopcount = [
    0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4, 1, 2, 2, 3, 2, 3, 3, 4, 2,
    3, 3, 4, 3,
    4, 4, 5, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4,
    4, 5, 3, 4,
    4, 5, 4, 5, 5, 6, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3,
    4, 3, 4, 4,
    5, 3, 4, 4, 5, 4, 5, 5, 6, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6,
    3, 4, 4, 5,
    4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3,
    4, 4, 5, 2,
    3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4,
    4, 5, 4, 5,
    5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 2, 3, 3, 4, 3, 4, 4,
    5, 3, 4, 4,
    5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 3, 4, 4, 5,
    4, 5, 5, 6,
    4, 5, 5, 6, 5, 6, 6, 7, 4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8
];
