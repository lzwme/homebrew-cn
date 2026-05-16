class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.249.0.tar.gz"
  sha256 "d6259722ebf45c8619110b4b7c359986f459338462a293310fdf3bbfeec602c7"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "20385edf134d4bf59c6bec2e7b44c6cd79357694dd14c831dab82a1b51e16558"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6634ccd7f5c6b4a7832df3ba5efa6b5eb9a3f084b0fee7be6402579fe6f02a92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22f35189a1aa5004064b3931e58e9ef66c17cd56c95d0c7f74d075ad69aba21c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a39edfc078c41a7b2a10396a374403eb553ec0930ccc7bb7c2531a0ce04c0fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1911b693a1c440cf46f1d0f561941d140c575b0162ae19391ca65a1bf574eac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34f407252b846501ffcaed7c3e8ae6c2cbda483dd1840e1a55780b8e19efede0"
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