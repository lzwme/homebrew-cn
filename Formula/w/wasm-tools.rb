class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.261.0.tar.gz"
  sha256 "fa78e7cf1f6e5e76c8590f950a55256fd77e5f1cd55392d9b2da25b8a89b4e5c"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2edb300b5c2b18b6024a97fc5aa7c79526c07834852e63b974ba128bba6da277"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "174ea331dbc6bd3bfddf16999754edfba048a8ac390b549cac0f28a995612f5d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "743aac9d0adb78e94cc280344456a042a6879fc2dcfec66ea596cd45386f2ece"
    sha256 cellar: :any,                 arm64_linux:       "939365fc926f549d509bf861103371eb2a8c12400f1ba848bb47eb3cb2fe2b89"
    sha256 cellar: :any,                 x86_64_linux:      "f0c1ca6e0d2c7ed623cb4c7e6e9378be33525845d5500f836b87dd8491972719"
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