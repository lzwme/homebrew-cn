class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https://wasi.dev"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v0.5.29.tar.gz"
  sha256 "77cd7755210d22768aa8ee504b24aefdabce1b4a0da37bf449347f8b936f1f38"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "628e1b976bef327a01982f55b0d553dc001f16979ff0052001827100d1632bf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf16c594626e58cc00224152633c4aa0f80485e5866d665aac08b1fc1b99ff9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f3eea1fd84417fb013173e4273045c5dc38bb8a7813c808d84f14431058ce70"
    sha256 cellar: :any_skip_relocation, sonoma:        "42aef38ce3d327a50a2453e469611e6b3daa91497d472d0da34bd0da01cdd3f8"
    sha256 cellar: :any,                 arm64_linux:   "cfa96ee11af13208a4fe1371de541d3cb19df87276f9e88bcabac554d8b545f9"
    sha256 cellar: :any,                 x86_64_linux:  "c8ac9fa62899e9c97d2ef7f2f798fb2d7d841e9e19e0d1661a9115635233f7d7"
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