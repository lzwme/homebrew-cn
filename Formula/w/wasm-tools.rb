class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.246.1.tar.gz"
  sha256 "129402845924f9e70072445640c7b37dbb5586a1047e357907a7bf9e1d03ee79"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f5997c0838542767454aa01c59b654ee67a63e5f5f7fd22030e274db19a01cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95f2be49e5b67f69b86ccde4c10a2d2e7daab7b495940a685d981b3455254b91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ba618c67166f3cf5fcfec7f0aa040d5c9cd4c0d7a1fe98889d5719fc5523308"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c69bef5b9709be17fb9f2e30d2f068c2eb64bec4985f677c4d9b23dfc3e55d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd5b9733e3bb118be03a09da5f9fc8e3bee8e1062aaff75c3539148362d1ea8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ba9ed958b35a41b86e1c5d1472135fe77b1b09d53762aa8882475fb2c874787"
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