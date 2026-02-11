class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.245.0.tar.gz"
  sha256 "1a5735cf524043dfe81f523f3816afdce2f2f524058315493b40488b1f4cfe7a"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f88e69beb6f2fd76832d52299116be5b58e44f77fb3ff96d99a520ebc2674c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8fe47cf6e5a1c7e38564e7642a7f5194fc7d82506cccdb80b47411c5b8985a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c163e83688560ae2a27b7830c3fabc91776c58c1664d4be439b11ca7fbe7ebf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5cb71a1ed84cb422534f1e8fc6aad421bbff7f4b8a14acff1abed1e3edf05ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ec8fab3bf94b57adfb8ae686c4f2196e27f2686a6423f983eb946bc308c4bda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65c2552fb98f66667f6e56f09aaf29b7b038021d09932cb74d51ea3e20182c8e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"wasm-tools", "completion", shells: [:bash, :fish, :pwsh, :zsh])
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    system bin/"wasm-tools", "validate", testpath/"sum.wasm"

    expected = <<~EOS
      (module
        (type (;0;) (func (param i32 i32) (result i32)))
        (export "sum" (func 0))
        (func (;0;) (type 0) (param i32 i32) (result i32)
          local.get 0
          local.get 1
          i32.add
        )
      )
    EOS
    assert_equal expected, shell_output("#{bin}/wasm-tools print #{testpath}/sum.wasm")
  end
end