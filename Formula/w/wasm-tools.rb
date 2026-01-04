class WasmTools < Formula
  desc "Low level tooling for WebAssembly in Rust"
  homepage "https://github.com/bytecodealliance/wasm-tools"
  url "https://ghfast.top/https://github.com/bytecodealliance/wasm-tools/archive/refs/tags/v1.243.0.tar.gz"
  sha256 "72b575475215082cb1ebe5fe1882c439dfe5b6e22b222914f08a0b214e6a2187"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasm-tools.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da09f1e66aabdef69bf49d2d4c7497e526db14febcf9e373e5846f68d652ac3c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4285a9b78315f473022613a26ec880656b883958a9560cc42963a476daa56276"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8043fc7dee5193c1cd825fe384ed1dafe2a78dd49a6aafa427033d8af919534e"
    sha256 cellar: :any_skip_relocation, sonoma:        "5aa0861d5dc2b32a2190a2d82c0d5f91903a913085bdbb3dd2ccf32b6e276739"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "020d394463046b675512eaf6a86c80862b1447d9ed02647727f6cf6ab5b631a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c520d6292b36877cf7d51e806112ef965b618b00614880ac859d0c8001eb023"
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