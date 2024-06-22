class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https:wasmtime.dev"
  url "https:github.combytecodealliancewasmtime.git",
      tag:      "v22.0.0",
      revision: "761f044efbb6d7465b88d723619168919b30ce0b"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https:github.combytecodealliancewasmtime.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c92902c385af2761b20f919e48b74d85b11855c2df8545e204eb91fb50b57f57"
    sha256 cellar: :any,                 arm64_ventura:  "02bcf0f3dcf6b756d140a62f5cac5ed60b61458ff9845ebcabe994833b3c1564"
    sha256 cellar: :any,                 arm64_monterey: "f51c97037bb29045284e4502937910673ef746bfc239538cc03ae7b66853e068"
    sha256 cellar: :any,                 sonoma:         "0ca0afea0715aa9979ada6325a62dcb8a6c67ca5b1a017da299e5aeafa55e8d2"
    sha256 cellar: :any,                 ventura:        "4dda43179f51a356ec8e2a8788cf03cc9e07712cf22a2d43faea0290bd84fd98"
    sha256 cellar: :any,                 monterey:       "1160a3787f53975676680cf0b0a370f939a8cc011a8cced0dac42e94829d1735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ee42709d076a9597707215384ade62d3fb49243b3053453ebbabafe8850c256"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    cd "cratesc-api" do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
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