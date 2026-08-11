class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.256.0.tar.gz"
  sha256 "6d7fe8cc21d969bc21d42f3b8ca47650a309b0383b0587e35e9e50aa0193f433"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71f3eb9ad2c275af96fb293f4317f1d8b997991b8093b3b123b0ea2860bb369e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a3f54d3441a689df54d8057ec45998e1728a8c9fa21de38c166cf4b6e172463"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46dce5199694a8f92bb5b6776ee236be1aaf36ee59958ecd99b01fc988193c2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0848f7f085867e7621ef6389220ebeac51cd9d36c34558a19f585e800352ce2e"
    sha256 cellar: :any,                 arm64_linux:   "f04c7483dd29282c160b5660a2a19395873f6ba51bef02c9314955e82555862d"
    sha256 cellar: :any,                 x86_64_linux:  "a536552c0b74d60297b6bae752423acb74da79732af84a3759a8da3c87eabe0c"
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

    expected = <<~WASM
      (module
        (type (;0;) (func (param i32 i32) (result i32)))
        (export "sum" (func 0))
        (func (;0;) (type 0) (param i32 i32) (result i32)
          local.get 0
          local.get 1
          i32.add
        )
      )
    WASM
    assert_equal expected, shell_output("#{bin}/wasm-tools print #{testpath}/sum.wasm")
  end
end