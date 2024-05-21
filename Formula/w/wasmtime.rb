class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https:wasmtime.dev"
  url "https:github.combytecodealliancewasmtime.git",
      tag:      "v21.0.0",
      revision: "aaa39cb71ac09a518ce4563b61fe102cfa66333e"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.combytecodealliancewasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "09933fa9cd5d56af16d5e9ee21a7ab0bf3cf736554bb77c726685c8c96aac1b6"
    sha256 cellar: :any,                 arm64_ventura:  "00bb0a82a2d650982b3941db6eaf354b6cb1ea51e083d488bcf1bc2fd0f282de"
    sha256 cellar: :any,                 arm64_monterey: "ae751d0672a528178dc0108e0606a670997abda72be3489dba2cd7512c141044"
    sha256 cellar: :any,                 sonoma:         "4b96378267fc8ca22cde4dd81b54d806c86418aebcf4d683daa9a13cb046fa1c"
    sha256 cellar: :any,                 ventura:        "9759f8b8feda321c2cb2722980fa8ce35ad08bc62072980ec4d2526db73f865b"
    sha256 cellar: :any,                 monterey:       "beea93ac20786862b713112383e85f5aedfbfb8e3aaf56bfd5b9f912b3331ee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "343d4e8a4526fcb36d9293e27a0ec254819aa8558427e69e81e44ac52df5e721"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "build", "--locked", "--lib", "-p", "wasmtime-c-api", "--release"
    lib.install shared_library("targetreleaselibwasmtime")
    include.install Dir["cratesc-apiinclude*"]
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}wasmtime --invoke sum #{testpath"sum.wasm"} 1 2")

    (testpath"hello.wat").write <<~EOS
      (module
        (func $hello (import "" "hello"))
        (func (export "run") (call $hello))
      )
    EOS

    # Example from https:docs.wasmtime.devexamples-c-hello-world.html to test C library API,
    # with comments removed for brevity
    (testpath"hello.c").write <<~EOS
      #include <assert.h>
      #include <stdio.h>
      #include <stdlib.h>
      #include <wasm.h>
      #include <wasmtime.h>

      static void exit_with_error(const char *message, wasmtime_error_t *error, wasm_trap_t *trap);

      static wasm_trap_t* hello_callback(
          void *env,
          wasmtime_caller_t *caller,
          const wasmtime_val_t *args,
          size_t nargs,
          wasmtime_val_t *results,
          size_t nresults
      ) {
        printf("Calling back...\\n");
        printf("> Hello World!\\n");
        return NULL;
      }

      int main() {
        int ret = 0;
        printf("Initializing...\\n");
        wasm_engine_t *engine = wasm_engine_new();
        assert(engine != NULL);

        wasmtime_store_t *store = wasmtime_store_new(engine, NULL, NULL);
        assert(store != NULL);
        wasmtime_context_t *context = wasmtime_store_context(store);

        FILE* file = fopen(".hello.wat", "r");
        assert(file != NULL);
        fseek(file, 0L, SEEK_END);
        size_t file_size = ftell(file);
        fseek(file, 0L, SEEK_SET);
        wasm_byte_vec_t wat;
        wasm_byte_vec_new_uninitialized(&wat, file_size);
        assert(fread(wat.data, file_size, 1, file) == 1);
        fclose(file);

        wasm_byte_vec_t wasm;
        wasmtime_error_t *error = wasmtime_wat2wasm(wat.data, wat.size, &wasm);
        if (error != NULL)
          exit_with_error("failed to parse wat", error, NULL);
        wasm_byte_vec_delete(&wat);

        printf("Compiling module...\\n");
        wasmtime_module_t *module = NULL;
        error = wasmtime_module_new(engine, (uint8_t*) wasm.data, wasm.size, &module);
        wasm_byte_vec_delete(&wasm);
        if (error != NULL)
          exit_with_error("failed to compile module", error, NULL);

        printf("Creating callback...\\n");
        wasm_functype_t *hello_ty = wasm_functype_new_0_0();
        wasmtime_func_t hello;
        wasmtime_func_new(context, hello_ty, hello_callback, NULL, NULL, &hello);

        printf("Instantiating module...\\n");
        wasm_trap_t *trap = NULL;
        wasmtime_instance_t instance;
        wasmtime_extern_t import;
        import.kind = WASMTIME_EXTERN_FUNC;
        import.of.func = hello;
        error = wasmtime_instance_new(context, module, &import, 1, &instance, &trap);
        if (error != NULL || trap != NULL)
          exit_with_error("failed to instantiate", error, trap);

        printf("Extracting export...\\n");
        wasmtime_extern_t run;
        bool ok = wasmtime_instance_export_get(context, &instance, "run", 3, &run);
        assert(ok);
        assert(run.kind == WASMTIME_EXTERN_FUNC);

        printf("Calling export...\\n");
        error = wasmtime_func_call(context, &run.of.func, NULL, 0, NULL, 0, &trap);
        if (error != NULL || trap != NULL)
          exit_with_error("failed to call function", error, trap);

        printf("All finished!\\n");
        ret = 0;

        wasmtime_module_delete(module);
        wasmtime_store_delete(store);
        wasm_engine_delete(engine);
        return ret;
      }

      static void exit_with_error(const char *message, wasmtime_error_t *error, wasm_trap_t *trap) {
        fprintf(stderr, "error: %s\\n", message);
        wasm_byte_vec_t error_message;
        if (error != NULL) {
          wasmtime_error_message(error, &error_message);
          wasmtime_error_delete(error);
        } else {
          wasm_trap_message(trap, &error_message);
          wasm_trap_delete(trap);
        }
        fprintf(stderr, "%.*s\\n", (int) error_message.size, error_message.data);
        wasm_byte_vec_delete(&error_message);
        exit(1);
      }
    EOS

    system ENV.cc, "hello.c", "-I#{include}", "-L#{lib}", "-lwasmtime", "-o", "hello"
    expected = <<~EOS
      Initializing...
      Compiling module...
      Creating callback...
      Instantiating module...
      Extracting export...
      Calling export...
      Calling back...
      > Hello World!
      All finished!
    EOS
    assert_equal expected, shell_output(".hello")
  end
end