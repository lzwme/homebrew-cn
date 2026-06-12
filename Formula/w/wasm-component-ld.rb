class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https://wasi.dev"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v0.5.23.tar.gz"
  sha256 "31f45a590d03fe83e0857d421e492a37e640b5dc31fd1a8c34fb805192631868"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7578b049a4969f83cb816ba329cffa2f278e180629b6be1b13d56eb34caf878f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b63bb1505fd63ddc88102d64ac84cc77a7399a9177c19d7fa5cca7773409b0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acffcb1c7f4a75b5be60b4976cc020c8c16ce2e7778eb99b8d58c81bab88b437"
    sha256 cellar: :any_skip_relocation, sonoma:        "080d9ff392670e6504642f86c56455d902624f8b230fe4e311e4b0fb49869858"
    sha256 cellar: :any,                 arm64_linux:   "a27584d9ce6968e59f77b7ad8dac7eb6169c7bf7cb1e23df343634cdda5c520a"
    sha256 cellar: :any,                 x86_64_linux:  "c45b0b9b5c24da0237d8ba9ee6ffe163332f33151d9dac38676b97d8a59b507a"
  end

  depends_on "rust" => :build
  depends_on "lld" => :test
  depends_on "llvm" => :test
  depends_on "wasi-libc" => :test
  depends_on "wasmtime" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    resource "builtins" do
      url "https://ghfast.top/https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-24/libclang_rt.builtins-wasm32-wasi-24.0.tar.gz"
      sha256 "7e33c0df758b90469b1de3ca158e2d0a7f71934d5884525ba6a372de0b3b0ec7"
    end

    ENV.remove_macosxsdk if OS.mac?
    ENV.remove_cc_etc

    (testpath/"test.c").write <<~C
      #include <stdio.h>
      volatile int x = 42;
      int main(void) {
        printf("the answer is %d", x);
        return 0;
      }
    C

    clang = Formula["llvm"].opt_bin/"clang"
    clang_resource_dir = Pathname.new(shell_output("#{clang} --print-resource-dir").chomp)
    testpath.install_symlink clang_resource_dir/"include"
    resource("builtins").stage testpath/"lib/wasm32-unknown-wasip2"
    (testpath/"lib/wasm32-unknown-wasip2").install_symlink "libclang_rt.builtins-wasm32.a" => "libclang_rt.builtins.a"
    wasm_args = %W[--target=wasm32-wasip2 --sysroot=#{Formula["wasi-libc"].opt_share}/wasi-sysroot]
    system clang, *wasm_args, "-v", "test.c", "-o", "test", "-resource-dir=#{testpath}"
    assert_equal "the answer is 42", shell_output("wasmtime #{testpath}/test")
  end
end