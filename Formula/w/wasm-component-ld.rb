class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https:wasi.dev"
  url "https:github.combytecodealliancewasm-component-ldarchiverefstagsv0.5.10.tar.gz"
  sha256 "aa049a93da595e4dacf742865f13e7fb1cec1ab47de9258f0a11d81ad6c7a77b"
  license "Apache-2.0"
  head "https:github.combytecodealliancewasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79de06bddaa5af8534ef3e3210be559c7413e17d8f504f2ffdefeb24189f1239"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1f36e28abceafb366512a3a0235c8aa80ba3e6a3e403dc2bd78cde3b266c769"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d0fca96ba4e4dacef300f1d632ebcd0fc3066daae8853d517ded1bd55766dae"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bb06da23d7c598b67d980a7c0405e83762666473b4e54c1d8bc6eef749d2ac4"
    sha256 cellar: :any_skip_relocation, ventura:       "581b65d32016bc17e626999536900c6f5ecec015f694b75ec8eacdf34c72083f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38fecd207497a23c63d145c56ff12aa25e6a692905d34087ca211185e5dc36ad"
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
      url "https:github.comWebAssemblywasi-sdkreleasesdownloadwasi-sdk-24libclang_rt.builtins-wasm32-wasi-24.0.tar.gz"
      sha256 "7e33c0df758b90469b1de3ca158e2d0a7f71934d5884525ba6a372de0b3b0ec7"
    end

    ENV.remove_macosxsdk if OS.mac?
    ENV.remove_cc_etc

    (testpath"test.c").write <<~C
      #include <stdio.h>
      volatile int x = 42;
      int main(void) {
        printf("the answer is %d", x);
        return 0;
      }
    C

    clang = Formula["llvm"].opt_bin"clang"
    clang_resource_dir = Pathname.new(shell_output("#{clang} --print-resource-dir").chomp)
    testpath.install_symlink clang_resource_dir"include"
    resource("builtins").stage testpath"libwasm32-unknown-wasip2"
    (testpath"libwasm32-unknown-wasip2").install_symlink "libclang_rt.builtins-wasm32.a" => "libclang_rt.builtins.a"
    wasm_args = %W[--target=wasm32-wasip2 --sysroot=#{Formula["wasi-libc"].opt_share}wasi-sysroot]
    system clang, *wasm_args, "-v", "test.c", "-o", "test", "-resource-dir=#{testpath}"
    assert_equal "the answer is 42", shell_output("wasmtime #{testpath}test")
  end
end