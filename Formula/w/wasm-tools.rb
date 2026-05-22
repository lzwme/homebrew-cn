class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.250.0.tar.gz"
  sha256 "ca4d1aacd85df1f00b932d1a1ce3e2676c64e3156dbc20ef405bb12cac4b18f9"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d303859633abae37384472070153e89db5fb3064e61c17463cc9873dbeeed6b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a059a3bd2552f2583d3ec1cd3637f2adbfec292635ea0b2afabc9b70d8c963c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "860b87fd0a379fac7314e567f80998795b74a196b82d2b243c7cf15d1252b45f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bb45328235ee926892224a6bc2710041c75bea3612404f0cf861b1e175bd281"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a668a6435372d4f5166d4b783e39dd69e25624194e69e9f4d37d95ae8507ef68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "146eb97ca35fcbfffc8cc4526737fc7eb14410ffeb0fa04656140090aa4e5f00"
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