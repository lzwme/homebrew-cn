class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.260.0.tar.gz"
  sha256 "a0fea568085f3f33f1f8064fe28d34f27fd12d8a083427fb6a3fb5f445af2770"
  license any_of: [
    { "Apache-2.0" => { with: "LLVM-exception" } },
    "Apache-2.0",
    "MIT",
  ]
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1394e9db173c4ba5dada0c62717c46a888c5ec90a344ae9aa31fc5002196564e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "07d76b7c414703970a98a1068cb6f589de17d2753ae24e1234b253f558937a1b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5bd99aed9717b52d098df09d54df81061cd05b658272ecec19508d257f6607e3"
    sha256 cellar: :any,                 arm64_linux:       "9034d9d693f56048300e62ecc96a92280a8f448ffc862709ec7ed4e9c124fa41"
    sha256 cellar: :any,                 x86_64_linux:      "1caba430c7104ab482ef706f4a9fb38d530d15df4da640c3821f92f33572a872"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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