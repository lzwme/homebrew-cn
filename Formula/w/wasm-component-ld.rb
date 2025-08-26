class WasmComponentLd < Formula
  desc "Linker for creating WebAssembly components"
  homepage "https://wasi.dev"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-component-ld/archive/refs/tags/v0.5.16.tar.gz"
  sha256 "a4ab2d413b4235e2c7fbbda6ed4085c5263584ed6494f717414bebd64813909f"
  license "Apache-2.0"
  head "https://github.com/bytecodealliance/wasm-component-ld.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1bab3ae9b308180a7c1e6145b0afb6b732112152b9a2cd1e984486f20000bf73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c50477463aa0556ffd82ccf2b01f24460babd89ecb52e6812f8d082689ee2c0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ff11532a6b9453082cfb2e11cd777f776307bafd7ac540fb492931fc641e737f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9939517328c9068fedb071b840e55ff41fd43cad39c6a8660aaa83a2c945d28f"
    sha256 cellar: :any_skip_relocation, ventura:       "88f29b587926de99a6654a98183fb406545bd08e75b06ed86a660ae6ff38b21a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "087cdb36090db3c3b2138e94c96a18452531412c297bfef9587d10174a093924"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00052eb70c08acae366e31f95162cd707cfe7390a021ab3d32e4da87e3cdb29e"
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