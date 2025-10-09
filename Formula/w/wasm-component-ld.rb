class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https://wasi.dev"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v0.5.18.tar.gz"
  sha256 "27fd97d775a20737e5ee55b345200d23ae381f437886a54fe3a7a374e291e744"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "995c04ef4663bcdc178d24631e04dfa83e92d8d459e9162700eedf691461bc8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "647e8093a9605f0880fbfa931c23869f1ec2a8690a6b2dbe75d0eecdf102d0ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "731ffda684bee29d33ed9fcf70d84f42e311dca6af7d9b7cbbf2e4b2e385aca2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2537c20f99cb9a25f1d4a310b4ad4a6b5a8bcb4511625f8482c445529b05704"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65294a444ed484adceeab0e12a2f2697f482fba2d1321855dff319fb1cd3be25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42a5128674eda3deed28c4acacdf07c58d5385435f806713b5ff51c7b2abca81"
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