import std.stdio : writeln;
import std.file : write, readText;
import std.regex;
import std.string;
import std.array;

void main(string[] args)
{
    if (args.length < 3)
    {
        writeln("Usage: d_extract_static_inline_and_consts.d <input_header.h> <output_c_file.c>");
        return;
    }

    string headerFile = args[1];
    string outputFile = args[2];
    string content;

    try
    {
        content = cast(string) readText(headerFile);
    }
    catch (Exception e)
    {
        writeln("Failed to read file: ", e.msg);
        return;
    }

    string extracted = "";

    // --- Extract static inline functions ---
    auto funcRegex = regex(
        `(?ms)static\s+inline\s+([\w\s\*\d]+?)\s+(\w+)\s*\((.*?)\)\s*\{(.*?)^\}`, "ms");
    auto funcMatches = matchAll(content, funcRegex);

    foreach (m; funcMatches)
    {
        extracted ~= m.hit ~ "\n\n";
    }

    // --- Extract static const arrays ---
    // Matches patterns like: static const uint8_t _ArrowkPrecedingBitmask[] = { ... };
    auto constArrayRegex = regex(
        `(?ms)static\s+const\s+[\w\d_]+\s+[\w\d_]+\s*\[.*?\]\s*=\s*\{.*?\};`, "ms");
    auto constMatches = matchAll(content, constArrayRegex);

    foreach (m; constMatches)
    {
        extracted ~= m.hit ~ "\n\n";
    }

    if (extracted.length == 0)
    {
        writeln("No static inline functions or static const arrays found in ", headerFile);
        return;
    }

    try
    {
        write(outputFile, extracted);
        writeln("You can now run: ctod ", outputFile, " to generate D code.");
    }
    catch (Exception e)
    {
        writeln("Failed to write file: ", e.msg);
    }
