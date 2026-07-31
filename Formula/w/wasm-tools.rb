class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.255.0.tar.gz"
  sha256 "5e8d75ad53a1ffc82269c3007d1ed5800b49ba8fa2f8a84a306c529860e923b5"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "704c8c9ca65fc669b94c1142b296d4394559863064169c7e103250f5f22c33d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "907976bc1a5a098710a2396798c9044e3fe88e141ed974583c5e05420dc16ec5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5eb8d5ee37e38438e003ece3bf6e33e9fe38719f3c3f3530fd3dd592a6baef81"
    sha256 cellar: :any_skip_relocation, sonoma:        "108457f78c584ad239b2a38c90f6491d310597ce40efb033d252acb0a619b8df"
    sha256 cellar: :any,                 arm64_linux:   "b8b2e46496efc9a01bb69c8859b27908f6da1515a1e167ebad49f866a7429026"
    sha256 cellar: :any,                 x86_64_linux:  "0111127d5afe3b72d53cf3efd013304221a63dfc9e384a2fcc91633462ea3074"
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