import std.stdio;

import nanoarrow_d;

static ArrowError global_error;

const(char)* my_library_last_error()
{
    return ArrowErrorMessage(&global_error);
}

int make_simple_array(ArrowArray* array_out, ArrowSchema* schema_out)
{
    ArrowErrorSet(&global_error, "");
    array_out.release = null;
    schema_out.release = null;

    ArrowArrayInitFromType(array_out, NANOARROW_TYPE_INT32);

    ArrowArrayStartAppending(array_out);
    ArrowArrayAppendInt(array_out, 1);
    ArrowArrayAppendInt(array_out, 2);
    ArrowArrayAppendInt(array_out, 3);
    ArrowArrayFinishBuildingDefault(array_out, &global_error);

    ArrowSchemaInitFromType(schema_out, NANOARROW_TYPE_INT32);

    return NANOARROW_OK;
}

int print_simple_array(ArrowArray* array, ArrowSchema* schema)
{
    ArrowArrayView array_view;
    ArrowArrayViewInitFromSchema(&array_view, schema, &global_error);

    if (array_view.storage_type != NANOARROW_TYPE_INT32)
    {
        writeln("Array has storage that is not int32");
    }

    int result = ArrowArrayViewSetArray(&array_view, array, &global_error);
    if (result != NANOARROW_OK)
    {
        ArrowArrayViewReset(&array_view);
        return result;
    }

    for (ulong i = 0; i < array.length; i++)
    {
        writefln("%d", cast(int) ArrowArrayViewGetIntUnsafe(&array_view, i));
    }

    ArrowArrayViewReset(&array_view);
    return NANOARROW_OK;
}

void main()
{
    writeln("Nanoarrow version: ", NANOARROW_VERSION);

    ArrowArray array;
    ArrowSchema schema;

    array.release = null;
    schema.release = null;

    int result = make_simple_array(&array, &schema);
    if (result != 0)
    {
        if (array.release)
            array.release(&array);
        if (schema.release)
            schema.release(&schema);
        return;
    }

    result = print_simple_array(&array, &schema);
    if (array.release)
        array.release(&array);
    if (schema.release)
        schema.release(&schema);
}
