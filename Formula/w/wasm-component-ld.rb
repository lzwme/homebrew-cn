class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https://wasi.dev"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v0.5.28.tar.gz"
  sha256 "f855eddb814607ff862d08fcd30e06297b8a937920510414d3f5c655d69447e7"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bef3a0c7cfb5a20a831f22c2cddd9ca54a4a0d4ba5e90cbe48413f2f5516df7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1200b8b256d2bd126e782e4f552c6e702eb54ff7bcb288ad612857ea3d20d33d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6034c955d0b6a0eef4c42dbbb09726cc5bc19d766ecf667e3fd81f1d4eafef22"
    sha256 cellar: :any_skip_relocation, sonoma:        "28da9ef787d0cc67a988bea656a309694d9375f1e63815258ee99fa86f15e4fe"
    sha256 cellar: :any,                 arm64_linux:   "874b2716fe66e3b0c9f45d11b412a2003978a76bbb824d8832e5961eeb72e24b"
    sha256 cellar: :any,                 x86_64_linux:  "656c68e5b4addc368e8d075fcd790084534e6866f9ccf5ef32add90371bc6c4f"
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

    clang = formula_opt_bin("llvm")/"clang"
    clang_resource_dir = Pathname.new(shell_output("#{clang} --print-resource-dir").chomp)
    testpath.install_symlink clang_resource_dir/"include"
    resource("builtins").stage testpath/"lib/wasm32-unknown-wasip2"
    (testpath/"lib/wasm32-unknown-wasip2").install_symlink "libclang_rt.builtins-wasm32.a" => "libclang_rt.builtins.a"
    wasm_args = %W[--target=wasm32-wasip2 --sysroot=#{Formula["wasi-libc"].opt_share}/wasi-sysroot]
    system clang, *wasm_args, "-v", "test.c", "-o", "test", "-resource-dir=#{testpath}"
    assert_equal "the answer is 42", shell_output("wasmtime #{testpath}/test")
  end
end