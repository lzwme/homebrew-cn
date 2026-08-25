class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.258.0.tar.gz"
  sha256 "14a867a7f5ae233f27c6ad93c2ce6153afa43bf93b0a60450b8ba789d65f8ce4"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "19c56a325742786e2984d50028dc7219f5ddd029229504a00b5e3446bf94becb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdffec88981a2b3671ffb082af534dd25ac18f83bd47c5b64ce3d0f84f37c5a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e05450b7ec4800488c7a26e36403cb8a2735e939a75c9d2ef770e7979d7c5777"
    sha256 cellar: :any_skip_relocation, sonoma:        "190d88f8cd1b4611f5094a3347226def943beb5f2c04f63775ba75069d89222e"
    sha256 cellar: :any,                 arm64_linux:   "9c968287ac519fd3110346b63a56e0ab3b651941080ec65fb196dc35a335c351"
    sha256 cellar: :any,                 x86_64_linux:  "12e9de705ae8366c64027499e6b80ee79fd2a628e45c74ca2e687bdc0dd8237a"
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