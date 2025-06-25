class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https:wasi.dev"
  url "https:github.combytecodealliancewasm-component-ldarchiverefstagsv0.5.14.tar.gz"
  sha256 "ec54cfb88396753de52ed05977e4c6338bd16579f3ca96105a88adc017d25b6e"
  license "Apache-2.0"
  head "https:github.combytecodealliancewasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a3f0e52b139b949148dd0b3a9a3cad5255e6d757019606832ee1a3842982db2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d69c26d77f63da9dbb66bbf3a02c3df25e4bf0ba233e227eabc4492ef9a84e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9d5850cb956bf8439b908c1a34ecb89ee8b344f3bdb2d0827677e2848521586"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ac867b17aa2bf804dddf3081a73198942354c2004b07bcf1edfd706c4bf7b4c"
    sha256 cellar: :any_skip_relocation, ventura:       "89710eb6bca05a4cb612bc40e642b067717e54d7b53dc3da3f8a3794842d09df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b2610484aad80b6521bbf00ae0b168674177cd0170c3e9a64bcfbd87799edbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d87962d4f8645777356a62643156bd1f0804661838db23a131093cb4c5ef0b00"
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