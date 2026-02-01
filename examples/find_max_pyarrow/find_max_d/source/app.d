module find_max_d;

version = Python_3_0_Or_Later;
version = PydPythonExtension;

import pyd.pyd;
import std.stdio;

void hello() {
    writefln("Hello, world from D!");
}

string[] get_data(string x) {
    return [x, x];
}

extern(C) void PydMain() {
    def!(hello)();
    def!(get_data)();
    module_init();
}

import pyd.def;
import pyd.exception;
import pyd.thread;
import deimos.python.Python;
import core.runtime;

extern(C) shared bool _D2rt6dmain212_d_isHaltingOb;
alias _D2rt6dmain212_d_isHaltingOb _d_isHalting;
extern(C) {

    void rt_init();
    void rt_term();

    pragma(crt_constructor)
    void hacky_init() {
        rt_init();
    }

    pragma(crt_destructor)
    void hacky_fini() {
        if(!_d_isHalting){
            rt_term();
        }
    }

}

extern(C) export PyObject* PyInit_find_max_d() {
    return pyd.exception.exception_catcher(delegate PyObject*() {
        pyd.thread.ensureAttached();
        pyd.def.pyd_module_name = "find_max_d";
        PydMain();
        return pyd.def.pyd_modules[""];
    });
}
